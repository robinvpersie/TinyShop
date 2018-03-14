//
//  ShopTableViewController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ShopTableViewController: UITableViewController {

    var isFetching:Bool = false
    var currentPage:Int = 0
    var nextPage:Int = 1
    var isloading:Bool = true
    var isNeedTopRefresh:Bool = true {
        didSet{
            if !isNeedTopRefresh {
                if #available(iOS 10.0, *) {
                    self.tableView.refreshControl = nil
                } else {
                    self.refreshController.removeFromSuperview()
                }
            }
        }
    }
    var isNeedLoadMore:Bool = true {
        didSet{
            if !isNeedLoadMore {
               self.tableView.mj_footer = nil 
            }
        }
    }
    
    enum UpdateMode{
        case Static
        case TopRefresh
        case LoadMore
    }
    
    func popBack(){
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
   var refreshController:UIRefreshControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let back = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(popBack))
        back.tintColor = UIColor.darkcolor
        navigationItem.leftBarButtonItem = back
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(topRefresh), for: .valueChanged)
        //tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(topRefresh))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshController
        } else {
            tableView.insertSubview(refreshController, at: 0)
        }
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        tableView.mj_footer.isHidden = true
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.keyboardDismissMode = .onDrag
        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.tableFooterView = UIView()
    }
    
    func loadMore(){
        
    }
    
    func topRefresh(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchAgain(){
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}

extension ShopTableViewController:DZNEmptyDataSetSource {
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if isloading {
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

extension ShopTableViewController:DZNEmptyDataSetDelegate {
    
}

