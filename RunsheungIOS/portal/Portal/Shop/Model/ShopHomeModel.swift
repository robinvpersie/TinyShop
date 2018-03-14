//
//  ShopHomeModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

extension ShopHomeModel {
   static func GetWithDiv(_ divcode:String,
                          memid:String?,
                          token:String?,
                          completion:@escaping (NetWorkResult<ShopHomeModel>) -> Void)
   {
        let parse:(JSONDictionary) -> ShopHomeModel? = { json in
            let model = ShopHomeModel.create(with: json)
            return model
        }
        
        let requestParameter:[String:Any] = [
            "memid":memid ?? "",
            "token":token ?? "",
            "lang_type":"chn",
            "div":divcode
        ]
        let netResource = NetResource(baseURL: BaseType.shop.URI,
                                      path: "/api/ycO2O/getO2OMainList30",
                                      method: .post,
                                      parameters: requestParameter,
                                      parameterEncoding: JSONEncoding(),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
      }
}


struct Adinf {
    var adImage: URL?
    let eventId: String
    let itemCode: String
    init(with json: JSONDictionary) throws {
        if let adImageString = json["ad_image"] as? String {
            self.adImage = URL(string: adImageString)
        }
        guard let eventId = json["event_id"] as? String else {
            throw ParseError.notFound(key: "event_id")
        }
        guard let itemCode = json["item_code"] as? String else {
            throw ParseError.notFound(key: "item_code")
        }
        self.eventId = eventId
        self.itemCode = itemCode
    }
    
    static func create(with json: JSONDictionary) -> Adinf? {
        do {
            return try Adinf(with: json)
        } catch {
            print("Adinf json parse error: \(error)")
            return nil
        }
    }
}


struct ShopHomeModel {
    let adInfo: [Adinf]
    let banner: [ShopBanne]
    let category: [ShopCategor]
    struct Divinf {
        let billDivCode: String
        let divName: String
        init(with json: JSONDictionary) throws {
            guard let billDivCode = json["bill_div_code"] as? String else {
                throw ParseError.notFound(key: "bill_div_code")
            }
            guard let divName = json["div_name"] as? String else {
                throw ParseError.notFound(key: "div_name")
            }
            self.billDivCode = billDivCode
            self.divName = divName
        }
        static func create(with json: JSONDictionary) -> Divinf? {
            do {
                return try Divinf(with: json)
            } catch {
                print("Divinf json parse error: \(error)")
                return nil
            }
        }
    }
    let divinfo: [Divinf]
    let icon: [Ico]
    struct Mal {
        init(with json: JSONDictionary) throws {
        }
        static func create(with json: JSONDictionary) -> Mal? {
            do {
                return try Mal(with: json)
            } catch {
                print("Mal json parse error: \(error)")
                return nil
            }
        }
    }
    let mall: [Mal]
    init(with json: JSONDictionary) throws {
        guard let adInfoJSONArray = json["adInfo"] as? [JSONDictionary] else { throw ParseError.notFound(key: "adInfo") }
        let adInfo = adInfoJSONArray.map({ Adinf.create(with: $0) }).flatMap({ $0 })
        guard let bannerJSONArray = json["banner"] as? [JSONDictionary] else { throw ParseError.notFound(key: "banner") }
        let banner = bannerJSONArray.map({ ShopBanne.create(with: $0) }).flatMap({ $0 })
        guard let categoryJSONArray = json["category"] as? [JSONDictionary] else { throw ParseError.notFound(key: "category") }
        let category = categoryJSONArray.map({ ShopCategor.create(with: $0) }).flatMap({ $0 })
        guard let divinfoJSONArray = json["divinfo"] as? [JSONDictionary] else { throw ParseError.notFound(key: "divinfo") }
        let divinfo = divinfoJSONArray.map({ Divinf.create(with: $0) }).flatMap({ $0 })
        guard let iconJSONArray = json["icon"] as? [JSONDictionary] else {
            throw ParseError.notFound(key: "icon")
        }
        let icon = iconJSONArray.map({ Ico.create(with: $0) }).flatMap({ $0 })
        guard let mallJSONArray = json["mall"] as? [JSONDictionary] else {
            throw ParseError.notFound(key: "mall")
        }
        let mall = mallJSONArray.map({ Mal.create(with: $0) }).flatMap({ $0 })
        self.adInfo = adInfo
        self.banner = banner
        self.category = category
        self.divinfo = divinfo
        self.icon = icon
        self.mall = mall
    }
    static func create(with json: JSONDictionary) -> ShopHomeModel? {
        do {
            return try ShopHomeModel(with: json)
        } catch {
            print("ShopHomeModel json parse error: \(error)")
            return nil
        }
    }
}


struct Eventimag {
    let customCode: String
    let displayNum: String
    let eventId: String
    let imageUrl: URL
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        guard let displayNum = json["display_num"] as? String else { throw ParseError.notFound(key: "display_num") }
        guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
        guard let imageUrlString = json["image_url"] as? String else { throw ParseError.notFound(key: "image_url") }
        guard let imageUrl = URL(string: imageUrlString) else { throw ParseError.failedToGenerate(property: "imageUrl") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.customCode = customCode
        self.displayNum = displayNum
        self.eventId = eventId
        self.imageUrl = imageUrl
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> Eventimag? {
        do {
            return try Eventimag(with: json)
        } catch {
            print("Eventimag json parse error: \(error)")
            return nil
        }
    }
}



struct UniqueFloor {
    let customCode: String
    let eventImage: [Eventimag]
    let eventId: String
    let floorIcon: URL
    var imageCount: Int?
    init(with json: JSONDictionary) throws {
        guard let customCode = json["custom_code"] as? String else { throw ParseError.notFound(key: "custom_code") }
        guard let eventImageJSONArray = json["eventImage"] as? [JSONDictionary] else { throw ParseError.notFound(key: "eventImage") }
        let eventImage = eventImageJSONArray.map({ Eventimag.create(with: $0) }).flatMap({ $0 })
        guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
        guard let floorIconString = json["floor_icon"] as? String else { throw ParseError.notFound(key: "floor_icon") }
        guard let floorIcon = URL(string: floorIconString) else { throw ParseError.failedToGenerate(property: "floorIcon") }
        let imageCount = json["image_count"] as? Int
        self.customCode = customCode
        self.eventImage = eventImage
        self.eventId = eventId
        self.floorIcon = floorIcon
        self.imageCount = imageCount
    }
    static func create(with json: JSONDictionary) -> UniqueFloor? {
        do {
            return try UniqueFloor(with: json)
        } catch {
            print("UniqueFloor json parse error: \(error)")
            return nil
        }
    }
}


struct ShopCategor {
    
