//
//  OffOrderDetailController.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

public class OffOrderDetailController: OfflineBaseController {
    
   public enum controllerType {
        case noServiceMarket
        case eatAndDrink
        
        var count:Int {
            switch self {
            case .eatAndDrink:
                return 3
            case .noServiceMarket:
                return 2
            }
        }
        
        func getHeight(_ type:sectionType) -> CGFloat{
            switch self {
            case .noServiceMarket:
                switch type {
                case .orderGoods,.orderInfo:
                    return 50
                case .orderQR:
                    return 0.01
                }
            case .eatAndDrink:
                return 50
            }
        }
    }
    
    enum sectionType:Int{
        case orderGoods
        case orderInfo
        case orderQR
        static let count = 3
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.section)!
        }
        init(section:Int){
            self.init(rawValue: section)!
        }
        var title:String? {
            switch self {
            case .orderGoods:
                return "订单商品"
            case .orderInfo:
                return "订单信息"
            case .orderQR:
                return "取单二维码"
            }
        }
        var cellHeight:CGFloat {
            switch self {
            case .orderGoods:
                return OffOrderDetailCell.getHeight()
            case .orderInfo:
                return 45
            case .orderQR:
                return OffGenerateQRCell.getHeight()
            }
        }
    }
    var showScope:Bool = false
    var tableView:UITableView!
    var cotType:controllerType = .noServiceMarket
    var orderlis:OffOrderListModel.Orderlis?
    var foodlis:OffFoodListModel.Foodorderlis?
    var dataSource = [OffOrderDetailModel.Orderdetai]()
    var refundDataSource = [OffOrderDetailModel.Orderdetai]()
    var model:OffOrderDetailModel!
    lazy var refundView:OffRefundView = {
        let refundView = OffRefundView()
        refundView.frame.size = CGSize(width: screenWidth, height: 44)
        refundView.scopeAction = { [weak self] isall in
            guard let this = self else { return }
            this.dataSource.forEach({
                if ( $0.canDelete ) { $0.isNeedDelete = isall ? true:false }
            })
            this.tableView.reloadSections([sectionType.orderGoods.rawValue], with: .none)
        }
        refundView.refundAction = { [weak self] status in
            guard let this = self else { return }
            if status == .firstStep {
                this.showScope = true
                this.tableView.reloadSections([sectionType.orderGoods.rawValue], with: .none)
            }else {
                YCAlert.confirmOrCancel(title: nil, message: "请问要对选择的商品进行退款操作吗", confirmTitle: "确定", cancelTitle: "取消", inViewController: this, withConfirmAction: {
                    this.requestRefundRecipet()
                 }, cancelAction: nil)
            }
            
        }
        return refundView
    }()
    
    
    convenience init(type:controllerType,orderlis:OffOrderListModel.Orderlis?){
        self.init(nibName: nil, bundle: nil)
        self.cotType = type
        self.orderlis = orderlis
    }
    
    convenience init(type:controllerType,foodlis:OffFoodListModel.Foodorderlis?){
        self.init(nibName: nil, bundle: nil)
        self.cotType = type
        self.foodlis = foodlis
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "订单详情"
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.01))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClassOf(OffOrderDetailCell.self)
        tableView.regisiterHeaderFooterClassOf(OrderDetailHeaderView.self)
        tableView.registerClassOf(OffOrderDescriptionCell.self)
        tableView.registerNibOf(YCLoadMoreCell.self)
        tableView.registerClassOf(OffGenerateQRCell.self)
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        
    }
    
    func requestData(finish:(()->Void)?){
        var orderNum:String?
        switch cotType {
        case .noServiceMarket:
            orderNum = orderlis?.orderNum
        case .eatAndDrink:
            orderNum = foodlis?.orderNum
        }
        OffOrderDetailModel.requestOrderDetail(orderNum: orderNum,cottype: cotType) { [weak self] (result) in
            guard let strongself = self else { return }
            switch result {
            case .success(let json):
                if json.status == "1" {
                  strongself.model = json
                  strongself.dataSource = json.orderDetail
                    if strongself.dataSource.isEmpty { finish?() } else {
                       strongself.tableView.reloadSections([sectionType.orderGoods.rawValue], with: .automatic)
                       finish?()
                    }
                    if strongself.cotType == .noServiceMarket {
                       for model in strongself.dataSource {
                            if model.canDelete == true {
                              strongself.tableView.tableFooterView = strongself.refundView
                              break
                           }
                       }
                    }
              }else {
                  strongself.showMessage(json.msg)
                  finish?()
                }
            case .failure(let failure):
                strongself.showMessage(failure.localizedDescription)
                finish?()
            }
        }
    }
    
    func requestRefundRecipet(){
        
        var orderNum:String!
        switch cotType {
        case .noServiceMarket:
            orderNum = orderlis?.orderNum
        case .eatAndDrink:
            orderNum = foodlis?.orderNum
        }
        var itemRefund = [[String:Any]]()
        for unitSource in dataSource {
            if (unitSource.canDelete && unitSource.isNeedDelete){
                let unit:[String:Any] = [
                    "item_code": unitSource.itemCode,
                    "ser_no": unitSource.serNo,
                    "order_q": unitSource.orderQ,
                    "order_p": unitSource.orderP
                ]
                itemRefund.append(unit)
            }
        }
        let tab = self.tabBarController as? OfflineTabController
        OffRefundModel.requestOrderRefund(inoutStatus:model.custominoutstatus,
                                          divcode: tab?.divCode ?? "1",
                                          orderNum: orderNum,
                                          orderItemRefund: itemRefund)
        { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let json):
                if (json["status"] as? String) == "1" {
                    this.showScope = false
                    this.refundView.isAll = false
                    this.refundView.Status = .zeroStep
                    this.dataSource.forEach({ $0.isNeedDelete = false })
                    this.tableView.reloadSections([sectionType.orderGoods.rawValue], with: .none)
                    this.showLoading()
                    this.requestData(finish: {
                        this.hideLoading()
                    })
                }else {
                    this.refundView.Status = .firstStep
                    this.showMessage((json["msg"] as? String))
                }
            case .failure(let error):
                this.showMessage(error.localizedDescription)
            }
        }
    }


    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

