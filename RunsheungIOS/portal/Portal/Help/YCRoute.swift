//
//  YCRoute.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation


class YCRouteBox:NSObject {
    
    static let manager = YCRouteBox()
    
    private func currentVC() -> UIViewController? {
        guard let KeyWindow = UIApplication.shared.keyWindow,
              let rootvc = KeyWindow.rootViewController else {
                return nil
        }
        if rootvc.presentedViewController != nil {
            return rootvc.presentedViewController
        }
        return rootvc
    }
    
    var needPushUrl:URL? = URL(string: "http://hotel.dxbhtm.com:8863//NewsView/News?NewsSeq=121")!

    
    func pushEatIn(nav:UINavigationController?,groupID:String){
        let eatIn = EatInController()
        eatIn.hidesBottomBarWhenPushed = true
        eatIn.from = .fromPush
        eatIn.groupId = groupID
        nav?.pushViewController(eatIn, animated: true)
    }
    
    func finishNeedPush(){
        if let pushUrl = self.needPushUrl {
           self.RouteWithUrl(pushUrl)
           self.needPushUrl = nil 
        }
    }
    

    @discardableResult
    func RouteWithUrl(_ url:URL) -> Bool {
        guard url.scheme == "slapp" else {
            return false
        }
        let path = url.absoluteString
        let parameters = path.components(separatedBy: "$")
        let type = parameters[1]
        if type == "9" {
            let groupId = parameters[2]
            let currentVC = self.currentVC()
            if currentVC is UINavigationController {
               let nav = currentVC as! UINavigationController
               if let top = nav.topViewController as? EatInController {
                 top.groupId = groupId
                 top.from = .fromPush
                 top.getInfo()
               }else {
                 pushEatIn(nav: nav,groupID: groupId)
               }
           }else if currentVC is UITabBarController {
               let tab = currentVC as! UITabBarController
               if let selected = tab.selectedViewController as? UINavigationController {
                 if let top = selected.topViewController as? EatInController {
                   top.groupId = groupId
                   top.from = .fromPush
                   top.getInfo()
                 }else {
                   pushEatIn(nav: selected,groupID: groupId)
                }
               }
           }else {
                self.needPushUrl = url
           }
     }else if type == "8" {
            let newsID = parameters[2]
            let visibleVC = currentVC()
            let webURL = URL(string: "http://hotel.dxbhtm.com:8863/NewsView/News?NewsSeq=\(newsID)")!
            if let visibleVC = visibleVC,visibleVC is UINavigationController {
                  let nav = visibleVC as! UINavigationController
                  let top = nav.topViewController
                  if top is YCWebViewController {
                      let web = top as! YCWebViewController
                      web.url = webURL
                      web.refresh()
                  }else {
                     let web = YCWebViewController.init(url: webURL)
                     nav.pushViewController(web, animated: true)
                }
            }else if let visible = visibleVC,visible is UITabBarController {
                let tab = visible as! UITabBarController
                let selected = tab.selectedViewController
                if selected is UINavigationController {
                   let nav = selected as! UINavigationController
                   let web = YCWebViewController(url: webURL)
                   nav.pushViewController(web, animated: true)
                }
            }else {
                self.needPushUrl = url
            }
        }else if type == "100" {
            let top:UIViewController? = currentVC()
            if (top is WelcomeViewController){
                self.needPushUrl = url
            }else {
              CheckToken.chekcTokenAPI(completion: { (result) in
                 switch result {
                 case .success(let checktoken):
                    if checktoken.status != "1" {
                        top?.goToLogin()
                    }
                case .failure(_):
                    break
                }
            })
         }
       }
        return true
    }
    
}
