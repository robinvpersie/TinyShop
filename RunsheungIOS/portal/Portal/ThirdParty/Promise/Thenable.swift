//
//  Thenable.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public protocol Thenable: class {
    associatedtype T
    func pipe(to: @escaping(PromiseResult<T>) -> Void)
    var result: PromiseResult<T>? { get }
}

public extension Thenable {

    func then<U: Thenable>(on: DispatchQueue? = conf.Q.map, file: StaticString = #file, line: UInt = #line, _ body: @escaping (T) throws -> U) -> Promise<U.T> {
        let rp = Promise<U.T>.init(.pending)
        pipe {
            switch $0 {
            case .fulfilled(let value):
                on.async {
                    do {
                        let rv = try body(value)
                        guard rv !== rp else { throw PMKError.returnedSelf }
                        rv.pipe(to: rp.box.seal)
                    } catch {
                        rp.box.seal(.rejected(error))
                    }
                }
            case .rejected(let error):
                rp.box.seal(.rejected(error))
            }
        }
        return rp
    }
    
    func map<U>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping (T) throws -> U) -> Promise<U> {
        let rp = Promise<U>(.pending)
        pipe {
            switch $0 {
            case .fulfilled(let value):
                on.async {
                    do {
                       rp.box.seal(.fulfilled(try transform(value)))
                    } catch {
                        rp.box.seal(.rejected(error))
                    }
                }
            case .rejected(let error):
                rp.box.seal(.rejected(error))
            }
        }
        return rp
    }
    
    
    func compactMap<U>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping (T) throws -> U?) -> Promise<U> {
        let rp = Promise<U>(.pending)
        pipe {
            switch $0 {
            case .fulfilled(let value):
                on.async {
                    do {
                        if let rv = try transform(value) {
                            rp.box.seal(.fulfilled(rv))
                        } else {
                            throw PMKError.compactMap(value, U.self)
                        }
                    } catch {
                        rp.box.seal(.rejected(error))
                    }
                }
            case .rejected(let error):
                rp.box.seal(.rejected(error))
            }
        }
        return rp
    }
    
    
    func done(on: DispatchQueue? = conf.Q.return, _ body: @escaping (T) throws -> Void) -> Promise<Void> {
        let rp = Promise<Void>(.pending)
        pipe {
            switch $0 {
            case .fulfilled(let value):
                on.async {
                    do {
                        try body(value)
                        rp.box.seal(.fulfilled(()))
                    } catch {
                        rp.box.seal(.rejected(error))
                    }
                }
            case .rejected(let error):
                rp.box.seal(.rejected(error))
            }
        }
        return rp
    }
    
    func get(on: DispatchQueue? = conf.Q.return, _ body: @escaping (T) throws -> Void ) -> Promise<T> {
        return map(on: on, {
            try body($0)
            return $0
        })
    }
    
    func asVoid() -> Promise<Void> {
        return map(on: nil, { _ in })
    }

}

public extension Thenable {
    var error: Error? {
        switch result {
        case .none:
            return nil
        case .some(.fulfilled):
            return nil
        case .some(.rejected(let error)):
            return error
        }
    }
    
    var isPending: Bool {
        return result == nil
    }
    
    var isResolved: Bool {
        return !isPending
    }
    
    var value: T? {
        switch result {
        case .none:
            return nil
        case .some(.fulfilled(let value)):
            return value
        case .some(.rejected):
            return nil
        }
    }
    
    var isFulfilled: Bool {
        return value != nil
    }
    
    var isRejected: Bool {
        return error != nil 
    }
}


public extension Thenable where T: Sequence {
    
    func mapValues<U>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping (T.Iterator.Element) throws -> U) -> Promise<[U]> {
        return map(on: on, {
            try $0.map(transform)
        })
    }
    
    func flatMapValues<U: Sequence>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping (T.Iterator.Element) throws -> U) -> Promise<[U.Iterator.Element]> {
        return map(on: on, { (foo: T) in
            try foo.flatMap({ try transform($0) })
        })
    }
    
    func compactMapValues<U>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping (T.Iterator.Element) throws -> U?) -> Promise<[U]> {
        return map(on: on, { (foo) -> [U] in
            return try foo.compactMap(transform)
        })
    }
    
//    func thenMap<U: Thenable>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping (T.Iterator.Element) throws -> U) -> Promise<[U.T]> {
//        return then(on: on, {
//
//        })
//    }
}


public extension Thenable where T: Collection {
    
    var firstValue: Promise<T.Iterator.Element> {
        return map(on: nil, {  aa in
            if let a1 = aa.first {
                return a1
            } else {
                throw PMKError.emptySequence
            }
        })
    }
    
    var lastValue: Promise<T.Iterator.Element> {
        return map(on: nil, { aa in
            if aa.isEmpty {
                throw PMKError.emptySequence
            } else {
                let i = aa.index(aa.endIndex, offsetBy: -1)
                return aa[i]
            }
        })
    }
}

public extension Thenable where T: Sequence, T.Iterator.Element: Comparable {
    func sortedValues(on: DispatchQueue? = conf.Q.map) -> Promise<[T.Iterator.Element]> {
        return map(on: on, { $0.sorted() })
    }
}




