//
//  AppDelegate.swift
//  Portal
//
//  Created by linpeng on 2016/11/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Proposer


//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var type: Int? = 100
    var itemCode: String = ""
    var shareArr = [String]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        OperationQueue.main.addOperation {
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
        let home = YCHomeController()
        window?.rootViewController = YCNavigationController(rootViewController: home)
        return true
    }
    
    func goShare() {
        if (self.type != 100 && !self.itemCode.isEmpty) {
            if self.type == 2 || self.type == 0 {
                let vc = GoodsDetailController()
                vc.item_code = itemCode
                let currentVC = self.getPresentVC()
                if currentVC is UINavigationController {
                    let vvc:UINavigationController = currentVC as! UINavigationController
                    vvc.navigationBar.backgroundColor = UIColor.white
                    vvc.pushViewController(vc, animated: true)
                }else if currentVC is UITabBarController {
                    let vvc:UITabBarController = currentVC as! UITabBarController
                    let first:UINavigationController = vvc.viewControllers?.first as! UINavigationController
                    first.pushViewController(vc, animated: true)
                }else {
                    currentVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if self.type == 1 {
                let vc = OrderFoodController()
                vc.restaurantCode = itemCode
                vc.divCode = "1"
                let currentVC = self.getPresentVC()
                if currentVC is UINavigationController {
                    let vvc:UINavigationController = currentVC as! UINavigationController
                    vvc.pushViewController(vc, animated: true)
                }else if currentVC is UITabBarController {
                    let vvc:UITabBarController = currentVC as! UITabBarController
                    let first:UINavigationController = vvc.viewControllers?.first as! UINavigationController
                    first.pushViewController(vc, animated: true)
                }else {
                    currentVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
         return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.absoluteString.contains("ret=0") && url.absoluteString.contains("wx98da3da69fcf2bcc://pay/") {
             NotificationCenter.default.post(name: Notification.Name(rawValue:"WeChatPaySuccessNotification"), object: self, userInfo: nil)
        }
        let result:Bool = UMSocialManager.default().handleOpen(url, options: options)
        if result {
           
            return result
        }
       if url.scheme == "slapp" {
            let result = url.absoluteString
            PaymentWay.payCallBack(url)
            if (!result.contains("$") || result.contains("result") || result.contains("pay")) {
                return true
            }
            
            let arr:Array = result.components(separatedBy: "$")
            self.shareArr = arr
            let type = arr[1]
            let itemCode = arr[2];
        
            self.type = Int(type)
            self.itemCode = itemCode
            
          if Int(type) == 2 || Int(type) == 0 {
            let vc = GoodsDetailController()
            vc.item_code = itemCode
            let currentVC = self.getPresentVC()
            if currentVC is UINavigationController {
               let vvc:UINavigationController = currentVC as! UINavigationController
               vvc.pushViewController(vc, animated: true)
            }else if currentVC is UITabBarController {
                let vvc:UITabBarController = currentVC as! UITabBarController
                let first:UINavigationController = vvc.viewControllers?.first as! UINavigationController
                first.pushViewController(vc, animated: true)
             }else {
                currentVC.navigationController?.pushViewController(vc, animated: true)
             }
          }
          else if Int(type) == 1 {
            let vc = OrderFoodController()
            vc.restaurantCode = itemCode
            vc.divCode = "1"
            let currentVC = self.getPresentVC()
            if currentVC is UINavigationController {
                let vvc:UINavigationController = currentVC as! UINavigationController
                vvc.pushViewController(vc, animated: true)
            }else if currentVC is UITabBarController {
                let vvc:UITabBarController = currentVC as! UITabBarController
                let first:UINavigationController = vvc.viewControllers?.first as! UINavigationController
                first.pushViewController(vc, animated: true)
            }else {
                currentVC.navigationController?.pushViewController(vc, animated: true)
            }
          }else {
             YCRouteBox.manager.RouteWithUrl(url)
          }
           return true
        }
        return true
    }
    

    func getPresentVC() -> UIViewController {
        let appRootVC = UIApplication.shared.keyWindow?.rootViewController
        var topVC = appRootVC
        if ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    

}
