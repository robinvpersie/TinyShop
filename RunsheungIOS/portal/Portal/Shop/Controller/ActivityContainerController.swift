//
//  ActivityContainerController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopActivityBaseController: ShopBaseViewController {
    
    var divCode:String!
    var tab:TYTabButtonPagerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "活动".localized
        
        tab = TYTabButtonPagerController()
        tab.showbadge = false
        tab.dataSource = self
        tab.adjustStatusBarHeight = true
        tab.barStyle = .progressView
        tab.cellSpacing = 0
        tab.progressWidth = 36
        tab.cellWidth = screenWidth/2
        tab.normalTextColor = UIColor.darkcolor
        tab.selectedTextColor = UIColor.navigationbarColor
        tab.progressColor = UIColor.navigationbarColor
        addChildViewController(tab)
        view.addSubview(tab.view)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tab.view.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.width, height: view.height - topLayoutGuide.length)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ShopActivityBaseController:TYPagerControllerDataSource {
    
    func numberOfControllersInPagerController() -> Int {
        return 2
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let titleArray = ["进行中".localized,"已结束".localized]
        return titleArray[index]
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        let shop = ShopActivityController()
        shop.divCode = divCode
        if index == 0 {
            shop.progress = 1
        }else {
            shop.progress = 0
        }
        return shop
    }
    
}

