//
//  OrderConfirmController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import CryptoSwift
import Alamofire

class OrderConfirmController: CanteenBaseViewController {
    
    private var tableView:UITableView!
    private var bottomContainerView:UIView!
    fileprivate var pricelable:UILabel!
    private var uploadOrderBtn:UIButton!
    private var isUpdatePay:Bool = false
    var from:fromController = .fromRestaurant

    fileprivate enum sectionType:Int {
       case shopInfo
       case detail
       case pay
    }
    
    fileprivate enum rowType:Int {
       case styleAndPrice
       case foodMenu
       case timeAndPeopleNum
       case point
    }
    fileprivate var selectPayType:payType = .yuchengPay
    fileprivate var orderNum:String!
    var reserveId:String!
    fileprivate var isPointSelected:Bool = false

    fileprivate var orderConfirmModel:OrderConfirmModel?{
        didSet{
          if let model = orderConfirmModel {
             self.tableView.reloadData()
            if from == .fromRestaurant {
              pricelable.text = "￥" + model.totalAmount
            }else {
              pricelable.text = "￥" + model.actualOrderAmount!
            }
          }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(orderNum:String,reserveId:String = ""){
        self.init()
        self.orderNum = orderNum
        self.reserveId = reserveId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI(){
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderConfirmShopInfoCell.self)
        tableView.registerClassOf(FoodMenulistCell.self)
        tableView.registerClassOf(OrderConfirmTimeNumCell.self)
        tableView.registerClassOf(OrderConfirmPayCell.self)
        tableView.registerClassOf(UITableViewCell.self)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        bottomContainerView = UIView()
        bottomContainerView.backgroundColor = UIColor.white
        view.addSubview(bottomContainerView)
        
        pricelable = UILabel()
        pricelable.textColor = UIColor.navigationbarColor
        pricelable.font = UIFont.systemFont(ofSize: 15)
        bottomContainerView.addSubview(pricelable)
        
        uploadOrderBtn = UIButton(type: .custom)
        let tt = newtitle == "订单确认" ? "提交订单":"去结算"
        uploadOrderBtn.setTitle(tt.localized, for: .normal)
        uploadOrderBtn.setTitleColor(UIColor.white, for: .normal)
        uploadOrderBtn.backgroundColor = UIColor.navigationbarColor
        uploadOrderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        uploadOrderBtn.addTarget(self, action: #selector(upload), for: .touchUpInside)
        bottomContainerView.addSubview(uploadOrderBtn)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 50, 0))
        }
        
        bottomContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
        }
        
        pricelable.snp.makeConstraints { (make) in
            make.leading.equalTo(bottomContainerView).offset(15)
            make.centerY.equalTo(bottomContainerView)
        }
        
