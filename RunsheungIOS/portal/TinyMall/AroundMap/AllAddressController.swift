//
//  AllAddressController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class AllAddressController: BaseViewController {
    
    var leftTableView: UITableView!
    var rightTableView: UITableView!
    
    var leftDataSource: [String] = ["ssss", "ggggg", "gsnf" , "sbgabgb"]
    var rightDataSource: [String] = ["nsnngng", "sngng" , "sbbg"]
    
    var leftSelectIndexPath: IndexPath?
    var rightSelectIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "지역검색"
        
        leftTableView = UITableView(frame: .zero, style: .plain)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.tableFooterView = UIView()
        leftTableView.backgroundColor = UIColor.groupTableViewBackground
        leftTableView.registerClassOf(UITableViewCell.self)
        view.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(view)
            make.width.equalTo(100)
        }
        
        rightTableView = UITableView(frame: .zero, style: .plain)
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.tableFooterView = UIView()
        rightTableView.registerClassOf(UITableViewCell.self)
        view.addSubview(rightTableView)
        rightTableView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftTableView.snp.trailing)
            make.top.bottom.trailing.equalTo(view)
        }
        
        if !leftDataSource.isEmpty {
            leftSelectIndexPath = IndexPath(row: 0, section: 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AllAddressController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if tableView == leftTableView {
            leftSelectIndexPath = indexPath
            leftTableView.reloadData()
            rightTableView.reloadData()
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

extension AllAddressController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return leftDataSource.count
        }else {
            return rightDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell()
        if tableView == leftTableView {
            cell.textLabel?.text = leftDataSource[indexPath.row]
            cell.textLabel?.textColor = leftSelectIndexPath == indexPath ? UIColor.red : UIColor.darkText
            cell.contentView.backgroundColor = leftSelectIndexPath == indexPath ? UIColor.white : UIColor.groupTableViewBackground
        }else {
            cell.textLabel?.text = rightDataSource[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkText
        }
        
        return cell
    }
    
    
}
