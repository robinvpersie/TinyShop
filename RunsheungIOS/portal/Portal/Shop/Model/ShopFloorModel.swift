//
//  ShopFloorModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct Mbrandlis {
    let brandType: String?
    let customCode: String
    let imageUrl: URL
    let rank: String?
    init(with json: JSONDictionary) throws {
        let brandType = json["brand_type"] as? String
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        guard let imageUrlString = json["image_url"] as? String else { throw ParseError.notFound(key: "image_url") }
        guard let imageUrl = URL(string: imageUrlString) else { throw ParseError.failedToGenerate(property: "imageUrl") }
        let rank = json["rank"] as? String
        self.brandType = brandType
        self.customCode = customCode
        self.imageUrl = imageUrl
        self.rank = rank
    }
    static func create(with json: JSONDictionary) -> Mbrandlis? {
        do {
            return try Mbrandlis(with: json)
        } catch {
            print("Mbrandlis json parse error: \(error)")
            return nil
        }
    }
}


struct Floorbrandcategor {
    let adType: String
    let adTypeName: String
    let eventId: String
    let floorNum: String
    let mBrandList: [Mbrandlis]
    init(with json: JSONDictionary) throws {
        guard let adType = json["ad_type"] as? String else { throw ParseError.notFound(key: "ad_type") }
        guard let adTypeName = json["ad_type_name"] as? String else { throw ParseError.notFound(key: "ad_type_name") }
        guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
        guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
        guard let mBrandListJSONArray = json["mBrandList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "mBrandList") }
        let mBrandList = mBrandListJSONArray.map({ Mbrandlis.create(with: $0) }).flatMap({ $0 })
        self.adType = adType
        self.adTypeName = adTypeName
        self.eventId = eventId
        self.floorNum = floorNum
        self.mBrandList = mBrandList
    }
    static func create(with json: JSONDictionary) -> Floorbrandcategor? {
        do {
            return try Floorbrandcategor(with: json)
        } catch {
            print("Floorbrandcategor json parse error: \(error)")
            return nil
        }
    }
}


struct Eventgoods2 {
    let assessCnt: String
    let customCode: String
    var imageUrl: URL?
    let itemCode: String
    let itemName: String
    let itemP: String
    init(with json: JSONDictionary) throws {
        guard let assessCnt = json["assess_cnt"] as? String else { throw ParseError.notFound(key: "assess_cnt") }
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        if let imageUrlString = json["image_url"] as? String {
            self.imageUrl = URL.init(string: imageUrlString)
        }
        guard let itemCode = json["item_code"] as? String else { throw ParseError.notFound(key: "item_code") }
        guard let itemName = json["item_name"] as? String else { throw ParseError.notFound(key: "item_name") }
        guard let itemP = json["item_p"] as? String else { throw ParseError.notFound(key: "item_p") }
        self.assessCnt = assessCnt
        self.customCode = customCode
        self.itemCode = itemCode
        self.itemName = itemName
        self.itemP = itemP
    }
    static func create(with json: JSONDictionary) -> Eventgoods2? {
        do {
            return try Eventgoods2(with: json)
        } catch {
            print("Eventgoods2 json parse error: \(error)")
            return nil
        }
    }
}




struct ShopFloorModel {
    let flag: String
    let floorBrandCategory: [Floorbrandcategor]
    struct Floorevent1 {
        let adType: String
        let adTypeName: String
        struct Eventgoods1 {
            let customCode: String
            let imageUrl: URL
            let itemCode: String
            init(with json: JSONDictionary) throws {
                guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
                guard let imageUrlString = json["image_url"] as? String else { throw ParseError.notFound(key: "image_url") }
                guard let imageUrl = URL(string: imageUrlString) else { throw ParseError.failedToGenerate(property: "imageUrl") }
                guard let itemCode = json["item_code"] as? String else { throw ParseError.notFound(key: "item_code") }
                self.customCode = customCode
                self.imageUrl = imageUrl
                self.itemCode = itemCode
            }
            static func create(with json: JSONDictionary) -> Eventgoods1? {
                do {
                    return try Eventgoods1(with: json)
                } catch {
                    print("Eventgoods1 json parse error: \(error)")
                    return nil
                }
            }
        }
        let eventGoods10: [Eventgoods1]
        let eventId: String
        let floorNum: String
        init(with json: JSONDictionary) throws {
            guard let adType = json["ad_type"] as? String else { throw ParseError.notFound(key: "ad_type") }
            guard let adTypeName = json["ad_type_name"] as? String else { throw ParseError.notFound(key: "ad_type_name") }
            guard let eventGoods10JSONArray = json["eventGoods10"] as? [JSONDictionary] else { throw ParseError.notFound(key: "eventGoods10") }
            let eventGoods10 = eventGoods10JSONArray.map({ Eventgoods1.create(with: $0) }).flatMap({ $0 })
            guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
            guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
            self.adType = adType
            self.adTypeName = adTypeName
            self.eventGoods10 = eventGoods10
            self.eventId = eventId
            self.floorNum = floorNum
        }
        static func create(with json: JSONDictionary) -> Floorevent1? {
            do {
                return try Floorevent1(with: json)
            } catch {
                print("Floorevent1 json parse error: \(error)")
                return nil
            }
        }
    }
    let floorEvent10: [Floorevent1]
    struct Floorevent2 {
        let adType: String
        let adTypeName: String
        let eventGoods20: [Eventgoods2]
        let eventId: String
        let floorNum: String
        init(with json: JSONDictionary) throws {
            guard let adType = json["ad_type"] as? String else { throw ParseError.notFound(key: "ad_type") }
            guard let adTypeName = json["ad_type_name"] as? String else { throw ParseError.notFound(key: "ad_type_name") }
            guard let eventGoods20JSONArray = json["eventGoods20"] as? [JSONDictionary] else { throw ParseError.notFound(key: "eventGoods20") }
            let eventGoods20 = eventGoods20JSONArray.map({ Eventgoods2.create(with: $0) }).flatMap({ $0 })
            guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
            guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
            self.adType = adType
            self.adTypeName = adTypeName
            self.eventGoods20 = eventGoods20
            self.eventId = eventId
            self.floorNum = floorNum
        }
        static func create(with json: JSONDictionary) -> Floorevent2? {
            do {
                return try Floorevent2(with: json)
            } catch {
                print("Floorevent2 json parse error: \(error)")
                return nil
            }
        }
    }
    let floorEvent20: [Floorevent2]
    var adInfo:[Adinf] = [Adinf]()
    let floorMsg: String
    let msg: String
    let status: String
    init(with json: JSONDictionary) throws {
        guard let flag = json["flag"] as? String else { throw ParseError.notFound(key: "flag") }
        guard let floorBrandCategoryJSONArray = json["floorBrandCategory"] as? [JSONDictionary] else { throw ParseError.notFound(key: "floorBrandCategory") }
        let floorBrandCategory = floorBrandCategoryJSONArray.map({ Floorbrandcategor.create(with: $0) }).flatMap({ $0 })
        guard let floorEvent10JSONArray = json["floorEvent10"] as? [JSONDictionary] else { throw ParseError.notFound(key: "floorEvent10") }
        let floorEvent10 = floorEvent10JSONArray.map({ Floorevent1.create(with: $0) }).flatMap({ $0 })
        guard let floorEvent20JSONArray = json["floorEvent20"] as? [JSONDictionary] else { throw ParseError.notFound(key: "floorEvent20") }
        let floorEvent20 = floorEvent20JSONArray.map({ Floorevent2.create(with: $0) }).flatMap({ $0 })
        guard let floorMsg = json["floorMsg"] as? String else { throw ParseError.notFound(key: "floorMsg") }
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
        if let adinfo = json["adInfo"] as? [JSONDictionary] {
            self.adInfo = adinfo.map({
                Adinf.create(with: $0)
            }).flatMap({
                $0
            })
        }
        self.flag = flag
        self.floorBrandCategory = floorBrandCategory
        self.floorEvent10 = floorEvent10
        self.floorEvent20 = floorEvent20
        self.floorMsg = floorMsg
        self.msg = msg
        self.status = status
    }
    static func create(with json: JSONDictionary) -> ShopFloorModel? {
        do {
            return try ShopFloorModel(with: json)
        } catch {
            print("ShopFloorModel json parse error: \(error)")
            return nil
        }
    }
}

extension ShopFloorModel {
   
    static func getWithFloorNum(_ floorNum:Int,
                                divCode:String,
                                completion:@escaping ((NetWorkResult<ShopFloorModel>)->Void)){
        
        let parse:(JSONDictionary) -> ShopFloorModel? = { json in
            let model = ShopFloorModel.create(with: json)
            return model
        }
        let requestParameter:[String:Any] = [
            "lang_type":"chn",
            "token":"",
            "floor_num":"\(floorNum)",
            "memid":"",
            "mall_home_id":"",
            "ad_type":"400,402",
            "event_type":"406,408",
            "div_code":divCode
        ]
        let netResource = NetResource(baseURL: BaseType.shop.URI,
                                      path: shopFloorDetailKey,
                                      method: .post,
                                      parameters: requestParameter,
                                      parameterEncoding: JSONEncoding(),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)

    }

}