        uploadOrderBtn.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalTo(bottomContainerView)
            make.width.equalTo(150)
        }
    
    }
    
    var newtitle:String = "订单确认"
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if newtitle == "订单确认".localized {
            updateUnpayOrder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = newtitle.localized
        makeUI()
        requestData()
    }
    
    
    private func requestData(){
        
        showCustomloading()
        confirmModel.GetWithOrderNum(orderNum) { [weak self] result in
            guard let strongself = self else {
               return
            }
            strongself.hideLoading()
            switch result {
            case .success(let json):
                let status = json.status
                if status == -9001 {
                 strongself.goToLogin(completion: {
                    strongself.requestData()
                  })
                   return
                  }
                 strongself.orderConfirmModel = json.data
                  if let data = json.data,let payer = data.payer,!payer.characters.isEmpty {
                    let detail = OrderFormDetailController()
                    detail.from = strongself.from
                    detail.reserveId = strongself.reserveId
                    detail.orderNum = data.orderNum
                    detail.reserveStatus = "B"
                    strongself.navigationController?.pushViewController(detail, animated: true)
                    return
                }
            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
        }
    }
    
    
    private func addPaymentAdvance(authno:String,finish:@escaping (Bool)->Void){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                doneWith(memid: check.custom_code, token: check.newtoken)
            case .failure(let error):
                finish(false)
            }
        }
        
        func doneWith(memid:String,token:String) {
        
        let point = isPointSelected ? orderConfirmModel!.canConsumePoint : "0"
        let payAmount = Float(orderConfirmModel!.totalAmount)! - Float(point)!
        AddPaymentAdvanceWithhPayType(selectPayType.payTypeParameter,
                                      authno: authno,
                                      point: point,
                                      orderNum: orderNum,
                                      orderAmount: String(format: "%.2f", payAmount),
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
    
    
    func updateUnpayOrder(){
        let acturalMoney = isPointSelected ? Float(orderConfirmModel!.totalAmount)! - Float(orderConfirmModel!.canConsumePoint)! : Float(orderConfirmModel!.totalAmount)!
        let usePoint:String = isPointSelected ? orderConfirmModel!.canConsumePoint : "0"
        self.UpdateUnpayOrder(orderNo:orderNum,
                              orderAmount: orderConfirmModel!.totalAmount,
                              realAmount: acturalMoney,
                              pointAmount: usePoint,
                              couponAmount: 0.0)
        { result in
            
        }
    }
    
    override func popBack() {
        super.popBack()
    }

    
    func upload(){
        
        if !YCAccountModel.islogin() {
           self.goToLogin()
           return
        }
        
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
           let usePoint = strongself.isPointSelected ? strongself.orderConfirmModel!.canConsumePoint : "0"
           let acturalMoney = strongself.isPointSelected ? Float(strongself.orderConfirmModel!.totalAmount)! - Float(strongself.orderConfirmModel!.canConsumePoint)! : Float(strongself.orderConfirmModel!.totalAmount)!
            
           KLHttpTool.supermarketPay(withUserID: account?.memid ?? "",
                                    orderNumber: strongself.orderNum,
                                    orderMoney: strongself.orderConfirmModel!.totalAmount,
                                    actualMoney: "\(acturalMoney)",
                                    point: usePoint,
                                    couponCode: "0",
                                    password: encryptPassword,
            success: { [weak self] jsonData in
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
                          strongself.addPaymentAdvance(authno: auth_no!, finish: { isOk in
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
                          strongself.goToLogin()
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
                let confirm = OrderFormDetailController()
                confirm.reserveStatus = status.alreadyChoose.rawValue
                confirm.reserveId = self.reserveId
                confirm.orderNum = self.orderNum
                confirm.from = self.from
                self.navigationController?.pushViewController(confirm, animated: true)
            })
          }
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OrderConfirmController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == sectionType.pay.rawValue {
           selectPayType = payType(rawValue: indexPath.row)!
        }
    }

}

extension OrderConfirmController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sectionType.shopInfo.rawValue {
           return 0.01
        }else {
          return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = orderConfirmModel else {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sectionType(rawValue: section) else { return 0 }
        switch section {
        case .shopInfo:
            return 1
        case .detail:
            let tt = newtitle == "订单确认" ? 4:3
            return tt
        case .pay:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .shopInfo:
            let cell:OrderConfirmShopInfoCell = tableView.dequeueReusableCell()
            return cell
        case .detail:
            guard let rowType = rowType(rawValue: indexPath.row) else { fatalError() }
            switch rowType {
            case .styleAndPrice:
                let cell = tableView.dequeueReusableCell()
                cell.selectionStyle = .none
                return cell
            case .foodMenu:
                let cell:FoodMenulistCell = tableView.dequeueReusableCell()
                return cell
            case .timeAndPeopleNum:
                let cell:OrderConfirmTimeNumCell = tableView.dequeueReusableCell()
                return cell
            case .point:
                let cell = orderConfirmPointCell(style: .default, reuseIdentifier: nil)
                return cell
            }
        case .pay:
            let cell:OrderConfirmPayCell = tableView.dequeueReusableCell()
            guard let payType = payType(rawValue: indexPath.row) else { fatalError() }
            if payType == selectPayType {
                cell.paySelected.image = UIImage.selectedImage
            }else {
                cell.paySelected.image = UIImage.unselectedImage
            }
            return cell
         }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .shopInfo:
            let cell = cell as! OrderConfirmShopInfoCell
            cell.confirmModel = self.orderConfirmModel
        case .detail:
            guard let rowType = rowType(rawValue: indexPath.row) else { fatalError() }
            switch rowType {
            case .styleAndPrice:
                cell.textLabel?.text = "\(self.orderConfirmModel!.orderItemList.count)样菜品"
                cell.textLabel?.textColor = UIColor.darkcolor
            case .foodMenu:
                let cell = cell as! FoodMenulistCell
                cell.compareModelArray = orderConfirmModel!.orderItemList
            case .timeAndPeopleNum:
                let cell = cell as! OrderConfirmTimeNumCell
                cell.num.text = "就餐人数".localized + ":" + self.orderConfirmModel!.personCnt + "人".localized
                cell.time.text = "就餐时间".localized + ":" + self.orderConfirmModel!.reserveDate
            case .point:
                let cell = cell as! orderConfirmPointCell
                cell.updateWithSelected(self.isPointSelected)
                let point = orderConfirmModel!.canConsumePoint
                cell.pointlb.text = "可使用\(point)积分抵消\(point)元"
                cell.selectAction = { [weak self] in
                    guard let strongself = self else { return }
                    strongself.isPointSelected = !strongself.isPointSelected
                    tableView.reloadRows(at: [indexPath], with: .none)
                    if strongself.isPointSelected {
                       let price = Float(strongself.orderConfirmModel!.totalAmount)! - Float(strongself.orderConfirmModel!.canConsumePoint)!
                       strongself.pricelable.text = "￥\(price)"
                    }else {
                       strongself.pricelable.text = "￥" + strongself.orderConfirmModel!.totalAmount
                    }
                }
            }
        case .pay:
            guard let payType = payType(rawValue: indexPath.row) else {
                fatalError()
            }
            let cell = cell as! OrderConfirmPayCell
            cell.payImageView.image = payType.cellImage
            cell.payName.text = payType.cellTitle.localized
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .shopInfo:
            return OrderConfirmShopInfoCell.getHeight()
        case .detail:
            guard let rowType = rowType(rawValue: indexPath.row) else { fatalError() }
            switch rowType {
            case .styleAndPrice,.point:
                return 45
            case .foodMenu:
                return FoodMenulistCell.getHeightWithModel(orderConfirmModel!.orderItemList)
            case .timeAndPeopleNum:
                return OrderConfirmTimeNumCell.getHeight()
            }
        case .pay:
            return OrderConfirmPayCell.getHeight()
        }
    }

}




extension OrderConfirmController {
    
    func UpdateUnpayOrder(orderNo:String,
                          orderAmount:String,
                          realAmount:Float,
                          pointAmount:String,
                          couponAmount:Float,
                          completion:@escaping (NetWorkResult<JSONDictionary>)->Void)
    {
        
        let account = YCAccountModel.getAccount()
        
        let requestParameters:[String:Any] = [
           "orderNo":orderNo,
           "memberID":account?.memid ?? "",
           "orderAmount":orderAmount,
           "realAmount":realAmount,
           "pointAmount":pointAmount,
           "couponAmount":couponAmount,
           "token":account?.token ?? ""
        ]
        
        let parse:(JSONDictionary) -> JSONDictionary? = { json in
           return json
        }
        
        let netResource = NetResource(baseURL: BaseType.canteen.URI,
                                      path: "/UpdateUnpayOrder",
                                      method: .post,
                                      parameters: requestParameters,
                                      parameterEncoding: URLEncoding(destination: .queryString) ,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
        
    }

}


