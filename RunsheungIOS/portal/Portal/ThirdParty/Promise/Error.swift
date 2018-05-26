//
//  Error.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public enum PMKError: Error {
    case invalidCallingConvention
    case returnedSelf
    case badInput
    case cancelled
    case compactMap(Any, Any.Type)
    case emptySequence
}

extension PMKError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .compactMap(let obj, let type):
            return "Could not `flatMap<\(type)>`: \(obj)"
        case .invalidCallingConvention:
            return "A closure was called with an invalid calling convention, probably (nil, nil)"
        case .returnedSelf:
            return "A promise handler returned itself"
        case .badInput:
            return "Bad input was provided to a PromiseKit function"
        case .cancelled:
            return "The asynchronous sequence was cancelled"
        case .emptySequence:
            return "The first or last element was requested for an empty sequence"
        }
    }
}

extension PMKError: LocalizedError {
    public var errorDescription: String? {
        return debugDescription
    }
}

public protocol CancellableError: Error {
    var isCancelled: Bool { get }
}

extension Error {
    public var isCancelled: Bool {
        do {
            throw self
        } catch PMKError.cancelled {
            return true
        } catch let error as CancellableError {
            return error.isCancelled
        } catch URLError.cancelled {
            return true
        } catch CocoaError.userCancelled {
            return true
        } catch {
            return false
        }
    }
}

public enum CatchPolicy {
    case allErrors
    case allErrorsExceptCancellation 
}
