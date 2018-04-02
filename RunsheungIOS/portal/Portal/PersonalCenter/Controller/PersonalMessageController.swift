//
//  PersonalMessageController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class PersonalMessageController: BaseViewController {
    
    
    var tab: TYTabButtonPagerController!
    
    fileprivate var ControllerArray: [UIViewController] {
        get {
            let star = PersonalStarController()
            star.message = self
            let personal = PersonalCommentController()
            return [personal,star]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的消息".localized
      
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
        tab.view.frame = CGRect(x: 0, y: topLayoutGuide.length, width: screenWidth, height: screenHeight - topLayoutGuide.length)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PersonalMessageController:TYPagerControllerDataSource {
    
    func numberOfControllersInPagerController() -> Int {
        return 2
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        return self.ControllerArray[index]
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let titleArray = ["评论".localized,"点赞".localized]
        return titleArray[index]
    }
    
}







