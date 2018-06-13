//
//  YCConcurrentOperation.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/24.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation

public class ConcurrentOperation: Operation {
    enum State: String{
    case Ready, Executing, Finished
        
    var keyPath: String {
           return "is" + rawValue
        }
    }
    
    var state = State.Ready{
        willSet{
          willChangeValue(forKey: newValue.keyPath)
          willChangeValue(forKey: state.keyPath)
        }
        didSet{
          didChangeValue(forKey: oldValue.keyPath)
          didChangeValue(forKey: state.keyPath)
        }
    }
    
}


public extension ConcurrentOperation
{
    override public var isReady: Bool{
       return super.isReady && state == .Ready
    }
    
    override public var isFinished: Bool{
       return state == .Finished
    }
    
    override public var isExecuting: Bool{
       return state == .Executing
    }
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    override public func start() {
        if isCancelled {
            state = .Finished
            return
        }
        main()
        state = .Executing
    }
    
    override public func cancel() {
        state = .Finished
    }
}
