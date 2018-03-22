//
//  SearchListController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SearchListController: BaseViewController {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    var dataSource = [SearchListModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "搜索地址"
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        navigationItem.titleView = searchBar
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.estimatedRowHeight = 10;
        tableView.registerClassOf(UITableViewCell.self)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    
    }
    
    func requestDataWithQuery(_ query: String) {
        
        SearchListModel.requestWithQuery(query) { [weak self] (modelArray) in
            self?.dataSource = modelArray
            OperationQueue.main.addOperation {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SearchListController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        yc_back()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.requestDataWithQuery(searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        throttle { [weak self] in
            self?.requestDataWithQuery(searchText)
        }
    }
    
}


extension SearchListController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "搜索想要的商品")
    }
}



extension SearchListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
//
extension SearchListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell()
        cell.textLabel?.text = dataSource[indexPath.row].address
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}



