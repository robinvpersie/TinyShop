//
//  ShopBrandModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct ShopBrandlis {
    let customCode: String
    let imageUrl: URL
    let listRank: String
    init(with json: JSONDictionary) throws {
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        guard let imageUrlString = json["image_url"] as? String else { throw ParseError.notFound(key: "image_url") }
        guard let imageUrl = URL(string: imageUrlString) else { throw ParseError.failedToGenerate(property: "imageUrl") }
        guard let listRank = json["list_rank"] as? String else { throw ParseError.notFound(key: "list_rank") }
        self.customCode = customCode
        self.imageUrl = imageUrl
        self.listRank = listRank
    }
    static func create(with json: JSONDictionary) -> ShopBrandlis? {
        do {
            return try ShopBrandlis(with: json)
        } catch {
            print("ShopBrandlis json parse error: \(error)")
            return nil
        }
    }
}


struct ShopDat {
    let brandList: [ShopBrandlis]
    let brandType: String
    init(with json: JSONDictionary) throws {
        guard let brandListJSONArray = json["brandList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "brandList") }
        let brandList = brandListJSONArray.map({ ShopBrandlis.create(with: $0) }).flatMap({ $0 })
        guard let brandType = json["brand_type"] as? String else { throw ParseError.notFound(key: "brand_type") }
        self.brandList = brandList
        self.brandType = brandType
    }
    static func create(with json: JSONDictionary) -> ShopDat? {
        do {
            return try ShopDat(with: json)
        } catch {
            print("ShopDat json parse error: \(error)")
            return nil
        }
    }
}




struct ShopBrandModel {
    let data: [ShopDat]
    let flag: String
    let msg: String
    let status: String
    init(with json: JSONDictionary) throws {
        guard let dataJSONArray = json["data"] as? [JSONDictionary] else { throw ParseError.notFound(key: "data") }
        let data = dataJSONArray.map({ ShopDat.create(with: $0) }).flatMap({ $0 })
        guard let flag = json["flag"] as? String else { throw ParseError.notFound(key: "flag") }
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
        self.data = data
        self.flag = flag
        self.msg = msg
        self.status = status
    }
    static func create(with json: JSONDictionary) -> ShopBrandModel? {
        do {
            return try ShopBrandModel(with: json)
        } catch {
            print("ShopBrandModel json parse error: \(error)")
            return nil
        }
    }
}


extension ShopBrandModel {
    
    static func GetWithDiv(_ divCode:String,failureHandler:FailureHandler?,completion:@escaping (ShopBrandModel?) -> Void){
        
        let parse:(JSONDictionary) -> ShopBrandModel? = { json in
            let model = ShopBrandModel.create(with: json)
            return model
        }
        let requestParameter:[String:Any] = [
            "memid":"",
            "token":"",
            "lang_type":"chn",
            "div":divCode
        ]
        
        let resource = AlmofireResource(Type: .shop, path:shopBrandKey, method: .post, requestParameters:requestParameter, urlEncoding:JSONEncoding(),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

        
    }
   
}

