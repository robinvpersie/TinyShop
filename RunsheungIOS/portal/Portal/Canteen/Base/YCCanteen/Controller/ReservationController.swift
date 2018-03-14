//
//  ReservationController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import SwiftDate
import SwiftyJSON
import Alamofire

public struct OrderCondition {
    var isNeedBox:Bool = false
    var peopleNum:Int?
    var timestr:String?
    var dateStr:String?
    var phoneStr:String?
    var contactStr:String?
    var remarkStr:String?
}

class ReservationController: CanteenBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    struct webRounter:URLRequestConvertible {
        let customCode:String
        let searchDate:String
        func asURLRequest() throws -> URLRequest {
            let requestParameter = [
                "customCode":customCode,
                "searchDate":searchDate
            ]
            guard let BaseUrl = URL(string: BaseType.canteen.baseURL) else {
                throw ParseError.failedToGenerate(property: "baseurl")
            }
            let urlrequest = URLRequest(url: BaseUrl.appendingPathComponent(canteenDinnerTableListKey))
            do {
                var request = try URLEncoding(destination: .queryString).encode(urlrequest, with: requestParameter)
                request.httpMethod = "GET"
                return request
            }catch let error {
                throw error
            }
        }
    }

    
    enum reservationType{
       case justFood
       case foodAndReservation
       case eatTogether
    }
    
    private enum rowType:Int {
        case time
        case peoplenum
        case needBox
        case contact
        case phone
        case remark
    }
    
    private lazy var tableView:TPKeyboardAvoidingTableView = {
        let tableView = TPKeyboardAvoidingTableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(ReservationBasicCell.self)
        tableView.registerClassOf(ReservationSelectCell.self)
        tableView.registerClassOf(ReservationRemarkCell.self)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = UIColor.classBackGroundColor
        return tableView
    }()
    
    private lazy var bottomView:ReservationBottomView = {
        let bottomView = ReservationBottomView()
        bottomView.clickAction = { [weak self] type in
            guard let strongself = self else {
                return
            }
            switch type {
            case .food:
                strongself.checkCondition(finish: { isOk in
                    if isOk {
                        YCAlert.confirmOrCancel(title: "选择菜单".localized, message: "若进行点单，则无法再修改预约信息。请问要继续吗？（没有点菜单也完成续约）".localized, confirmTitle: "选择菜单".localized, cancelTitle: "取消".localized, inViewController: self, withConfirmAction: {
                            let menu = OrderMenuController(strongself.restaurantCode,strongself.conditionModel,strongself.divCode)
                            menu.needCondition = false
                            menu.from = .fromRestaurant
                            strongself.navigationController?.pushViewController(menu, animated: true)
                        })
                    }
                })
            case .reservation:
                strongself.checkCondition(finish: { ok in
                    if ok {
                        YCAlert.confirmOrCancel(title: "预约完成".localized, message: "若预约完成，则无法再修改其内容。请问要完成续约吗？".localized, confirmTitle: "预约完成".localized, cancelTitle: "取消".localized, inViewController: self, withConfirmAction: {
                            strongself.showLoading()
                            strongself.addReserve(finish: { (issuccess,reserveId) in
                                strongself.hideLoading()
                                if issuccess {
                                    let orderFormDetail = OrderFormDetailController()
                                    orderFormDetail.reserveId = reserveId!
                                    orderFormDetail.reserveStatus = "R"
                                    strongself.navigationController?.pushViewController(orderFormDetail, animated: true)
                                }else {
                                    strongself.showMessage("预约失败".localized)
                                }
                            })
                        })
                    }
                })
            }
        }

        return bottomView
    }()
    
    private lazy var bottomFoodBtn:UIButton = {
        let food = UIButton()
        food.addTarget(self, action: #selector(clickFood), for: .touchUpInside)
        food.setTitle("确认下单".localized, for: .normal)
        food.setTitleColor(UIColor.white, for: .normal)
        food.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        food.backgroundColor = UIColor.navigationbarColor
        return food
    }()
    
    private lazy var nextStepBtn:UIButton = {
        let step = UIButton(type: .custom)
        step.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        step.setTitle("下一步".localized, for: .normal)
        step.setTitleColor(UIColor.white, for: .normal)
        step.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        step.backgroundColor = UIColor.navigationbarColor
        return step
    }()
    
    private lazy var reserveStatusBtn:UIButton = {
        let status = UIButton(type: .custom)
        status.addTarget(self, action: #selector(didStatus), for: .touchUpInside)
        status.setTitle("预约现况".localized, for: .normal)
        status.setTitleColor(UIColor.navigationbarColor, for: .normal)
        status.layer.borderWidth = 1
        status.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        status.layer.borderColor = UIColor.navigationbarColor.cgColor
        let width = "预约现况".localized.widthWithConstrainedWidth(height: 20, font: UIFont.systemFont(ofSize: 13))
        status.frame = CGRect(x: 0, y: 0, width: width+10, height: 20)
        return status
    }()
    
    
    lazy var pickDateView:PickReservationDate = PickReservationDate()
    
    lazy var pickNum:PickPeopleNum = PickPeopleNum()
    
    lazy var pickTime:PickPeopleNum = PickPeopleNum(with: .ordertime)
    
    var conditionModel:OrderCondition?{
        set{
            if let model = newValue {
               isNeedBox = model.isNeedBox
               peopleNum = model.peopleNum ?? 1
               timestr = model.timestr
               dateStr = model.dateStr
               phoneStr = model.phoneStr
               contactStr = model.contactStr
               remarkStr = model.remarkStr!
            }
        }
        get{
            let model = OrderCondition(isNeedBox: isNeedBox,
                                       peopleNum: peopleNum,
                                       timestr: timestr,
                                       dateStr: dateStr,
                                       phoneStr: phoneStr,
                                       contactStr: contactStr,
                                       remarkStr: remarkStr)
           return model
        }
    }
    var compareModelArray = [[compareMenuModel]]()
    var isNeedBox = false
    var from:fromController = .fromRestaurant
    
    var peopleNum:Int = 1{
        didSet{
         tableView.reloadRows(at: [IndexPath(row: rowType.peoplenum.rawValue, section: 0)], with: .none)
        }
    }
    
    var timestr:String?{
        didSet {
         tableView.reloadRows(at: [IndexPath(row: rowType.time.rawValue, section: 0)], with: .none)
        }
    }
    
    var dateStr:String?
    var phoneStr:String?{
        didSet{
         tableView.reloadRows(at: [IndexPath(row: rowType.phone.rawValue, section: 0)], with: .none)
        }
    }
    var contactStr:String?{
        didSet{
          tableView.reloadRows(at: [IndexPath(row: rowType.contact.rawValue, section: 0)], with: .none)
        }
    }
    var remarkStr:String = ""{
        didSet{
           tableView.reloadRows(at: [IndexPath(row: rowType.remark.rawValue, section: 0)], with: .none)
        }
    }
    var restaurantCode:String!
    var divCode:String!
    var reserveID:String?
    var controllerType:reservationType!
    
    convenience init(_ restaurantCode:String,_ type:reservationType = .foodAndReservation,_ divCode:String){
       self.init()
       self.restaurantCode = restaurantCode
       self.controllerType = type
       self.divCode = divCode
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "预约用餐".localized
        
        let trailingItem = UIBarButtonItem(customView: reserveStatusBtn)
        self.navigationItem.rightBarButtonItem = trailingItem
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(tableView)
        view.addSubview(bottomView)
        makeConstraint()

        if controllerType == .justFood {
          view.addSubview(bottomFoodBtn)
          bottomFoodBtn.snp.makeConstraints({ make in
            make.edges.equalTo(bottomView)
          })
        }
        
        if controllerType == .eatTogether {
          view.addSubview(nextStepBtn)
          nextStepBtn.snp.makeConstraints({ make in
            make.edges.equalTo(bottomView)
          })
        }
        
        if let account = YCAccountModel.getAccount() {
           phoneStr = account.customId
           contactStr = account.userName
        }
        
        let defaultDate = Date(timeIntervalSinceNow: 60 * 60)
        dateStr = defaultDate.string(format: .custom("YYYYMMddHHmm"))
        
        let month = defaultDate.month
        let day = defaultDate.day
        let hour = defaultDate.hour
        let minute = defaultDate.minute
        timestr = "\(month)月"+"\(day)日"+"\(hour)时"+"\(minute)分"
    }
    
    func didStatus(){
        
        guard let time = self.dateStr else {
            YCAlert.alert(title: "尚未选择时间".localized, message: nil, dismissTitle: "确定".localized, inViewController: self, withDismissAction: nil)
            return
        }
        let webrouter = webRounter(customCode: restaurantCode, searchDate:time)
        let eatweb = EatWebController(url: webrouter)
        eatweb.hideNavigation = true
        self.navigationController?.pushViewController(eatweb, animated: true)
        
    }
    
    
    func nextStep(){
        self.checkCondition { ok in
            if ok {
               self.showLoading()
               self.addReserve("Y",finish: { isSuccess, reserveId in
                   self.hideLoading()
                   if isSuccess {
                     let orderFormDetail = OrderFormDetailController()
                     orderFormDetail.reserveId = reserveId!
                     self.navigationController?.pushViewController(orderFormDetail, animated: true)
                }else {
                    if let msg = reserveId {
                      self.showMessage(msg)
                    }else {
                      self.showMessage("删除失败")
                    }
                }
              })
           }
        }
    }

    
    private func addReserve(_ groupYN:String? = nil,finish:((_ isSuccess:Bool,_ reserveId:String?) -> Void)? = nil){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    let phone = check.custom_code
                    let token = check.newtoken
                    OrderAddReserve(restaurantCode: self.restaurantCode,
                                    userId: phone ,
                                    reserveDate: self.dateStr!,
                                    personCount: self.peopleNum,
                                    userName: self.contactStr!,
                                    phoneNumber: self.phoneStr!,
                                    roomUse: self.isNeedBox ? 1:0,
                                    description: self.remarkStr,
                                    token: token,
                                    groupYN:groupYN,
                                    failureHandler: { reason, errormessage in
                                        self.hideLoading()
                                        finish?(false,errormessage)
                    }, completion: { jsonData in
                        guard let json = jsonData else {
                            finish?(false,nil)
                            return
                        }
                        let newjson = JSON(json)
                        if let status = newjson["status"].int {
                            switch status {
                            case 1:
                                let dataJson = newjson["data"].dictionaryValue
                                let reserveId = dataJson["reserveID"]?.stringValue
                                finish?(true,reserveId)
                            case -9001:
                                self.goToLogin()
                            default:
                                let msg = newjson["msg"].string
                                finish?(false,msg)
                            }
                        }
                    })

                }else {
                  self.hideLoading()
                  self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
            }
        }
    }
    
    
    private func checkCondition(finish:((_ isOk:Bool) -> Void)){
        
        if dateStr == nil {
            showMessage("尚未选择时间".localized)
            finish(false)
            return
        }else if phoneStr == nil {
            showMessage("填写电话号码".localized)
            finish(false)
            return
        }else {
            guard let contact = contactStr else {
                finish(false)
                return
            }
            if contact.characters.count <= 0 {
                  showMessage("请填写联系人".localized)
                  finish(false)
                  return
            }
        }
        finish(true)
    }
    
    
    func clickFood(){
        checkCondition { (ok) in
            if ok {
                self.showLoading()
                addReserve {  isSuccess,reserveId in
                    self.hideLoading()
                    if isSuccess {
                        self.addOrderWithReserveId(reserveId!)
                    }else {
                        self.showMessage("预约失败")
                    }
                }
             }
        }
    }
    
    
    private func addOrderWithReserveId(_ reserveId:String){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    doneWith(userid: check.custom_code, token: check.newtoken)
                }else {
                  self.hideLoading()
                  self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
                self.showMessage(error.localizedDescription)
            }
        }
        
        func doneWith(userid:String,token:String) {
          var uploadDic = [[String:Any]]()
          uploadDic = compareModelArray.map({
             var dic = [String:Any]()
             dic["itemCode"] = $0[0].menulis.itemCode
             dic["itemAmount"] = "\($0[0].menulis.itemAmount)"
             dic["count"] = $0.count
             return dic
           })
          let reservation = ReservationRounter(divCode: divCode, reserveId: reserveId, restaurantCode: restaurantCode, userId: userid, token: token,Json:uploadDic)
          do {
            let urlrequest = try reservation.asURLRequest()
            Alamofire.request(urlrequest).responseJSON(completionHandler: { (response) in
                self.hideLoading()
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
                    if json["status"].intValue == 1 {
                        self.showMessage("下单成功")
                        let orderConfirm = OrderConfirmController(orderNum: json["data"].stringValue)
                        orderConfirm.from = self.from
                        orderConfirm.reserveId = reserveId
                        self.navigationController?.pushViewController(orderConfirm, animated: true)
                    }else if json["status"].intValue == -9001 {
                         self.goToLogin()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }catch let error {
           print(error.localizedDescription)
        }
      }
    }
    
    private func makeConstraint(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 50, 0))
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = rowType(rawValue: indexPath.row) else { fatalError() }
        switch rowType {
        case .time,.peoplenum,.contact,.phone:
            let cell:ReservationBasicCell = tableView.dequeueReusableCell()
            if case .time = rowType {
               cell.textfield.isUserInteractionEnabled = false
               cell.textfield.placeholder = "请选择就餐时间".localized
               cell.leftlable.text = "就餐时间".localized
               cell.updateWithTimeStr(timestr)
            }else if case .peoplenum = rowType {
               cell.leftlable.text = "就餐人数".localized
               cell.textfield.placeholder = "填写就餐人数".localized
               cell.textfield.isUserInteractionEnabled = false
               cell.updateWithNum(peopleNum)
            }
            else if case .contact = rowType {
               cell.leftlable.text = "联系人".localized
               cell.textfield.placeholder = "请输入联系人".localized
               cell.textfield.isUserInteractionEnabled = true
               cell.textfield.keyboardType = .namePhonePad
               cell.updateWithContact(contactStr)
               cell.valueChangeAction = { [weak self] contactStr in
                 guard let strongself = self else { return }
                 strongself.contactStr = contactStr
                }
            }else if case .phone = rowType {
               cell.leftlable.text = "联系电话".localized
               cell.textfield.placeholder = "请输入联系电话".localized
               cell.textfield.isUserInteractionEnabled = true
               cell.textfield.keyboardType = .phonePad
               cell.updateWithPhone(phoneStr)
               cell.valueChangeAction = { [weak self] phoneStr in
               guard let strongself = self else { return }
                strongself.phoneStr = phoneStr
               }
            }
            return cell
        case .needBox:
            let cell:ReservationSelectCell = tableView.dequeueReusableCell()
            cell.leftlable.text = "是否需要包厢".localized
            cell.updateSelected(isNeedBox)
            cell.selectAction = { [weak self] in
               guard let strongself = self else { return }
               strongself.isNeedBox = !strongself.isNeedBox
               tableView.beginUpdates()
               tableView.reloadRows(at: [indexPath], with: .automatic)
               tableView.endUpdates()
            }
            return cell
        case .remark:
            let cell:ReservationRemarkCell = tableView.dequeueReusableCell()
            cell.updateWithRemark(remarkStr)
            cell.valueChangeAction = { [weak self] remark in
                guard let strongself = self else { return }
                strongself.remarkStr = remark
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rowtype = rowType(rawValue: indexPath.row) else { fatalError() }
        switch rowtype {
        case .contact,.needBox,.peoplenum,.phone,.time:
            return 45
        case .remark:
            return ReservationRemarkCell.getHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == rowType.time.rawValue {
           chooseTime()
        }else if indexPath.row == rowType.peoplenum.rawValue {
           chooseNum()
        }
    }
    
    private func chooseNum(){
        if controllerType == .eatTogether {
           pickNum.selectType = .eattogether
        }else {
           pickNum.selectType = .peoplenum
        }
       pickNum.showInView(view.window!)
       pickNum.confirmBlock = { [weak self] num in
        guard let strongself = self else { return }
        strongself.peopleNum = num
        }

    }
    
    private func chooseTime(){
       pickDateView.showInView(view.window!)
       pickDateView.dateAction = {[weak self] date in
        guard let strongself = self else {
            return
        }
        let month = date.month
        let day = date.day
        let hour = date.hour
        let minute = date.minute
        strongself.timestr = "\(month)月"+"\(day)日"+"\(hour)时"+"\(minute)分"
        strongself.dateStr = date.string(format: .custom("YYYYMMddHHmm"))
    
      }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


class ReservationBottomView:UIView {
    
    enum reservationType:String{
       case reservation = "预约"
       case food = "点餐"
    }
    
    var clickAction:((_ type:reservationType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        let reservationBtn = UIButton(type: .custom)
        reservationBtn.setTitle(reservationType.reservation.rawValue.localized, for: .normal)
        reservationBtn.setTitleColor(UIColor.darkcolor, for: .normal)
        reservationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        reservationBtn.addTarget(self, action: #selector(didreservation), for: .touchUpInside)
        addSubview(reservationBtn)
        
        let food = UIButton(type: .custom)
        food.setTitle(reservationType.food.rawValue.localized, for: .normal)
        food.setTitleColor(UIColor.darkcolor, for: .normal)
        food.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        food.addTarget(self, action: #selector(didfood), for: .touchUpInside)
        addSubview(food)
        
        let centerView = UIView()
        centerView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(centerView)
        
        reservationBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(self).multipliedBy(0.5)
            make.leading.bottom.equalTo(self)
        }
        
        food.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(self).multipliedBy(0.5)
            make.trailing.bottom.equalTo(self)
        }

        centerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.bottom.centerX.equalTo(self)
        }
    }
    
    func didfood(){
       clickAction?(.food)
    }
    
    func didreservation(){
       clickAction?(.reservation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}





//////////////////////

class PickPeopleNum:UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    private lazy var containerView:UIButton = {
       let container = UIButton(type: .custom)
       container.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
       container.backgroundColor = UIColor.black
       container.alpha = 0.5
       return container
    }()
    
    private lazy var pickContainerView:UIView = {
       let picker = UIView()
       picker.backgroundColor = UIColor.classBackGroundColor
       return picker
    }()
    
    private lazy var topBar:UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.white
        return bar
    }()
    
    private lazy var cancleBtn:UIButton = {
         let cancle = UIButton()
         cancle.setTitle("取消".localized, for: .normal)
         cancle.setTitleColor(UIColor.YClightBlueColor, for: .normal)
         cancle.titleLabel?.font = UIFont.systemFont(ofSize: 15)
         cancle.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
         return cancle
    }()
    
    private lazy var confirmBtn:UIButton = {
        let confirm = UIButton()
        confirm.setTitle("确定".localized, for: .normal)
        confirm.setTitleColor(UIColor.YClightBlueColor, for: .normal)
        confirm.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirm.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return confirm
    }()
    
    private lazy var pickNum:UIPickerView = {
        let pickNum = UIPickerView()
        pickNum.delegate = self
        pickNum.dataSource = self 
        return pickNum
    }()
    
    enum SelectType {
       case peoplenum
       case ordertime
       case bellCode
       case eattogether
    }
    
    var BellDataArray = [BellData](){
        didSet{
          self.pickNum.reloadAllComponents()
        }
    }
    var selectType:SelectType = .peoplenum{
        didSet{
          self.pickNum.reloadAllComponents()
        }
    }
    private var bottomConstraint:Constraint?
    private var numArray = Array(1...50)
    lazy private var eattogetherArray = Array(2...50)
    var confirmBlock:((_ num:Int) -> Void)?
    
    convenience init(with type:SelectType){
       self.init(frame: CGRect.zero)
       self.selectType = type
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(pickContainerView)
        pickContainerView.addSubview(topBar)
        topBar.addSubview(cancleBtn)
        topBar.addSubview(confirmBtn)
        pickContainerView.addSubview(pickNum)
        makeConstraint()
    }
    
    private func makeConstraint(){
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        pickContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            self.bottomConstraint =  make.bottom.equalTo(self).offset(210).constraint
            make.height.equalTo(210)
        }
        
        topBar.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(pickContainerView)
            make.height.equalTo(30)
        }
        
        cancleBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(topBar).offset(5)
            make.centerY.equalTo(topBar)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(topBar).offset(-5)
            make.centerY.equalTo(topBar)
        }
        
        pickNum.snp.makeConstraints { (make) in
            make.edges.equalTo(pickContainerView).inset(UIEdgeInsetsMake(30, 0, 0, 0))
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint?.update(inset: 0)
            self.layoutIfNeeded()
        }) { finish in }
    }
    
    func hide(){
       self.removeFromSuperview()
    }
    
    func hideAndDo(_ complete:(()->Void)?){
       UIView.animate(withDuration: 0.3, animations: { 
         self.bottomConstraint?.update(offset: 210)
         self.layoutIfNeeded()
       }) { (finish) in
          self.removeFromSuperview()
          complete?()
        }
    }
    
   @objc func confirmAction(){
        hideAndDo { 
            switch self.selectType{
              case .peoplenum:
                let num = self.numArray[self.pickNum.selectedRow(inComponent: 0)]
                self.confirmBlock?(num)
              case .ordertime:
                break
              case .bellCode:
                let num = self.pickNum.selectedRow(inComponent: 0)
                self.confirmBlock?(num)
            case .eattogether:
                let num = self.eattogetherArray[self.pickNum.selectedRow(inComponent: 0)]
                self.confirmBlock?(num)
            }
        }
    }
    
    @objc func cancleAction(){
        hide()
    }
    
    func showInView(_ superView:UIView){
         superView.addSubview(self)
         self.snp.makeConstraints { (make) in
            make.edges.equalTo(superView)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.selectType {
        case .peoplenum:
            return "\(numArray[row])"
        case .ordertime:
            return ""
        case .bellCode:
            return BellDataArray[row].CODE_NAME
        case .eattogether:
            return "\(eattogetherArray[row])"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch self.selectType {
        case .peoplenum:
            return 1
        case .ordertime:
            return 2
        case .bellCode:
            return 1
        case .eattogether:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.selectType {
        case .peoplenum:
            return numArray.count
        case .ordertime:
            return 10
        case .bellCode:
            return BellDataArray.count
        case .eattogether:
            return eattogetherArray.count
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








class PickReservationDate:UIView {
    
    fileprivate lazy var BlackcontainerView:UIButton = {
        let container = UIButton(type: .custom)
        container.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        container.backgroundColor = UIColor.black
        container.alpha = 0.5
        return container
    }()
    
    fileprivate lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.classBackGroundColor
        return view
    }()
    
    fileprivate lazy var toolBar:UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.backgroundColor = UIColor.white
        return toolbar
    }()
    
    fileprivate lazy var leftItem:UIBarButtonItem = {
        let leftItem = UIBarButtonItem(title: "取消".localized, style: .plain, target: self, action: #selector(cancleAction))
        leftItem.tintColor = UIColor.YClightBlueColor
        return leftItem
    }()
    
    fileprivate lazy var rightItem:UIBarButtonItem = {
        let rightItem = UIBarButtonItem(title: "确定".localized, style: .plain, target: self, action: #selector(finish))
        rightItem.tintColor = UIColor.YClightBlueColor
        return rightItem
    }()
    
    fileprivate lazy var centerSpace:UIBarButtonItem = {
        let centerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        centerItem.width = 70
        return centerItem
    }()
    
    fileprivate lazy var datepicker:UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.locale = Locale(identifier: "zh_Hans_CN")
        datepicker.datePickerMode = .dateAndTime
        datepicker.addTarget(self, action: #selector(dateChange(picker:)), for: .valueChanged)
        return datepicker
    }()
    
   fileprivate var bottomConstraint:Constraint? = nil
   fileprivate var ChooseDate = Date(timeIntervalSinceNow: 60*60)
   var dateAction: ((_ date:Date)->Void)?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIView.animate(withDuration: 0.3) { 
            self.bottomConstraint?.update(offset: 0)
        }
    }
    
    @objc func dateChange(picker:UIDatePicker){
       let date = picker.date
       ChooseDate = date
    }
    
    @objc func finish(){
        hideAndDo { (date) in
           self.dateAction?(date)
        }
    }
    
    func hideAndDo(complete:@escaping (_ date:Date)->Void){
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint?.update(offset: 210)
        }) { (finish) in
            if finish {
               self.removeFromSuperview()
               complete(self.ChooseDate)
            }
        }
    }
    
    @objc func cancleAction(){
        removeFromSuperview()
    }
    
    func showInView(_ view:UIView){
        datepicker.minimumDate = Date(timeIntervalSinceNow: 60*60)
        datepicker.maximumDate = Date(timeIntervalSinceNow: 60*60*24*7)
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(BlackcontainerView)
        addSubview(containerView)
        containerView.addSubview(toolBar)
        containerView.addSubview(datepicker)
        toolBar.items = [leftItem,centerSpace,rightItem]
        
        makeConstraint()

    }
    
    private func makeConstraint() ->Void {
        
        BlackcontainerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            self.bottomConstraint =  make.bottom.equalTo(self).offset(210).constraint
            make.height.equalTo(210)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(containerView)
            make.height.equalTo(30)
        }
        
        datepicker.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(containerView)
            make.top.equalTo(toolBar.snp.bottom)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



struct ReservationRounter:URLRequestConvertible {
    
    let divCode:String
    let reserveId:String
    let restaurantCode:String
    let userId:String
    let token:String
    let Json:[[String:Any]]
    
    internal func asURLRequest() throws -> URLRequest {
        
        let requestParameter = [
            "divCode":divCode,
            "reserveID":reserveId,
            "restaurantCode":restaurantCode,
            "userID":userId,
            "token":token
        ]
        
        guard let BaseUrl = URL(string: BaseType.canteen.baseURL) else { throw ParseError.failedToGenerate(property: "BaseUrl")}
        let urlRequest = URLRequest(url: BaseUrl.appendingPathComponent(canteenAddOrderKey))
        do {
            var request = try URLEncoding(destination: .queryString).encode(urlRequest, with: requestParameter)
            let httpBodyData = try JSONSerialization.data(withJSONObject: Json, options: [])
            request.httpBody = httpBodyData
            request.httpMethod = "POST"
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            return request
        }catch let error {
            throw error
        }
        
    }
}











