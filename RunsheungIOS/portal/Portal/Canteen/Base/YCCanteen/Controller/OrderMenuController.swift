//
//  OrderMenuController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/4.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire


class OrderMenuController: CanteenBaseViewController,CAAnimationDelegate{
    
    fileprivate var foodTypeTableView:UITableView!
    fileprivate var menuTableView:UITableView!
    fileprivate var isScrollDown:Bool = true
    fileprivate var lastOffsetY:CGFloat = 0
    fileprivate var selectIndex:Int = 0
    fileprivate var orderMenuBottomView:OrderMenuBottomView!
    fileprivate var orderMenuPushView:OrderMenuPushView!
    fileprivate var dotLayer = CALayer()
    var needCondition = true
    var from:fromController?
    var restaurantCode:String!
    var groupId:String!
    var divCode:String!
    var ConditionModel:OrderCondition?
    var isPushShow = false
    var foodModel:OrderFoodModel?
    var modelArray = [OrderMenuModel]()
    var compareModelArray = [[compareMenuModel]]()
    var itemCodeDic = [String:Int]()
    var badgeValue:Int {
        set{
          orderMenuBottomView.badgeValue = newValue
        }
        get{
          return orderMenuBottomView.badgeValue
        }
    }
    var totalPrice:Float{
        set {
          orderMenuBottomView.totalPrice = newValue
        }
        get{
           return orderMenuBottomView.totalPrice
        }
    }
    var reserveIdStr:String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(_ restaurantCode:String,_ OrderCondition:OrderCondition?,_ divCode:String,_ from:fromController = .fromRestaurant) {
        self.init(nibName: nil, bundle: nil)
        self.restaurantCode = restaurantCode
        self.ConditionModel = OrderCondition
        self.divCode = divCode
        self.from = from 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "菜单".localized
        
        if #available(iOS 11.0, *) {
            
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        foodTypeTableView = UITableView(frame: CGRect.zero, style: .plain)
        foodTypeTableView.backgroundColor = UIColor.groupTableViewBackground
        foodTypeTableView.delegate = self
        foodTypeTableView.dataSource = self
        foodTypeTableView.rowHeight = 50
        foodTypeTableView.sectionHeaderHeight = 0
        foodTypeTableView.tableFooterView = UIView()
        foodTypeTableView.showsVerticalScrollIndicator = false
        foodTypeTableView.separatorColor = UIColor.clear
        foodTypeTableView.registerClassOf(FoodTypeCell.self)
        if #available(iOS 11.0, *) {
            foodTypeTableView.contentInsetAdjustmentBehavior = .never
        }
        foodTypeTableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        view.addSubview(foodTypeTableView)

