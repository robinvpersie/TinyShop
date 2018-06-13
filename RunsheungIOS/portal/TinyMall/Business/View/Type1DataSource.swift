//
//  Type1DataSource.swift
//  Portal
//
//  Created by 이정구 on 2018/6/11.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class Type1DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var flavor = [StoreDetail.FoodFlavor]()
    var flavorAction: ((StoreDetail.FoodFlavor) -> ())?
 
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        flavorAction?(flavor[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flavor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell()
        cell.textLabel?.text = flavor[indexPath.row].flavorName
        cell.textLabel?.textColor = UIColor.darkText
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

}
