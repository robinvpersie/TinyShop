//
//  RSTabBarMainController.swift
//  Portal
//
//  Created by zhengzeyou on 2017/12/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class RSTabBarMainController: UITabBarController {
    
    enum Tab: Int {
        case home
        case category
        case shopcart
        case mine
        
        init(index: Int) {
            self.init(rawValue: index)!
        }
        
        var tabName: String {
            switch self {
            case .home:
                return "首页"
            case .category:
                return "附近商家"
            case .shopcart:
                return "特价优惠"
            case .mine:
                return "我的"
            }
        }
        
        var normalImage: UIImage? {
            switch self {
            case .home:
                return UIImage(named: "icon_home_bottom")
            case .category:
                return UIImage(named: "icon_shop_bottom")
            case .shopcart:
                return UIImage(named: "icon_sale_bottom")
            case .mine:
                return UIImage(named: "icon_personal_bottom")
            }
        }
        
        var selectImage: UIImage? {
            switch self {
            case .home:
                return UIImage(named: "icon_home_bottom_s")?.withRenderingMode(.alwaysOriginal)
            case .category:
                return UIImage(named: "icon_shop_bottom_s")?.withRenderingMode(.alwaysOriginal)
            case .shopcart:
                return UIImage(named: "icon_sale_bottom_s")?.withRenderingMode(.alwaysOriginal)
            case .mine:
                return UIImage(named: "icon_personal_bottom_s")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    
    private var homeController = YCHomeController()
    private var cateController = RSCategoriesViewController()
    private var shopcartController = LZCartViewController()
    private var mineController = RSMineController()
    
    
    var divCode: String? {
        didSet{
        }
    }

    var divName: String?{
        didSet{
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        delegate = self
        view.backgroundColor = UIColor.white
        
        let homeNav = UINavigationController(rootViewController: homeController)
        let cateNav = UINavigationController(rootViewController: cateController)
        let shopcartNav = UINavigationController(rootViewController:shopcartController)
        let minNav = UINavigationController(rootViewController: mineController)
        
        viewControllers = [homeNav, cateNav, shopcartNav, minNav]
        
        viewControllers?.enumerated().forEach({ offset, controller in
           // let nav = controller as! UINavigationController
            let tab = Tab(index: offset)
            controller.tabBarItem = UITabBarItem(title: tab.tabName, image: tab.normalImage, selectedImage: tab.selectImage)
        })
        
        tabBar.barTintColor = UIColor.white
        tabBar.barStyle = .default
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 33, green: 192, blue: 67)], for: .selected)

        
    }
    
    var isTabBarVisible: Bool {
        return tabBar.frame.origin.y < view.frame.maxY
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RSTabBarMainController:UITabBarControllerDelegate {
    
    
    
}

