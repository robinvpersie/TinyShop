//
//  StoreInfo.swift
//  Portal
//
//  Created by 이정구 on 2018/6/4.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct StoreInfomation: Codable {
    var custom_code: String
    var custom_name: String
    var company_num: String
    var shop_thumnail_image: String
    var shop_image1: String
    var shop_image2: String
    var shop_image3: String
    var shop_image4: String
    var working_hour: String
    var shop_info: String
    var addr: String
    var telephon: String
    var mobilepho: String
}


struct StoreInfoTarget: TargetType {
    var baseURL: URL = BaseUrlType.base.url
    var path: String = "/api/StoreCate/requestStoreInfo"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(saleCustomCode: String) {
        let account = YCAccountModel.getAccount()
        let parameters: [String: Any] = [
            "sale_custom_code":saleCustomCode,
            "lang_type":"kor",
            "div_code":"2",
            "token": account?.combineToken ?? "",
            "user_id": account?.customCode ?? ""
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    
}
