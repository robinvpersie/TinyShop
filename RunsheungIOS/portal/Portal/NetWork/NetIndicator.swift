//
//  NetIndicator.swift
//  Portal
//
//  Created by 이정구 on 2018/3/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

class NetActivityIndicator {
    static let share = NetActivityIndicator()
    let lock = NSLock()
    var activityCount :Int = 0 {
        didSet {
            OperationQueue.main.addOperation {
                if self.activityCount > 0 {
                  UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }else {
                  UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    func increment() {
        lock.lock(); defer { lock.unlock() }
        activityCount += 1
    }
    
    func decrement() {
        lock.lock(); defer { lock.unlock() }
        activityCount -= 1
    }
}
