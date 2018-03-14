//
//  CanteenHomeTypeController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON

class CanteenHomeTypeController: CanteenBaseViewController {
    
    convenience init(divCode:String,subCode:String){
       self.init()
       self.divCode = divCode
       self.subCode = subCode
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var divCode:String!
    var subCode:String!
    var searchbar:UISearchBar!
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.registerNibOf(CanteenHomeCell.self)
        table.tableFooterView = UIView()
        return table
    }()
    
    private lazy var segmentMenu:CanteenSegmentMenu = CanteenSegmentMenu(with:self.view)
    private let serviceGroup = DispatchGroup()
    fileprivate var AllTypeModelArray = [CanteenAllTypeModel]()
    fileprivate var placeModel = [CanteenPlaceModel]()
    fileprivate var sortModelArray = [CanteenSortModel]()
    fileprivate var filterModelArray = [CanteenFilterModel]()
    fileprivate var restaurantArray = [Restaurantlis]()
    fileprivate var categoryCode = ""
    fileprivate var floorCode = ""
    fileprivate var timeCode = ""
    fileprivate var setMenuCode = ""
    fileprivate var serviceCode = ""
    fileprivate var holyDay:Int = 0
    fileprivate var takeOut:Int = 0
    fileprivate var currentPage = 1
    fileprivate var smartSearch:String = "03"
    var searchText:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.classBackGroundColor
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_qr"), style: .plain, target: self, action: #selector(didScan))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkcolor
        
        searchbar = YCSearchBar(size:CGSize(width: 100, height: 40))
        searchbar.searchBarStyle = .minimal
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.placeholder = "搜索商家名称".localized
        navigationItem.titleView = searchbar

        view.addSubview(segmentMenu)
        segmentMenu.callBackBlock = { [weak self] model in
            guard let strongself = self else { return }
            if strongself.AllTypeModelArray.isEmpty || strongself.placeModel.isEmpty  { return }
            strongself.categoryCode = strongself.AllTypeModelArray[model.allSelectIndex].SUBCode
            if let trail = model.nearrightSelectIndex {
               strongself.floorCode = strongself.placeModel[model.nearleftSelectIndex].FloorList[trail].SUBCode
            }else {
               strongself.floorCode = ""
            }
            
            if let timeIndex = model.timeIndex {
                strongself.timeCode = strongself.filterModelArray[0].subCodeLis[timeIndex].SUB_CODE
            }else {
                strongself.timeCode = ""
            }
            
            if let menuCode = model.numIndex {
              strongself.setMenuCode = strongself.filterModelArray[1].subCodeLis[menuCode].SUB_CODE
            }else {
              strongself.setMenuCode = ""
            }
            
            if let serviceCode = model.serviceIndex {
              strongself.serviceCode = strongself.filterModelArray[2].subCodeLis[serviceCode].SUB_CODE
            }else {
              strongself.serviceCode = ""
            }
            strongself.smartSearch = (model.sortSelectIndex == 0) ? "03":"04"
            strongself.holyDay = model.isholy ? 1:0
            strongself.takeOut = model.isWatch ? 1:0
            
            strongself.showCustomloading()
            HomeTypelist.GetWithDivCode(strongself.divCode,
                                        floorCode: strongself.floorCode,
                                        categoryCode: strongself.categoryCode,
                                        timeCode: strongself.timeCode,
                                        setMenuCode: strongself.setMenuCode,
                                        serviceCode: strongself.serviceCode,
                                        smartSearch: strongself.smartSearch,
                                        holyDay: "\(strongself.holyDay)",
                                        takeOut: "\(strongself.takeOut)",
                                        currentPage: strongself.currentPage,
            failureHandler: { reason, errormessage in
                 strongself.hideLoading()
                 strongself.showMessage(errormessage)
            }, completion: { model in
                 strongself.hideLoading()
                if let typelist = model {
                    strongself.restaurantArray = typelist.restaurantList
                    let waytoUpdate:UITableView.WayToUpdate = .reloadData
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
            })
        }
        
        view.addSubview(tableView)
        makeConstraint()
        fetchData()
    }
    
