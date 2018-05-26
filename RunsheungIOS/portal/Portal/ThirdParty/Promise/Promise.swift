//
//  Promise.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public class Promise<T>: Thenable {
    
    let box: Box<PromiseResult<T>>
    
    fileprivate init(box: SealedBox<PromiseResult<T>>) {
        self.box = box 
    }
    
    public class func value(_ value: T) -> Promise<T> {
        return Promise(box: SealedBox(value: .fulfilled(value)))
    }
    
    public init(error: Error) {
        box = SealedBox(value: .rejected(error))
    }
    
    public init<U: Thenable>(_ bridge: U) where U.T == T {
        box = EmptyBox()
        bridge.pipe(to: box.seal)
    }
    
    public init(resolver body: (Resolver<T>) throws -> Void) {
        box = EmptyBox()
        let resolver = Resolver(box)
        do {
           try body(resolver)
        } catch {
            resolver.reject(error)
        }
    }
    
    public class func pending() -> (promise: Promise<T>, resolver: Resolver<T>) {
         return { ($0, Resolver($0.box)) }(Promise<T>(.pending))
    }
    
    
    public func pipe(to: @escaping (PromiseResult<T>) -> Void) {
        switch box.inspect() {
        case .pending:
            box.inspect {
                switch $0 {
                case .pending(let handlers):
                    handlers.append(to)
                case .resolved(let value):
                    to(value)
                }
            }
        case .resolved(let value):
            to(value)
        }
        
    }
    
    public var result: PromiseResult<T>? {
        switch box.inspect() {
        case .pending:
            return nil
        case .resolved(let result):
            return result
        }
    }
    
    
    init(_: PMKUnambiguousInitializer) {
        box = EmptyBox()
    }
    
}

public extension Promise {
    func tap(_ body: @escaping (PromiseResult<T>) -> Void) -> Promise {
        pipe(to: body)
        return self
    }
    
    func wait() throws -> T {
        if Thread.isMainThread {
            print("call on main thread")
        }
        var result = self.result
        
        if result == nil {
            let group = DispatchGroup()
            group.enter()
            pipe {
                result = $0
                group.leave()
            }
            group.wait()
        }
        switch result! {
        case .rejected(let error):
            throw error
        case .fulfilled(let value):
            return value
        }
    }
}

extension Promise where T == Void {
    public convenience init() {
        self.init(box: SealedBox(value: .fulfilled(Void())))
    }
}

public extension DispatchQueue {
    
    final func async<T>(_: PMKNamespacer, group: DispatchGroup? = nil, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute body: @escaping () throws -> T) -> Promise<T> {
        let promise = Promise<T>(.pending)
        async(group: group, qos: qos, flags: flags) {
            do {
                promise.box.seal(.fulfilled(try body()))
            } catch {
                promise.box.seal(.rejected(error))
            }
        }
        return promise
    }
    
}

public enum PMKNamespacer {
    case promise
}

enum PMKUnambiguousInitializer {
    case pending
}
