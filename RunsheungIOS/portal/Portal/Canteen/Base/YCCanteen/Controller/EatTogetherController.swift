//
//  EatTogetherController.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct eatUrlConvert:URLRequestConvertible {
    let memberId:String
    let groupId:String
    let token:String
    var path:String
    
    func asURLRequest() throws -> URLRequest {
        guard let baseUrl = URL(string: BaseType.canteen.baseURL) else { throw ParseError.failedToGenerate(property: "baseUrl") }
        var urlrequest = URLRequest(url: baseUrl.appendingPathComponent(path))
        urlrequest.httpMethod = "Get"
        let requestParameter:[String:Any] = [
            "memberId":memberId,
            "groupId":groupId,
            "token":token
        ]
        do {
            let request = try URLEncoding(destination: .queryString).encode(urlrequest, with: requestParameter)
            return request
        }catch let error {
            throw error
        }
    }
}


class EatTogetherController: CanteenBaseViewController {
    
   fileprivate enum rowType:Int {
       case avatar
       case foodtype
       case price
    }
    fileprivate enum requestModel {
       case Static
       case topRefresh
    }
    fileprivate var isfetching:Bool = false
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.registerClassOf(eatBottomCell.self)
        tableView.registerClassOf(GenericCell.self)
        tableView.registerClassOf(topCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    fileprivate var GroupmemberArray = [Groupmemberlis]()
    fileprivate var eatTogetherModel:EatTogetherModel?
    fileprivate lazy var bottomView:GroupBottomView = {
        let bottom = GroupBottomView()
        bottom.carbackView.carImage = UIImage(named: "icon_r_number-1")
        bottom.calculateAction = { [weak self] in
            guard let strongself = self else { return }
            let together = EatPayController()
            strongself.navigationController?.pushViewController(together,animated:true)
        }
        bottom.payAction = { [weak self] in
            guard let strongself = self else { return }
            strongself.addGroupOrder()
        }
        bottom.gameAction = { [weak self] in
            guard let strongself = self else { return }
            let gameNames = ["转盘游戏","Jumping JAKE","老虎机","随机游戏"]
            let gameUrls = ["/Game/RunRoulette","/Game/RunRacing","/Game/RunSlot","/Game/RunRandom"]
            var alertModels = [AlertActionModel]()
            let memberId = YCAccountModel.getAccount()?.memid
            let token = YCAccountModel.getAccount()?.token
            for offset in 0..<4 {
                let alertModel = AlertActionModel(title: gameNames[offset],action:{ alertAction in
                    AddGroupOrder(groupMasterId:memberId ?? "",groupId:strongself.eatTogetherModel?.data.groupId ?? "",token:token ?? "",failureHandler:{ reason,errormessage in
                        strongself.showMessage(errormessage)
                    },completion:{ json in
                        let jsonData = JSON(json!)
                        let status = jsonData["status"].intValue
                        if status == 1 {
                            YCAlert.confirmOrCancel(title: "确定生成订单", message: "生成后无非再添加人数", confirmTitle: "确定", cancelTitle: "取消", inViewController: strongself, withConfirmAction:{
                                let eaturl = eatUrlConvert(memberId: memberId ?? "", groupId: strongself.eatTogetherModel?.data.groupId ?? "", token: token ?? "", path: gameUrls[offset])
                                let eatWeb = EatWebController(url: eaturl)
                                strongself.navigationController?.pushViewController(eatWeb,animated:true)
                            }, cancelAction:{})
                        }else {
                            let msg = jsonData["msg"].stringValue
                            strongself.showMessage(msg)
                        }
                    })
                })
                alertModels.append(alertModel)
            }
            YCAlert.alertWithModelArray(alertModels, viewController: strongself)
        }

        return bottom
    }()
    private lazy var naviBtn:UIButton = {
        let navi = UIButton(type: .custom)
        navi.addTarget(self, action: #selector(didNavi), for: .touchUpInside)
        navi.setTitleColor(UIColor.navigationbarColor, for: .normal)
        navi.titleLabel?.font = UIFont(name: "Georgia", size: 12)
        navi.titleLabel?.textAlignment = .right
        navi.frame.size = CGSize(width: 100, height: 40)
        return navi
    }()
    @objc private func didNavi(){
        let memberId = YCAccountModel.getAccount()?.memid
        let groupId = self.eatTogetherModel?.data.groupId
        let token = YCAccountModel.getAccount()?.token
        let requestParameter:[String:Any] = [
            "memberId":memberId ?? "",
            "groupId":groupId ?? "",
            "token":token ?? ""
        ]
        guard let urlString = self.eatTogetherModel?.data.gameUrl ,let url = URL(string: urlString) else {
                self.showMessage("不是正确的游戏路径")
                return
        }
        let urlrequest = URLRequest(url: url)
        if let request = try? URLEncoding(destination: .queryString).encode(urlrequest, with: requestParameter) {
             let eatweb = EatWebController(url: request)
             eatweb.hideNavigation = false 
             self.navigationController?.pushViewController(eatweb, animated: true)
        }
    }
    var groupId:String
    var eattype:eatType = .together
    var remarkText:String? = nil
    var from:fromController?
    
    init(groupID:String){
       self.groupId = groupID
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGroupOrder(){
        
        self.showLoading()
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    doneWithMemberId(check.custom_code, token: check.token)
                }else {
                    self.hideLoading()
                    self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
            }
        }
        
        func doneWithMemberId(_ memberID:String,token:String){
        
        AddGroupOrder(groupMasterId: memberID, groupId: self.groupId, token: token, failureHandler: { reason, errormessage in
            self.hideLoading()
            self.showMessage(errormessage)
        }) { json in
            self.hideLoading()
            let json = JSON(json!)
            if let data = json["data"].dictionary {
                let orderNum = data["orderNum"]?.stringValue
                let confirm = OrderConfirmController(orderNum: orderNum!)
                if let fromWhere = self.from {
                  confirm.from = fromWhere
                }
                self.navigationController?.pushViewController(confirm, animated: true)
            }else {
                self.showMessage(json["msg"].string)
            }
          }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "一起吃吧"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: naviBtn)
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(view).offset(64)
        }
    }
    
