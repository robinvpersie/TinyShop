//
//  OrderFoodModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct OrderFoodModel {
    let data:OrderFoodData
    let msg: String
    let status: Int
    init(with json: JSONDictionary) throws {
        guard let dataJSONDictionary = json["data"] as? JSONDictionary else { throw ParseError.notFound(key: "data") }
        guard let data = OrderFoodData.create(with: dataJSONDictionary) else { throw ParseError.failedToGenerate(property: "data") }
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        self.data = data
        self.msg = msg
        self.status = status
    }
    static func create(with json: JSONDictionary) -> OrderFoodModel? {
        do {
            return try OrderFoodModel(with: json)
        } catch {
            print("OrderFoodModel json parse error: \(error)")
            return nil
        }
    }
}

struct OrderPagerImage {
    let imgUrl: URL
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let imgUrlString = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
        guard let imgUrl = URL(string: imgUrlString) else { throw ParseError.failedToGenerate(property: "imgUrl") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.imgUrl = imgUrl
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> OrderPagerImage? {
        do {
            return try OrderPagerImage(with: json)
        } catch {
            print("OrderPagerImage json parse error: \(error)")
            return nil
        }
    }
}


struct OrderFoodData {
    let address: String
    let businessTime: String
    let images: [OrderPagerImage]
    let info: String
    let phone: String
    let rate: String
    let rateCount: String
    let reply: [OrderFoodRepl]?
    let restaurantCode: String
    let favoriteYN:String
    //let restaurantFullName: String
    let restaurantName: String
    let score1: String
    let score2: String
    let score3: String
    init(with json: JSONDictionary) throws {
        guard let address = json["address"] as? String else { throw ParseError.notFound(key: "address") }
        guard let businessTime = json["businessTime"] as? String else { throw ParseError.notFound(key: "businessTime") }
        guard let imagesJSONArray = json["images"] as? [JSONDictionary] else { throw ParseError.notFound(key: "images") }
        let images = imagesJSONArray.map({ OrderPagerImage.create(with: $0) }).flatMap({ $0 })
        guard let info = json["info"] as? String else { throw ParseError.notFound(key: "info") }
        guard let phone = json["phone"] as? String else { throw ParseError.notFound(key: "phone") }
        guard let rate = json["rate"] as? String else { throw ParseError.notFound(key: "rate") }
        guard let rateCount = json["rateCount"] as? String else { throw ParseError.notFound(key: "rateCount") }
        if let replyJSONArray = json["reply"] as? [JSONDictionary] {
            reply = replyJSONArray.map({ OrderFoodRepl.create(with: $0) }).flatMap({ $0 })
        }else {
            reply = nil
        }
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode") }
        guard let restaurantName = json["restaurantName"] as? String else { throw ParseError.notFound(key: "restaurantName") }
        guard let score1 = json["score1"] as? String else { throw ParseError.notFound(key: "score1") }
        guard let score2 = json["score2"] as? String else { throw ParseError.notFound(key: "score2") }
        guard let score3 = json["score3"] as? String else { throw ParseError.notFound(key: "score3") }
        self.favoriteYN = json["favoriteYN"] as! String
        self.address = address
        self.businessTime = businessTime
        self.images = images
        self.info = info
        self.phone = phone
        self.rate = rate
        self.rateCount = rateCount
        self.restaurantCode = restaurantCode
        //self.restaurantFullName = restaurantFullName
        self.restaurantName = restaurantName
        self.score1 = score1
        self.score2 = score2
        self.score3 = score3
    }
    static func create(with json: JSONDictionary) -> OrderFoodData? {
        do {
            return try OrderFoodData(with: json)
        } catch {
            print("OrderFoodData json parse error: \(error)")
            return nil
        }
    }
}

struct OrderFoodReplyImages {
    let imgUrl: URL
    init(with json: JSONDictionary) throws {
        guard let imgUrlString = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
        guard let imgUrl = URL(string: imgUrlString) else { throw ParseError.failedToGenerate(property: "imgUrl") }
        self.imgUrl = imgUrl
    }
    static func create(with json: JSONDictionary) -> OrderFoodReplyImages? {
        do {
            return try OrderFoodReplyImages(with: json)
        } catch {
            print("OrderFoodReplyImages json parse error: \(error)")
            return nil
        }
    }
}


struct OrderFoodRepl {
    let content: String
    let date: String
    let images: [OrderFoodReplyImages]
    let memberID: String
    let nickName: String
    let rate: String
    let iconImg:URL
    init(with json: JSONDictionary) throws {
        guard let content = json["content"] as? String else { throw ParseError.notFound(key: "content") }
        guard let dateString = json["date"] as? String else { throw ParseError.notFound(key: "date") }
//        guard let date = dateOnlyDateFormatter.date(from: dateString) else { throw ParseError.failedToGenerate(property: "date") }
        guard let imagesJSONArray = json["images"] as? [JSONDictionary] else { throw ParseError.notFound(key: "images") }
        let images = imagesJSONArray.map({ OrderFoodReplyImages.create(with: $0) }).flatMap({ $0 })
        guard let memberID = json["memberID"] as? String else { throw ParseError.notFound(key: "memberID") }
        guard let nickName = json["nickName"] as? String else { throw ParseError.notFound(key: "nickName") }
        guard let rate = json["rate"] as? String else { throw ParseError.notFound(key: "rate") }
        guard let iconImgstr = json["iconImg"] as? String else { throw ParseError.notFound(key: "iconImg")}
        guard let iconurl = URL(string: iconImgstr) else { throw ParseError.failedToGenerate(property: "iconImg") }
        self.iconImg = iconurl
        self.content = content
        self.date = dateString
        self.images = images
        self.memberID = memberID
        self.nickName = nickName
        self.rate = rate
    }
    
    static func create(with json: JSONDictionary) -> OrderFoodRepl? {
        do {
            return try OrderFoodRepl(with: json)
        } catch {
            print("OrderFoodRepl json parse error: \(error)")
            return nil
        }
    }
}

extension OrderFoodModel{
    
    static func GetWithRestaurantCode(_ RestaurantCode:String,failureHandler:FailureHandler?,completion:@escaping (OrderFoodModel?) -> Void){
        
        let parse:(JSONDictionary) -> OrderFoodModel? = { json in
            let model = OrderFoodModel.create(with: json)
            return model
        }
        let requestParameter = [
          "saleCustomCode":RestaurantCode,
          "customCode":YCAccountModel.getAccount()?.memid ?? ""
        ]
        let resource = AlmofireResource(Type: .canteen, path:canteenOrderFoodKey, method: .post, requestParameters: requestParameter, urlEncoding:URLEncoding(destination: .queryString) , parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
}


public func AddFavoriteWithCustomCode(restaurantCode:String,
                                      token:String,
                                      completion:@escaping ((NetWorkResult<JSONDictionary>) -> Void)) {
    
    let parse:(JSONDictionary) -> JSONDictionary? = { json in
        return json
    }
    let customCode = YCAccountModel.getAccount()!.memid!
    let requestParameters:[String:Any] = [
        "customCode":customCode,
        "restaurantCode":restaurantCode,
        "token":token
    ]
    let netResource = NetResource(baseURL: BaseType.canteen.URI,
                                       path: "/AddFavorite",
                                       method: .post,
                                       parameters: requestParameters,
                                       parameterEncoding: URLEncoding(destination: .queryString),
                                       parse: parse)
    YCProvider.requestDecoded(netResource, queue: nil, completion: completion)
}

