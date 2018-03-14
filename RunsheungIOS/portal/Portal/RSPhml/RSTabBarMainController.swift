//
//  RSTabBarMainController.swift
//  Portal
//
//  Created by zhengzeyou on 2017/12/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class RSTabBarMainController: UITabBarController {
    
    enum tab:Int {
        case home
        case category
        case shopcart
        case mine
        
        var tabName:String {
            switch self {
            case .home:
                return "首页"
            case .category:
                return "分类"
            case .shopcart:
                return "购物车"
            case .mine:
                return "我"
            }
        }
        
        var normalImage:UIImage? {
            switch self {
            case .home:
                return UIImage(named: "icon_home_n1")
            case .category:
                return UIImage(named: "icon_classification_n")
            case .shopcart:
                return UIImage(named: "icon_shoppingcart_n")
               
            case .mine:
                return UIImage(named: "icon_me_n")
            }
        }
        
        var selectImage:UIImage? {
            switch self {
            case .home:
                return UIImage(named: "icon_home_s1")?.withRenderingMode(.alwaysOriginal)
            case .category:
                return UIImage(named: "icon_classification_s")?.withRenderingMode(.alwaysOriginal)
            case .shopcart:
                return UIImage(named: "icon_shoppingcart_s")?.withRenderingMode(.alwaysOriginal)
            case .mine:
                return UIImage(named: "icon_me_s")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    
    private var homeController = YCHomeController()
    private var cateController = RSCategoriesViewController()
    private var shopcartController = LZCartViewController()
    private var mineController = RSMineController()
    
    
    var divCode:String? {
        didSet{
            guard let divCode = divCode else { return }
//            homeController.divCode = divCode
//            orderController.divCode = divCode
//            profileController.divCode = divCode
        }
    }

    var divName:String?{
        didSet{
            guard let divName = divName else { return }
//            homeController.divName = divName
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
        viewControllers = [homeNav,cateNav,shopcartNav,minNav]
        tabBar.barTintColor = UIColor.white
        tabBar.barStyle = .default
        UITabBarItem.appearance().setTitleTextAttributes(
        [
          NSForegroundColorAttributeName:UIColor(red: 33/255.0, green: 192/255.0, blue: 67/255.0, alpha: CGFloat(1))], for: .selected
        )
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

extension RSTabBarMainController:UITabBarControllerDelegate {
    
    
    
}

