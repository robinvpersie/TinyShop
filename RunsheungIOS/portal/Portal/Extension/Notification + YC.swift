//
//  Notification + YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation

public extension Notification.Name {
    
    public static var addressUpdate: Notification.Name{
       return Notification.Name("YCLocationUpdated")
    }
    
    public static var addressUpdateFail: Notification.Name{
       return Notification.Name("YCLocationFail")
    }
    
    public static var longinState: NSNotification.Name{
      return NSNotification.Name("YCAccountIsLogin")
    }
    
    public static var OrderRow: NSNotification.Name {
      return NSNotification.Name("OrderRow")
    }
    
    public static var changeLanguage: NSNotification.Name{
      return NSNotification.Name("changeLanguage")
    }
}