    let data: [UniqueFloor]
    let eventId: String
    let floorNum: String
    let level1: String
    let levelName: String
    init(with json: JSONDictionary) throws {
        guard let dataJSONArray = json["data"] as? [JSONDictionary] else { throw ParseError.notFound(key: "data") }
        let data = dataJSONArray.map({ UniqueFloor.create(with: $0) }).flatMap({ $0 })
        guard let eventId = json["event_id"] as? String else { throw ParseError.notFound(key: "event_id") }
        guard let floorNum = json["floor_num"] as? String else { throw ParseError.notFound(key: "floor_num") }
        guard let level1 = json["level1"] as? String else { throw ParseError.notFound(key: "level1") }
        guard let levelName = json["level_name"] as? String else { throw ParseError.notFound(key: "level_name") }
        self.data = data
        self.eventId = eventId
        self.floorNum = floorNum
        self.level1 = level1
        self.levelName = levelName
    }
    static func create(with json: JSONDictionary) -> ShopCategor? {
        do {
            return try ShopCategor(with: json)
        } catch {
            print("Categor json parse error: \(error)")
            return nil
        }
    }
}



struct Ico {
    let count: String?
    let icon: URL?
    let rank: String
    let title: String?
    let ver: String?
    init(with json: JSONDictionary) throws {
        let iconString = json["icon"] as? String
        let icon = URL(string: iconString ?? "")
        guard let rank = json["rank"] as? String else { throw ParseError.notFound(key: "rank") }
        self.title = json["title"] as? String
        self.ver = json["ver"] as? String
        self.count = json["count"] as? String
        self.icon = icon
        self.rank = rank
    }
    static func create(with json: JSONDictionary) -> Ico? {
        do {
            return try Ico(with: json)
        } catch {
            print("Ico json parse error: \(error)")
            return nil
        }
    }
}



struct ShopBanne {
    let adId: String
    let adImage: URL
    let adTitle: String
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let adId = json["ad_id"] as? String else { throw ParseError.notFound(key: "ad_id") }
        guard let adImageString = json["ad_image"] as? String else { throw ParseError.notFound(key: "ad_image") }
        guard let adImage = URL(string: adImageString) else { throw ParseError.failedToGenerate(property: "adImage") }
        guard let adTitle = json["ad_title"] as? String else { throw ParseError.notFound(key: "ad_title") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.adId = adId
        self.adImage = adImage
        self.adTitle = adTitle
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> ShopBanne? {
        do {
            return try ShopBanne(with: json)
        } catch {
            print("ShopBanne json parse error: \(error)")
            return nil
        }
    }
}

