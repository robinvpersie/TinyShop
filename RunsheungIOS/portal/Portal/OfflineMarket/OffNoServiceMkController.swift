//
//  OffNoServiceMkController.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class OffNoServiceMkController: OfflineBaseController {
    
    var activityIndicator:UIActivityIndicatorView!
    var isloading:Bool = true
    var isFetching:Bool = false
    var freshControl:UIRefreshControl!
    var tableView:UITableView!
    var offset:Int = 1
    var dataSource = [OffOrderListModel.Orderlis]()
    var foodDataSource = [OffFoodListModel.Foodorderlis]()
    var controllerType:OffOrderDetailController.controllerType = .noServiceMarket
    
    enum requestMode {
        case Static
        case TopRefresh
        case LoadMore
    }
    
    enum sectionType:Int {
        case list
        case loadMore
        static let count = 2
        init(indexPath:IndexPath){
           self.init(rawValue: indexPath.section)!
        }
        init(section:Int){
           self.init(rawValue: section)!
        }
    }
    
    convenience init(cottype:OffOrderDetailController.controllerType){
        self.init(nibName: nil, bundle: nil)
        self.controllerType = cottype
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        freshControl = UIRefreshControl()
        freshControl.addTarget(self, action: #selector(topRefresh(sender:)), for: .valueChanged)

        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OffNoServiceCell.self)
        tableView.registerNibOf(YCLoadMoreCell.self)
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        if #available(iOS 10.0, *) {
            tableView.refreshControl = freshControl
        } else {
            tableView.insertSubview(freshControl, at: 0)
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor,constant:10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let finish:()->Void = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }

        switch controllerType {
          case .noServiceMarket:
             requestData(.Static, finish: finish)
          case .eatAndDrink:
             requestFoodData(.Static, finish: finish)
        }
        
    }
    
    @objc func topRefresh(sender:UIRefreshControl){
        
        let finish:()->Void = {
            sender.endRefreshing()
        }
        switch controllerType {
        case .noServiceMarket:
            requestData(.TopRefresh, finish: finish)
        case .eatAndDrink:
            requestFoodData(.TopRefresh, finish: finish)
        }
    }
    
    func requestFoodData(_ mode:requestMode,finish:(()->Void)?){
        if isFetching { finish?(); return }
        if case .Static = mode {
            activityIndicator.startAnimating()
        }else if case .LoadMore = mode {
            offset = offset + 1
        }else {
            offset = 1
        }
        isFetching = true
        OffFoodListModel.requestFoodOrderList(offset: offset) { [weak self] (result) in
            guard let strongself = self else { return }
            strongself.isFetching = false
            strongself.isloading = false
            switch result {
            case .success(let model):
                if mode == .Static || mode == .TopRefresh {
                    let waytoUpdate:UITableView.WayToUpdate = .reloadData
                    strongself.foodDataSource = model.foodOrderList
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }else {
                    if model.foodOrderList.isEmpty {
                        strongself.offset -= 1
                    }else {
                        let originalData = strongself.foodDataSource.count
                        strongself.foodDataSource.append(contentsOf: model.foodOrderList)
                        let newData = strongself.foodDataSource.count
                        let indexPaths = Array(originalData ..< newData).map({ IndexPath(item: $0, section: sectionType.list.rawValue) })
                        let waytoUpdate:UITableView.WayToUpdate = .insert(indexPaths)
                        waytoUpdate.performWithTableView(tableview: strongself.tableView)
                     }
                }
            case .failure:
                if mode == .LoadMore {
                    strongself.offset = strongself.offset - 1
                }else {
                    let waytoUpdate:UITableView.WayToUpdate = .reloadData
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
            }
            finish?()
        }
    }
    
    func requestData(_ mode:requestMode,finish:(()->Void)?){
        if isFetching { finish?(); return }
        if case .Static = mode {
            activityIndicator.startAnimating()
        }else if case .LoadMore = mode {
            offset = offset + 1
        }else {
            offset = 1
        }
        isFetching = true
        OffOrderListModel.requestOrderList(offset: offset) { [weak self] (result) in
            guard let strongself = self else { return }
            strongself.isFetching = false
            strongself.isloading = false
            switch result {
            case .success(let model):
                if mode == .Static || mode == .TopRefresh {
                    let waytoUpdate:UITableView.WayToUpdate = .reloadData
                    strongself.dataSource = model.orderList
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }else {
                    if model.orderList.isEmpty {
                        strongself.offset = strongself.offset - 1
                    }else {
                        let originalData = strongself.dataSource.count
                        strongself.dataSource.append(contentsOf: model.orderList)
                        let newData = strongself.dataSource.count
                        let indexPaths = Array(originalData ..< newData).map({ IndexPath(item: $0, section: sectionType.list.rawValue) })
                        let waytoUpdate:UITableView.WayToUpdate = .insert(indexPaths)
                        waytoUpdate.performWithTableView(tableview: strongself.tableView)
                    }
                }
            case .failure:
                if mode == .LoadMore {
                  strongself.offset = strongself.offset - 1
                }else {
                 let waytoUpdate:UITableView.WayToUpdate = .reloadData
                 waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
            }
            finish?()
         }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



}

extension OffNoServiceMkController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sectionType(indexPath: indexPath)
        var orderDetail:OffOrderDetailController?
        switch section {
          case .list:
            switch controllerType {
            case .eatAndDrink:
                orderDetail = OffOrderDetailController(type: controllerType, foodlis: foodDataSource[indexPath.row])
            case .noServiceMarket:
                orderDetail = OffOrderDetailController(type: controllerType, orderlis: dataSource[indexPath.row])
            }
            orderDetail?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(orderDetail!, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .list:
            return OffNoServiceCell.getHeight()
        case .loadMore:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .list:
            let cell = cell as! OffNoServiceCell
            switch controllerType {
            case .eatAndDrink:
                cell.foodModel = foodDataSource[indexPath.row]
            case .noServiceMarket:
                cell.model = dataSource[indexPath.row]
            }
        case .loadMore:
            let cell = cell as! YCLoadMoreCell
            if !cell.activityIndicator.isAnimating {
                cell.activityIndicator.startAnimating()
                cell.info = nil
            }
            let finish:()->Void = {
                cell.activityIndicator.stopAnimating()
            }
            
            switch controllerType {
            case .eatAndDrink:
                requestFoodData(.LoadMore, finish: finish)
            case .noServiceMarket:
                requestData(.LoadMore, finish: finish)
            }
        }
    }

}

extension OffNoServiceMkController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectiontype = sectionType(section: section)
        switch sectiontype {
        case .loadMore:
            switch controllerType {
            case .noServiceMarket:
               return dataSource.isEmpty ? 0:1
            case .eatAndDrink:
               return foodDataSource.isEmpty ? 0:1
            }
        case .list:
            switch controllerType {
            case .noServiceMarket:
                return dataSource.count
            case .eatAndDrink:
                return foodDataSource.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .list:
            let cell:OffNoServiceCell = tableView.dequeueReusableCell()
            return cell
        case .loadMore:
            let cell:YCLoadMoreCell = tableView.dequeueReusableCell()
            return cell
        }
    }
}

extension OffNoServiceMkController:DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if isloading {
            return nil
        }else {
            let attribute = NSAttributedString(string: "还没有订单")
            return attribute
        }
    }
}