    private func fetchData(){
        
        showCustomloading()
        serviceGroup.enter()
        CanteenAllTypeModel.GetWithdivCode(divCode, codeType: "A", failureHandler: { (reason, errormessage) in
            self.serviceGroup.leave()
        }) { [weak self] modelArray in
            if let array = modelArray {
            self?.AllTypeModelArray = array
            }
            self?.serviceGroup.leave()
        }
        
        serviceGroup.enter()
        CanteenPlaceModel.GetWithdivCode(divCode, codeType: "B", failureHandler: { (reason, errormessage) in
            self.serviceGroup.leave()
        }) { [weak self] model in
            if let model = model {
                self?.placeModel = model
            }
            self?.serviceGroup.leave()
        }
        
        serviceGroup.enter()
        CanteenSortModel.GetWithdivCode(divCode, codeType: "C", failureHandler: { [weak self] reason, errormessage in
            self?.serviceGroup.leave()
        }) { [weak self] sortModelArray in
            if let modelArray = sortModelArray {
                self?.sortModelArray = modelArray
            }
            self?.serviceGroup.leave()
        }
        
        serviceGroup.enter()
        CanteenFilterModel.GetWithdivCode(divCode, codeType: "D", failureHandler: { [weak self] reason, errormessage in
            self?.serviceGroup.leave()
        }) { [weak self] filterModelArray in
            if let modelArray = filterModelArray {
                self?.filterModelArray = modelArray
            }
            self?.serviceGroup.leave()
        }
        
        serviceGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            let subcodeArray = self.AllTypeModelArray.map({
                 $0.SUBCode
            })
            self.segmentMenu.allSelectIndex = subcodeArray.index(of: self.subCode)!
            self.segmentMenu.AllTypeModelArray = self.AllTypeModelArray
            self.segmentMenu.placeModel = self.placeModel
            self.segmentMenu.sortModelArray = self.sortModelArray
            self.segmentMenu.filterModelArray = self.filterModelArray
            HomeTypelist.GetWithDivCode(self.divCode,
                                        categoryCode:self.subCode,
                                        searchValue:self.searchText ?? "",
                                        currentPage: self.currentPage,
            failureHandler: { [weak self] reason, errormessage in
                guard let strongself = self else {
                   return
                }
                strongself.hideLoading()
                strongself.showMessage(errormessage)
            }, completion: { [weak self] model in
                guard let strongself = self else {
                   return
                }
                 strongself.hideLoading()
                 if let typelist = model {
                   strongself.restaurantArray = typelist.restaurantList
                   let waytoUpdate:UITableView.WayToUpdate = .reloadData
                   waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
            })
        }))

    
    }
    
    private func makeConstraint(){
        
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        segmentMenu.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view).offset(topLayoutGuide.length)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(segmentMenu.snp.bottom)
        }
    }
    
   @objc func didScan(){

        let scanController = HNScanViewController()
        scanController.delegate = self
        let navigationController = UINavigationController(rootViewController: scanController)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension CanteenHomeTypeController:HNScanViewControllerDelegate {
    
    func scanViewController(_ scanViewController: HNScanViewController!, didScanResult result: String!) {
        
        guard let UrlComponents = URLComponents(string: result) else {
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
        CheckToken.chekcTokenAPI { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let check):
                if check.status == "1" {
                    if UrlComponents.host!.contains(YCConfigs.key_reserve_restaurant) {
                       this.bizWithParameters(parameters, token: check.newtoken)
                    }else if UrlComponents.host!.contains(YCConfigs.pay_from_qr){
                       this.payWithParameters(parameters)
                    }
                }else {
                   this.hideLoading()
                   this.goToLogin()
                }
            case .failure(let error):
                this.hideLoading()
                this.showMessage(error.localizedDescription)
            }
        }
     }
}



extension CanteenHomeTypeController {
    
    func payWithParameters(_ parameters:[String]){
        
        NetWorkManager.manager.pay(divcode: parameters[0], restaurantCode: parameters[1], tempOrderNum: parameters[2], failureHandler: { [weak self] (reason, errormessage) in
            guard let this = self else { return }
            this.hideLoading()
            this.showMessage(errormessage)
        }) { [weak self] (json) in
            guard let this = self else { return }
            this.hideLoading()
            let swiftJson = JSON(json!)
            let status = swiftJson["status"].int
            if status != nil && status == 1 {
                let msg = swiftJson["msg"].string
                this.showMessage(msg)
            }
            
            if let data = swiftJson["data"].dictionary,let orderNumber = data["orderNum"]?.string {
                let detail = OrderConfirmController(orderNum: orderNumber)
                detail.from = .fromPush
                detail.hidesBottomBarWhenPushed = true
                this.navigationController?.pushViewController(detail, animated: true)
            }
        }
        
    }
    
    
    
    
    func bizWithParameters(_ parameters:[String],token:String) {
        
        NetWorkManager.manager.biz(divCode: parameters[0],restaurantCode: parameters[1],tableName: parameters[2],token:token,completion:{ [weak self] result in
                                    guard let strongself = self else { return }
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



extension CanteenHomeTypeController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderMenu = OrderFoodController()
        orderMenu.restaurantCode = restaurantArray[indexPath.row].restaurantCode
        orderMenu.divCode = self.divCode
        orderMenu.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(orderMenu, animated: true)
     }
}

extension CanteenHomeTypeController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CanteenHomeCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CanteenHomeCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CanteenHomeCell
        cell.model = self.restaurantArray[indexPath.row]
    }
}


extension CanteenHomeTypeController:UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchViewController = PYSearchViewController(hotSearches: nil, searchBarPlaceholder: "搜索商家名称".localized) { searchController, searchBar, searchString in
            
            let homeType = CanteenHomeTypeController(divCode: self.divCode, subCode: self.categoryCode)
            homeType.searchText = searchString
            searchController?.navigationController?.pushViewController(homeType, animated: true)
        }
        searchViewController?.hotSearchStyle = .arcBorderTag
        searchViewController?.searchHistoryStyle = .arcBorderTag
        searchViewController?.searchType = .canteen
        searchViewController?.delegate = self
        let nav = UINavigationController(rootViewController: searchViewController!)
        self.present(nav, animated: true, completion: nil)
        return false
    }
}

extension CanteenHomeTypeController:PYSearchViewControllerDelegate {
    
    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange seachBar: UISearchBar!, searchText: String!) {
    
    }
    
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        searchViewController.dismiss(animated: true, completion: nil)
    }
}























