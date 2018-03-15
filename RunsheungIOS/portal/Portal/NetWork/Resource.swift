//
//  Resource.swift
//  Portal
//
//  Created by 이정구 on 2018/3/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya


struct TargetResource<T>: MapTargetType {
    
    typealias resultType = T
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var sampleData: Data
    var task: Task
    var headers: [String : String]?
    var map: (JSONDictionary) throws -> T
    
    init(baseURL:URL = BaseType.PortalBase.URI,
         path: String,
         method: Moya.Method,
         parameters: [String:Any]?,
         parameterEncoding: ParameterEncoding = URLEncoding.default,
         sampleData: Data = Data(),
         task: Task = .requestPlain,
         map: @escaping (JSONDictionary) throws -> T
        )
    {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.sampleData = sampleData
        if let parameters = parameters {
            self.task = .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }else {
            self.task = task
        }
        self.map = map
    }
}