    private func headerView() -> UIView {
        let topContainer = UIView()
        topContainer.backgroundColor = UIColor.white
        topContainer.frame.size = CGSize(width: screenWidth, height: 100)
        let inviteBtn = UIButton(type: .custom)
        inviteBtn.addTarget(self, action: #selector(didInvite), for: .touchUpInside)
        inviteBtn.backgroundColor = UIColor.navigationbarColor
        inviteBtn.setTitle("邀请好友", for: .normal)
        inviteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        topContainer.addSubview(inviteBtn)
        inviteBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(topContainer)
            make.width.equalTo(topContainer).multipliedBy(0.8)
            make.height.equalTo(40)
            make.bottom.equalTo(topContainer).offset(-20)
        }
        return topContainer
    }
    
    var task:CancelableTask?
    
    private func requestBytimer(_ model:requestModel){
          requestData(model) {
           self.task = delay(5, work: {
                self.requestBytimer(.topRefresh)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         requestBytimer(.Static)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.task?(true)
    }
    
    
    fileprivate func requestData(_ model:requestModel,finish:(()->Void)? = nil){
        if isfetching {
            finish?()
            return
        }
        isfetching = true
        if model == .Static {
           self.showLoading()
        }
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                   doneWithToken(check.newtoken, memid: check.custom_code)
                }else {
                  self.isfetching = false
                   self.hideLoading()
                   self.goToLogin()
                }
            case .failure(let error):
                self.isfetching = false
                self.hideLoading()
            }
        }
        
      func doneWithToken(_ token:String,memid:String){
        
        EatTogetherModel.Get(groupId: self.groupId,
                             token:token,
                             memberId:memid,
                             failureHandler:
       { (reason, errormessage) in
          self.hideLoading()
          self.showMessage(errormessage)
          self.isfetching = false
          finish?()
       }) { model in
          self.hideLoading()
          self.eatTogetherModel = model
          self.isfetching = false
          if let model = model {
           if model.data.orderMemberCnt > 0 {
              self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
              self.bottomView.showInView(self.view)
              self.bottomView.badgeValue = model.data.orderMemberCnt
              self.bottomView.totalPrice = Float(model.data.totalAmount)
            }else {
              self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
              self.bottomView.hide()
            }
            
            if let groupStatus = model.data.groupStatus,groupStatus == "C" {
                self.tableView.tableHeaderView = self.headerView()
            }else {
                self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
            }
            
            if let groupFixYN = model.data.groupFixYN,groupFixYN == "Y" {
                   self.bottomView.gameBtn.isHidden = true
                if let groupMasterYN = model.data.groupMasterYN,groupMasterYN == "Y" {
                   self.bottomView.payBtn.isHidden = false
                }else {
                   self.bottomView.payBtn.isHidden = true
                }
                let gameName = model.data.gameName
                if let gameStatus = model.data.gameStatus{
                    switch gameStatus{
                       case "F":
                        let witdth:CGFloat = "查看结果".widthWithConstrainedWidth(height: 40, font: UIFont.systemFont(ofSize: 12)) + 10.0
                        self.naviBtn.isHidden = false
                        self.naviBtn.setTitle("查看结果", for: .normal)
                        self.naviBtn.width = witdth
                       case "J","C":
                        if let name = gameName {
                        let width:CGFloat = name.widthWithConstrainedWidth(height: 40, font: UIFont.systemFont(ofSize: 12)) + 10
                        self.naviBtn.isHidden = false
                        self.naviBtn.setTitle(name, for: .normal)
                        self.naviBtn.width = width
                    }
                    default:
                        self.naviBtn.isHidden = true
                    }
                }
            }else {
                if let groupMasterYN = model.data.groupMasterYN,groupMasterYN == "Y" {
                    self.bottomView.payBtn.isHidden = false
                    self.bottomView.gameBtn.isHidden = false
                    if let goldenBellYN = model.data.goldenBellYN,goldenBellYN == "Y" {
                        self.bottomView.gameBtn.isHidden = false
                    }else {
                        self.bottomView.gameBtn.isHidden = false
                    }
                    self.naviBtn.isHidden = true
             }else {
                    self.bottomView.payBtn.isHidden = true
                    self.bottomView.gameBtn.isHidden = true
                    self.naviBtn.isHidden = true
                }
            }
            if let goldenBellYN = model.data.goldenBellYN,goldenBellYN == "Y" {
                self.bottomView.gameBtn.isHidden = true
                self.naviBtn.isHidden = true
            }

            self.GroupmemberArray = model.data.GroupMemberList
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            waytoUpdate.performWithTableView(tableview: self.tableView)
            finish?()
          }
        }
       }
    }
    
