//
//  OrderFormDetailController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher


public enum eatType:Int {
    case together
    case kim
}


class OrderFormDetailController: CanteenBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    private enum orderState{
        case alreadyOrder
        case needpay
        case alreadyDate
    }
    
    private enum Section:Int{
        case header
        case alert
        case address
        case foodstyle
        case orderPrice
        case together
        case remark
     }
    
    private lazy var shareView:OrderShareView = {
        let share = OrderShareView()
        return share
    }()
    
    private lazy var nextStepBtn:UIButton = {
        let next = UIButton(type: .custom)
        next.backgroundColor = UIColor.white
        next.setTitle("下一步", for: .normal)
        next.setTitleColor(UIColor.darkText, for: .normal)
        next.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        next.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return next
    }()
    
    private var selectType:eatType = .together {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadSections([Section.together.rawValue,Section.remark.rawValue], with: .none)
            }
        }
    }


    private lazy var tableView:TPKeyboardAvoidingTableView = {
        let tableView = TPKeyboardAvoidingTableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderNumberCell.self)
        tableView.registerClassOf(OrderFoodStyleCell.self)
        tableView.registerClassOf(ReservationSelectCell.self)
        tableView.registerClassOf(avatarCell.self)
        tableView.registerClassOf(UITableViewCell.self)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
        return tableView
    }()
    
    private lazy var bottomView:BottomView = BottomView()
    private var remarkText:String?
    private var goldenBellCode:String?
    private lazy var pickNum:PickPeopleNum = PickPeopleNum(with:.bellCode)
    var from:fromController = .fromRestaurant
    var orderReserveModel:OrderReserveModel?
    var reserveId:String = ""
    var orderNum:String = ""
    var reserveStatus = status.alreadyOrder.rawValue
    
    
   @objc func nextStep(){
        
        if let model = self.orderReserveModel,let groupId = model.groupId {
            let eat = EatTogetherController(groupID: groupId)
            eat.eattype = .together
            self.navigationController?.pushViewController(eat, animated: true)
        }else {
            showLoading()
            CheckToken.chekcTokenAPI(completion: { (result) in
                switch result {
                case .success(let check):
                    if check.status == "1" {
                    doneWith(memid: check.custom_code, token: check.newtoken)
                    }else {
                        self.goToLogin()
                    }
                case .failure(let error):
                    self.hideLoading()
                    self.showMessage(error.localizedDescription)
                }
            })
        }
            
        func doneWith(memid:String,token:String){
            
            EatGroupModel.AddGroupWithReserveID(reserveId,
                                                goldenBellYN: selectType == .together ? "N":"Y",
                                                groupDescription: remarkText ?? "",
                                                groupBellCode: goldenBellCode ?? "",
                                                memid: memid,
                                                token: token,
                                                completion:
                { (result) in
                    self.hideLoading()
                    switch result {
                    case .success(let json):
                        let eatTogether = EatTogetherController(groupID: json.data.groupID)
                        eatTogether.eattype = self.selectType
                        eatTogether.remarkText = self.remarkText
                        self.navigationController?.pushViewController(eatTogether, animated: true)
                    case .failure(let error):
                        self.showMessage(error.localizedDescription)
                    }
               })
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订单详情".localized
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
     }
    
    fileprivate func addBottomView(){
        
        if reserveStatus == status.alreadyOrder.rawValue {
            if let groupYN = orderReserveModel?.groupYN,
                   groupYN == "Y" {
               view.addSubview(nextStepBtn)
               nextStepBtn.snp.makeConstraints({ (make) in
                   make.leading.trailing.bottom.equalTo(view)
                   make.height.equalTo(50)
               })
               return
            }
            
            view.addSubview(bottomView)
            
            bottomView.deleteBlock = { [weak self] in
                self?.deleteOrder()
            }
            
            bottomView.goBlock = { [weak self] in
                guard let strongself = self,let model = strongself.orderReserveModel else {
                    return
                }
                let orderMenu = OrderMenuController(model.restaurantCode, nil, YCUserDefaults.canteendivCode.value ?? "1", strongself.from)
                orderMenu.needCondition = false
                orderMenu.reserveIdStr = strongself.reserveId
                strongself.navigationController?.pushViewController(orderMenu, animated: true)
            }
            
            bottomView.snp.makeConstraints({ (make) in
                make.leading.trailing.bottom.equalTo(view)
                make.height.equalTo(50)
            })
        }
    }
    
    override func yc_back() {
        self.navigationController?.viewControllers.forEach({ controller in
            if self.from == .fromRestaurant {
                if controller is OrderFoodController {
                   self.navigationController?.popToViewController(controller, animated: true)
                }
            } else if controller is OrderFormController {
                self.navigationController?.popToViewController(controller, animated: true)
            }else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    
   private func requestData(){
    
      showCustomloading()
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
            self.hideLoading()
        }
       }

    func doneWith(memid:String,token:String){
        OrderReserve.GetWithReserveID(reserveId,
                                      orderNum: orderNum,
                                      reserveStatus: reserveStatus,
                                      memid:memid,
                                      token:token,
                                      failureHandler:
        { [weak self] reason, errormessage in
            guard let strongself = self else { return }
            strongself.hideLoading()
            strongself.showMessage(errormessage)
        }) { [weak self] jsonModel in
            guard let strongself = self else { return }
            strongself.hideLoading()
            if let json = jsonModel {
                if json.status == -9001 {
                     strongself.goToLogin(completion: { 
                        strongself.requestData()
                     })
                     return
                }
                strongself.orderReserveModel = json.data
                strongself.addBottomView()
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
               }
            }
         }
    }
    
    func edit(){
        shareView.showInView(superView: view.window)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
     }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section),let status = status(rawValue: self.reserveStatus) else { fatalError() }
        switch section {
        case .foodstyle:
            if status == .alreadyChoose {
               return 10
            }else {
               return 0
            }
        case .orderPrice:
            if status == .alreadyOrder {
              return 0
            }else {
              return 10
            }
        default:
            return 10
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = orderReserveModel else { return 0 }
        return 7
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section),let status = status(rawValue: self.reserveStatus) else { fatalError() }
        switch section {
        case .header:
            return 3
        case .alert,.address:
            return 1
        case .together:
            if let model = self.orderReserveModel,let groupYN = model.groupYN,groupYN == "Y"{
                return 2
            }
            return 0
        case .remark:
            if let model = self.orderReserveModel,let groupYN = model.groupYN {
                if groupYN == "Y" && self.selectType == .kim {
                   return 1
                }
            }
               return 0
        case .foodstyle:
            if status == .alreadyChoose {
               return 2
            }else {
               return 0
            }
        case .orderPrice:
           if status == .alreadyOrder {
                return 0
             }else {
                return 3
             }
           }
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0}
        switch section {
        case .header:
            if indexPath.row == 0 {
                return OrderNumberCell.getHeight()
            }else if indexPath.row == 1 {
                return OrderShopDetailCell.getHeight()
            }else {
                return OrderOtherInfoCell.getHeightWithModel(orderReserveModel!)
            }
        case .alert:
            return 40
        case .foodstyle:
            if indexPath.row == 0 {
                return 40
            }else {
                return OrderFoodContainerCell.getHeightWithModelArray(orderReserveModel!.menu)
            }
        case .address:
            return OrderNumberCell.getHeight()
        case .orderPrice:
            if indexPath.row == 0 {
                return OtherInfolittleCell.getHeight()
            }else if indexPath.row == 1 {
                return OrderPriceBodyCell.getHeight()
            }else {
                return OrderPriceBottomCell.getHeight()
            }
        case .together:
            if let model = self.orderReserveModel,
                let groupYN = model.groupYN
            {
                guard groupYN == "Y" else {
                    return 0
                }
                if let groupList = model.groupList,!groupList.isEmpty {
                    if indexPath.row == 0 {
                        return 40
                    }else {
                        return avatarCell.getHeight()
                    }
                }else if let _ = model.groupId {
                    return 0
                }else {
                    return 40
                }
            }
            return 0
        case .remark:
            return ReservationRemarkCell.getHeight()
        }
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .header:
            if indexPath.row == 0 {
                let cell:OrderNumberCell = OrderNumberCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }else if indexPath.row == 1{
                let cell:OrderShopDetailCell = OrderShopDetailCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }else {
                let cell:OrderOtherInfoCell = OrderOtherInfoCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }
        case .alert:
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = UIColor(hex: 0xfff7d6)
            cell.textLabel?.textColor = UIColor(hex: 0xbea064)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.text = "具体桌位以实际就餐人数和餐厅安排为准".localized
            cell.selectionStyle = .none
            return cell
        case .address:
            let cell:OrderNumberCell = tableView.dequeueReusableCell()
            cell.updateWithAddress(orderReserveModel!)
            cell.accessoryType = .disclosureIndicator
            return cell
        case .foodstyle:
            if indexPath.row == 0 {
              let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
              cell.textLabel?.text = "菜品".localized
              cell.textLabel?.textColor = UIColor.darkcolor
              cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
              cell.selectionStyle = .none
              return cell
            }else{
                 let cell = OrderFoodContainerCell(style: .default, reuseIdentifier: nil)
                 cell.reserveModelArray = orderReserveModel!.menu
                 return cell
            }
        case .orderPrice:
            if indexPath.row == 0 {
                let cell:OrderleadTrailCell = OrderleadTrailCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }else if indexPath.row == 1 {
                let cell:OrderPriceBodyCell = OrderPriceBodyCell(style: .default, reuseIdentifier: nil)
                cell.updateWithModel(orderReserveModel!)
                return cell
            }else {
                let cell:OrderPriceBottomCell = OrderPriceBottomCell(style: .default, reuseIdentifier: nil)
                cell.refundAction = {
                    YCAlert.confirmOrCancel(title: "申请退款", message: "请问要申请退款吗", confirmTitle: "申请退款", cancelTitle: "取消", inViewController: self, withConfirmAction: {
                        self.deleteOrder()
                    })
                }
                return cell
            }
        case .together:
            if self.orderReserveModel?.groupYN == "Y" {
                if let groupList = self.orderReserveModel?.groupList,!groupList.isEmpty {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell()
                        cell.textLabel?.text = "一起吃的朋友"
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                        cell.textLabel?.textColor = UIColor.darkcolor
                        return cell
                    }else {
                        let cell:avatarCell = tableView.dequeueReusableCell()
                        cell.updateWithModelArray(groupList)
                        return cell
                     }
                }
                if self.orderReserveModel?.groupId == nil {
                    let cell:ReservationSelectCell = tableView.dequeueReusableCell()
                    if indexPath.row == 0 {
                        cell.leftlable.text = "一起吃吧"
                        cell.BellReasonBtn.isHidden = true
                        cell.whatkimBtn.isHidden = true
                    }else {
                        cell.leftlable.text = "金钟"
                        cell.BellReasonBtn.isHidden = self.selectType == .kim ? false:true
                        cell.whatkimBtn.isHidden = false
                        cell.BellReasonBtn.setTitle("选择原因", for: .normal)
                        cell.BellAction = {
                             self.showBellSubCode(completion: { bellData in
                                cell.BellReasonBtn.setTitle(bellData.CODE_NAME, for: .normal)
                             })
                        }
                        cell.whatAction = { [weak self] in
                           YCAlert.alert(title: "什么是金钟？", message: "想要请亲朋好友吃饭的话，请敲响金钟", dismissTitle: "确定", inViewController: self, withDismissAction: nil)
                        }
                    }
                    cell.selectAction = {
                        self.selectType = eatType(rawValue: indexPath.row)!
                    }
                    cell.updateSelected(indexPath.row == self.selectType.rawValue ? true:false )
                    return cell
                }
            }
            let cell = tableView.dequeueReusableCell()
            return cell
        case .remark:
            let cell:ReservationRemarkCell = ReservationRemarkCell(style: .default, reuseIdentifier: nil)
            cell.updateWithRemark(self.remarkText)
            cell.valueChangeAction = { text in
                self.remarkText = text
            }
            return cell
            }
      }
    
     func showBellSubCode(completion:((BellData)->Void)?){
        self.showLoading()
        GoldenBellCode.Get(failureHandler: { reason, errormessage in
            self.hideLoading()
            self.showMessage(errormessage)
        }) { model in
            self.hideLoading()
            if let model = model {
                guard let window = self.view.window else { return }
                self.pickNum.showInView(window)
                self.pickNum.BellDataArray = model.BellDataArray
                self.pickNum.confirmBlock = { index in
                  self.goldenBellCode = model.BellDataArray[index].SUB_CODE
                  completion?(model.BellDataArray[index])
                }
            }else {
                 self.showMessage("数据获取错误")
            }
        }
        
    }
    
    func deleteOrder(){
        self.showLoading()
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    doneWith(memid: check.custom_code, token: check.newtoken)
                }else {
                    self.goToLogin()
                    self.hideLoading()
                }
            case .failure(let error):
                self.hideLoading()
            }
        }

        func doneWith(memid:String,token:String){
           DeleteOrderWithReserveId(reserveId,
                                    cancelCode: "01",
                                    cancelReason: "",
                                    token:token,
                                    memid:memid,
                                    failureHandler:
          { reason, errormessage in
            self.hideLoading()
            self.showMessage(errormessage)
          }) { JsonDic in
            self.hideLoading()
            guard let jsondic = JsonDic else {
                return
            }
            let json = JSON(jsondic)
            if let status = json["status"].int {
              if status == 1 {
                self.navigationController?.popViewController(animated: true)
              }else if status == -9001 {
                self.goToLogin()
              }else {
                self.showMessage("删除失败")
              }
               return
            }
            self.showMessage("删除失败")
         }
        }
     }
    
}


