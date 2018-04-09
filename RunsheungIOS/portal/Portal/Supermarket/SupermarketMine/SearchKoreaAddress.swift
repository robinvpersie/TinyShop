//
//  SearchKoreaAddress.swift
//  Portal
//
//  Created by 이정구 on 2018/3/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SnapKit
import MJRefresh

class SearchKoreaAddress: BaseViewController {
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var dataArray = NSMutableArray()
    var offset: Int = 1
    var searchText: String?
    @objc var selectAction: ((NSDictionary) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.registerClassOf(UITableViewCell.self)
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.rowHeight = 45
        tableView.estimatedRowHeight = 45
        view.addSubview(tableView)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.prefetchDataSource = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    @objc func loadMore() {
        self.offset = self.offset + 1
        KoreaPlaceModel.fetchWithQuery(self.searchText, offset: self.offset) { (array) in
            if let array = array {
                self.dataArray.addObjects(from: array as! [Any])
            }
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension SearchKoreaAddress: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        throttle {
            self.searchText = searchText
            self.offset = 1
            KoreaPlaceModel.fetchWithQuery(searchText, offset: self.offset, success: { (array) in
                if let array = array {
                    self.dataArray = array
                }
                OperationQueue.main.addOperation {
                   self.tableView.reloadData()
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text
        self.offset = 1
        KoreaPlaceModel.fetchWithQuery(searchBar.text, offset: offset) { (array) in
            if let array = array {
                self.dataArray = array
            }
            OperationQueue.main.addOperation {
               self.tableView.reloadData()
            }
        }
    }
    
    override func yc_back() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}


extension SearchKoreaAddress: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexpath) in
            
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
    
}

extension SearchKoreaAddress: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        self.navigationController?.dismiss(animated: true, completion: {
            self.selectAction?(dic)
        })
    }
    
}

extension SearchKoreaAddress: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell()
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = dic["address"] as? String
        cell.detailTextLabel?.text = dic["postcd"] as? String
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray.count == 0 {
            tableView.mj_footer.isHidden = true
        }else {
            tableView.mj_footer.isHidden = false
        }
        return self.dataArray.count
    }
    
}

extension SearchKoreaAddress: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click SearchBar to search")
    }
}