extension OffOrderDetailController:UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectiontype = sectionType(indexPath: indexPath)
        return sectiontype.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectiontype = sectionType(section: section)
        return cotType.getHeight(sectiontype)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .orderGoods:
            if let cell = cell as? OffOrderDetailCell {
                cell.scopeAction = { [weak self] isDeleteSelected in
                    guard let this = self else { return }
                    if isDeleteSelected == false {
                        this.refundView.isAll = false
                    }
                    this.dataSource[indexPath.row].isNeedDelete = isDeleteSelected
                }
                cell.helpAction = { [weak self] in
                    guard let this = self else { return }
                    YCAlert.alert(title: "提示", message: "请访问1楼顾客中心向工作人员确认该商品后即可给予退款", dismissTitle: "确定", inViewController: this, withDismissAction: nil)
                }
                cell.model = dataSource[indexPath.row]
                cell.updateShowScope(showScope)
           }else if let cell = cell as? YCLoadMoreCell {
                cell.activityIndicator.startAnimating()
                requestData(finish: { [weak cell] in
                    if let strongcell = cell {
                    strongcell.activityIndicator.stopAnimating()
                    strongcell.info = "请求失败"
                    }
                })
            }
        default:
            break
        }
    }

    
}

extension OffOrderDetailController:UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return cotType.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionType(section: section)
        switch section {
        case .orderGoods:
            return dataSource.isEmpty ? 1:dataSource.count
        case .orderInfo:
            return 3
        case .orderQR:
            switch cotType {
            case .eatAndDrink:
                return 1
            case .noServiceMarket:
                return 0
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectiontype = sectionType(section: section)
        let view:OrderDetailHeaderView = tableView.dequeueReusableHeaderFooter()
        view.titlelb.text = sectiontype.title
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .orderGoods:
            if !dataSource.isEmpty {
              let cell:OffOrderDetailCell = tableView.dequeueReusableCell()
              return cell
            }else {
                let cell:YCLoadMoreCell = tableView.dequeueReusableCell()
                cell.backgroundColor = UIColor.white
                return cell
            }
        case .orderInfo:
            let cell:OffOrderDescriptionCell = tableView.dequeueReusableCell()
            if indexPath.row == 0 {
                cell.leftlb.text = "订单编号"
                switch cotType {
                case .eatAndDrink:
                    cell.trailinglb.text = foodlis?.orderNum
                case .noServiceMarket:
                    cell.trailinglb.text = orderlis?.orderNum
                }
            }else if indexPath.row == 1 {
                cell.leftlb.text = "订单时间"
                switch cotType {
                case .eatAndDrink:
                    cell.trailinglb.text = foodlis?.orderDate
                case .noServiceMarket:
                    cell.trailinglb.text = orderlis?.orderDate
                }
            }else {
                cell.leftlb.text = "总金额"
                switch cotType {
                case .eatAndDrink:
                    cell.trailinglb.text = foodlis?.realAmount
                case .noServiceMarket:
                    cell.trailinglb.text = orderlis?.realAmount
                }
            }
            return cell
        case .orderQR:
            let cell:OffGenerateQRCell = tableView.dequeueReusableCell()
            cell.orderNum = foodlis?.orderNum
            return cell
        }
        
    }
}
