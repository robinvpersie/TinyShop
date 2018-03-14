//
//  OrderMyCollectController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderMyCollectController: CanteenBaseTableViewController {
    
   var favoriteLis = [Favoritedat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的收藏".localized
        tableView.registerNibOf(CanteenHomeCell.self)
        requestWithModel(.Static)
    }
    
    override func topRefresh() {
        requestWithModel(.TopRefresh) { [weak self] in
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
    override func loadMore() {
        requestWithModel(.LoadMore) { [weak self] in
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    
    override func fetchAgain() {
        requestWithModel(.Static)
    }
    
    
    private func requestWithModel(_ UpdateMode:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching { finish?(); return }
        if case .LoadMore = UpdateMode {
            if nextPage == 0 {
                tableView.mj_footer.endRefreshingWithNoMoreData()
                finish?()
                return
            }
        }else if case .TopRefresh = UpdateMode {
            self.nextPage = 0
        }
        isFetching = true
        let memid = YCAccountModel.getAccount()?.memid ?? ""
        let token = YCAccountModel.getAccount()?.token ?? ""
        CanteenFavoriteModel.GetWithCurrentPage(nextPage,
                                                memberId:memid,
                                                token:token)
        { [weak self] result in
            guard let strongself = self else { return }
            strongself.isFetching = false
            strongself.isloading = false
            var waytoUpdate:UITableView.WayToUpdate = .none
            switch result {
            case .success(let json):
                strongself.currentPage = json.currentPage
                strongself.nextPage = json.nextPage
                if UpdateMode == .Static || UpdateMode == .TopRefresh {
                   strongself.tableView.mj_footer.endRefreshing()
                   strongself.favoriteLis = json.FavoriteData
                   waytoUpdate = .reloadData
                   waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }else {
                    let oldListCount = strongself.favoriteLis.count
                    strongself.favoriteLis.append(contentsOf: json.FavoriteData)
                    let newListCount = strongself.favoriteLis.count
                    let indexPathsArray = Array(oldListCount..<newListCount)
                    let indexPaths = indexPathsArray.map({
                        IndexPath(row: $0, section: 0)
                    })
                    waytoUpdate = .insert(indexPaths)
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
                finish?()
            case .failure(_):
                waytoUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
                finish?()
            }
            if !strongself.favoriteLis.isEmpty {
                strongself.tableView.mj_footer.isHidden = false
            }else {
                strongself.tableView.mj_footer.isHidden = true
            }
         }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let orderMenu = OrderFoodController()
        orderMenu.restaurantCode = favoriteLis[indexPath.row].restaurantCode
        orderMenu.divCode = "1"
        orderMenu.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(orderMenu, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CanteenHomeCell.getHeight()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CanteenHomeCell = tableView.dequeueReusableCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CanteenHomeCell
        cell.updateWithModel(favoriteLis[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .default, title: "删除") { [weak self] action, indexPath in
            let customCode = YCAccountModel.getAccount()?.memid ?? ""
            let token = YCAccountModel.getAccount()?.token ?? ""
            self?.deleteWithMemid(customCode, token: token, indexPath: indexPath)
            self?.favoriteLis.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()

        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
}

extension OrderMyCollectController {
    
    func deleteWithMemid(_ memid:String,token:String,indexPath:IndexPath){
        
        let restaurantCode = self.favoriteLis[indexPath.row].restaurantCode
       NetWorkManager.manager.deleteCanteenCollect(restaurantCode: restaurantCode,
                                                   memid:memid,
                                                   token:token,
                                                   failureHandler:
        { (reason, errormessage) in
          self.showMessage(errormessage)
       }, completion: { (json) in
          let swiftJson = JSON(json!)
         let status = swiftJson["status"].int
         if status == 0 {
           print("删除成功")
         }
       })
    }

    
}
