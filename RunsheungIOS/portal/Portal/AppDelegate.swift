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
        
        DispatchQueue.global().async {
            //设置微信支付wx98da3da69fcf2bcc
            WXApi.registerApp("wx98da3da69fcf2bcc", withDescription: "人生药业充值")
			
        }
        
        proposeToAccess(.notifications(UIUserNotificationSettings(types: [.sound,.alert,.badge], categories: nil)), agreed: {}, rejected: {})
        proposeToAccess(.location(.whenInUse), agreed: { }) { }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
      
        let pro = ProtocolController()
        pro.startAction = { [weak self] in
            guard let this = self else { return }
            UIView.transition(with: this.window!, duration: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        let oldState = UIView.areAnimationsEnabled
                        UIView.setAnimationsEnabled(false)
                        let home = SupermarketMainController()
                        this.window?.rootViewController = home
                        UIView.setAnimationsEnabled(oldState)
              }, completion: { finish in
                   
              })
            }
        window?.rootViewController = pro
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


