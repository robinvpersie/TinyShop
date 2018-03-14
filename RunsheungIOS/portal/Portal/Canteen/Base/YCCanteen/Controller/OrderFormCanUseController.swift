//
//  OrderFormCanUseController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON

class OrderFormCanUseController: CanteenBaseViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    private enum rowType:Int {
       case header
       case body
       case bottom
    }
    
    enum ControllerType:String {
        case all = "A"
        case consum = "B" //*"R"*//
        case refund = "C"
        case comment = "D"
    }
    
    private enum UpdateMode{
        case Static
        case TopRefresh
        case LoadMore
    }

    private var isFetching:Bool = false
    private var currentPage:Int = 0
    private var nextPage:Int = 1
    private var isloading:Bool = true
    private var needLoadMore:Bool = true
    var divCode:String!
    private var ReservelisArray = [Reservelis]()
    private lazy var canteenNeedLoginView:CanteenNeedLoginView = CanteenNeedLoginView()
    private var tableView:UITableView!
    var type:ControllerType = .all
    
    convenience init(_ type:ControllerType){
       self.init()
       self.type = type
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestDataWithModel(.TopRefresh)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.registerClassOf(OrderCanUseCell.self)
        tableView.registerClassOf(OrderCanUseHeaderCell.self)
        tableView.registerClassOf(OrderNeedPayBottomCell.self)
        tableView.registerClassOf(OrderCanUseBottomBasicCell.self)
        tableView.registerClassOf(OrderCommentBottomCell.self)
        tableView.registerClassOf(OrderRefundBottomCell.self)
        tableView.registerClassOf(RefundingCell.self)
        tableView.registerClassOf(AlreadyReadyCell.self)
        tableView.registerClassOf(AlreadyChooseCell.self)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.1))
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(topRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        if type == .all {
          requestDataWithModel(.Static)
        }

    }
    
    func fetchAgain() {
        requestDataWithModel(.Static)
    }
    
    @objc func topRefresh() {
        requestDataWithModel(.TopRefresh) { [weak self] in
            guard let strongself = self else {
               return
            }
            strongself.tableView.mj_header.endRefreshing()
            strongself.tableView.mj_footer.resetNoMoreData()
            
        }
    }
    
    @objc func loadMore() {
        requestDataWithModel(.LoadMore) { [weak self] in
            guard let strongself = self else {
               return
            }
            if strongself.needLoadMore {
                strongself.tableView.mj_footer.endRefreshing()
            }else {
                strongself.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
    
    private func requestDataWithModel(_ model:UpdateMode,finish:(() -> Void)? = nil){
        
        CheckToken.chekcTokenAPI { result in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    doneWith(memid: check.custom_code, token: check.newtoken)
                }else {
                   finish?()
                }
            case .failure(let error):
                finish?()
            }
        }
        
     func doneWith(memid:String,token:String){
        
        if isFetching {
           return
        }
        if case .LoadMore = model {
            if nextPage == 0 {
              self.needLoadMore = false
              finish?()
              return
            }
        }
        if model == .TopRefresh || model == .Static {
            nextPage = 1
        }
        isFetching = true
        CanteenAll.GetWithMemberId(memid,
                                   token:token,
                                   reserveType: type.rawValue,
                                   currentPage: nextPage,
        failureHandler: { [weak self] reason, errormessage in
            guard let strongself = self else {
                return
            }
            strongself.isFetching = false
            strongself.isloading = false
            strongself.tableView.reloadData()
            strongself.showMessage(errormessage)
            finish?()
        }) { [weak self] allmodel in
            guard let strongself = self else {
                return
            }
            strongself.isFetching = false
            strongself.isloading = false
            var waytoUpDate:UITableView.WayToUpdate = .none
            if let allmodel = allmodel {
                if allmodel.status == -9001 {
                   strongself.goToLogin(completion: { 
                     strongself.fetchAgain()
                   })
                   waytoUpDate.performWithTableView(tableview: strongself.tableView)
                   finish?()
                   strongself.needLoadMore = true
                   return
                }
                guard let data = allmodel.data else {
                   strongself.ReservelisArray.removeAll()
                   waytoUpDate = .reloadData
                   waytoUpDate.performWithTableView(tableview: strongself.tableView)
                   strongself.needLoadMore = true
                   finish?()
                   return
                }
               strongself.currentPage = data.currentPage
               strongself.nextPage = data.nextPage
               if case .Static = model {
                 waytoUpDate = .reloadData
                 strongself.ReservelisArray = data.reserveList
                 waytoUpDate.performWithTableView(tableview: strongself.tableView)
                 strongself.needLoadMore = true
                 strongself.tableView.mj_footer.resetNoMoreData()
               }
               if case .TopRefresh = model {
                  waytoUpDate = .reloadData
                  strongself.ReservelisArray = data.reserveList
                  waytoUpDate.performWithTableView(tableview: strongself.tableView)
                  strongself.needLoadMore = true
               }
               if case .LoadMore = model {
                 strongself.needLoadMore = data.reserveList.isEmpty ? false:true
                 let oldCount = strongself.ReservelisArray.count
                 strongself.ReservelisArray.append(contentsOf: data.reserveList)
                 let newCount = strongself.ReservelisArray.count
                 let indexes:IndexSet = IndexSet(integersIn: oldCount ..< newCount)
                 strongself.tableView.insertSections(indexes, with: .none)
               }
            }else {
               strongself.ReservelisArray.removeAll()
               waytoUpDate = .reloadData
               waytoUpDate.performWithTableView(tableview: strongself.tableView)
               strongself.needLoadMore = false
            }
            finish?()
         }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = ReservelisArray[indexPath.section]
        guard let status = status(rawValue: model.reserveStatus) else {
            fatalError()
        }
        switch status {
        case .alreadyChoose,.alreadyOrder:
            let orderFromDetail = OrderFormDetailController()
            orderFromDetail.reserveId = model.reserveId
            orderFromDetail.orderNum = model.orderNum
            orderFromDetail.reserveStatus = model.reserveStatus
            orderFromDetail.from = .fromOrder
            orderFromDetail.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(orderFromDetail, animated: true)
        case .needPay:
            if model.groupYN == "Y" {
              let together = EatTogetherController(groupID: model.groupId)
              together.hidesBottomBarWhenPushed = true
              navigationController?.pushViewController(together, animated: true)
            }else {
              let order = OrderConfirmController(orderNum: model.orderNum)
              order.newtitle = "订单详情"
              order.from = .fromOrder
              order.hidesBottomBarWhenPushed = true
              navigationController?.pushViewController(order, animated: true)
            }
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReservelisArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = ReservelisArray[section]
        guard let status = status(rawValue: model.reserveStatus) else {
            return 0
        }
        switch status {
        case .isRefunding,.refundFinish:
            return 2
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = rowType(rawValue: indexPath.row) else {
            return 0
        }
        switch type {
        case .header:
            return OrderCanUseHeaderCell.getHeight()
        case .body:
            guard let status = status(rawValue: ReservelisArray[indexPath.section].reserveStatus) else {
                return 0
            }
            switch status {
            case .alreadyChoose:
                 return AlreadyChooseCell.getHeight()
            case .alreadyOrder:
                 return AlreadyReadyCell.getHeight()
            case .finishCheckComment,.finishNeedComment,.needPay:
                 return OrderCanUseCell.getHeight()
            case .isRefunding,.refundFinish:
                 return RefundingCell.getHeight()
            }
        case .bottom:
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let Type = rowType(rawValue: indexPath.row) else {
            fatalError()
        }
        switch Type {
        case .header:
            let cell:OrderCanUseHeaderCell = tableView.dequeueReusableCell()
            cell.updateWithModel(ReservelisArray[indexPath.section])
            return cell
        case .body:
            guard let status = status(rawValue: ReservelisArray[indexPath.section].reserveStatus) else {
                fatalError()
            }
            switch status {
            case .alreadyChoose:
                let cell:AlreadyChooseCell = tableView.dequeueReusableCell()
                cell.updateWithModel(ReservelisArray[indexPath.section])
                return cell
            case .alreadyOrder:
                let cell:AlreadyReadyCell = tableView.dequeueReusableCell()
                cell.updateWithModel(ReservelisArray[indexPath.section])
                return cell
            case .finishCheckComment,.finishNeedComment,.needPay:
                let cell:OrderCanUseCell = tableView.dequeueReusableCell()
                cell.updateWithModel(ReservelisArray[indexPath.section])
                return cell
            case .isRefunding,.refundFinish:
                let cell:RefundingCell = tableView.dequeueReusableCell()
                cell.updateWithModel(ReservelisArray[indexPath.section])
                return cell
            }
        case .bottom:
            let model = ReservelisArray[indexPath.section]
            guard let status = status(rawValue: model.reserveStatus) else {
                fatalError()
            }
            switch status {
            case .needPay:
                let cell:OrderNeedPayBottomCell = tableView.dequeueReusableCell()
                cell.payAction = { [weak self] in
                    guard let strongself = self else {
                        return
                    }
                    strongself.PayMoneyWithModel(model)
                }
                cell.updateWithModel(ReservelisArray[indexPath.section])
                return cell
            case .alreadyChoose,.alreadyOrder:
                let cell:OrderCanUseBottomBasicCell = tableView.dequeueReusableCell()
                cell.updateWithModel(ReservelisArray[indexPath.section])
                return cell
            case .finishCheckComment:
                let cell:OrderCommentBottomCell = tableView.dequeueReusableCell()
                cell.againAction = { [weak self] in
                    guard let strongself = self else {
                        return
                    }
                    strongself.againAction(model.restaurantCode)
                }
                cell.commentAction = { [weak self] type in
                    guard let strongself = self else {
                        return
                    }
                    let orderFood = OrderFoodController()
                    orderFood.restaurantCode = strongself.ReservelisArray[indexPath.section].restaurantCode
                    orderFood.divCode = strongself.divCode
                    orderFood.hidesBottomBarWhenPushed = true
                    strongself.navigationController?.pushViewController(orderFood, animated: true)
                }
                cell.celltype = .check
                return cell
            case .finishNeedComment:
                let cell:OrderCommentBottomCell = tableView.dequeueReusableCell()
                cell.commentAction = { [weak self] type in
                    guard let strongself = self else {
                        return
                    }
                    let orderComment = OrderCommentController()
                    orderComment.divCode = strongself.divCode
                    orderComment.reservelis = strongself.ReservelisArray[indexPath.section]
                    orderComment.hidesBottomBarWhenPushed = true
                    strongself.navigationController?.pushViewController(orderComment, animated: true)
                }
                cell.celltype = .comment
                return cell
            case .isRefunding:
                fatalError()
            case .refundFinish:
                let cell:OrderRefundBottomCell = tableView.dequeueReusableCell()
                cell.againAction = { [weak self] in
                    guard let strongself = self else {
                        return
                    }
                    strongself.againAction(model.restaurantCode)
                }
                return cell
            }
        }
    }
    
    
    func PayMoneyWithModel(_ model:Reservelis){
            let passwordView = CYPasswordView()
            passwordView.loadingText = "提交中...".localized
            passwordView.title = "输入交易密码".localized
            passwordView.show(in: view.window!)
            passwordView.finish = { [weak self] password in
                guard let strongself = self else {
                    return
                }
                let encryptPassword = password!.sha512()
                passwordView.hideKeyboard()
                passwordView.startLoading()
                let account = YCAccountModel.getAccount()
                KLHttpTool.supermarketPay(withUserID: account?.memid ?? "",
                                          orderNumber: model.orderNum,
                                          orderMoney: model.amount,
                                          actualMoney: model.realAmount,
                                          point: model.pointAmount,
                                          couponCode: "0",
                                          password: encryptPassword,
                success: { jsonData in
                        guard let strongself = self else {
                            return
                        }
                        if let json = jsonData {
                            let Json = JSON(json)
                            let status = Json["status"].intValue
                            if status == 1711 {
                                passwordView.requestComplete(false, message: "余额不足".localized)
                            }else if status == 1 {
                                passwordView.requestComplete(true, message: "支付成功".localized)
                                let auth_no = Json["data"].dictionaryValue["auth_no"]?.stringValue
                                strongself.addPaymentAdvance(model: model, authno: auth_no!, finish: { isOk in
                                     OkAction()
                                })
                                return
                            }else if status == 10 {
                                passwordView.requestComplete(false, message: "支付密码错误".localized)
                            }else if status == 1603 {
                                passwordView.requestComplete(false, message: "无法确认登录信息".localized)
                            }else if status == 1101 {
                                passwordView.requestComplete(false, message: "没有支付密码".localized)
                            }else if status == -9001{
                                passwordView.requestComplete(false, message: Json["msg"].stringValue)
                                self?.goToLogin()
                            }else {
                                passwordView.requestComplete(false, message: Json["msg"].stringValue)
                            }
                        }else {
                            passwordView.requestComplete(false, message: "支付失败".localized)
                        }
                        delay(2, work: {
                            passwordView.hide()
                        })
                        
                }) {  error in
                    passwordView.requestComplete(false, message: "支付失败".localized)
                    delay(2, work: {
                        passwordView.hide()
                    })
                }
            }
            /// 支付成功之后的行动
            func OkAction(){
                delay(2, work: {
                    passwordView.hide()
                    self.fetchAgain()
                })
            }
    }
    
    
    private func addPaymentAdvance(model:Reservelis,authno:String,finish:@escaping (Bool)->Void){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                   doneWith(memid: check.custom_code, token: check.newtoken)
                }else {
                   finish(false)
                }
            case .failure(let error):
                finish(false)
            }
        }
        
      func doneWith(memid:String,token:String){
        AddPaymentAdvanceWithhPayType(payType.yuchengPay.payTypeParameter,
                                      authno: authno,
                                      point: model.pointAmount,
                                      orderNum: model.orderNum,
                                      orderAmount: model.realAmount,
                                      memid:memid,
                                      token:token,
        failureHandler: { reason, errormessage in
            finish(false)
        }) { dic in
            let json = JSON(dic!)
            let status = json["status"].intValue
            if status == 1 {
                finish(true)
                return
            }else if status == -9001 {
                self.goToLogin()
                finish(false)
                return
            }
            finish(false)
        }
        }
    }

    
    
    private func againAction(_ restaurantCode:String){
        let menu = OrderMenuController(restaurantCode, nil, "1",.fromOrder)
        menu.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if isloading {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            return indicator
        } else {
            let nodata = YCNoDataAlertView()
            nodata.freshAction = { [weak self] in
                guard let strongself = self else { return }
                strongself.fetchAgain()
            }
            return nodata
        }
    }

}
