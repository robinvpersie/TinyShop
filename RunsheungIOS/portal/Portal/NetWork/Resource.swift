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
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var map: (JSONDictionary) throws -> T
    
    init(baseURL:URL = BaseType.PortalBase.URI,
         path: String,
         method: Moya.Method,
         parameters: [String:Any]?,
         parameterEncoding: ParameterEncoding = URLEncoding.default,
         sampleData: Data = Data(),
         task: Task = .request,
         map: @escaping (JSONDictionary) throws -> T
        )
    {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        self.task = task
        self.map = map
    }
}
