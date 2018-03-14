//
//  OrderFoodController.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import Kingfisher

class OrderFoodController: CanteenBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var restaurantCode:String!
    var divCode:String!
    var customCode:String!
    var favoriteYN:String?

    enum Section:Int{
        case introduce
        case commenHeader
        case commentDetail
    }
    var selectType:OrderFoodSelectType = .all
    var foodModel:OrderFoodModel?
    var replyArray = [OrderFoodRepl]()
    var ImageReplyArray = [OrderFoodRepl]()
    var preViewRefrences:[Reference?]?
    var previewAttachmentPhotos: [PreviewAttachmentPhoto] = []

    lazy var orderBtn:UIButton = {
        let orderBtn = UIButton(type: .custom)
        orderBtn.addTarget(self, action: #selector(order), for: .touchUpInside)
        let titleStr = "预约".localized + "/" + "点餐".localized
        orderBtn.setTitle(titleStr, for: .normal)
        orderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        orderBtn.backgroundColor = UIColor.clear
        return orderBtn
    }()
    
    lazy var orderAndReserveBtn:UIButton = {
        let orderBtn = UIButton(type: .custom)
        orderBtn.addTarget(self, action: #selector(orderAndReserve), for: .touchUpInside)
        orderBtn.setTitle("点餐".localized, for: .normal)
        orderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        orderBtn.backgroundColor = UIColor.clear
        return orderBtn
    }()
    
    lazy var ordershare:OrderShareView = OrderShareView()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderPageCell.self)
        tableView.registerClassOf(OrderAddressCell.self)
        tableView.registerClassOf(OrderDetailAddressCell.self)
        tableView.registerClassOf(OrderDescriptionCell.self)
        tableView.registerClassOf(OrderCommentHeaderCell.self)
        tableView.registerClassOf(OrderCommentBasicCell.self)
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        return tableView
    }()
    
    private lazy var eatTogetherBtn:UIButton = {
        let eat = UIButton(type: .custom)
        eat.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        eat.addTarget(self, action: #selector(eatTogether), for: .touchUpInside)
        eat.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        eat.setTitleColor(UIColor.navigationbarColor, for: .normal)
        eat.layer.borderWidth = 0.7
        eat.layer.borderColor = UIColor.navigationbarColor.cgColor
        eat.setTitle("一起吃吧".localized, for: .normal)
        return eat
    }()
    
    var activityIndicator:UIActivityIndicatorView!
    
    
  @objc func eatTogether(){
        showLoading()
        CheckToken.chekcTokenAPI { result in
            self.hideLoading()
            switch result {
            case .success(let check):
                if check.status == "1" {
                   let reservation = ReservationController(self.restaurantCode, .eatTogether, self.divCode)
                   self.navigationController?.pushViewController(reservation, animated: true)
                }else {
                  self.goToLogin()
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(restaurantCode code:String,divCode:String,customCode:String){
       self.init()
       self.restaurantCode = code
       self.divCode = divCode
       self.customCode = customCode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订餐".localized
        
        view.backgroundColor = UIColor.clear
        
        let eatItem = UIBarButtonItem(customView: eatTogetherBtn)
        navigationItem.rightBarButtonItem = eatItem
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        let container = UIView()
        container.backgroundColor = UIColor.navigationbarColor
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        container.addSubview(orderBtn)
        container.addSubview(orderAndReserveBtn)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        orderBtn.snp.makeConstraints { (make) in
            make.width.equalTo(container).multipliedBy(0.5)
            make.leading.bottom.height.equalTo(container)
        }
        
        orderAndReserveBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(orderBtn.snp.trailing)
            make.trailing.top.bottom.equalTo(container)
        }

        updateMain()
        
    }
    
    
    func updateMain(finish:(()->Void)?=nil){
        
        activityIndicator.startAnimating()
        OrderFoodModel.GetWithRestaurantCode(restaurantCode, failureHandler: { [weak self]  reason,errormessage in
            guard let strongself = self else { return }
            strongself.activityIndicator.stopAnimating()
            strongself.showMessage(errormessage)
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            waytoUpdate.performWithTableView(tableview: strongself.tableView)
            finish?()
        }) { [weak self] jsonModel in
            guard let strongself = self else { return }
            strongself.activityIndicator.stopAnimating()
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            if let json = jsonModel {
                strongself.foodModel = json
                if json.data.favoriteYN == "Y" {
                  strongself.favoriteYN = "Y"
                }else {
                  strongself.favoriteYN = "N"
                }
                if let replyArray = json.data.reply {
                    strongself.replyArray = replyArray
                    strongself.ImageReplyArray = replyArray.filter({ !($0.images.isEmpty) })
                }
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
                finish?()

            }else {
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
                finish?()

            }
        }
        
    }
    
    func share(){
        
        guard let food = foodModel else {
           self.showMessage("稍等,正在加载数据")
           return
        }
        showLoading()
        CheckToken.chekcTokenAPI { (result) in
            self.hideLoading()
            switch result {
            case .success(let check):
                if check.status == "1"{
                    let shareModel = YCShareModel()
                    shareModel.action_type = "rsshare"
                    shareModel.phone_number = YCAccountModel.getAccount()?.customId
                    shareModel.password = YCAccountModel.getAccount()?.password
                    shareModel.token = check.newtoken
                    shareModel.title = food.data.restaurantName
                    shareModel.content = "厉害了，快来吃啊我的哥"
                    shareModel.imageUrl = food.data.images[0].imgUrl.absoluteString
                    shareModel.url = ""
                    shareModel.type = "1"
                    shareModel.item_code = food.data.restaurantCode
                    YCShareAddress.share(with: YCShareAddress.getWith(shareModel))
                }else {
                    self.goToLogin()
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            }
        }
    }
    
    
    
    func collect(){
        if favoriteYN == "Y" {
            favoriteYN = "N"
           }else {
            favoriteYN = "Y"
            showMessage("收藏成功")
            
        }
            
        CheckToken.chekcTokenAPI(completion: { (result) in
            switch result {
            case .success(let check):
                if check.status == "1"{
                   addFavoriteWithToken(check.newtoken)
                }else {
                  self.goToLogin()
                }
            case .failure(let error):
                break
            }
          })
        
        func addFavoriteWithToken(_ token:String){
            AddFavoriteWithCustomCode(restaurantCode: restaurantCode,token:token, completion: { [weak self] result in
                guard let strongself = self else { return }
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    strongself.showMessage(error.localizedDescription)
                }
            })
        }
    }
    
    
    
  @objc func orderAndReserve(){
           showLoading()
           CheckToken.chekcTokenAPI { [weak self] (result) in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
            case .success(let check):
                if check.status == "1" {
                    let menu = OrderMenuController(this.restaurantCode,nil,this.divCode)
                    menu.needCondition = true
                    this.navigationController?.pushViewController(menu, animated: true)
                }else {
                   this.goToLogin()
                }
            case .failure(let error):
                this.showMessage(error.localizedDescription)
            }
           }
    }
    
    
   @objc func order(){
            showLoading()
            CheckToken.chekcTokenAPI { [weak self] (result) in
                guard let this = self else { return }
                this.hideLoading()
                switch result {
                case .success(let check):
                    if check.status == "1" {
                        let order = ReservationController(this.restaurantCode,.foodAndReservation,this.divCode)
                        this.navigationController?.pushViewController(order, animated: true)
                    }else {
                       this.goToLogin()
                    }
                case .failure(let error):
                    this.showMessage(error.localizedDescription)
                }
            }
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .introduce:
            return 0
        case .commenHeader:
            return 10
        case .commentDetail:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = foodModel else { return 0 }
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .introduce:
            return 5
        case .commenHeader:
            return 1
        case .commentDetail:
            switch self.selectType {
            case .all:
                return replyArray.count
            case .image:
                return ImageReplyArray.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .introduce:
            if indexPath.row == 2 {
               let controller = UIAlertController(title: "导航".localized, message: nil, preferredStyle: .actionSheet)
               let appleMapAction = UIAlertAction(title: "苹果地图导航".localized, style: .default, handler: { (action) in
                 let mapItem = MKMapItem.forCurrentLocation()
                 mapItem.openInMaps(launchOptions: nil)
               })
               let baiduMapAction = UIAlertAction(title: "百度地图导航".localized, style: .default, handler: { (action) in
                if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
                    UIApplication.shared.openURL(URL(string: "baidumap://")!)
                }
               })
               let gaodeMapAction = UIAlertAction(title: "高德地图导航".localized, style: .default, handler: { (action) in
                if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
                    UIApplication.shared.openURL(URL(string: "iosamap://")!)
                }
               })
               let cancleAction = UIAlertAction(title: "取消".localized, style: .cancel, handler: { (action) in })
               controller.addAction(appleMapAction)
               controller.addAction(baiduMapAction)
               controller.addAction(gaodeMapAction)
               controller.addAction(cancleAction)
               self.present(controller, animated: true, completion: nil)
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .introduce:
            if indexPath.row == 0 {
                let cell:OrderPageCell = OrderPageCell(style: .default, reuseIdentifier: nil)
                return cell
            }else if indexPath.row == 1 {
                let cell:OrderAddressCell = OrderAddressCell(style: .default, reuseIdentifier: nil)
                return cell
            }else if indexPath.row == 2 {
                let cell:OrderDetailAddressCell = OrderDetailAddressCell(style: .default, reuseIdentifier: nil)
                cell.accessoryType = .disclosureIndicator
                cell.leftImageView.image = UIImage(named: "icon_dt")
                return cell
            }else if indexPath.row == 3 {
                let cell:OrderDetailAddressCell = OrderDetailAddressCell(style: .default, reuseIdentifier: nil)
                cell.leftImageView.image = UIImage(named: "icon_sj-1")
                cell.rightBtn.setImage(UIImage(named: "icon_dhh"), for: .normal)
                cell.clickRightAction = { [weak self] in
                    guard let strongself = self else { return }
                    let phoneNumber = strongself.foodModel!.data.phone
                    guard let url = URL(string: "tel://\(String(describing: phoneNumber))") else { return }
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
               }
                return cell
             }
            else {
                let cell:OrderDescriptionCell = tableView.dequeueReusableCell()
                return cell
            }
        case .commenHeader:
            let cell:OrderCommentHeaderCell = tableView.dequeueReusableCell()
            return cell
        case .commentDetail:
            let cell:OrderCommentBasicCell = tableView.dequeueReusableCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .introduce:
            if indexPath.row == 0 {
                let cell = cell as! OrderPageCell
                cell.foodModel =   foodModel
            }else if indexPath.row == 1 {
                let cell = cell as! OrderAddressCell
                cell.collectAction = { [weak self] in
                    guard let strongself = self else { return }
                    strongself.collect()
                    strongself.tableView.reloadRows(at: [indexPath], with: .none)
                }
                cell.shareAction = { [weak self] in
                    guard let strongself = self else { return }
                    strongself.share()
                }
                cell.orderInfoModel = foodModel
                cell.favoriteYN = self.favoriteYN
            }else if indexPath.row == 2 {
                let cell = cell as! OrderDetailAddressCell
                cell.infoLable.text = foodModel?.data.address
            }else if indexPath.row == 3 {
                let cell = cell as! OrderDetailAddressCell
                cell.infoLable.text = "营业时间".localized + ":" + foodModel!.data.businessTime
            }else {
                let cell = cell as! OrderDescriptionCell
                cell.orderinfo = foodModel
             }
        case .commenHeader:
            let cell = cell as! OrderCommentHeaderCell
            cell.foodModel = self.foodModel
            cell.didClickType = { [weak self] type in
                switch type {
                case .all:
                   self?.selectType = .all
                   tableView.beginUpdates()
                   tableView.reloadSections([Section.commentDetail.rawValue], with: .automatic)
                   tableView.endUpdates()
                case .image:
                   self?.selectType = .image
                   tableView.beginUpdates()
                   tableView.reloadSections([Section.commentDetail.rawValue], with: .automatic)
                   tableView.endUpdates()
                }
            }
        case .commentDetail:
            let cell = cell as! OrderCommentBasicCell
            switch self.selectType {
            case .all:
                 cell.updateWithModel(replyArray[indexPath.row])
            case .image:
                 cell.updateWithModel(ImageReplyArray[indexPath.row])
            }
            cell.FeedTapImagesAction = { [weak self] transitionViews,urls,image,index in
                guard let strongself = self else { return }
                strongself.preViewRefrences = transitionViews
                let previewAttachmentPhotos = urls.map({
                    PreviewAttachmentPhoto(url: $0)
                })
                strongself.previewAttachmentPhotos = previewAttachmentPhotos
                let photos:[Photo] = previewAttachmentPhotos.map({ $0 })
                let initialPhoto = photos[index]
                
                let photosViewController = PhotosViewController(photos: photos, initialPhoto: initialPhoto, delegate: strongself)
                strongself.present(photosViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .introduce:
            if indexPath.row == 0 {
              return OrderPageCell.getHeight()
            }else if indexPath.row == 1 {
              return OrderAddressCell.getHeight()
            }else if indexPath.row == 2 || indexPath.row == 3{
              return OrderDetailAddressCell.getHeight()
            }else {
              return OrderDescriptionCell.getHeightWithModel(self.foodModel!)
            }
        case .commenHeader:
             return OrderCommentHeaderCell.getHeight()
        case .commentDetail:
            switch self.selectType {
            case .all:
                return OrderCommentBasicCell.getHeightWithModel(replyArray[indexPath.row])
            case .image:
                return OrderCommentBasicCell.getHeightWithModel(ImageReplyArray[indexPath.row])
            }
        }
    }
}

extension OrderFoodController:PhotosViewControllerDelegate {
    
    func photosViewController(_ vc: PhotosViewController, referenceForPhoto photo: Photo) -> Reference? {
        if let previewAttachmentPhoto = photo as? PreviewAttachmentPhoto {
            if let index = previewAttachmentPhotos.index(of: previewAttachmentPhoto) {
                 return preViewRefrences?[index]
            }
        }
        return nil
    }
    
    func photosViewController(_ vc: PhotosViewController, didNavigateToPhoto photo: Photo, atIndex index: Int) {
        
    }
    
    func photosViewControllerWillDismiss(_ vc: PhotosViewController) {
        
    }
    
    func photosViewControllerDidDismiss(_ vc: PhotosViewController) {
         preViewRefrences = nil
         previewAttachmentPhotos = []
    }

}


