//
//  OrderFormController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OrderFormController: UIViewController {

    fileprivate var titleArray = ["全部".localized,
                                  "未消费".localized,
                                  "退款单".localized,
                                  "待评价".localized
                                 ]
    
    var tab:TYTabButtonPagerController!
    var divCode:String!
    private lazy var loginView:CanteenNeedLoginView = CanteenNeedLoginView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  YCAccountModel.islogin() {
            if loginView.superview != nil {
               loginView.removeFromSuperview()
               tab.reloadData()
            }
        }else {
            if loginView.superview == nil {
                loginView.showInView(view)
                loginView.loginAction = { [weak self] in
                    guard let strongself = self else {
                        return
                    }
                    let loginContainer = RSLoginContainerController()
//                    loginContainer.longinSuccess = {
//                       strongself.tab.reloadData()
//                    }
                    let navi = UINavigationController(rootViewController: loginContainer)
                    strongself.present(navi, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订单".localized
        automaticallyAdjustsScrollViewInsets = false
        
        tab = TYTabButtonPagerController()
        tab.showbadge = false
        tab.dataSource = self
        tab.adjustStatusBarHeight = true
        tab.barStyle = .progressView
        tab.cellSpacing = 0
        tab.progressWidth = 36
        tab.cellWidth = screenWidth/4
        tab.normalTextColor = UIColor.darkcolor
        tab.selectedTextColor = UIColor.navigationbarColor
        tab.progressColor = UIColor.navigationbarColor
        addChildViewController(tab)
        view.addSubview(tab.view)
    }
    
    override func viewWillLayoutSubviews() {
        tab.view.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.width, height: view.height - topLayoutGuide.length - bottomLayoutGuide.length)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OrderFormController:TYPagerControllerDataSource{
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        return titleArray[index]
    }
    
    func numberOfControllersInPagerController() -> Int {
        return 4
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        
        var canUse:OrderFormCanUseController
        if index == 0 {
           canUse = OrderFormCanUseController(.all)
        }else if index == 1 {
            canUse = OrderFormCanUseController(.consum)
        }else if index == 2 {
            canUse = OrderFormCanUseController(.refund)
        }else {
            canUse = OrderFormCanUseController(.comment)
        }
        canUse.divCode = self.divCode
        return canUse
    }
}
