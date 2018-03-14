//
//  ShopClassifyModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ClassifyModel {
    let categoryCode: String
    let categoryName: String
    let categoryNameEn: String
    let iconUrl: URL?
    let level: String
    init(with json: JSONDictionary) throws {
        guard let categoryCode = json["category_code"] as? String else { throw ParseError.notFound(key: "category_code") }
        guard let categoryName = json["category_name"] as? String else { throw ParseError.notFound(key: "category_name") }
        guard let categoryNameEn = json["category_name_en"] as? String else { throw ParseError.notFound(key: "category_name_en") }
        guard let iconUrlString = json["icon_url"] as? String else { throw ParseError.notFound(key: "icon_url") }
        guard let level = json["level"] as? String else { throw ParseError.notFound(key: "level") }
        self.iconUrl = URL(string: iconUrlString)
        self.categoryCode = categoryCode
        self.categoryName = categoryName
        self.categoryNameEn = categoryNameEn
        self.level = level
    }
    static func create(with json: JSONDictionary) -> ClassifyModel? {
        do {
            return try ClassifyModel(with: json)
        } catch {
            print("ClassifyModel json parse error: \(error)")
            return nil
        }
    }
}

extension ClassifyModel{
    
    static func Get(_ failureHandler:@escaping FailureHandler,
                    completion:@escaping (([ClassifyModel]?)->Void)){
        
        let parse:(JSONDictionary) -> [ClassifyModel]? = { json in
            guard let dicArray = json["data"] as? [JSONDictionary] else { return nil }
            let array:[ClassifyModel] = dicArray.map({
                return ClassifyModel.create(with: $0)!
            })
            return array
        }
        let requestParameters:[String:Any] = [
           "appType":8
        ]
        let resource = AlmofireResource(Type: .shopb, path: shopClassifyKey, method: .post, requestParameters: requestParameters, parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
   }
}

