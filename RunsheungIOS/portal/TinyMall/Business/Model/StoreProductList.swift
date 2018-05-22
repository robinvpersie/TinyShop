//
//  StoreProductList.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct StoreInfoProduct: Codable {
    
}


struct StoreInfoProductTarget: TargetType  {
    
    var baseURL: URL = BaseUrlType.base.url
    var path: String = "/api/StoreCate/requestStoreInfoProductList"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(saleCustomCode: String, customCode: String, pg: Int) {
        let parameters: [String: Any] = [
            "sale_custom_code": saleCustomCode,
            "custom_code": customCode,
            "latitude": "",
            "longitude": "",
            "token": "",
            "pg": pg,
            "pagesize": 10
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}
