//
//  YCCanteenHomeController.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class YCCanteenHomeController: UIViewController {
    
    enum MenuType:Int{
       case left
       case right
    }
    
    var leftArray = ["全部菜系","川湘菜","粤菜","东北菜","西餐","台湾菜"]
    var rightArray = ["智能排序","距离最近"]
    var leftSelectIndex:Int = 0
    var rightSelectIndex:Int = 0
    var tableView:UITableView!
    var menu:JSDropDownMenu!
    var naviView:HomeNaviView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController!.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // automaticallyAdjustsScrollViewInsets = false
        naviView = HomeNaviView(frame: CGRect.zero)
        view.addSubview(naviView)
        naviView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.height.equalTo(64)
        }
        
        menu = JSDropDownMenu(origin: CGPoint(x: 0, y: 64), andHeight: 45)
        menu.textColor = UIColor.darkcolor
        menu.indicatorColor = UIColor(red: 210.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        menu.separatorColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0,alpha:1.0)
        menu.delegate = self
        menu.dataSource = self
        view.addSubview(menu)
        
        tableView = UITableView(frame: CGRect(x: 0, y: menu.maxy, width: screenWidth, height: view.height - 45), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNibOf(CanteenHomeCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom).offset(-self.tabBarController!.tabBar.height)
            make.top.equalTo(view.snp.top).offset(64 + 45)
        }
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension YCCanteenHomeController:JSDropDownMenuDelegate{
    
    func menu(_ menu: JSDropDownMenu!, didSelectRowAt indexPath: JSIndexPath!) {
        guard let column = MenuType(rawValue: indexPath.column) else { fatalError() }
        switch column {
        case .left:
            leftSelectIndex = indexPath.row
        case .right:
            rightSelectIndex = indexPath.row
        }
    }

}

extension YCCanteenHomeController:JSDropDownMenuDataSource{
    
    func numberOfColumns(in menu: JSDropDownMenu!) -> Int {
        return 2
    }
    
    func menu(_ menu: JSDropDownMenu!, numberOfRowsInColumn column: Int, leftOrRight: Int, leftRow: Int) -> Int{
        guard let column = MenuType(rawValue: column) else { return 0 }
        switch column {
        case .left:
            return leftArray.count
        case .right:
            return rightArray.count
        }
    }
    
    func menu(_ menu: JSDropDownMenu!, titleForRowAt indexPath: JSIndexPath!) -> String! {
        guard let column = MenuType(rawValue: indexPath.column) else { return "" }
        switch column {
        case .left:
            return leftArray[indexPath.row]
        default:
            return rightArray[indexPath.row]
        }
    }
    
    func menu(_ menu: JSDropDownMenu!, titleForColumn column: Int) -> String! {
        guard let column = MenuType(rawValue: column) else { return ""}
        switch column {
        case .left:
            return leftArray[leftSelectIndex]
        case .right:
            return rightArray[rightSelectIndex]
        }
    }
    
    func widthRatio(ofLeftColumn column: Int) -> CGFloat {
        return 1
    }
    
    func haveRightTableView(inColumn column: Int) -> Bool {
        return false
    }
    
    func currentLeftSelectedRow(_ column: Int) -> Int {
        guard let column = MenuType(rawValue: column) else { return 0 }
        switch column {
        case .left:
            return leftSelectIndex
        case .right:
            return rightSelectIndex
        }
    }
    
}

extension YCCanteenHomeController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension YCCanteenHomeController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CanteenHomeCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
