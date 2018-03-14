//
//  ShopBrandFilterController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ShopBrandFilterController: ShopBaseViewController {
    
   var collectionView:UICollectionView!
    
   lazy var searchBar:YCSearchBar = {
        let searchbar = YCSearchBar(size:CGSize(width: 120, height: 44))
        searchbar.searchBarStyle = .minimal
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.placeholder = "输入商品名称".localized
       // searchbar.frame.size = CGSize(width: Ruler.iPhoneHorizontal(120, 120, 120).value, height: 30)
        return searchbar
    }()
    
    var filterHeader:FitlerHeaderView!
    var isLoading = true
    var filterItems = [BrandFilterItem]()
    var brandFilterModel:ShopBrandFilterModel?
    var isFetching:Bool = false
    
    enum UpdateMode{
        case Static
        case TopRefresh
        case LoadMore
    }
    
    enum Section:Int{
        case item
        case loadMore
        static let count = 2
        
        init(section:Int){
            self = Section(rawValue: section)!
        }
        
        init(indexPath:IndexPath){
            self = Section(rawValue: indexPath.section)!
        }
    }

    var parameters:FilterParameter
    
    init(with parameters:FilterParameter){
        self.parameters = parameters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.titleView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        view.backgroundColor = UIColor.groupTableViewBackground
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClassOf(ShopBrandFilterCell.self)
        collectionView.registerNibOf(YCLoadMoreCollectionCell.self)
        collectionView.emptyDataSetSource = self
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(topRefresh))
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        filterHeader = FitlerHeaderView(view)
        view.addSubview(filterHeader)
        filterHeader.callBackAction = { [weak self] sorttype ,orderBytype in
            guard let strongself = self else { return }
            if let sorttype = sorttype {
                strongself.parameters.sortType = sorttype
            }
            if let orderByType = orderBytype {
                strongself.parameters.orderByType = orderByType
            }
            strongself.collectionView.mj_header.beginRefreshing()
        }
        
        requestWithModel(.Static)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        filterHeader.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view).offset(topLayoutGuide.length)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(filterHeader.snp.bottom)
        }
     
    }
    
    
    @objc private func topRefresh(){
        
        requestWithModel(.TopRefresh) { _ in
            self.collectionView.mj_header.endRefreshing()
        }
        
    }
    
    fileprivate func fetchAgain(){
         requestWithModel(.Static)
    }
    
    fileprivate func requestWithModel(_ updateModel:UpdateMode,finish:((_ havemore:Bool)->Void)? = nil){
        if isFetching {
            finish?(false)
            return
        }
        isFetching = true
        if updateModel == .TopRefresh {
           self.parameters.pageIndex = 1
        }else if updateModel == .LoadMore {
           self.parameters.pageIndex += 1
        }
        ShopBrandFilterModel.GetWith(parameters: self.parameters, failureHandler: { (reason, errormessage) in
            self.showMessage(errormessage)
            self.isFetching = false
            self.isLoading = false
            let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
            waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
            finish?(false)
        }) { (filterModel) in
            self.isFetching = false
            self.isLoading = false 
            self.brandFilterModel = filterModel
            var waytoUpdate:UICollectionView.WayToUpdate = .reloadData
            guard let model = self.brandFilterModel else {
                finish?(false)
                waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
                return
            }
            if updateModel == .Static || updateModel == .TopRefresh {
                self.filterItems = model.data
                waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
                finish?(false)
            }else {
                let oldCount = self.filterItems.count
                self.filterItems.append(contentsOf: model.data)
                let newCount = self.filterItems.count
                let indexpaths = Array(oldCount..<newCount).map({
                    IndexPath(item: $0, section: 0)
                })
                finish?(model.data.isEmpty ? false:true)
                waytoUpdate = .insert(indexpaths)
                waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension ShopBrandFilterController:UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(section: section)
        switch section {
        case .item:
            return self.filterItems.count
        case .loadMore:
            return self.filterItems.isEmpty ? 0:1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(indexPath: indexPath)
        switch section {
        case .item:
            let cell:ShopBrandFilterCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        case .loadMore:
            let cell:YCLoadMoreCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = Section(indexPath: indexPath)
        switch section {
        case .item:
            let cell = cell as? ShopBrandFilterCell
            cell?.updateWithModel(filterItems[indexPath.row])
        case .loadMore:
            let cell = cell as! YCLoadMoreCollectionCell
            if cell.activity.isAnimating {
               cell.activity.startAnimating()
               cell.info = ""
            }
            self.requestWithModel(.LoadMore, finish: { haveMore in
                cell.activity.stopAnimating()
                if !haveMore{
                   cell.info = "没有更多数据了"
                }
            })
        }
    }
}


extension ShopBrandFilterController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let detail = GoodsDetailController()
         detail.controllerType = .departmentStores
         detail.item_code = filterItems[indexPath.row].itemCode
         detail.divCode = parameters.divCode
         navigationController?.pushViewController(detail, animated: true)
    }

}


extension ShopBrandFilterController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(indexPath: indexPath)
        switch section {
        case .item:
            return ShopBrandFilterCell.getSize()
        case .loadMore:
            return CGSize(width: screenWidth, height: 44)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }


}

extension ShopBrandFilterController:DZNEmptyDataSetSource {
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        if isLoading {
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


extension ShopBrandFilterController:UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let searchController:PYSearchViewController = PYSearchViewController(hotSearches: nil, searchBarPlaceholder: "输入名称".localized) { [weak self] searchViewController, searchBar, searchText in
            guard let strongself = self else { return }
            var filter = strongself.parameters
            filter.searchText = searchText!
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




struct FilterParameter {
    var brandCode:String
    var divCode:String
    var pageIndex = 1
    var sortType:Int
    var orderByType:Int
    var level1:String
    var level2:String
    var level3:String
    var searchText:String
    
    init(brandCode:String = "",divCode:String = "1",pageIndex:Int = 1,sortType:Int = 1,orderByType:Int = 0,level1:String = "",level2:String = "",level3:String = "",searchText:String = ""){
        self.brandCode = brandCode
        self.divCode = divCode
        self.pageIndex = pageIndex
        self.sortType = sortType
        self.orderByType = orderByType
        self.level1 = level1
        self.level2 = level2
        self.level3 = level3
        self.searchText = searchText
    }
}


















