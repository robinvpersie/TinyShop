//
//  YCBaseTableViewController.swift
//  Portal
//
//  Created by PENG LIN on 2017/1/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class YCBaseTableViewController: UITableViewController {
    
    
    var isFetching:Bool = false
    var currentPage:Int = 0
    var nextPage:Int = 1
    var isloading:Bool = true
    
    enum UpdateMode{
        case Static
        case TopRefresh
        case LoadMore
    }
    
    lazy var refreshController:UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullRefresher(sender:)), for: .valueChanged)
        refresh.tintColor = UIColor.lightGray
        refresh.layer.zPosition = -1
        return refresh
    }()
    
    lazy var baseActivityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        return activityIndicator
    }()

    
    lazy var requestFailView:YCInfoView = YCInfoView("请求失败")
    
    lazy var LoadMoreFooterView:YCInfoView = {
        let footerView = YCInfoView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        return footerView
    }()

    
    @objc func pullRefresher(sender:UIRefreshControl){}
    
    func fetchMore(){}
    
    func fetchAgain(){}
    
    @objc func popBack(){
        navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.addSubview(refreshController)
        tableView.keyboardDismissMode = .onDrag
        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 44){
              fetchMore()
        }
    }


}

extension YCBaseTableViewController:DZNEmptyDataSetSource {
    
    
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

extension YCBaseTableViewController:DZNEmptyDataSetDelegate {
    
}

