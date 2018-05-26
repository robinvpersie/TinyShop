//
//  CustomStringConvertible.swift
//  Portal
//
//  Created by 이정구 on 2018/5/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

extension Promise: CustomStringConvertible {
    public var description: String {
        switch result {
        case .none:
            return "Promise(...\(T.self))"
        case .some(.rejected(let error)):
            return "Promise(\(error)"
        case .some(.fulfilled(let value)):
            return "Promise(\(value)"
        }
    }
}

extension Promise: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch box.inspect() {
        case .pending(let handlers):
            return "Promise<\(T.self)>.pending(handlers:\(handlers.bodies.count)"
        case .resolved(.rejected(let error)):
            return "Promise<\(T.self)>.rejected(\(type(of: error)).\(error)"
        case .resolved(.fulfilled(let value)):
            return "Promise<\(T.self)>.fulfilled(\(value)"
        }
    }
}


