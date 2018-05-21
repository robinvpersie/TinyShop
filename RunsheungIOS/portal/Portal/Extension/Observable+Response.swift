//
//  Observable+Response.swift
//  Portal
//
//  Created by 이정구 on 2018/5/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension ObservableType where E == Response {
    
    public func filter(statusCodes: ClosedRange<Int>) -> Observable<E> {
        return flatMap { Observable.just(try $0.filter(statusCodes: statusCodes)) }
    }
    
    public func filter(statusCode: Int) -> Observable<E> {
        return flatMap { Observable.just(try $0.filter(statusCode: statusCode)) }
    }
   
    public func filterSuccessfulStatusCodes() -> Observable<E> {
        return flatMap { Observable.just(try $0.filterSuccessfulStatusCodes()) }
    }
    
  
    public func filterSuccessfulStatusAndRedirectCodes() -> Observable<E> {
        return flatMap { Observable.just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }
    
   
    public func mapImage() -> Observable<Image?> {
        return flatMap { Observable.just(try $0.mapImage()) }
    }
    
   
    public func mapJSON(failsOnEmptyData: Bool = true) -> Observable<Any> {
        return flatMap { Observable.just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }
    
  
    public func mapString(atKeyPath keyPath: String? = nil) -> Observable<String> {
        return flatMap { Observable.just(try $0.mapString(atKeyPath: keyPath)) }
    }
    
    
    public func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Observable<D> {
        return flatMap { Observable.just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
    
}


extension ObservableType where E == ProgressResponse {
    
    public func filterCompleted() -> Observable<Response> {
        return self.filter { $0.completed }.flatMap { progress -> Observable<Response> in
                switch progress.response {
                case .some(let response): return .just(response)
                case .none: return .empty()
               }
        }
    }
    
    public func filterProgress() -> Observable<Double> {
        return self.filter { !$0.completed }.map { $0.progress }
    }
}


