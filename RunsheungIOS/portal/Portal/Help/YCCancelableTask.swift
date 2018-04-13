//
//  YCCancelableTask.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/14.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation


public typealias CancelableTask = (_ cancel: Bool) -> Void
public typealias WorkBlock = () -> Void

@discardableResult
public func delay(_ time: TimeInterval, work:@escaping WorkBlock) -> CancelableTask? {
    var finalTask: CancelableTask?
    let cancelTask: CancelableTask = { cancel in
        if cancel {
           finalTask = nil
        }else {
            DispatchQueue.main.async {
                   work()
            }
        }
    }
    finalTask = cancelTask
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
        if let task = finalTask {
           task(false)
        }
    })
    return finalTask
}


