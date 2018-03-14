//
//  NotificationNameEx.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    static var deleteString:Notification.Name{
        return Notification.Name("delete")
    }
    
    static var addstring:Notification.Name {
        return Notification.Name("add")
    }

}
