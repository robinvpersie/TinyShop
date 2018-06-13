//
//  AddGood.swift
//  Portal
//
//  Created by 이정구 on 2018/6/1.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct GoodNumTarget: TargetType {
    
    var baseURL: URL = BaseUrlType.pay.url
    var path: String = "/FreshMart/User/GetUserShopCartOfListByShopId"
//    var path: String = "/FreshMart/Main/SendToken"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(shopId: String?) {
        let account = YCAccountModel.getAccount()
        let parameters: [String: Any] = [
            "ShopId": shopId ?? "",
            "appType": 1,
            "token": account?.combineToken ?? ""
        ]
//        let parameters: [String: Any] = [
//            "token": account?.combineToken ?? ""
//        ]
        self.task = .requestParameters(parameters: parameters, encoding: JSONEncoding())
    }
    
    
}

struct AddGoodTarget: TargetType  {
    
    var baseURL: URL = BaseUrlType.pay.url
    var path: String = "/FreshMart/User/AddUserShopCart"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(itemCode: String, saleCustomCode: String, goodnumber: Int) {
        let account = YCAccountModel.getAccount()
        let parameters: [String: Any] = [
            "item_quantity": goodnumber,
            "sale_custom_code": saleCustomCode,
            "item_code": itemCode,
            "div_code": "2",
            "token": account?.combineToken ?? ""
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
}