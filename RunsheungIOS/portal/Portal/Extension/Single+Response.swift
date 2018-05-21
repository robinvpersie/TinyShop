//
//  Single+Response.swift
//  Portal
//
//  Created by 이정구 on 2018/5/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import RxSwift
import Moya


extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    

    public func filter(statusCodes: ClosedRange<Int>) -> Single<ElementType> {
        return flatMap { .just(try $0.filter(statusCodes: statusCodes)) }
    }
    
 
    public func filter(statusCode: Int) -> Single<ElementType> {
        return flatMap { .just(try $0.filter(statusCode: statusCode)) }
    }
    
 
    public func filterSuccessfulStatusCodes() -> Single<ElementType> {
        return flatMap { .just(try $0.filterSuccessfulStatusCodes()) }
    }
    
   
    public func filterSuccessfulStatusAndRedirectCodes() -> Single<ElementType> {
        return flatMap { .just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }
    
    
    public func mapImage() -> Single<Image?> {
        return flatMap { .just(try $0.mapImage()) }
    }
    

    public func mapJSON(failsOnEmptyData: Bool = true) -> Single<Any> {
        return flatMap { .just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }
    
    
    public func mapString(atKeyPath keyPath: String? = nil) -> Single<String> {
        return flatMap { .just(try $0.mapString(atKeyPath: keyPath)) }
    }
    
  
    public func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap { .just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}

