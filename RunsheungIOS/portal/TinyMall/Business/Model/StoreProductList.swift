//
//  StoreProductList.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct Plist: Codable, Hashable {
    let ANum: String
    let item_code: String
    let image_url: String
    let item_name: String
    let item_p: String
    let MonthSaleCount: String
    let GroupId: String
    let isSingle: String
    let Remark: String
    let synopsis: String
    let ITEM_DETAILS: String
}

struct StoreInfo: Codable {
    let custom_code: String
    let custom_name: String
    let shop_thumnail_image: String
    let sale_cnt: String
    let fav_cnt: String
    let distance: String
    let score: String
    let cnt: String
    let sale_custom_cnt: String
    let favorites: String
}

struct Category: Codable {
    let id: String
    let level_name: String
}

struct StoreInfoProduct: Codable {
    var StoreInfo: StoreInfo
    var plist: [Plist]
    var category: [Category]
    
}

struct StoreInfoProductTarget: TargetType  {
    var baseURL: URL = BaseUrlType.base.url
    var path: String = "/api/StoreCate/requestStoreInfoProductList"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    init(saleCustomCode: String?, pg: Int, itemlevel: String) {
        let customCode = YCAccountModel.getAccount()?.customCode
        let token = YCAccountModel.getAccount()?.combineToken
        let latitude = UserDefaults.standard.object(forKey: "latitude")
        let longtitude = UserDefaults.standard.object(forKey: "longitude")
        let parameters: [String: Any] = [
            "lang_type": "kor",
            "item_level1": itemlevel,
            "sale_custom_code": saleCustomCode ?? "",
            "custom_code": customCode ?? "",
            "latitude": latitude ?? "0",
            "longitude": longtitude ?? "0",
            "token": token ?? "",
            "pg": pg,
            "pagesize": 10
        ]
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}
