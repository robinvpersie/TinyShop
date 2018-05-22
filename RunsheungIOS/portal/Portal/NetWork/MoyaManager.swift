//
//  MoyaManager.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift

public enum BaseUrlType: String {
    case base = "http://mall.gigawon.co.kr:8800"
    
    var url: URL {
       switch self {
         case .base:
            return URL(string: self.rawValue)!
        }
    }
}


public struct MoyaManager {
    
    static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    }
    
    static func defaultRequestMapping(for endpoint: Endpoint, closure: (Result<URLRequest, MoyaError>) -> Void) {
        do {
            var urlRequest = try endpoint.urlRequest()
            urlRequest.timeoutInterval = 30
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    static let loggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: MoyaManager.JSONResponseDataFormatter)
    
    static let pluginArray = [MoyaManager.loggerPlugin]

}


public struct API {
    
    static let RxMoyaProvider = MultiMoyaProvider()
    
    static func request(_ target: TargetType, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return RxMoyaProvider.rx.request(MultiTarget(target), callbackQueue: callbackQueue)
    }
    
}


