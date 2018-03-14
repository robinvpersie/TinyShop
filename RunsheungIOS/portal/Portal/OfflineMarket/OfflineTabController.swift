//
//  OfflineTabController.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OfflineTabController: UITabBarController {
    
    enum mode {
        case ticket
        case empty
        
        var viewControllers:[UIViewController] {
            switch self {
            case .ticket:
                let marketController = OfflineShopCarController()
                let eatAndDrinkController = OffEatAndDrinkController()
                let myOrderController = OffOrderController()
                let marketNav = UINavigationController(rootViewController: marketController)
                let eatAndDrinkNav = UINavigationController(rootViewController: eatAndDrinkController)
                let myOrderNav = UINavigationController(rootViewController: myOrderController)
                return [marketNav,eatAndDrinkNav,myOrderNav]
           case .empty:
                let marketController = OfflineHomeController()
                let eatAndDrinkController = OffEatAndDrinkController()
                let myOrderController = OffOrderController()
                let marketNav = UINavigationController(rootViewController: marketController)
                let eatAndDrinkNav = UINavigationController(rootViewController: eatAndDrinkController)
                let myOrderNav = UINavigationController(rootViewController: myOrderController)
                return [marketNav,eatAndDrinkNav,myOrderNav]
           }
        }
        
    }
    
    var tabmode:mode = .empty {
        didSet{
            setViewControllers(tabmode.viewControllers, animated: false)
            for (index,value) in viewControllers!.enumerated(){
                let tab = offLineTab(index: index)
                value.tabBarItem = UITabBarItem(title: tab.itemName, image: tab.normalImage, selectedImage: tab.selectedImage)
            }
        }
    }
    
    var divCode:String?{
        didSet{
            
        }
    }
    
    enum offLineTab:Int{
        case market
        case eatAndDrink
        case myOrder
        
        init(index:Int){
            self.init(rawValue: index)!
        }
        
        
        var itemName:String {
            switch self {
            case .market:
                return "无人超市"
            case .eatAndDrink:
                return "吃吃喝喝"
            case .myOrder:
                return "我的订单"
            }
        }
        
        var normalImage:UIImage? {
            switch self {
            case .market:
                return UIImage(named: "icon_offline_shop_n")?.withRenderingMode(.alwaysOriginal)
            case .eatAndDrink:
                return UIImage(named: "icon_restaurant_n")?.withRenderingMode(.alwaysOriginal)
            case .myOrder:
                return UIImage(named: "icon_order_n")?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        var selectedImage:UIImage? {
            switch self {
            case .market:
                return UIImage(named: "icon_offline_shop_s")?.withRenderingMode(.alwaysOriginal)
            case .eatAndDrink:
                return UIImage(named: "icon_restaurant_s")?.withRenderingMode(.alwaysOriginal)
            case .myOrder:
                return UIImage(named: "icon_order_ss")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        view.backgroundColor = UIColor.white
        tabBar.barTintColor = UIColor.white
        tabBar.barStyle = .default
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(hex: 0x43c3ff)], for: .selected)
   }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

extension OfflineTabController:UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
    
}
