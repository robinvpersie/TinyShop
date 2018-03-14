//
//  OrderSearchController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/2.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderSearchController: CanteenBaseTableViewController {
    
    private var divCode:String = ""
    private var searchValue:String? = ""
    private var restaurantArray = [Restaurantlis]()
    init(divCode:String,searchValue:String?){
       self.divCode = divCode
       self.searchValue = searchValue
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商家列表"
        tableView.registerNibOf(CanteenHomeCell.self)
        fetchData()
   }
    
    private func fetchData(_ model:UpdateMode = .Static,finish:(()->Void)? = nil){
        
        if isFetching {
           finish?()
           return
        }
        isFetching = true
        if model == .Static {
            self.showCustomloading()
        }else if model == .TopRefresh {
            self.nextPage = 1
        }else {
            if self.nextPage == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                isFetching = false
                return
            }
        }
        
        HomeTypelist.GetWithDivCode(divCode, searchValue: searchValue==nil ? "":searchValue!, currentPage: self.nextPage, failureHandler: { reason, errormessage in
            self.isFetching = false
            self.isloading = false
            self.hideLoading()
            self.showMessage(errormessage)
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            waytoUpdate.performWithTableView(tableview: self.tableView)
            finish?()
            
        }) { list in
           
            self.isFetching = false
            self.isloading = false
            self.hideLoading()
            var waytoUpdate:UITableView.WayToUpdate = .none
            if let list = list {
                self.nextPage = list.nextPage
                self.currentPage = list.currentPage
                if model == .Static || model == .TopRefresh {
                    waytoUpdate = .reloadData
                    self.restaurantArray = list.restaurantList
                    waytoUpdate.performWithTableView(tableview: self.tableView)
                }else {
                    let oldCount = self.restaurantArray.count
                    self.restaurantArray.append(contentsOf: list.restaurantList)
                    let newCount = self.restaurantArray.count
                    let indexArray = Array(oldCount ..< newCount).map({
                        IndexPath(row: $0, section: 0)
                    })
                    waytoUpdate = .insert(indexArray)
                    waytoUpdate.performWithTableView(tableview: self.tableView)
                }
                finish?()
            }else {
                waytoUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: self.tableView)
                finish?()
            }
        }

      
    }
    
    override func topRefresh() {
        
        fetchData(.TopRefresh) { 
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    override func loadMore() {
        
        fetchData(.LoadMore) { 
            self.tableView.mj_footer.endRefreshing()
        }
        
    }
    
    override func fetchAgain() {
        
        fetchData(.TopRefresh) { 
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderMenu = OrderFoodController()
        orderMenu.restaurantCode = restaurantArray[indexPath.row].restaurantCode
        orderMenu.divCode = self.divCode
        orderMenu.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(orderMenu, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CanteenHomeCell = tableView.dequeueReusableCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! CanteenHomeCell
        cell.model = restaurantArray[indexPath.row]
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CanteenHomeCell.getHeight()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



}

