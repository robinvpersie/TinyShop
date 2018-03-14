//
//  YCPublicVar.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/21.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation


public let screenWidth = UIScreen.main.bounds.size.width
public let screenHeight = UIScreen.main.bounds.size.height

public let PersonalCenterAvatarSize:CGFloat = 100

public struct YCConfigs {
    
    struct Weibo {
        static let appID = "1772193724"
        static let appKey = "453283216b8c885dad2cdb430c74f62a"
        static let redirectURL = "http://www.limon.top"
    }
    
    struct Wechat {
        static let appID = "wx4868b35061f87885"
        static let appKey = "64020361b8ec4c99936c0e3999a9f249"
    }
    
    struct QQ {
        static let appID = "1104881792"
    }
    
    static let key_Url_Schem = "yuchang"
    static let key_reserve_restaurant = "reserverRestraunt"
    static let pay_from_qr = "payFromQR"
}

public enum ParseError: Error {
    case notFound(key: String)
    case failedToGenerate(property: String)
}

public enum fromController {
    case fromOrder
    case fromRestaurant
    case fromKim
    case fromPush
}

public enum payType:Int {
    case yuchengPay
    case wechatPay
    case aliPay
    case bankPay
    
    var payTypeParameter:String {
        switch self {
        case .yuchengPay:
            return "Y"
        case .wechatPay:
            return "W"
        case .aliPay:
            return "A"
        case .bankPay:
            return "U"
        }
    }
    
    var cellImage:UIImage?{
        switch self {
        case .yuchengPay:
            return UIImage.ycpayImage
        case .wechatPay:
            return UIImage.wechatPayImage
        case .aliPay:
            return UIImage.aliPayImage
        case .bankPay:
            return UIImage.bankPayImage
        }
    }
    
    var cellTitle:String {
        switch self {
        case .yuchengPay:
            return "宇成支付"
        case .wechatPay:
            return "微信支付"
        case .aliPay:
            return "支付宝支付"
        case .bankPay:
            return "银行卡支付"
        }
    }
    
}


