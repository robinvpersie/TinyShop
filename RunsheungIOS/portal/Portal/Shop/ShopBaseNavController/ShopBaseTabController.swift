//
//  ShopBaseTabController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopBaseTabController: UITabBarController,UITabBarControllerDelegate{
    
    fileprivate enum tab:Int {
        case home
        case category
        case shopcar
        case profile
        
        var tabName:String {
            switch self {
            case .home:
                return "首页".localized
            case .category:
                return "分类".localized
            case .shopcar:
                return "购物车".localized
            case .profile:
                return "我的".localized
            }
        }
        
        var normalImage:UIImage? {
            switch self {
            case .home:
                return UIImage(named: "home")
            case .category:
                return UIImage(named: "icon_bfl")
            case .shopcar:
                return UIImage(named:"icon_bgwc")
            case .profile:
                return UIImage(named: "icon_bwd")
            }
        }
        
        var selectImage:UIImage? {
            switch self {
            case .home:
                return UIImage(named: "home_fill")?.withRenderingMode(.alwaysOriginal)
            case .category:
                return UIImage(named: "icon_bflf")?.withRenderingMode(.alwaysOriginal)
            case .shopcar:
                return UIImage(named: "icon_bgwcfill")?.withRenderingMode(.alwaysOriginal)
            case .profile:
                return UIImage(named: "icon_bwdfll")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    var divCode:String?{
        didSet{
            guard let divcode = divCode else {
                return
            }
            YCUserDefaults.shopDivcode.value = divcode
            homeController.divCode = divcode
            classify.divCode = divcode
            mine.divCode = divcode
        }
    }
    
    var divName:String?{
        didSet{
           homeController.divName = divName
        }
    }
    
    fileprivate var homeController = ShopHomeController()
    fileprivate let classify = ShopClassifyController()
    fileprivate let mine = SupermarketMineViewController()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        delegate = self
        let homeNav = ShopBaseNavController(rootViewController: homeController)
        let categoryNav = ShopBaseNavController(rootViewController: classify)
        
        let shopCartVC = LZCartViewController()
        shopCartVC.controllerType = .departmentStores

        shopCartVC.divCode = self.divCode
        let shopcarNav = ShopBaseNavController(rootViewController: shopCartVC)
        
        mine.controllerType = .departmentStores
        let profileNav = ShopBaseNavController(rootViewController: mine)
        
        self.viewControllers = [homeNav,categoryNav,shopcarNav,profileNav]
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.barStyle = .default
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.red], for: .selected)
        for (index,value) in viewControllers!.enumerated(){
            let nav = value as! UINavigationController
            guard let tab = tab(rawValue: index) else {
                return
            }
            nav.tabBarItem = UITabBarItem(title: tab.tabName, image: tab.normalImage, selectedImage: tab.selectImage)
        }

    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.selectedIndex == 2 || self.selectedIndex == 3 {
            NotificationCenter.default.post(name: NSNotification.Name("SupermarketSelectTabBar"), object: nil)
        }
     }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
