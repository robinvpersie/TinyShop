//
//  ShopMallController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/16.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class ShopMallController:ShopTableViewController{
    
    fileprivate enum Section:Int{
        case header
        case shoppe
        case hot
        case special
    }
    
    var MallModel:ShopMallModel?
    var menuTypeArray = [MenulTypeEnum]()
    var mainModel:ShopHomeModel?
    var divCode:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "商城".localized
        
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.tableHeaderView = headerView()
        self.tableView.registerClassOf(HomeScrollCell.self)
        self.tableView.registerClassOf(CanteenHomeTypeCell.self)
        self.tableView.registerClassOf(MallShoppeCell.self)
        self.tableView.registerClassOf(MallHotCell.self)
        self.tableView.registerClassOf(MallSpecialCell.self)
        self.tableView.regisiterHeaderFooterClassOf(UITableViewHeaderFooterView.self)
        requestData(.Static)
    }
    
    private func requestData(_ updateModel:UpdateMode,finish:(()->Void)? = nil){
        if isFetching {
           finish?()
           return
        }
        isFetching = true
        ShopMallModel.get(divcode: self.divCode) { (result) in
            self.isloading = false
            self.isFetching = false
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            switch result {
            case .success(let shopMallModel):
                self.MallModel = shopMallModel
                self.seperateArray(shopMallModel.icon)
                waytoUpdate.performWithTableView(tableview: self.tableView)
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                waytoUpdate.performWithTableView(tableview: self.tableView)
            }
            finish?()
        }

    }
    
    fileprivate func seperateArray(_ array:[MallIco]){
        
        var mutableArray = array
        var uniqueArray = [MallIco]()
        var mutableContainer:[MenulTypeEnum] = [MenulTypeEnum]()
        var total:Int = 0
        if array.count % 8 == 0 {
            total = array.count/8
        }else {
            total = array.count/8 + 1
        }
        for x in 0 ..< total {
            if x == (total-1){
                let newarray = Array(x*8 ..< array.count)
                uniqueArray = newarray.map({
                    return mutableArray[$0]
                })
                let menutypeArray:MenulTypeEnum = .mall(uniqueArray)
                mutableContainer.append(menutypeArray)
            }else {
                let array = Array(x*8 ..< (x+1)*8)
                uniqueArray = array.map({
                    return mutableArray[$0]
                })
                let menutypeArray:MenulTypeEnum = .mall(uniqueArray)
                mutableContainer.append(menutypeArray)
            }
        }
        self.menuTypeArray = mutableContainer
    }

    
    override func fetchAgain() {
        requestData(.Static)
    }
    
    override func topRefresh() {
        requestData(.TopRefresh) { 
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    private lazy var searchBar:UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.searchBarStyle = .minimal
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.placeholder = "轻松逛商城".localized
        return searchbar
    }()
    
    private func headerView() -> UIView {
        let header = UIView()
        header.frame.size = CGSize(width: screenWidth, height: 40)
        header.backgroundColor = UIColor.white
        header.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { (make) in
            make.center.equalTo(header)
            make.height.equalTo(30)
            make.width.equalTo(header).multipliedBy(0.9)
        }
        return header
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.MallModel else { return 0 }
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError() }
        switch section {
        case .header:
            return 2
        case .shoppe,.hot,.special:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            if indexPath.row == 0 {
              let cell = HomeScrollCell(style: .default, reuseIdentifier: nil)
              return cell
            }else {
              let cell = CanteenHomeTypeCell(style: .default, reuseIdentifier: nil)
              return cell
            }
        case .hot:
            let cell:MallHotCell = tableView.dequeueReusableCell()
            return cell
        case .shoppe:
            let cell:MallShoppeCell = tableView.dequeueReusableCell()
            return cell
        case .special:
            let cell:MallSpecialCell = tableView.dequeueReusableCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            if indexPath.row == 0 {
              let cell = cell as? HomeScrollCell
//              cell?.updateWithModel(self.MallModel)
              cell?.updateWithMallModel(self.MallModel)
              cell?.selectIndex = { [weak self] banner in
                    guard let strongself = self else {
                        return
                    }
                    let detail = GoodsDetailController()
                    detail.controllerType = .departmentStores
                    detail.item_code = banner.itemCode
                    detail.divCode = strongself.divCode
                    strongself.navigationController?.pushViewController(detail, animated: true)
                }

             }else {
              let cell = cell as? CanteenHomeTypeCell
              cell?.dataSource = self.menuTypeArray
              cell?.callBackMallIcon = { [weak self] mallIco in
                guard let strongself = self else { return }
                if mallIco.linkType == "2" {
                  let classify = ShopClassifyController()
                  classify.divCode = strongself.divCode
                  classify.navif = .mall
                  strongself.navigationController?.pushViewController(classify, animated: true)
                  return
                }else {
                    let parameter = FilterParameter(divCode:strongself.divCode,
                                                    level1: mallIco.level1,
                                                    level2: mallIco.level2,
                                                    level3: mallIco.level3)
                    let filter = ShopBrandFilterController(with: parameter)
                    strongself.navigationController?.pushViewController(filter, animated: true)
                }
              }
            }
        case .shoppe:
            let  cell = cell as? MallShoppeCell
            cell?.updateWithArray(self.MallModel!.event10[0].goods10)
            cell?.clickAction = { [weak self] cha in
                guard let strongself = self else { return }
                let modelArray = strongself.MallModel!.event10[0].goods10
                modelArray.forEach({ mallgoods in
                    let displayNum = mallgoods.displayNum
                    if displayNum.contains(cha) {
                    let detail = GoodsDetailController()
                    detail.controllerType = .departmentStores
                    detail.item_code = mallgoods.itemCode
                    detail.divCode = strongself.divCode
                    strongself.navigationController?.pushViewController(detail, animated: true)
                    }
                })
            }
        case .hot:
            let  cell = cell as? MallHotCell
            cell?.updateWithArray(self.MallModel!.event20[0].goods20)
            cell?.clickAction = { [weak self] cha in
                guard let strongself = self else { return }
                let modelArray = strongself.MallModel!.event20[0].goods20
                modelArray.forEach({ mallgoods in
                    let displayNum = mallgoods.displayNum
                    if displayNum.contains(cha) {
                    let detail = GoodsDetailController()
                    detail.controllerType = .departmentStores
                    detail.item_code = mallgoods.itemCode
                    detail.divCode = strongself.divCode
                    strongself.navigationController?.pushViewController(detail, animated: true)
                    }
           })
            }
        case .special:
            let cell = cell as? MallSpecialCell
            cell?.updateWithArray(self.MallModel!.event30[0].goods30)
            cell?.itemAction = { [weak self] mallgoods in
                guard let strongself = self else { return }
                let detail = GoodsDetailController()
                detail.controllerType = .departmentStores
                detail.item_code = mallgoods.itemCode
                detail.divCode = strongself.divCode
                strongself.navigationController?.pushViewController(detail, animated: true)

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            if indexPath.row == 0 {
              return HomeScrollCell.getHeight()
            }else {
              return CanteenHomeTypeCell.getHeight()
            }
        case .hot:
            return MallHotCell.getHeight()
        case .shoppe:
            return MallShoppeCell.getHeight()
        case .special:
            return MallSpecialCell.getHeight()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        let header:UITableViewHeaderFooterView = tableView.dequeueReusableHeaderFooter()
        header.backgroundColor = UIColor.clear
        header.contentView.backgroundColor = UIColor.groupTableViewBackground
        switch section {
        case .header:
            return nil
        case .hot:
            header.textLabel?.text = "热门市场".localized
        case .shoppe:
            header.textLabel?.text = "专柜同款".localized
        case .special:
            header.textLabel?.text = "精选好货".localized
        }
        return header

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { fatalError() }
        switch section {
        case .header:
            return 0
        default:
            return 45
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ShopMallController:UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let searchController:PYSearchViewController = PYSearchViewController(hotSearches: nil, searchBarPlaceholder: "输入商品名称".localized) { (searchViewController, searchBar, searchText) in
            let filter = FilterParameter(divCode:self.divCode,searchText: searchText!)
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
