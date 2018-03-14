//
//  YCCanteenHomeController.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa

class YCCanteenHomeController: UIViewController {
    
    enum requestMode{
       case TopRefresh
       case Static
       case loadMore
    }
    
    enum sectionType: Int{
       case header
       case shop
       case loadMore
    }
    
    var divCode: String!
    var divName: String?
    var isFetching: Bool = false
    var currentPage = 0
    var nextPage = 1
    var tableView: UITableView!
    var mainPageModel: OrderMainPageModel?
    var advertiseArray = [Advertiselis]()
    var foodCodeArray = [Foodcodelis]()
    var foodCodeContainerArray = [MenulTypeEnum]()
    var restaurantArray = [Restaurantlis]()
    var activity: UIActivityIndicatorView!
    let dispag = DisposeBag()
    
    lazy var refreshController:UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(topRefresh(sender:)), for: .valueChanged)
        refresh.tintColor = UIColor.lightGray
        refresh.layer.zPosition = -1
        return refresh
    }()

    var searchbar:YCSearchBar!
    
    fileprivate lazy var addressBtn:UIButton = {
         let address = UIButton(type: .custom)
         address.setTitleColor(UIColor.darkcolor, for: .normal)
         address.titleLabel?.font = UIFont.systemFont(ofSize: 13)
         address.frame.size = CGSize(width: Ruler.iPhoneHorizontal(70, 70, 70).value, height: 20)
         address.rx.tap.subscribe(onNext: { [weak self] in
            guard let strongself = self else { return }
            let order = OrderLocationController()
            order.hidesBottomBarWhenPushed = true
            strongself.navigationController?.pushViewController(order, animated: true)
         }).addDisposableTo(self.dispag)
         return address
    }()
    
   @objc func topRefresh(sender:UIRefreshControl){
        self.requestDataWithMode(.TopRefresh, finish: {
              sender.endRefreshing()
         })
    }
    
    private func makeUI(){
        
        searchbar = YCSearchBar(size:CGSize(width: 100, height: 40))
        searchbar.searchBarStyle = .minimal
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.placeholder = "搜索商家名称".localized
        navigationItem.titleView = searchbar
        
        let rightItem = UIBarButtonItem()
        rightItem.image = UIImage(named: "icon_qr")
        rightItem.tintColor = UIColor.darkcolor
        rightItem.rx.tap.subscribe(onNext: { [weak self] in
            guard let strongself = self else { return }
            let scanController = HNScanViewController()
            scanController.delegate = strongself
            let navigationController = UINavigationController(rootViewController: scanController)
            strongself.present(navigationController, animated: true, completion: nil)
        }).addDisposableTo(dispag)
        navigationItem.rightBarButtonItem = rightItem
        
        let returnItem = UIBarButtonItem()
        returnItem.tintColor = UIColor.darkcolor
        returnItem.image = UIImage.leftarrow
        returnItem.rx.tap.subscribe(onNext: { [weak self] in
            guard let strongself = self else { return }
            strongself.dismiss(animated: true, completion: nil)
        }).addDisposableTo(dispag)
        
        let addressItem = UIBarButtonItem(customView: addressBtn)
        navigationItem.leftBarButtonItems = [returnItem,addressItem]
        
        if let divName = self.divName {
            addressBtn.setTitle(divName, for: .normal)
        }else {
            addressBtn.setTitle("朝阳广场",for:.normal)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.scrollsToTop = false
        tableView.registerClassOf(CanteenHomeTypeCell.self)
        tableView.registerNibOf(CanteenHomeCell.self)
        tableView.registerClassOf(CanteenHeaderPagerCell.self)
        tableView.registerNibOf(YCLoadMoreCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(refreshController)
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        requestDataWithMode(.Static)
    }
    
    func requestDataWithMode(_ mode:requestMode,finish:(()->Void)?=nil){
        
        if isFetching { finish?(); return }
        isFetching = true
        if case .TopRefresh = mode {
            currentPage = 0
        }
        activity.startAnimating()
        OrderMainPageModel.getWith(divCode: divCode) { [weak self] (result) in
            guard let strongself = self else { return }
            strongself.isFetching = false
            strongself.activity.stopAnimating()
            switch result {
            case .success(let json):
                strongself.mainPageModel = json
                strongself.advertiseArray = json.data.advertise.advertiseList
                strongself.foodCodeArray = json.data.foodCode.foodCodeList
                strongself.seperateArray(strongself.foodCodeArray)
                strongself.restaurantArray = json.data.restaurant.restaurantList
                strongself.currentPage = json.data.restaurant.currentPage
                strongself.nextPage = json.data.restaurant.nextPage
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
           case .failure(let error):
                strongself.mainPageModel = nil
                strongself.showMessage(error.localizedDescription)
           }
            finish?()
        }
     }
    
    private func seperateArray(_ array:[Foodcodelis]){
        var mutableArray = array
        var uniqueArray = [Foodcodelis]()
        var mutableContainer = [MenulTypeEnum]()
        var total:Int = 0
        if array.count % 8 == 0 {
            total = array.count/8
        }else {
            total = array.count/8 + 1
        }
        for x in 0 ..< total {
           if x == (total-1){
            let newarray = Array(x*8 ..< array.count)
            uniqueArray = newarray.map({ mutableArray[$0] })
            let menutypeArray:MenulTypeEnum = .foodCode(uniqueArray)
            mutableContainer.append(menutypeArray)
        }else {
            let array = Array(x*8 ..< (x+1)*8)
            uniqueArray = array.map({ mutableArray[$0] })
            let menutypeArray:MenulTypeEnum = .foodCode(uniqueArray)
            mutableContainer.append(menutypeArray)
         }
       }
       self.foodCodeContainerArray = mutableContainer
    }
    
    
    func requestRestaurantWith(_ nextPage:Int,finish:((_ isMore:Bool)->Void)?){
        if isFetching || self.nextPage == 0{
           finish?(false)
           return
        }
        isFetching = true
        OrderMoreRestaurant.GetWithDivcode(divCode, currentPage: nextPage) { [weak self] (result) in
            guard let strongself = self else { return}
            strongself.isFetching = false
            switch result {
            case .success(let json):
                strongself.currentPage = json.data.currentPage
                strongself.nextPage = json.data.nextPage
                var waytoupdate:UITableView.WayToUpdate = .none
                let oldRestaurantCount = strongself.restaurantArray.count
                strongself.restaurantArray.append(contentsOf: json.data.restaurantList)
                let newRestaurantCount = strongself.restaurantArray.count
                let indexpaths = Array(oldRestaurantCount ..< newRestaurantCount).map({
                    IndexPath(item: $0, section: sectionType.shop.rawValue)
                })
                waytoupdate = .insert(indexpaths)
                waytoupdate.performWithTableView(tableview: strongself.tableView)
                finish?(json.data.restaurantList.isEmpty ? false : true)

            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
                finish?(false)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension YCCanteenHomeController:UpdateDivCode{
    
    func updateWithDivCode(_ divCode:String,_ divName:String){
         self.divCode = divCode
         YCUserDefaults.canteendivCode.value = divCode
         addressBtn.setTitle(divName, for: .normal)
         requestDataWithMode(.TopRefresh)
    }
    
}


extension YCCanteenHomeController:HNScanViewControllerDelegate {
    
    func scanViewController(_ scanViewController: HNScanViewController!, didScanResult result: String!) {        guard let UrlComponents = URLComponents(string: result) else {
            YCAlert.alert(title: "扫码结果格式不正确", message: nil, dismissTitle: "确定", inViewController: self, withDismissAction: nil)
            return
        }
        guard let schem = UrlComponents.scheme , schem == YCConfigs.key_Url_Schem  else {
            YCAlert.alert(title: "不是餐厅的二维码", message: nil, dismissTitle: "确定", inViewController: self, withDismissAction: nil)
            return
        }
        guard let query = UrlComponents.query else { return }
        let parameters = query.components(separatedBy: "&")
        showLoading()
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let json):
                if json.status == "1" {
                    if UrlComponents.host!.contains(YCConfigs.key_reserve_restaurant) {
                        self.bizWithParameters(parameters,token:json.newtoken)
                    }else if UrlComponents.host!.contains(YCConfigs.pay_from_qr){
                        self.payWithParameters(parameters)
                    }
                }else {
                   self.hideLoading()
                   self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
                self.showMessage(error.localizedDescription)
            }
        }
    }
}



extension YCCanteenHomeController {
    
    func payWithParameters(_ parameters:[String]){
        
        NetWorkManager.manager.pay(divcode: parameters[0], restaurantCode: parameters[1], tempOrderNum: parameters[2], failureHandler: { (reason, errormessage) in
            self.hideLoading()
            self.showMessage(errormessage)
        }) { (json) in
            self.hideLoading()
            let swiftJson = JSON(json!)
            let status = swiftJson["status"].int
            if status != nil && status == 1 {
                let msg = swiftJson["msg"].string
                self.showMessage(msg)
            }
            
            if let data = swiftJson["data"].dictionary,let orderNumber = data["orderNum"]?.string {
                  let detail = OrderConfirmController(orderNum: orderNumber)
                  detail.from = .fromPush
                  detail.hidesBottomBarWhenPushed = true
                  self.navigationController?.pushViewController(detail, animated: true)
            }
         }
    
    }

    
    
    
    func bizWithParameters(_ parameters:[String],token:String) {
        
        NetWorkManager.manager.biz(divCode: parameters[0],
                                   restaurantCode: parameters[1],
                                   tableName: parameters[2],
                                   token:token,
                                   completion:{ [weak self] result in
                guard let strongself = self else {
                    return
                }
                strongself.hideLoading()
                switch result {
                case .success(let json):
                    
                    let swiftJson = JSON(json)
                    let status = swiftJson["status"].int
                    
                    if status != nil && status == 1 {
                        let msg = swiftJson["msg"].stringValue
                        strongself.showMessage(msg)
                        if let data = swiftJson["data"].dictionary {
                            let reserverStatus =  data["reserveStatus"]?.stringValue
                            if reserverStatus != nil {
                                if reserverStatus == "Q" {
                                    let orderMenu = OrderMenuController(parameters[1], nil, parameters[0])
                                    orderMenu.from = .fromPush
                                    orderMenu.reserveIdStr = data["reserveID"]?.stringValue
                                    orderMenu.needCondition = false
                                    orderMenu.hidesBottomBarWhenPushed = true
                                    strongself.navigationController?.pushViewController(orderMenu, animated: true)
                                }else if reserverStatus == "B" || reserverStatus == "R"{
                                    let orderFromDetail = OrderFormDetailController()
                                    orderFromDetail.reserveId = data["reserveID"]!.stringValue
                                    orderFromDetail.orderNum = data["orderNumber"]!.stringValue
                                    orderFromDetail.reserveStatus = reserverStatus!
                                    orderFromDetail.from = .fromPush
                                    orderFromDetail.hidesBottomBarWhenPushed = true
                                    strongself.navigationController?.pushViewController(orderFromDetail, animated: true)
                                }else if reserverStatus == "O"{
                                    let orderNumber = data["orderNumber"]!.stringValue
                                    let reserveId = data["reserveID"]!.stringValue
                                    let order = OrderConfirmController(orderNum: orderNumber, reserveId: reserveId)
                                    order.from = .fromPush
                                    order.hidesBottomBarWhenPushed = true
                                    strongself.navigationController?.pushViewController(order, animated: true)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    strongself.showMessage(error.localizedDescription)
                }
        })
    }

}




extension YCCanteenHomeController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = sectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .header:
            return
        case .shop:
          let orderMenu = OrderFoodController()
          orderMenu.restaurantCode = restaurantArray[indexPath.row].restaurantCode
          orderMenu.divCode = divCode
          orderMenu.hidesBottomBarWhenPushed = true
          navigationController?.pushViewController(orderMenu, animated: true)
        case .loadMore:
            break
       }
    }
}

extension YCCanteenHomeController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sectionType(rawValue: section) else { return 0 }
        switch section {
        case .header:
            return 2
        case .shop:
            return restaurantArray.count
        case .loadMore:
            return restaurantArray.isEmpty ? 0:1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.mainPageModel else {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            if indexPath.row == 0 {
               let cell:CanteenHomeTypeCell = tableView.dequeueReusableCell()
               return cell
            }else {
                let cell:CanteenHeaderPagerCell = CanteenHeaderPagerCell(style: .default, reuseIdentifier: nil)
                return cell
            }
        case .shop:
            let cell:CanteenHomeCell = tableView.dequeueReusableCell()
            return cell
        case .loadMore:
            let cell:YCLoadMoreCell = tableView.dequeueReusableCell()
            return cell 
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            if indexPath.row == 0 {
              let cell = cell as! CanteenHomeTypeCell
              cell.dataSource = foodCodeContainerArray
              cell.callBackAction = { [weak self] model in
                    guard let strongself = self else {
                        return
                }
                    let subcode = model.subCode
                    let type = CanteenHomeTypeController(divCode: strongself.divCode,subCode: subcode)
                    type.hidesBottomBarWhenPushed = true
                    strongself.navigationController?.pushViewController(type, animated: true)
                }
           }else {
              let cell = cell as! CanteenHeaderPagerCell
              cell.modelArray = advertiseArray
              cell.selectAction = { [weak self] index in
                 guard let strongself = self else { return }
                 let food = OrderFoodController()
                 food.restaurantCode = strongself.advertiseArray[index].restaurantCode
                 food.divCode = strongself.divCode
                 food.hidesBottomBarWhenPushed = true
                 strongself.navigationController?.pushViewController(food, animated: true)
             }
            }
        case .shop:
              let cell = cell as! CanteenHomeCell
              cell.model = restaurantArray[indexPath.row]
              cell.longPressAction = { [weak self] in
                guard let strongself = self else { return }
                let orderMenu = OrderFoodController()
                orderMenu.restaurantCode = strongself.advertiseArray[indexPath.row].restaurantCode
                orderMenu.divCode = strongself.divCode
                orderMenu.hidesBottomBarWhenPushed = true
                strongself.navigationController?.pushViewController(orderMenu, animated: true)
             }
        case .loadMore:
            let cell = cell as! YCLoadMoreCell
            if !cell.activityIndicator.isAnimating {
                cell.activityIndicator.startAnimating()
                cell.info = nil
            }
            self.requestRestaurantWith(self.nextPage, finish: { isMore in
                if !isMore {
                   cell.info = "加载完毕"
                   cell.activityIndicator.stopAnimating()
                }
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = sectionType.init(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .header:
            if indexPath.row == 0 {
               return CanteenHomeTypeCell.getHeight()
            }else {
               return CanteenHeaderPagerCell.getHeight()
            }
        case .shop:
            return CanteenHomeCell.getHeight()
        case .loadMore:
            return 44
        }
     }
    
}

//extension YCCanteenHomeController:UIScrollViewDelegate {
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if velocity.y > 0 {
//           self.navigationController?.setNavigationBarHidden(true, animated: true)
//           statusBgView.isHidden = false
//        }else if velocity.y < 0 {
//           self.navigationController?.setNavigationBarHidden(false, animated: true)
//           statusBgView.isHidden = true
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY:CGFloat = scrollView.contentOffset.y + scrollView.contentInset.top
//        let panTranslationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
//        if scrollView.isDragging {
//            if offsetY > 64 {
//                if panTranslationY > 0 {
//                   self.navigationController?.setNavigationBarHidden(false, animated: true)
//                   statusBgView.isHidden = true
//                }else {
//                   self.navigationController?.setNavigationBarHidden(true, animated: true)
//                   statusBgView.isHidden = false
//                }
//            }else {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                statusBgView.isHidden = true
//            }
//        }
//    }
//}


extension YCCanteenHomeController:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let searchController:PYSearchViewController = PYSearchViewController(hotSearches: nil, searchBarPlaceholder: "搜索商家名称".localized) { (searchViewController, searchBar, searchText) in
            let homeType = CanteenHomeTypeController(divCode: self.divCode, subCode: "")
            homeType.searchText = searchText
            searchViewController?.navigationController?.pushViewController(homeType, animated: true)
        }
        searchController.searchType = .canteen
        searchController.searchHistoryStyle = PYSearchHistoryStyle(rawValue: 1)!
        let searchNav = UINavigationController(rootViewController: searchController)
        self.present(searchNav, animated: false, completion: nil)
        return false
    }
    
}
