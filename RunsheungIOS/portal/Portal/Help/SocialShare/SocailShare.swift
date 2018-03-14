//
//  SocailShare.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation


class SocailShare:NSObject {
    
    public enum Message {
        public enum WeChatSubtype {
            case session(info:UMSocialMessageObject)
            case timeline(info:UMSocialMessageObject)
            case favorite(info:UMSocialMessageObject)
        }
        case weChat(WeChatSubtype)
        case QQ(info:UMSocialMessageObject)
        case weibo(info:UMSocialMessageObject)
        case long(info:String)
        
        public var canBeDelivered:Bool {
            return true
        }
        
        static var count:Int {
            return 6
        }
    }
    
    //swift的分享
    static func share(plattype:UMSocialPlatformType,
                      messageObject:UMSocialMessageObject,
                      viewController:UIViewController?,
                      completion: @escaping (_ data:Any?,_ error:Error?) -> Void) -> Void{
          UMSocialManager.default().share(to: plattype, messageObject: messageObject, currentViewController: viewController, completion: completion)
    }

    
    public class func deliver(_ message:Message,
                               currentViewController:UIViewController? = nil,
                               completionHandler:@escaping UMSocialRequestCompletionHandler)
    {
        switch message {
        case .QQ(info: let info):
           UMSocialManager.default().share(to: .QQ, messageObject:info,currentViewController:currentViewController, completion:completionHandler)
        case .weChat(let message):
            switch message {
            case .session(info:let info):
                UMSocialManager.default().share(to: .wechatSession, messageObject:info, currentViewController: currentViewController, completion: completionHandler)
            case .timeline(info:let info):
                UMSocialManager.default().share(to: .wechatTimeLine, messageObject:info, currentViewController:currentViewController, completion: completionHandler)
            case .favorite(info: let info):
                UMSocialManager.default().share(to:.wechatFavorite, messageObject: info, currentViewController: currentViewController, completion: completionHandler)
            }
        case .weibo(info:let info):
            UMSocialManager.default().share(to:.sina, messageObject:info, currentViewController: currentViewController, completion: completionHandler)
        case .long(info: _):
            break
        }
        
    }
    
    
}
