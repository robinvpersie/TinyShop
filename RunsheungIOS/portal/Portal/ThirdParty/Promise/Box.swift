//
//  Box.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

enum Sealant<R> {
    case pending(Handlers<R>)
    case resolved(R)
}

class Handlers<R> {
    var bodies: [(R) -> Void] = []
    func append(_ item: @escaping (R) -> Void) {
        bodies.append(item)
    }
}

class Box<T> {
    func inspect() -> Sealant<T> { fatalError() }
    func inspect(_ : (Sealant<T>) -> Void) { fatalError() }
    func seal(_: T) {}
}

class SealedBox<T>: Box<T> {
    let value: T
    
    init(value: T) {
        self.value = value
    }
    
    override func inspect() -> Sealant<T> {
        return .resolved(value)
    }
}

class EmptyBox<T>: Box<T> {
    private var sealant = Sealant<T>.pending(Handlers.init())
    private var barrier = DispatchQueue(label: "promisekit.barrier", attributes: .concurrent)
    
    override func seal(_ value: T) {
        var handlers: Handlers<T>!
        barrier.sync(flags: .barrier) {
            guard case .pending(let _handlers) = self.sealant else {
                return
            }
            handlers = _handlers
            self.sealant = .resolved(value)
        }
        
        if let handlers = handlers {
            handlers.bodies.forEach {
                $0(value)
            }
        }
    }
    
    override func inspect() -> Sealant<T> {
        var rv: Sealant<T>!
        barrier.sync {
            rv = self.sealant
        }
        return rv
    }
    
    override func inspect(_ body: (Sealant<T>) -> Void) {
        var sealed = false
        barrier.sync(flags: .barrier) {
            switch sealant {
            case .pending:
                body(sealant)
            case .resolved:
                sealed = true
            }
        }
        if sealed {
            body(sealant)
        }
    }
}


extension Optional where Wrapped: DispatchQueue {
    func async(_ body: @escaping () -> Void) {
        switch self {
        case .none:
            body()
        case .some(let q):
            q.async(execute: body)
        }
    }
}
