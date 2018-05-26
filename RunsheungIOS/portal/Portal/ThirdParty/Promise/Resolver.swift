//
//  Resolver.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public class Resolver<T> {
    
    let box: Box<PromiseResult<T>>
    
    init(_ box: Box<PromiseResult<T>>) {
        self.box = box
    }
    
    deinit {
        if case .pending = box.inspect() {
            print("PromiseKit: warning: pending promise deallocated")
        }
    }
}

public extension Resolver {
    
    func fulfill(_ value: T) {
        box.seal(.fulfilled(value))
    }
    
    func reject(_ error: Error) {
        box.seal(.rejected(error))
    }
    
    public func resolve(_ result: PromiseResult<T>) {
        box.seal(result)
    }
    
    public func resolve(_ obj: T?, _ error: Error?) {
        if let error = error {
            reject(error)
        } else if let obj = obj {
            fulfill(obj)
        } else {
            reject(PMKError.invalidCallingConvention)
        }
    }
    
    public func resolve(_ obj: T, _ error: Error?) {
        if let error = error {
            reject(error)
        } else {
            fulfill(obj)
        }
    }
    
    public func resolve(_ error: Error?, _ obj: T?) {
        resolve(obj, error)
    }
}

extension Resolver where T == Void {
    public func resolve(_ error: Error?) {
        if let error = error {
            reject(error)
        } else {
            fulfill(())
        }
    }
}

public enum PromiseResult<T> {
    case fulfilled(T)
    case rejected(Error)
}

extension PromiseResult {
    var isFulfilled: Bool {
        switch self {
        case .fulfilled:
            return true
        case .rejected:
            return false
        }
    }
}


