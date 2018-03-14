//
//  WeChatActivity.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class WeChatActivity:AnyActivity {
    
    enum `Type` {
        case session
        case timeline
        
        var activityType: UIActivityType? {
            switch self {
            case .session:
                return UIActivityType(rawValue: "com.WeChat.Session")
            case .timeline:
                return UIActivityType(rawValue: "com.WeChat.Timeline")
            }
        }
        
        var title: String? {
            switch self {
            case .session:
                return NSLocalizedString("微信", comment: "")
            case .timeline:
                return NSLocalizedString("朋友圈", comment: "")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .session:
                return UIImage(named: "wechat_session")
            case .timeline:
                return UIImage(named: "wechat_timeline")
            }
        }
    }
    
    init(type: Type, message: SocailShare.Message, completionHandler: @escaping ()->Void) {
        super.init(type: type.activityType, title: type.title, image: type.image, message: message, completion: completionHandler)
    }
}


class QQActivity:AnyActivity {
    
     init(type: UIActivityType?, image: UIImage?, message: SocailShare.Message, completion: @escaping () -> Void) {
        super.init(type: type, title: "QQ", image: image, message: message, completion: completion)
    }
    
}

class WeiboActivity:AnyActivity {
    
     init(type: UIActivityType?, image: UIImage?, message: SocailShare.Message, completion: @escaping () -> Void) {
        super.init(type: type, title:"微博", image: image, message: message, completion: completion)
    }
    
}

class longActivity:AnyActivity {
    
    var longIcon:UIImage? = UIImage(named: "longicon")
    let longtype:UIActivityType? = UIActivityType(rawValue: "com.WeChat.Session")
    
    init(type: UIActivityType?, message: SocailShare.Message, completion: @escaping () -> Void) {
        super.init(type: longtype, title: "龙聊", image:longIcon, message: message, completion: completion)
    }
}
