//
//  ShopBrandFilterModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct BrandFilterItem {
    let comments: Int
    var imageUrl: URL?
    let itemCode: String
    let itemName: String
    let itemPrice: String
    let stockUnit: String
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let comments = json["comments"] as? Int else { throw ParseError.notFound(key: "comments") }
        if let imageUrlString = json["image_url"] as? String {
            self.imageUrl = URL(string: imageUrlString)
        }
        guard let itemCode = json["item_code"] as? String else { throw ParseError.notFound(key: "item_code") }
        guard let itemName = json["item_name"] as? String else { throw ParseError.notFound(key: "item_name") }
        guard let itemPrice = json["item_price"] as? String else { throw ParseError.notFound(key: "item_price") }
        guard let stockUnit = json["stock_unit"] as? String else { throw ParseError.notFound(key: "stock_unit") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.comments = comments
        self.itemCode = itemCode
        self.itemName = itemName
        self.itemPrice = itemPrice
        self.stockUnit = stockUnit
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> BrandFilterItem? {
        do {
            return try BrandFilterItem(with: json)
        } catch {
            print("BrandFilterItem json parse error: \(error)")
            return nil
        }
    }
}


struct ShopBrandFilterModel {
    let data: [BrandFilterItem]
    let status: Int
    let total: Int
    init(with json: JSONDictionary) throws {
        guard let dataJSONArray = json["data"] as? [JSONDictionary] else { throw ParseError.notFound(key: "data") }
        let data = dataJSONArray.map({ BrandFilterItem.create(with: $0) }).flatMap({ $0 })
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        guard let total = json["total"] as? Int else { throw ParseError.notFound(key: "total") }
        self.data = data
        self.status = status
        self.total = total
    }
    static func create(with json: JSONDictionary) -> ShopBrandFilterModel? {
        do {
            return try ShopBrandFilterModel(with: json)
        } catch {
            print("User json parse error: \(error)")
            return nil
        }
    }
}


extension ShopBrandFilterModel {
    
    static func GetWith(parameters:FilterParameter,
                        failureHandler:@escaping FailureHandler,
                        completion:@escaping (ShopBrandFilterModel?) -> Void)
    {
        let parse:(JSONDictionary) -> ShopBrandFilterModel? = { json in
            let model = ShopBrandFilterModel.create(with: json)
            return model
        }
        let requestParameter:[String:Any] = [
             "brandCode":parameters.brandCode,
             "searchText":parameters.searchText,
             "pageIndex":parameters.pageIndex,
             "pageSize":10,
             "sortType":parameters.sortType,
             "orderByType":parameters.orderByType,
             "level1":parameters.level1,
             "level2":parameters.level2,
             "level3":parameters.level3,
             "divCode":parameters.divCode
        ]
        
        let resource = AlmofireResource(Type: .shopb, path:shopGoodListKey, method: .post, requestParameters:requestParameter,parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
}
