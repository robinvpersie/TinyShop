//
//  CantennTabBarController.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class CantennTabBarController: UITabBarController {
    
     enum tab:Int {
        case home
        case order
        case profile
        
        var tabName:String {
            switch self {
            case .home:
                return "首页".localized
            case .order:
                return "订单".localized
            case .profile:
                return "我的".localized
            }
        }
        
        var normalImage:UIImage? {
            switch self {
            case .home:
                return UIImage(named: "ICON_name1")
            case .order:
                return UIImage(named: "icon_dd")
            case .profile:
                return UIImage(named: "Iocn_my_n1")
            }
        }
        
        var selectImage:UIImage? {
            switch self {
            case .home:
                return UIImage(named: "ICON_name")?.withRenderingMode(.alwaysOriginal)
            case .order:
                return UIImage(named: "icon_dd1")?.withRenderingMode(.alwaysOriginal)
            case .profile:
                return UIImage(named: "Iocn_my_n")?.withRenderingMode(.alwaysOriginal)
            }
        }
     }
    
    
     private var homeController = YCCanteenHomeController()
     private var orderController = OrderFormController()
     private var profileController = OrderProfileController()


     var divCode:String? {
        didSet{
            guard let divCode = divCode else { return }
            homeController.divCode = divCode
            orderController.divCode = divCode
            profileController.divCode = divCode
         }
      }
    
    var divName:String?{
        didSet{
            guard let divName = divName else { return }
            homeController.divName = divName
        }
    }
    

     override func viewDidLoad() {
    
        super.viewDidLoad()
        
        delegate = self
        view.backgroundColor = UIColor.white
        let homeNav = CanteenBaseNavController(rootViewController: homeController)
        let orderNav = CanteenBaseNavController(rootViewController: orderController)
        let profileNav = CanteenBaseNavController(rootViewController: profileController)
        viewControllers = [homeNav,orderNav,profileNav]
        tabBar.barTintColor = UIColor.white
        tabBar.barStyle = .default
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.red], for: .selected)
        for (index,value) in viewControllers!.enumerated(){
            let nav = value as! UINavigationController
            guard let tab = tab(rawValue: index) else { return }
            nav.tabBarItem = UITabBarItem(title: tab.tabName, image: tab.normalImage, selectedImage: tab.selectImage)
         }
    }
    
    var isTabBarVisible:Bool {
        return tabBar.frame.origin.y < view.frame.maxY
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CantennTabBarController:UITabBarControllerDelegate {
    
    
    
}