    fileprivate func SectionHeader() -> UIView {
        let header = UIView()
        header.frame.size = CGSize(width: screenWidth, height: 40)
        let lable = UILabel()
        lable.text = "拼单列表"
        lable.textColor = UIColor.darkcolor
        lable.font = UIFont.systemFont(ofSize: 14)
        header.addSubview(lable)
        lable.snp.makeConstraints { (make) in
            make.leading.equalTo(header).offset(15)
            make.centerY.equalTo(header)
        }
        return header
    }

    
    @objc private func didInvite(){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    let phone = check.custom_code
                    let password = YCAccountModel.getAccount()?.password
                    let token = check.newtoken
                    let imageurl = self.eatTogetherModel?.data.imgUrl.absoluteString
                    let groupName = self.eatTogetherModel?.data.gameName
                    let groId = self.eatTogetherModel?.data.groupId
                    let content = self.eatTogetherModel?.data.address
                    let title = self.eattype == .together ? "一起吃吧":"金钟"
                    let sharemodel = eatShareModel(phoneNumber: phone, password: password ?? "empty", title: title, content:content ?? "empty", token: token, groupId: groId ?? "", imageUrl: imageurl ?? "empty", url: "empty", itemCode: "empty", groupName: groupName ?? "empty", roomId: self.groupId)
                    sharemodel.Share()
                }else {
                    self.hideLoading()
                    self.goToLogin()
                }
            case .failure(_):
                self.hideLoading()
            }
        }

        
       }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
          return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}


