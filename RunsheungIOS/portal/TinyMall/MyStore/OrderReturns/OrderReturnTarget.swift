//
//  OrderReturnTarget.swift
//  Portal
//
//  Created by 이정구 on 2018/7/5.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct OrderReturnTarget: TargetType  {
    
    var baseURL: URL = BaseUrlType.base.url
    var path: String = "/api/AppSM/requestCancelReturn"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(pg: Int) {
        let account = YCAccountModel.getAccount()
        let parameters: [String: Any] = [
            "lang_type": "kor",
            "custom_code": "01071390103abcde",
            "token": account?.combineToken ?? "",
            "pg": pg,
            "pagesize": "10"
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}


struct OrderReturnModel: Codable {
    let cancel_date: String
    let list_num: String
    let mobilepho: String
    let dataitem: [DataItem]
    let custom_name: String
    let cancel_num: String
    let tot_amt: String
    let custom_code: String
    let to_address: String
    let online_order_status: String
    let order_num: String
    let status_classify: String
}


struct DataItem: Codable {
    let order_q: String
    let order_o: String
    let item_image_url: String
    let item_name: String
}
