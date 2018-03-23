//
//  YCGCDTimer.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/25.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation

public typealias GCDThrottleBlock = () -> Void
public var scheduledSources = [String:DispatchSourceTimer]()

public func throttle(threshold: TimeInterval = 0.3,
                     queue: DispatchQueue = .main,
                     key: String = Thread.callStackSymbols[1],
                     block: @escaping GCDThrottleBlock)
{
    
    func createSource(){
        let source = DispatchSource.makeTimerSource(queue: queue)
        source.schedule(deadline: .now() + threshold, repeating: threshold)
        source.setEventHandler {
            block()
            source.cancel()
            scheduledSources.removeValue(forKey: key)
        }
        source.resume()
        scheduledSources[key] = source

    }
    
    if let sources = scheduledSources[key] {
        sources.cancel()
        createSource()
    }else {
        createSource()
    }
}
