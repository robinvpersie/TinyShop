//
//  ShopHomeController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopHomeController: ShopTableViewController{
    
    enum Section:Int {
       case scorll
       case icon
       case floor
       static let count = 3
       init(section:Int) {
         self = Section(rawValue: section)!
       }
       init(indexPath:IndexPath){
         self = Section(rawValue: indexPath.section)!
       }
     }
    var divCode:String?
    var divName:String?
    var mainModel:ShopHomeModel?
    var menuTypeArray = [MenulTypeEnum]()
    var searchbar:UISearchBar!
    var address:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar = YCSearchBar(size: CGSize(width: 100, height: 44))
        searchbar.searchBarStyle = .minimal
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.placeholder = "搜索商家名称".localized
        navigationItem.titleView = searchbar

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_qr"), style: .plain, target: self, action: #selector(didScan))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkcolor
        let returnItem = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(popBack))
        returnItem.tintColor = UIColor.darkcolor
        
        address = UIButton(type: .custom)
        address.setTitleColor(UIColor.darkcolor, for: .normal)
        address.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        address.frame.size = CGSize(width: Ruler.iPhoneHorizontal(70, 70, 70).value, height: 20)
        address.addTarget(self, action: #selector(didAddress), for: .touchUpInside)
        let addressItem = UIBarButtonItem(customView: address)
        navigationItem.leftBarButtonItems = [returnItem,addressItem]
        
        if let divName = self.divName {
            address.setTitle(divName, for: .normal)
        }else {
            address.setTitle("朝阳广场",for:.normal)
        }
        tableView.registerClassOf(ShopHomeBasicCell.self)
        tableView.registerClassOf(ShopHomeoddCell.self)
        tableView.registerClassOf(ShopHomeevenCell.self)
        tableView.separatorStyle = .none
        requestData(.Static)
    }

    @objc override func popBack() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didAddress(){
        let order = OrderLocationController()
        order.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(order, animated: true)
    }
    
    @objc private func didScan(){
        let scanController = HNScanViewController()
        scanController.delegate = self
        let navigationController = UINavigationController(rootViewController: scanController)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func topRefresh() {
        requestData(.TopRefresh) { [weak self] in
            guard let this = self else { return }
            this.refreshController.endRefreshing()
        }
    }
    
    override func fetchAgain() {
        requestData(.Static)
    }
    
    func seperateArray(_ array:[Ico]){
        var mutableArray = array
        var uniqueArray = [Ico]()
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
                let menutypeArray:MenulTypeEnum = .shop(uniqueArray)
                mutableContainer.append(menutypeArray)
            }else {
                let array = Array(x*8 ..< (x+1)*8)
                uniqueArray = array.map({ mutableArray[$0] })
                let menutypeArray:MenulTypeEnum = .shop(uniqueArray)
                mutableContainer.append(menutypeArray)
            }
        }
        self.menuTypeArray = mutableContainer
    }

    
    func requestData(_ model:UpdateMode,finish:(()->Void)? = nil)
    {
        guard let div = self.divCode else {
            self.showMessage("没有divcode")
            finish?()
            return
        }
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        ShopHomeModel.GetWithDiv(div, memid: nil, token: nil) { result in
            self.isloading = false
            self.isFetching = false
            switch result {
            case .success(let model):
                self.mainModel = model
                self.seperateArray(model.icon)
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: self.tableView)
                finish?()
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: self.tableView)
                finish?()

            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.mainModel else {
            return 0
        }
        return Section.count
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(section: section)
        switch section {
        case .scorll,.icon:
            return 1
        case .floor:
            return self.mainModel!.category.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(section: indexPath.section)
        switch section {
        case .scorll:
           return HomeScrollCell.getHeight()
        case .icon:
           return CanteenHomeTypeCell.getHeight()
        case .floor:
            let Intfloor = Int(self.mainModel!.category[indexPath.row].floorNum)
            if Intfloor! % 2 == 0 {
                return ShopHomeevenCell.getHeight()
            }else {
                return ShopHomeoddCell.getHeight()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let Section = Section(rawValue: indexPath.section) else { fatalError() }
        switch Section {
        case .scorll:
            let cell = HomeScrollCell(style: .default, reuseIdentifier: nil)
            return cell
        case .icon:
            let cell = CanteenHomeTypeCell(style: .default, reuseIdentifier: nil)
            return cell
        case .floor:
            let Intfloor = Int(self.mainModel!.category[indexPath.row].floorNum)
            if Intfloor! % 2 == 0 {
                let cell:ShopHomeevenCell = tableView.dequeueReusableCell()
                return cell
            }else {
                let cell:ShopHomeoddCell = tableView.dequeueReusableCell()
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let section = Section(indexPath: indexPath)
            switch section {
            case .scorll:
                let cell = cell as? HomeScrollCell
                cell?.updateWithModel(self.mainModel!)
                cell?.selectIndex = { [weak self] banner in
                    guard let strongself = self else { return }
                    let detail = GoodsDetailController()
                    detail.controllerType = .departmentStores
                    detail.item_code = banner.itemCode
                    detail.divCode = strongself.divCode
                    strongself.navigationController?.pushViewController(detail, animated: true)
                   }
            case .icon:
                let cell = cell as? CanteenHomeTypeCell
                cell?.dataSource = self.menuTypeArray
                cell?.callBackIconAction = { [weak self] ico in
                    guard let strongself = self else { return }
                    switch ico.rank {
                    case "1":
                        let brand = ShopBrandController(divCode: strongself.divCode!)
                        brand.hidesBottomBarWhenPushed = true
                        strongself.navigationController?.pushViewController(brand, animated: true)
                    case "2":
                        let activity = ShopActivityBaseController()
                        activity.divCode = strongself.divCode!
                        activity.hidesBottomBarWhenPushed = true 
                        strongself.navigationController?.pushViewController(activity, animated: true)
                    case "3":
                        let culture = ShopCultureController()
                        culture.hidesBottomBarWhenPushed = true
                        strongself.navigationController?.pushViewController(culture, animated: true)
                    case "4":
                        let mall = ShopMallController()
                        mall.mainModel = strongself.mainModel
                        mall.divCode = strongself.divCode
                        mall.hidesBottomBarWhenPushed = true
                        strongself.navigationController?.pushViewController(mall, animated: true)
                    case "5":
                        let detail = ShopFloorDetailController(div: strongself.divCode!)
                        detail.title = "全部楼层".localized
                        detail.hidesBottomBarWhenPushed = true
                        strongself.navigationController?.pushViewController(detail, animated: true)
                    case "6":
                         let market = SupermarketMyOrderController()
                         market.controllerType = .departmentStores
                         market.hidesBottomBarWhenPushed = true
                         strongself.navigationController?.pushViewController(market, animated: true)
                    case "7":
                        let model = YCAccountModel.getAccount()
                        let urlStr = "ycapp://wallet$\(model!.memid!)$\(model!.password!)$\(model!.token!)"
                        let utf8 = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        guard let utf = utf8, let url = URL(string: utf),UIApplication.shared.canOpenURL(url) else {
                            let appurl = URL(string:"itms-apps:https://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8")!
                            UIApplication.shared.openURL(appurl)
                            return
                        }
                        UIApplication.shared.openURL(url)
                   case "8":
                        let request = URLRequest(url: URL(string: "http://ssadmin.dxbhtm.com:8090/20_CM/cmList.aspx")!)
                        let web = EatWebController(url: request)
                        web.hidesBottomBarWhenPushed = true
                        strongself.navigationController?.pushViewController(web, animated: true)
                    default:
                        break
                    }
                }
            case .floor:
                func actionWithCell(_ cell:ShopHomeBasicCell?){
                    cell?.arrorAction = { [weak self] in
                        guard let strongself = self else { return }
                        let Intfloor = Int(strongself.mainModel!.category[indexPath.row].floorNum)
                        let floor = ShopFloorController(floorNum: Intfloor!)
                        floor.divCode = strongself.divCode
                        floor.mainModel = strongself.mainModel
                        floor.title = "\(Intfloor!)" + "楼".localized
                        floor.hidesBottomBarWhenPushed = true
                        strongself.navigationController?.pushViewController(floor, animated: true)
                    }
                    cell?.btnAction = { [weak self] cha in
                        guard let strongself = self else { return }
                        let data:[UniqueFloor] = strongself.mainModel!.category[indexPath.row].data
                        data.forEach({ uniqueFloor in
                            if let evenImg = uniqueFloor.eventImage.first {
                               let characters = evenImg.displayNum.characters
                               if characters.contains(cha.characters.first!) {
                                   let parameter = FilterParameter(brandCode: uniqueFloor.customCode,divCode:strongself.divCode!)
                                   let filter = ShopBrandFilterController(with: parameter)
                                   filter.hidesBottomBarWhenPushed = true 
                                   strongself.navigationController?.pushViewController(filter, animated: true)
                                }
                            }
                        })
                    }
                }
                
                let Intfloor = Int(self.mainModel!.category[indexPath.row].floorNum)
                if Intfloor! % 2 == 0 {
                   let cell = cell as? ShopHomeevenCell
                   cell?.updateWithModel(mainModel!.category[indexPath.row])
                   actionWithCell(cell)
                }else {
                   let cell = cell as? ShopHomeoddCell
                   cell?.updateWithModel(mainModel!.category[indexPath.row])
                   actionWithCell(cell)
                }
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ShopHomeController:UpdateDivCode{
    
    func updateWithDivCode(_ divCode:String,_ divName:String){
        self.divCode = divCode
        self.divName = divName
        self.address.setTitle(divName, for: .normal)
        self.refreshController.beginRefreshing()
        self.topRefresh()
    }
    
}

extension ShopHomeController:HNScanViewControllerDelegate {
    
    func scanViewController(_ scanViewController: HNScanViewController!, didScanResult result: String!) {
        YCAlert.alert(title: result, message: nil, dismissTitle: "确定", inViewController: self, withDismissAction: nil)
    }
    
}


extension ShopHomeController:UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchController:PYSearchViewController = PYSearchViewController(hotSearches: nil, searchBarPlaceholder: "输入名称") { searchViewController, searchBar, searchText in
            let filter = FilterParameter(searchText: searchText!)
            let shopfilter = ShopBrandFilterController(with: filter)
            searchViewController?.navigationController?.pushViewController(shopfilter, animated: true)
        }
        searchController.searchType = .mall
        searchController.searchHistoryStyle = PYSearchHistoryStyle(rawValue: 1)!
        let searchNav = UINavigationController(rootViewController: searchController)
        self.present(searchNav, animated: false, completion: nil)
        return false
    }
}

