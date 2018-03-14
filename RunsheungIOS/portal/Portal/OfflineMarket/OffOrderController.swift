//
//  OffOrderController.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OffOrderController: OfflineBaseController {
    
    var tab = TYTabButtonPagerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的订单"
        
        tab = TYTabButtonPagerController()
        tab.showbadge = false
        tab.dataSource = self
        tab.adjustStatusBarHeight = true
        tab.barStyle = .progressView
        tab.cellSpacing = 0
        tab.progressWidth = 36
        tab.cellWidth = screenWidth/2
        tab.normalTextColor = UIColor(hex: 0x999999)
        tab.selectedTextColor = UIColor(hex: 0x43c3ff)
        tab.progressColor = UIColor(hex:0x43c3ff)
        tab.selectedTextFont = UIFont.systemFont(ofSize: 15)
        tab.normalTextFont = UIFont.systemFont(ofSize: 15)
        addChildViewController(tab)
        view.addSubview(tab.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            tab.view.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            tab.view.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.size.width, height: view.height - topLayoutGuide.length - bottomLayoutGuide.length)
        }
    }
    
    override func yc_back() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OffOrderController:TYPagerControllerDataSource {
    
    func numberOfControllersInPagerController() -> Int {
        return 2
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        if index == 0 {
            return OffNoServiceMkController(cottype:.noServiceMarket)
        }else {
            return OffNoServiceMkController(cottype:.eatAndDrink)
        }
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        if index == 0 {
           return "无人超市"
        }else {
           return "吃吃喝喝"
        }
    }
}