extension EatTogetherController:UITableViewDelegate {
    
    
}

extension EatTogetherController:UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 40
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.SectionHeader()
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.GroupmemberArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.GroupmemberArray[section].OrderList.isEmpty {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rowtype = rowType(rawValue: indexPath.row) else { return 0 }
        switch rowtype {
        case .avatar:
            return topCell.getHeight()
        case .foodtype:
            let items = self.GroupmemberArray[indexPath.section].OrderList
            let recentItems:[recentItem] = items.map({ .orderlis($0) })
            return GenericCell.getHeightWith(items: recentItems)
        case .price:
            return eatBottomCell.getHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowtype = rowType(rawValue: indexPath.row) else { fatalError() }
        switch rowtype {
        case .avatar:
            let cell:topCell = tableView.dequeueReusableCell()
            return cell
        case .foodtype:
            let cell:GenericCell = tableView.dequeueReusableCell()
            return cell
        case .price:
            let cell:eatBottomCell = tableView.dequeueReusableCell()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let rowtype = rowType(rawValue: indexPath.row) else { fatalError() }
        switch rowtype {
        case .avatar:
            let cell = cell as? topCell
            cell?.changeAction = { [weak self] in
                guard let strongself = self,let restaurantCode = strongself.eatTogetherModel?.data.restaurantCode else { return }
                let items = strongself.GroupmemberArray[indexPath.section].OrderList
                var itemNumDic = [String:Int]()
                var compareModelArray = [[compareMenuModel]]()
                /////方法
                func checkAddSameWithModel(_ model:compareMenuModel){
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
                ///////方法
                items.forEach({ orderlist in
                    let select = selectMenulis(itemCode: orderlist.itemCode, itemAmount: Float(orderlist.amount), itemName: orderlist.itemName)
                    for _ in 0 ..< orderlist.quantity {
                     let mo = compareMenuModel(itemCode: orderlist.itemCode, menu: select)
                     checkAddSameWithModel(mo)
                    }
                    itemNumDic[orderlist.itemCode] = orderlist.quantity
                })
                let menu = OrderMenuController(restaurantCode, nil, "1", .fromKim)
                menu.groupId = strongself.groupId
                menu.compareModelArray = compareModelArray
                menu.itemCodeDic = itemNumDic
                strongself.navigationController?.pushViewController(menu, animated: true)
            }
            cell?.deleteAction = { [weak self] in
                guard let strongself = self else { return }
                let model = strongself.GroupmemberArray[indexPath.section]
                let memberId = model.memberID
                YCAlert.confirmOrCancel(title: "您确定要删除这位一起吃的小伙伴吗？", message: "多一个人吃热闹一些哦", confirmTitle: "确定", cancelTitle: "取消", inViewController: strongself, withConfirmAction: {
                    strongself.deleteMember(groupId: strongself.groupId, cancelMemberId: memberId, success: {
                        strongself.requestData(.Static)
                    })
                }, cancelAction: {})
            }
            cell?.emptyAction = { [weak self] in
                guard let strongself = self else { return }
                let memberId = strongself.GroupmemberArray[indexPath.section].memberID
                strongself.deleteGroup(memberId, groupId: strongself.groupId, success: {
                    strongself.requestData(.Static)
                })
            }
            cell?.updateWithModel(self.GroupmemberArray[indexPath.section], groupFixYN: self.eatTogetherModel?.data.groupFixYN,groupMasterYN:self.eatTogetherModel?.data.groupMasterYN)
        case .foodtype:
            let cell = cell as? GenericCell
            let items = self.GroupmemberArray[indexPath.section].OrderList
            let recentItems:[recentItem] = items.map({ .orderlis($0) })
            cell?.updateWithItems(recentItems)
        case .price:
            let cell = cell as? eatBottomCell
            cell?.model = self.GroupmemberArray[indexPath.section]
        }
        
    }
    
    
    fileprivate func deleteMember(groupId:String,cancelMemberId:String,success:(()->Void)?){
        self.showLoading()
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    doneWithToken(check.newtoken, memid: check.custom_code)
                }else {
                    self.hideLoading()
                    self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
            }
        }

       func doneWithToken(_ token:String,memid:String){
          SetGroupMemberCancel(groupId: groupId,
                               cancelMemberId: cancelMemberId,
                               memberId:memid,
                               token:token,
                               failureHandler:
          { reason, errormessage in
            self.hideLoading()
            self.showMessage(errormessage)
          }) { json in
            self.hideLoading()
            guard let jsonData:JSON = json else { return }
            let status = jsonData["status"].int
            if status == 1 {
                success?()
            }else{
                let msg = jsonData["msg"].string
                self.showMessage(msg)
            }
          }
        }
    }
    
    
    fileprivate func deleteGroup(_ groupMemberId:String,groupId:String,success:(()->Void)?){
        self.showLoading()
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1"{
                    doneWithToken(check.newtoken)
                }else {
                    self.hideLoading()
                    self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
                self.showMessage(error.localizedDescription)
            }
        }
       
        func doneWithToken(_ token:String){
            DelGroupMemberOrderWith(groupMemberId,
                                    groupId: groupId,
                                    token:token,
                                    failureHandler:
           { reason, errormessage in
             self.hideLoading()
             self.showMessage(errormessage)
           }) { json in
            self.hideLoading()
            guard let jsonData:JSON = json else { return }
            let status = jsonData["status"].int
            if status == 1 {
                success?()
            }else {
                let msg = jsonData["msg"].string
                self.showMessage(msg)
            }
         }
        }
     }
}