///底部的View
class BottomView:UIView {
    
    private lazy var deleteOrder:UIButton = {
        let deleteOrder = UIButton(type: .custom)
        deleteOrder.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        deleteOrder.setTitleColor(UIColor.darkcolor, for: .normal)
        deleteOrder.setTitle("删除预约".localized, for: .normal)
        deleteOrder.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return deleteOrder
    }()
    
    private lazy var goToOrder:UIButton = {
        let goToOrder = UIButton(type: .custom)
        goToOrder.addTarget(self, action: #selector(goAction), for: .touchUpInside)
        goToOrder.setTitleColor(UIColor.darkcolor, for: .normal)
        goToOrder.setTitle("去点餐".localized, for: .normal)
        goToOrder.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return goToOrder
    }()
    
    var goBlock:(()->Void)?
    var deleteBlock:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(deleteOrder)
        addSubview(goToOrder)
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        deleteOrder.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
        
        goToOrder.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
        }
    }
    
    @objc fileprivate func goAction(){
       goBlock?()
    }
    
    @objc fileprivate func deleteAction(){
       deleteBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}



/// avatarCell
class avatarCell:UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView!
    private var grouplist = [GroupList](){
        didSet{
            let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
            waytoUpdate.performWithCollectionView(collectionview: collectionView)
        }
    }
    
    func updateWithModelArray(_ array:[GroupList]){
        self.grouplist = array
    }
    
    class func getHeight() -> CGFloat {
        return 70
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let flowLayOut = UICollectionViewFlowLayout()
        flowLayOut.itemSize = CGSize(width: 50, height: 70)
        flowLayOut.scrollDirection = .horizontal
        flowLayOut.minimumInteritemSpacing = 0
        flowLayOut.minimumLineSpacing = 0
        flowLayOut.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayOut)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClassOf(avatarSubCell.self)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grouplist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:avatarSubCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? avatarSubCell
        cell?.updateWithModel(grouplist[indexPath.row])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class avatarSubCell:UICollectionViewCell {
    
    private var avatarImgView:UIImageView!
    private var namelb:UILabel!
    
    func updateWithModel(_ model:GroupList){
       namelb.text = model.nickName
       let iconUrl = URL(string: model.iconImg)
       avatarImgView.kf.setImage(with: iconUrl)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarImgView = UIImageView()
        contentView.addSubview(avatarImgView)
        
        namelb = UILabel()
        namelb.textColor = UIColor.darkcolor
        namelb.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(namelb)
        makeConstraints()
    }
    
    private func makeConstraints(){
        
        avatarImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(30)
            make.top.equalTo(contentView).offset(10)
        }
        
        namelb.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImgView.snp.bottom).offset(10)
            make.centerX.equalTo(contentView)
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




