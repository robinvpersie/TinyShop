//
//  AppDelegate.swift
//  Portal
//
//  Created by linpeng on 2016/11/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Proposer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        if YCUserDefaults.isFirstOpen {
            let pro = ProtocolController()
            pro.startAction = { [weak self] in
            guard let this = self else { return }
            UIView.transition(with: this.window!, duration: 0.5, options: .curveEaseIn, animations: {
                        let oldState = UIView.areAnimationsEnabled
                        UIView.setAnimationsEnabled(false)
                        let home = SupermarketMainController()
                        this.window?.rootViewController = home
                        UIView.setAnimationsEnabled(oldState)
                }, completion: { finish in
                    YCUserDefaults.FirstOpen.value = true
                })
            }
            window?.rootViewController = pro
        } else {
            let home = SupermarketMainController()
            window?.rootViewController = home
        }
        window?.makeKeyAndVisible()
        return true
    }
    

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
}


