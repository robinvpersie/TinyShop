//
//  Catchable.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public protocol CatchMixin: Thenable {
    
}

public extension CatchMixin {
    
    @discardableResult
    func `catch`(on: DispatchQueue? = conf.Q.return, policy: CatchPolicy = conf.catchPolicy, _ body: @escaping (Error) -> Void)  {
        
    }
    
}

public class PMKFinalizer {
    
}
