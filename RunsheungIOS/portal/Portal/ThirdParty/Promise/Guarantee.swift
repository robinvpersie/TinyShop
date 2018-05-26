//
//  Guarantee.swift
//  Portal
//
//  Created by 이정구 on 2018/5/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public class Guarantee<T>: Thenable {
    
    let box: Box<T>
    
    fileprivate init(box: SealedBox<T>) {
        self.box = box
    }
    
    public func pipe(to: @escaping (PromiseResult<T>) -> Void) {
        
    }
    
     public var result: PromiseResult<T>?
    
    
    
}