fileprivate class GroupBottomView: UIView {
    
    private lazy var priceLable:UILabel = {
        let priceLable = UILabel()
        priceLable.numberOfLines = 1
        priceLable.font = UIFont.systemFont(ofSize: 15)
        priceLable.textColor = UIColor.white
        return priceLable
    }()
    
    private lazy var backGroundView:UIView = {
       let back = UIView()
       back.backgroundColor = UIColor.darkcolor
       back.alpha = 0.95
       return back
    }()
    
    lazy var carbackView:shopCarView = {
       let shopcar = shopCarView()
       return shopcar
    }()
    
    private lazy var carBack:UIView = {
        let back = UIView()
        back.backgroundColor = UIColor.clear
        return back
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carBack.badgeCenterOffset = CGPoint(x: -8, y: 10)
    }

    lazy var payBtn:UIButton = {
       let pay = UIButton(type: .custom)
       pay.backgroundColor = UIColor.navigationbarColor
       pay.setTitle("支付", for: .normal)
       pay.setTitleColor(UIColor.white, for: .normal)
       pay.titleLabel?.font = UIFont.systemFont(ofSize: 13)
       pay.addTarget(self, action: #selector(didPay), for: .touchUpInside)
       return pay
    }()
    
    lazy var gameBtn:UIButton = {
       let game = UIButton(type: .custom)
       game.backgroundColor = UIColor.orange
       game.setTitle("买单游戏", for: .normal)
       game.setTitleColor(UIColor.white, for: .normal)
       game.titleLabel?.font = UIFont.systemFont(ofSize: 13)
       game.addTarget(self, action: #selector(didGame), for: .touchUpInside)
       return game
    }()
    
    
    @objc private func didGame(){
       gameAction?()
    }
    
    @objc private func didPay(){
       payAction?()
    }
    
    
    var badgeValue:Int = 0 {
        didSet{
            carBack.showBadge(with: .number, value: badgeValue, animationType: .none)
        }
    }
    
    var totalPrice:Float = 0 {
        didSet{
            if totalPrice > 0 {
                priceLable.text = "共\(totalPrice)"
            }else {
                priceLable.text = "购物车为空"
            }
        }
    }
    
    var payAction:(()->Void)?
    var gameAction:(()->Void)?
    var calculateAction:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backGroundView)
        backGroundView.addSubview(priceLable)
        addSubview(carBack)
        carBack.addSubview(carbackView)
        backGroundView.addSubview(payBtn)
        backGroundView.addSubview(gameBtn)
        makeConstraint()
    }
    
    func showInView(_ view:UIView){
        if let _ = self.superview {
           self.removeFromSuperview()
        }
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(60)
        }
    }
    
    func hide(){
       self.removeFromSuperview()
    }
    
    private func makeConstraint(){
        backGroundView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        
        priceLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(backGroundView)
            make.leading.equalTo(backGroundView).offset(70)
        }
        
        carBack.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.height.equalTo(60)
        }
        
        carbackView.snp.makeConstraints { (make) in
            make.edges.equalTo(carBack)
        }
        
        payBtn.snp.makeConstraints { (make) in
            make.trailing.bottom.top.equalTo(backGroundView)
            make.width.equalTo(60)
        }
        
        gameBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(payBtn.snp.leading)
            make.top.bottom.equalTo(backGroundView)
            make.width.equalTo(60)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







