//
//  StoreDetail.swift
//  Portal
//
//  Created by 이정구 on 2018/5/24.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct StoreDetail: Codable {
    
    let FoodSpec: [FoodSpec]
    let FoodFlavor: [FoodFlavor]
 
    
    struct FoodSpec: Codable {
        let item_code: String
        let item_name: String
        let item_p: String
    }
    
    struct FoodFlavor: Codable {
        let flavorName: String
    }
    

}


struct StoreDetailTarget: TargetType {
    var baseURL: URL = BaseUrlType.base.url
    var path: String = "/api/StoreCate/requestStoreDetailByGroupid"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(groupId: String) {
        let parameters: [String: Any] = [
            "Groupid":groupId
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}