        menuTableView = UITableView(frame: CGRect.zero, style: .plain)
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.tableFooterView = UIView()
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.rowHeight = 80
        menuTableView.sectionHeaderHeight = 25
        menuTableView.registerClassOf(MenuFoodCell.self)
        menuTableView.regisiterHeaderFooterClassOf(OrderMenuTableHeader.self)
        if #available(iOS 11.0, *) {
            menuTableView.contentInsetAdjustmentBehavior = .never
        }
        menuTableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        view.addSubview(menuTableView)
        
        orderMenuPushView = OrderMenuPushView()
        view.addSubview(orderMenuPushView)
        orderMenuPushView.callback = { [weak self] Modelarray,uniqueModel,actionType in
            guard let strongself = self else {
                return
            }
            strongself.compareModelArray = Modelarray
            switch actionType {
            case .add:
                  strongself.totalPrice = strongself.totalPrice + uniqueModel.menulis.itemAmount
                  if let num = strongself.itemCodeDic[uniqueModel.itemCode] {
                       var newnum = num
                       newnum += 1
                       strongself.itemCodeDic[uniqueModel.itemCode] = newnum
                  }
                 strongself.badgeValue += 1
            case .sub:
                strongself.totalPrice = strongself.totalPrice - uniqueModel.menulis.itemAmount
                if let num = strongself.itemCodeDic[uniqueModel.itemCode]{
                    var newnum = num
                    newnum -= 1
                    strongself.itemCodeDic[uniqueModel.itemCode] = newnum
                }
                strongself.badgeValue -= 1
            }
        }
        orderMenuPushView.deleteAllAction = { [weak self] modelArray in
            guard let strongself = self else { return }
            strongself.isPushShow = false
            strongself.compareModelArray = modelArray
            strongself.totalPrice = 0
            strongself.badgeValue = 0
            strongself.itemCodeDic.removeAll()
        }
        orderMenuPushView.hideAction = { [weak self] in
            guard let strongself = self else { return }
            strongself.isPushShow = false
            strongself.menuTableView.reloadData()
        }
        
        orderMenuBottomView = OrderMenuBottomView()
        view.addSubview(orderMenuBottomView)
        orderMenuBottomView.totalPrice = totalPrice
        orderMenuBottomView.pushAction = { [weak self] in
            guard let strongself = self else { return }
            if strongself.isPushShow{
                strongself.isPushShow = false
                strongself.orderMenuPushView.hide()
             }else {
                strongself.isPushShow = true
                strongself.show()
            }
         }
        orderMenuBottomView.payAction = { [weak self] in
            guard let strongself = self else {
                return
                
            }
            if strongself.from == .fromKim {
                strongself.showLoading()
                CheckToken.chekcTokenAPI(completion: { (result) in
                    switch result {
                    case .success(let check):
                        if check.status == "1" {
                            doneWith(memid: check.custom_code, token: check.newtoken)
                        }else {
                            self?.hideLoading()
                            self?.goToLogin()
                        }
                    case .failure(let error):
                        self?.hideLoading()
                        self?.showMessage(error.localizedDescription)
                    }
                })
                
                func doneWith(memid:String,token:String){
                    addOrderWithGroup(strongself.groupId,
                                      userid:memid,
                                      token:token, uploadJson: strongself.compareModelArray,
                                      failureHandler:
                    { reason, errormessage in
                       strongself.hideLoading()
                       strongself.showMessage(errormessage)
                    }, completion: { status in
                       strongself.hideLoading()
                        if status == 1 {
                         strongself.navigationController?.popViewController(animated: true)
                        }else {
                       strongself.showMessage("添加失败")
                      }
                   })
                }
                
                return
            }
            
            if strongself.needCondition {
                guard !strongself.itemCodeDic.isEmpty else {
                  YCAlert.alert(title: "请选择菜品", message: nil, dismissTitle: "确定", inViewController: self, withDismissAction: nil)
                  return
                }
            let reservation = ReservationController(strongself.restaurantCode, .justFood,strongself.divCode)
            reservation.conditionModel = strongself.ConditionModel
            reservation.compareModelArray = strongself.compareModelArray
            reservation.from = strongself.from!
            strongself.navigationController?.pushViewController(reservation, animated: true)
                
            }else {
                if let reserveStr = strongself.reserveIdStr {
                   strongself.addOrderWithReserveId(reserveStr)
                }else {
                   strongself.addReserve(finish: { success, reserveId in
                    if success {
                        strongself.addOrderWithReserveId(reserveId!)
                    }else {
                        strongself.showMessage("预约失败")
                    }
                })
                }
            }
         }
        
        makeConstraint()
        fetchData()
        
    }
    
    
    
    private func addOrderWithReserveId(_ reserveId:String){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                 doneWiht(memid: check.custom_code, token: check.newtoken)
                }else {
                  self.hideLoading()
                  self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
                self.showMessage(error.localizedDescription)
            }
        }
        
    func doneWiht( memid:String,token:String){
        var uploadDic = [[String:Any]]()
        uploadDic = compareModelArray.map({
            var dic = [String:Any]()
            dic["itemCode"] = $0[0].menulis.itemCode
            dic["itemAmount"] = "\($0[0].menulis.itemAmount)"
            dic["count"] = $0.count
            return dic
        })
        let reservation = ReservationRounter(divCode: divCode,
                                             reserveId: reserveId,
                                             restaurantCode: restaurantCode,
                                             userId: memid,
                                             token: token,
                                             Json:uploadDic)
        do {
            let urlrequest = try reservation.asURLRequest()
            Alamofire.request(urlrequest).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
                    if json["status"].intValue == 1 {
                        self.showMessage("下单成功")
                        let orderConfirm = OrderConfirmController(orderNum: json["data"].stringValue)
                        orderConfirm.from = self.from!
                        orderConfirm.reserveId = reserveId
                        self.navigationController?.pushViewController(orderConfirm, animated: true)
                    }else if json["status"].intValue == -9001 {
                        self.goToLogin()
                    }else {
                        self.showMessage("下单失败")
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

    
    private func addReserve(finish:((_ isSuccess:Bool,_ reserveId:String?) -> Void)? = nil){
        guard let condition = ConditionModel else {
           finish?(false,nil)
           return
        }
        
        CheckToken.chekcTokenAPI { result in
            switch result {
            case .success(let check):
                if check.status == "1" {
                   doneWith(phone: check.custom_code, token: check.token)
                }else {
                   self.hideLoading()
                   self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
                self.showMessage(error.localizedDescription)
            }
        }
        
    func doneWith(phone:String,token:String) {
        
        OrderAddReserve(restaurantCode: restaurantCode,
                        userId: phone,
                        reserveDate: condition.dateStr!,
                        personCount: condition.peopleNum!,
                        userName: condition.contactStr!,
                        phoneNumber: condition.phoneStr!,
                        roomUse: condition.isNeedBox ? 1:0,
                        description: condition.remarkStr!,
                        token: token,
        failureHandler: { (reason, errormessage) in
            finish?(false,nil)
        }, completion: { (jsonData) in
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
                default:
                    finish?(false,nil)
                }
            }
        })
      }
    }

    
    private func show(){
         orderMenuPushView.showWithModel(compareModelArray)
    }
    
    private func fetchData(){
        showCustomloading()
        OrderMenuModel.GetWithRestaurantCode(restaurantCode, failureHandler: { [weak self] (reason, errorMessage) in
            guard let strongself = self else {
                return
            }
            strongself.hideLoading()
            strongself.showMessage(errorMessage)
        }) { [weak self] modelArray in
            guard let strongself = self else {
                return
            }
            strongself.hideLoading()
            if let jsonArray = modelArray {
                strongself.modelArray = jsonArray
                var badgenum:Int = 0
                var allprice:Float = 0
                strongself.compareModelArray.forEach({ compareArray in
                    badgenum += compareArray.count
                    let uniquePrice = compareArray.first?.menulis.itemAmount
                    allprice += (uniquePrice! * Float(compareArray.count))
                })
                strongself.badgeValue = badgenum
                strongself.totalPrice = allprice
                strongself.foodTypeTableView.reloadData()
                strongself.menuTableView.reloadData()
                strongself.foodTypeTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
        }
     }
    
    private func makeConstraint(){
        
        
        foodTypeTableView.snp.makeConstraints { (make) in
            make.leading.bottom.equalTo(view)
            make.width.equalTo(90)
            make.top.equalTo(view)
        }
        
        menuTableView.snp.makeConstraints { (make) in
            make.leading.equalTo(foodTypeTableView.snp.trailing)
            make.trailing.bottom.equalTo(view)
            make.top.equalTo(foodTypeTableView)
        }
        
        orderMenuPushView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        orderMenuBottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(50)
        }

    
    }
    
    
    func joinCarAnimationWithRect(rect:CGRect){
       
       let endRect = orderMenuBottomView.convert(orderMenuBottomView.backBtn.frame, to: self.view)
       let endcenterPoint = CGPoint(x: endRect.midX, y: endRect.midY)
       let startcenterPoint = CGPoint(x: rect.midX, y: rect.midY)
       let path = UIBezierPath()
       path.move(to: startcenterPoint)
       path.addCurve(to: endcenterPoint, controlPoint1: startcenterPoint, controlPoint2: CGPoint(x: startcenterPoint.x - 100 , y: startcenterPoint.y - 200))
       dotLayer = CALayer()
       dotLayer.backgroundColor = UIColor.navigationbarColor.cgColor
       dotLayer.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
       dotLayer.cornerRadius = 12
       view.layer.addSublayer(dotLayer)
       
       let animation = CAKeyframeAnimation(keyPath: "position")
       animation.path = path.cgPath
       animation.rotationMode = kCAAnimationRotateAuto
       
       let alphaAnimation = CABasicAnimation(keyPath: "alpha")
       alphaAnimation.duration = 0.5
       alphaAnimation.fromValue = 1
       alphaAnimation.toValue = 0.1
       alphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
       
       let groups = CAAnimationGroup()
       groups.animations = [animation,alphaAnimation]
       groups.duration = 0.8
       groups.isRemovedOnCompletion = false
       groups.fillMode = kCAFillModeForwards
       groups.delegate = self
       groups.setValue("groupsAnimation", forKey: "animationName")
       dotLayer.add(groups, forKey: nil)
       self.perform(#selector(removeFromLayer(layerAnimation:)), with: dotLayer, afterDelay: 0.8)
    }
    
    
   func removeFromLayer(layerAnimation:CALayer){
        layerAnimation.removeFromSuperlayer()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let value = anim.value(forKey: "animationName") as? String
        if value == "groupsAnimation" {
           let shakeAnimation = CABasicAnimation(keyPath: "transform.scale")
           shakeAnimation.duration = 0.25
           shakeAnimation.fromValue = 0.9
           shakeAnimation.toValue = 1
           shakeAnimation.autoreverses = true
           orderMenuBottomView.carBackgroundView.layer.add(shakeAnimation, forKey: nil)
           orderMenuBottomView.badgeValue += 1
         }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension OrderMenuController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == foodTypeTableView {
            selectIndex = indexPath.row
            foodTypeTableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)
            menuTableView.scrollToRow(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
        }
    }

}

extension OrderMenuController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == menuTableView {
            let header:OrderMenuTableHeader = tableView.dequeueReusableHeaderFooter()
            header.headerName = modelArray[section].groupName
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == foodTypeTableView {
            return 1
        }else {
            return modelArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == foodTypeTableView {
            return modelArray.count
        }else {
            return modelArray[section].MenuList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == foodTypeTableView {
            let cell:FoodTypeCell = tableView.dequeueReusableCell()
            return cell
        }else {
            let cell:MenuFoodCell = tableView.dequeueReusableCell()
            cell.countAction = { [weak self] totalNum, type in
                guard let strongself = self else { return }
                let menulist = strongself.modelArray[indexPath.section].MenuList[indexPath.row]
                let itemCode = menulist.itemCode
                let addMenu = selectMenulis(itemCode: itemCode, itemAmount: menulist.itemAmount, itemName: menulist.itemName)
                let compareModel = compareMenuModel(itemCode: menulist.itemCode, menu: addMenu)
                switch type {
                case .none:
                    break
                case .addAction:
                  strongself.checkAddSameWithModel(compareModel)
                  strongself.totalPrice += menulist.itemAmount
                  if let num = strongself.itemCodeDic[itemCode]{
                       var NewNum = num
                       NewNum += 1
                       strongself.itemCodeDic[itemCode] = NewNum
                  }else {
                       strongself.itemCodeDic[itemCode] = 1
                  }
                let parentRect = strongself.view.convert(cell.addBtn.frame, from: cell.menuCountView)
                strongself.joinCarAnimationWithRect(rect: parentRect)
                case .subAction:
                    strongself.chekcSubSameWithModel(compareModel)
                    strongself.totalPrice -= menulist.itemAmount
                    if let num = strongself.itemCodeDic[itemCode] {
                      var newnum = num
                      newnum -= 1
                      strongself.itemCodeDic[itemCode] = newnum
                    }
                     strongself.orderMenuBottomView.badgeValue -= 1
                }
            }
            return cell
        }
    }
    
    private func chekcSubSameWithModel(_ model:compareMenuModel){
        var check:Bool = false
        var offsetIndex:Int = 0
        for (offset,item) in compareModelArray.enumerated() {
            if item.first == model {
                check = true
                offsetIndex = offset
                break
            }
        }
        if check {
           compareModelArray[offsetIndex].removeLast()
            if compareModelArray[offsetIndex].isEmpty {
               compareModelArray.remove(at: offsetIndex)
            }
        }
    }
    
    private func checkAddSameWithModel(_ model:compareMenuModel){
        var check:Bool = false
        var offsetIndex:Int = 0
        for (offset,item) in compareModelArray.enumerated() {
            if item.first == model {
                check = true
                offsetIndex = offset
                break
            }
        }
        if check {
           compareModelArray[offsetIndex].append(model)
        }else {
           let item = [model]
           compareModelArray.append(item)
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == foodTypeTableView {
            let cell = cell as! FoodTypeCell
            cell.name.text = modelArray[indexPath.row].groupName
        }else {
            let cell = cell as! MenuFoodCell
            let menulis = modelArray[indexPath.section].MenuList[indexPath.row]
            cell.updateWithModel(menulis)
            cell.updateNum(itemCodeDic[menulis.itemCode])
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if (tableView == menuTableView && isScrollDown && menuTableView.isDragging){
            foodTypeTableView.selectRow(at: IndexPath(row: section + 1, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (menuTableView == tableView) && !isScrollDown && menuTableView.isDragging {
            foodTypeTableView.selectRow(at: IndexPath(row: section, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
}

extension OrderMenuController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableView = scrollView as? UITableView
        if menuTableView == tableView {
           isScrollDown = lastOffsetY < scrollView.contentOffset.y
           lastOffsetY = scrollView.contentOffset.y
        }
    }

}



struct KimRounter:URLRequestConvertible {
    
    let groupMemberId:String?
    let token:String?
    let groupId:String
    let Json:[[String:Any]]
    
    func asURLRequest() throws -> URLRequest {
        let requestParameter = [
            "groupId":groupId,
            "groupMemberId":groupMemberId ?? "",
            "token":token ?? ""
        ]
        guard let BaseUrl = URL(string: BaseType.canteen.baseURL) else { throw ParseError.failedToGenerate(property: "BaseUrl")}
        let urlRequest = URLRequest(url: BaseUrl.appendingPathComponent(AddGroupMemberOrderKey))
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