/// topCell
fileprivate class topCell:UITableViewCell {
    
    private lazy var avatarImgView:UIImageView = {
       let avatar = UIImageView()
       avatar.layer.masksToBounds = true
       avatar.layer.cornerRadius = 15
       return avatar
    }()
    
    private lazy var namelb:UILabel = {
       let name = UILabel()
       name.textColor = UIColor.darkcolor
       name.font = UIFont.systemFont(ofSize: 15)
       return name
    }()
    
    lazy var mylb:UILabel = {
       let my = UILabel()
       my.textColor = UIColor.navigationbarColor
       my.text = "我"
       my.layer.borderWidth = 1
       my.font = UIFont.systemFont(ofSize: 10)
       my.textAlignment = .center
       my.layer.borderColor = UIColor.navigationbarColor.cgColor
       return my
    }()
    
    lazy var emptyBtn:UIButton = {
       let empty = UIButton(type: .custom)
       empty.setTitle("清空", for: .normal)
       empty.setTitleColor(UIColor.YClightGrayColor, for: .normal)
       empty.titleLabel?.font = UIFont.systemFont(ofSize: 12)
       empty.layer.borderWidth = 1
       empty.layer.borderColor = UIColor.YClightGrayColor.cgColor
       empty.addTarget(self, action: #selector(didEmpty), for: .touchUpInside)
       empty.isHidden = true
       return empty
    }()
    
    lazy var changeBtn:UIButton = {
       let change = UIButton(type: .custom)
       change.setTitle("修改商品", for: .normal)
       change.titleLabel?.font = UIFont.systemFont(ofSize: 12)
       change.setTitleColor(UIColor.YClightGrayColor, for: .normal)
       change.layer.borderWidth = 1
       change.layer.borderColor = UIColor.YClightGrayColor.cgColor
        change.addTarget(self, action: #selector(didClickChange), for: .touchUpInside)
       return change
    }()
    
    lazy var deleteBtn:UIButton = {
        let delete = UIButton(type: .custom)
        delete.setTitle("删除", for: .normal)
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        delete.setTitleColor(UIColor.navigationbarColor, for: .normal)
        delete.layer.borderWidth = 1
        delete.layer.borderColor = UIColor.navigationbarColor.cgColor
        delete.addTarget(self, action: #selector(didClickDelete), for: .touchUpInside)
        return delete
  }()
    
    
    func updateWithModel(_ model:Groupmemberlis,groupFixYN:String?,groupMasterYN:String?){
        avatarImgView.kf.setImage(with: model.iconImg)
        namelb.text = model.nickName
        if let groupFixYN = groupFixYN,groupFixYN == "Y" {
            mylb.isHidden = true
            deleteBtn.isHidden = true
            changeBtn.isHidden = true
            emptyBtn.isHidden = true
        }else {
             if model.myYN == "Y" {
                if model.orderYN == "Y" {
                    emptyBtn.isHidden = false
                }else {
                    emptyBtn.isHidden = true
                }
                mylb.isHidden = false
                deleteBtn.isHidden = true
                changeBtn.isHidden = false
             }else {
                mylb.isHidden = true
                emptyBtn.isHidden = true
                changeBtn.isHidden = true
                if let groupMasterYN = groupMasterYN,groupMasterYN == "Y" {
                      deleteBtn.isHidden = false
                }else {
                      deleteBtn.isHidden = true
                }
           }
        }

    }
    var deleteAction:(()->Void)?
    var changeAction:(()->Void)?
    var emptyAction:(()->Void)?
    @objc private func didClickDelete(){
       deleteAction?()
    }
    
    @objc private func didClickChange(){
       changeAction?()
    }
    
    @objc private func didEmpty(){
       emptyAction?()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(avatarImgView)
        contentView.addSubview(namelb)
        contentView.addSubview(mylb)
        contentView.addSubview(changeBtn)
        contentView.addSubview(emptyBtn)
        contentView.addSubview(deleteBtn)
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        avatarImgView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        
        namelb.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
        }
        
        mylb.snp.makeConstraints { (make) in
            make.leading.equalTo(namelb.snp.trailing).offset(5)
            make.centerY.equalTo(self)
            make.width.height.equalTo(15)
        }
        
        changeBtn.snp.makeConstraints { (make) in
            let width = "修改商品".widthWithConstrainedWidth(height: 15, font: UIFont.systemFont(ofSize: 12))
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-15)
            make.width.equalTo(width+10)
            make.height.equalTo(18)
        }

        emptyBtn.snp.makeConstraints { (make) in
            let width = "清空".widthWithConstrainedWidth(height: 15, font: UIFont.systemFont(ofSize: 12))
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(changeBtn.snp.leading).offset(-15)
            make.width.equalTo(width+10)
            make.height.equalTo(18)
        }

       deleteBtn.snp.makeConstraints { (make) in
            let width = "删除".widthWithConstrainedWidth(height: 15, font: UIFont.systemFont(ofSize: 12))
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-15)
            make.height.equalTo(18)
            make.width.equalTo(width+10)
        }
    }
    
    func updateWithModel(_ model:YCAccountModel?){
        if let account = model {
          namelb.text = account.userName
          guard let avatarPath = account.avatarPath, let accountUrl = URL(string: avatarPath) else { return }
          avatarImgView.kf.setImage(with: accountUrl)
        }
    }
    
    class func getHeight() -> CGFloat {
       return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







fileprivate class eatBottomCell:UITableViewCell {
    
    private var pricelb = UILabel()
    
    var model:Groupmemberlis!{
        didSet{
            let orderlis = model.OrderList
            var totalPrice = 0
            orderlis.forEach { (order) in
                totalPrice += order.amount * order.quantity
            }
            let attribute = NSMutableAttributedString()
            let first = NSAttributedString(string: "订单金额：", attributes: [NSForegroundColorAttributeName:UIColor.YClightGrayColor,NSFontAttributeName:UIFont.systemFont(ofSize: 14)])
            let second = NSAttributedString(string: "\(totalPrice)元", attributes: [NSForegroundColorAttributeName:UIColor.navigationbarColor,NSFontAttributeName:UIFont.systemFont(ofSize: 14)])
            attribute.append(first)
            attribute.append(second)
            pricelb.attributedText = attribute
        }
    }
    
    class func getHeight() -> CGFloat {
       return 40
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(pricelb)
        pricelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
