//
//  NetWorkResult.swift
//  Portal
//
//  Created by 이정구 on 2018/3/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

public enum NetWorkResult<Value>{
    
    case success(Value)
    case failure(MoyaError)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: MoyaError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

extension NetWorkResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}


extension NetWorkResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}


extension NetWorkResult {
    
    public func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    public func map<T>(_ transform: (Value) -> T) -> NetWorkResult<T> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
}

