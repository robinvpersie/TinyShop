//
//  Type2DataSource.swift
//  Portal
//
//  Created by 이정구 on 2018/6/11.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class Type2DataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var foodSpec = [StoreDetail.FoodSpec]()
    var specAction: ((StoreDetail.FoodSpec) -> ())?
    
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        specAction?(foodSpec[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodSpec.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell()
        cell.textLabel?.textColor = UIColor.darkText
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = foodSpec[indexPath.row].item_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
  
}
