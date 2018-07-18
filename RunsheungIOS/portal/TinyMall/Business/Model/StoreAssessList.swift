//
//  StoreAssessList.swift
//  Portal
//
//  Created by 이정구 on 2018/7/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct ShopAssessData: Codable {
    let list_num: String
    let id: String
    let custom_name: String
    let img_path: String
    let reg_date: String
    let score: String
    let rep_content: String
    let sale_content: String
    let sale_reg_date: String
}


struct ShopAssessTarget: TargetType {
    var baseURL: URL = BaseUrlType.base.url
    var path: String = "/api/Assess/requestStoreAssessList"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(saleCustomCode: String) {
        let account = YCAccountModel.getAccount()
        let parameters: [String: Any] = [
            "lang_type": "kor",
            "sale_custom_code": saleCustomCode,
            "custom_code": account?.customCode ?? "",
            "token": account?.combineToken ?? "",
            "pg": "1",
            "pagesize": "5",
            "orderby": "2"
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}
