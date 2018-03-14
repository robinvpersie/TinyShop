//
//  ShopMallModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/16.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire


struct MallIco {
    let appType: String
    let icon: URL
    let level1: String
    let level2: String
    let level3: String
    let linkType: String
    let pageType: String
    let rank: String
    let title: String
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let appType = json["app_type"] as? String else { throw ParseError.notFound(key: "app_type") }
        guard let iconString = json["icon"] as? String else { throw ParseError.notFound(key: "icon") }
        guard let icon = URL(string: iconString) else { throw ParseError.failedToGenerate(property: "icon") }
        guard let level1 = json["level1"] as? String else { throw ParseError.notFound(key: "level1") }
        guard let level2 = json["level2"] as? String else { throw ParseError.notFound(key: "level2") }
        guard let level3 = json["level3"] as? String else { throw ParseError.notFound(key: "level3") }
        guard let linkType = json["link_type"] as? String else { throw ParseError.notFound(key: "link_type") }
        guard let pageType = json["page_type"] as? String else { throw ParseError.notFound(key: "page_type") }
        guard let rank = json["rank"] as? String else { throw ParseError.notFound(key: "rank") }
        guard let title = json["title"] as? String else { throw ParseError.notFound(key: "title") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.appType = appType
        self.icon = icon
        self.level1 = level1
        self.level2 = level2
        self.level3 = level3
        self.linkType = linkType
        self.pageType = pageType
        self.rank = rank
        self.title = title
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> MallIco? {
        do {
            return try MallIco(with: json)
        } catch {
            print("MallIco json parse error: \(error)")
            return nil
        }
    }
}


struct MallGoods1 {
    let customCode: String
    let displayNum: String
    let eventId: String
    let floorNum: String
    let imageUrl: URL
    let itemCode: String
    let rank: String
    let ver: String?
    init(with json: JSONDictionary) throws {
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        guard let displayNum = json["display_num"] as? String else { throw ParseError.notFound(key: "display_num") }
        guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
        guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
        guard let imageUrlString = json["image_url"] as? String else { throw ParseError.notFound(key: "image_url") }
        guard let imageUrl = URL(string: imageUrlString) else { throw ParseError.failedToGenerate(property: "imageUrl") }
        guard let itemCode = json["item_code"] as? String else { throw ParseError.notFound(key: "item_code") }
        guard let rank = json["rank"] as? String else { throw ParseError.notFound(key: "rank") }
        let ver = json["ver"] as? String
        self.customCode = customCode
        self.displayNum = displayNum
        self.eventId = eventId
        self.floorNum = floorNum
        self.imageUrl = imageUrl
        self.itemCode = itemCode
        self.rank = rank
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> MallGoods1? {
        do {
            return try MallGoods1(with: json)
        } catch {
            print("MallGoods1 json parse error: \(error)")
            return nil
        }
    }
}

struct MallGoods2 {
    let customCode: String
    let displayNum: String
    let eventId: String
    let floorNum: String
    let imageUrl: URL
    let itemCode: String
    let rank: String
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        guard let displayNum = json["display_num"] as? String else { throw ParseError.notFound(key: "display_num") }
        guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
        guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
        guard let imageUrlString = json["image_url"] as? String else { throw ParseError.notFound(key: "image_url") }
        guard let imageUrl = URL(string: imageUrlString) else { throw ParseError.failedToGenerate(property: "imageUrl") }
        guard let itemCode = json["item_code"] as? String else { throw ParseError.notFound(key: "item_code") }
        guard let rank = json["rank"] as? String else { throw ParseError.notFound(key: "rank") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.customCode = customCode
        self.displayNum = displayNum
        self.eventId = eventId
        self.floorNum = floorNum
        self.imageUrl = imageUrl
        self.itemCode = itemCode
        self.rank = rank
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> MallGoods2? {
        do {
            return try MallGoods2(with: json)
        } catch {
            print("MallGoods2 json parse error: \(error)")
            return nil
        }
    }
}


struct MallGoods3 {
    let assessCnt: String
    let customCode: String
    var imageUrl: URL?
    let itemCode: String
    let itemName: String
    let itemP: String
    init(with json: JSONDictionary) throws {
        guard let assessCnt = json["assess_cnt"] as? String else { throw ParseError.notFound(key: "assess_cnt") }
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        if let imageUrlString = json["image_url"] as? String  {
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
    static func create(with json: JSONDictionary) -> MallGoods3? {
        do {
            return try MallGoods3(with: json)
        } catch {
            print("MallGoods3 json parse error: \(error)")
            return nil
        }
    }
}




struct ShopMallModel {
    struct Event1 {
        let adType: String
        let adTypeName: String
        let customCode: String?
        let displayNum: String?
        let eventId: String
        let floorNum: String
        let goods10: [MallGoods1]
        let imageUrl: String?
        let rank: String?
        let ver: String?
        init(with json: JSONDictionary) throws {
            guard let adType = json["ad_type"] as? String else { throw ParseError.notFound(key: "ad_type") }
            guard let adTypeName = json["ad_type_name"] as? String else { throw ParseError.notFound(key: "ad_type_name") }
            let customCode = json["custom_code"] as? String
            let displayNum = json["display_num"] as? String
            guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
            guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
            guard let goods10JSONArray = json["goods10"] as? [JSONDictionary] else { throw ParseError.notFound(key: "goods10") }
            let goods10 = goods10JSONArray.map({ MallGoods1.create(with: $0) }).flatMap({ $0 })
            let imageUrl = json["image_url"] as? String
            let rank = json["rank"] as? String
            let ver = json["ver"] as? String
            self.adType = adType
            self.adTypeName = adTypeName
            self.customCode = customCode
            self.displayNum = displayNum
            self.eventId = eventId
            self.floorNum = floorNum
            self.goods10 = goods10
            self.imageUrl = imageUrl
            self.rank = rank
            self.ver = ver
        }
        static func create(with json: JSONDictionary) -> Event1? {
            do {
                return try Event1(with: json)
            } catch {
                print("Event1 json parse error: \(error)")
                return nil
            }
        }
    }
    let event10: [Event1]
    struct Event2 {
        let adType: String
        let adTypeName: String
        let eventId: String
        let floorNum: String
        let goods20: [MallGoods2]
        init(with json: JSONDictionary) throws {
            guard let adType = json["ad_type"] as? String else { throw ParseError.notFound(key: "ad_type") }
            guard let adTypeName = json["ad_type_name"] as? String else { throw ParseError.notFound(key: "ad_type_name") }
            guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
            guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
            guard let goods20JSONArray = json["goods20"] as? [JSONDictionary] else { throw ParseError.notFound(key: "goods20") }
            let goods20 = goods20JSONArray.map({ MallGoods2.create(with: $0) }).flatMap({ $0 })
            self.adType = adType
            self.adTypeName = adTypeName
            self.eventId = eventId
            self.floorNum = floorNum
            self.goods20 = goods20
        }
        static func create(with json: JSONDictionary) -> Event2? {
            do {
                return try Event2(with: json)
            } catch {
                print("Event2 json parse error: \(error)")
                return nil
            }
        }
    }
    let event20: [Event2]
    struct Event3 {
        let adType: String
        let adTypeName: String
        let eventId: String
        let floorNum: String
        let goods30: [MallGoods3]
        init(with json: JSONDictionary) throws {
            guard let adType = json["ad_type"] as? String else { throw ParseError.notFound(key: "ad_type") }
            guard let adTypeName = json["ad_type_name"] as? String else { throw ParseError.notFound(key: "ad_type_name") }
            guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
            guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
            guard let goods30JSONArray = json["goods30"] as? [JSONDictionary] else { throw ParseError.notFound(key: "goods30") }
            let goods30 = goods30JSONArray.map({ MallGoods3.create(with: $0) }).flatMap({ $0 })
            self.adType = adType
            self.adTypeName = adTypeName
            self.eventId = eventId
            self.floorNum = floorNum
            self.goods30 = goods30
        }
        static func create(with json: JSONDictionary) -> Event3? {
            do {
                return try Event3(with: json)
            } catch {
                print("Event3 json parse error: \(error)")
                return nil
            }
        }
    }
    let event30: [Event3]
    let flag: String
    let icon: [MallIco]
    let msg: String
    let status: String
    var adinfo:[Adinf] = [Adinf]()
    init(with json: JSONDictionary) throws {
        guard let event10JSONArray = json["event10"] as? [JSONDictionary] else { throw ParseError.notFound(key: "event10") }
        let event10 = event10JSONArray.map({ Event1.create(with: $0) }).flatMap({ $0 })
        guard let event20JSONArray = json["event20"] as? [JSONDictionary] else { throw ParseError.notFound(key: "event20") }
        let event20 = event20JSONArray.map({ Event2.create(with: $0) }).flatMap({ $0 })
        guard let event30JSONArray = json["event30"] as? [JSONDictionary] else { throw ParseError.notFound(key: "event30") }
        let event30 = event30JSONArray.map({ Event3.create(with: $0) }).flatMap({ $0 })
        guard let flag = json["flag"] as? String else { throw ParseError.notFound(key: "flag") }
        guard let iconJSONArray = json["icon"] as? [JSONDictionary] else { throw ParseError.notFound(key: "icon") }
        let icon = iconJSONArray.map({ MallIco.create(with: $0) }).flatMap({ $0 })
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
        if let adinfo:[JSONDictionary] = json["adInfo"] as? [JSONDictionary]  {
            self.adinfo = adinfo.map({
                  Adinf.create(with: $0)
            }).flatMap({
                $0
            })
        }
        self.event10 = event10
        self.event20 = event20
        self.event30 = event30
        self.flag = flag
        self.icon = icon
        self.msg = msg
        self.status = status
    }
    static func create(with json: JSONDictionary) -> ShopMallModel? {
        do {
            return try ShopMallModel(with: json)
        } catch {
            print("ShopMallModel json parse error: \(error)")
            return nil
        }
    }
}

extension ShopMallModel{
    
    static func get(divcode:String,
                    completion:@escaping ((NetWorkResult<ShopMallModel>)->Void))
    {
        
        let parse:(JSONDictionary) -> ShopMallModel? = { json in
            let model = ShopMallModel.create(with: json)
            return model
        }
        
        let requestParameter:[String:Any] = [
            "lang_type":"chn",
            "token":"",
            "memid":"",
            "mall_home_id":"186731755542e810",
            "app_type":"G",
            "page_type":"mall",
            "div_Code":divcode
        ]
        
        let netResource = NetResource(baseURL: BaseType.shop.URI,
                                      path:  shopMallMainKey,
                                      method: .post,
                                      parameters: requestParameter,
                                      parameterEncoding: JSONEncoding(),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
        
        }

}
