//
//  OrderTogetherController.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OrderTogetherController:CanteenBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    private enum Section:Int {
        case info
        case alert
        case address
        case together
        case remark
    }
    
    private lazy var tableView:TPKeyboardAvoidingTableView = {
        let tableView = TPKeyboardAvoidingTableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(ReservationSelectCell.self)
        tableView.registerClassOf(UITableViewCell.self)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var selectType:eatType = .together{
        didSet {
           self.tableView.reloadSections([Section.together.rawValue], with: .none)
        }
    }
    private var reserveId:String
    private var orderReserveModel:OrderReserveModel?
    private var remarkText:String?
    
    private lazy var nextStepBtn:UIButton = {
        let next = UIButton(type: .custom)
        next.backgroundColor = UIColor.white
        next.setTitle("下一步", for: .normal)
        next.setTitleColor(UIColor.darkText, for: .normal)
        next.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        next.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return next
    }()
    
    init(reserveId:String){
       self.reserveId = reserveId
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func nextStep(){
        
//        self.showLoading()
//        EatGroupModel.AddGroupWithReserveID(self.reserveId,
//                                            goldenBellYN: "Y",
//                                            groupDescription: self.remarkText ?? "",
//                                            failureHandler:
//        { reason, errormessage in
//            self.hideLoading()
//            self.showMessage(errormessage)
//        }) { model in
//            self.hideLoading()
//            if let json = model {
//
//            }else {
//
//            }
//        }
    }
    
    
    
    
    private func requestData(){
        
        self.showCustomloading()
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                  doneWith(memid: check.custom_code, token: check.newtoken)
                }else {
                    self.hideLoading()
                    self.goToLogin()
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                self.hideLoading()
            }
        }
      
     func doneWith(memid:String,token:String) {
        OrderReserve.GetWithReserveID(reserveId,
                                      reserveStatus: status.alreadyOrder.rawValue,
                                      memid:memid,
                                      token:token,
                                      failureHandler:
            { reason, errormessage in
            
              self.hideLoading()
              self.showMessage(errormessage)
            
         }) { jsonModel in
            
              self.hideLoading()
                if let json = jsonModel {
                if json.status == -9001 {
                    self.goToLogin(completion: {
                        self.requestData()
                    })
                    return
                }
                self.orderReserveModel = json.data
                self.addBottomView()
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: self.tableView)
            }
        }
        }
     }
    
    
    private func addBottomView(){
        
        view.addSubview(nextStepBtn)
        nextStepBtn.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(50)
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "预约信息"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        requestData()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = orderReserveModel {
           return 5
        }else {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .info,.remark:
            return 0
        case .alert,.address,.together:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .info:
            return 2
        case .alert:
            return 1
        case .address:
            return 1
        case .together:
            return 2
        case .remark:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .info:
            if indexPath.row == 0{
                let cell = OrderShopDetailCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }else {
                let cell = OrderOtherInfoCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }
        case .alert:
            let cell:UITableViewCell = tableView.dequeueReusableCell()
            cell.backgroundColor = UIColor(hex: 0xfff7d6)
            cell.textLabel?.textColor = UIColor(hex: 0xbea064)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.text = "具体桌位以实际就餐人数和餐厅安排为准"
            cell.selectionStyle = .none
            return cell
        case .address:
            let cell = OrderNumberCell(style: .default, reuseIdentifier: nil)
            cell.updateWithAddress(orderReserveModel!)
            cell.accessoryType = .disclosureIndicator
            return cell
        case .together:
            let cell:ReservationSelectCell = tableView.dequeueReusableCell()
            guard let eattype = eatType(rawValue: indexPath.row) else { fatalError() }
            switch eattype {
            case .together:
              cell.leftlable.text = "一起吃吧"
            case .kim:
              cell.leftlable.text = "金钟"
            }
            cell.selectAction = {
                self.selectType = eattype
            }
            cell.updateSelected(eattype == self.selectType ? true:false)
            return cell
        case .remark:
            let cell = ReservationRemarkCell(style: .default, reuseIdentifier: nil)
            cell.updateWithRemark(self.remarkText)
            cell.valueChangeAction = { text in
               self.remarkText = text
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .info:
            if indexPath.row == 0 {
               return OrderShopDetailCell.getHeight()
            }else {
               return OrderOtherInfoCell.getHeightWithModel(orderReserveModel!)
            }
        case .alert:
            return 40
        case .address:
            return OrderNumberCell.getHeight()
        case .together:
            return 40
        case .remark:
            return ReservationRemarkCell.getHeight()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
