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
    var type: Int? = 100
    var itemCode: String = ""
    var shareArr = [String]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        DispatchQueue.global().async {
            //设置微信支付wx98da3da69fcf2bcc
            WXApi.registerApp("wx98da3da69fcf2bcc", withDescription: "人生药业充值")
            
            MobClick.setLogEnabled(true)
            UMAnalyticsConfig.sharedInstance().appKey = "59ae3e687f2c74461a001a71"
            MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
            
            UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
            UMSocialManager.default().openLog(true)
            UMSocialManager.default().umSocialAppkey = "59ae3e687f2c74461a001a71"
            UMSocialManager.default().setPlaform(.QQ, appKey: "1105955455", appSecret:"sh0sSUOnMosPpbhZ", redirectURL: nil)
            UMSocialManager.default().setPlaform(.sina, appKey:"3859364376", appSecret: "1f3a02ed0032b94a661bd9e8e8864754", redirectURL: "http://pay.shelongwang.com")
            UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx8ab5a1f852d8663c", appSecret: "b57c0626ccab1ef315b4ad7225e08da3", redirectURL: nil)
            UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: "wx8ab5a1f852d8663c", appSecret: "b57c0626ccab1ef315b4ad7225e08da3", redirectURL: nil)
        }
        
        proposeToAccess(.notifications(.init(types: [.sound,.alert,.badge], categories: nil)), agreed: {}, rejected: {})
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
      
        if YCUserDefaults.isFirstLanuch.value == nil {
            let pro = ProtocolController()
            pro.startAction = { [weak self] in
                guard let this = self else { return }
                UIView.transition(with: this.window!,
                                  duration: 0.5,
                                  options: UIViewAnimationOptions.transitionFlipFromRight,
                                  animations:
                    {
                        let oldState = UIView.areAnimationsEnabled
                        UIView.setAnimationsEnabled(false)
                        let home = YCHomeController()
                        let nav = YCNavigationController(rootViewController: home)
                        this.window?.rootViewController = nav
                        UIView.setAnimationsEnabled(oldState)
                    }, completion: nil)
            }
            window?.rootViewController = pro
        } else {
            let home = YCHomeController()
            window?.rootViewController = YCNavigationController(rootViewController: home)
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


