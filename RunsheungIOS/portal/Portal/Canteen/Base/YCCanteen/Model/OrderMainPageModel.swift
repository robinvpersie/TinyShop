//
//  OrderMainPageModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire
import Result
import Moya

struct Foodcode {
    let foodCodeList: [Foodcodelis]
    init(with json: JSONDictionary) throws {
        guard let foodCodeListJSONArray = json["foodCodeList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "foodCodeList") }
        let foodCodeList = foodCodeListJSONArray.map({ Foodcodelis.create(with: $0) }).flatMap({ $0 })
        self.foodCodeList = foodCodeList
    }
    static func create(with json: JSONDictionary) -> Foodcode? {
        do {
            return try Foodcode(with: json)
        } catch {
            print("Foodcode json parse error: \(error)")
            return nil
        }
    }
}


public struct Foodcodelis {
    
    let divCode:String
    let seq:String
    let mainCode:String
    let subCode:String
    let displayName:String
    let imgUrl:String
    let ver:String
    
    init(with json: JSONDictionary) throws {
        guard let divcode = json["divCode"] as? String else { throw ParseError.notFound(key: "divCode") }
        guard let seq = json["seq"] as? String else { throw ParseError.notFound(key: "seq")}
        guard let mainCode = json["mainCode"] as? String else { throw ParseError.notFound(key:"mainCode")}
        guard let subCode = json["subCode"] as? String else { throw ParseError.notFound(key: "subCode")}
        guard let codeName = json["displayName"] as? String else { throw ParseError.notFound(key: "displayName")}
        guard let imageUrl = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl")}
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver")}
        self.divCode = divcode
        self.seq = seq
        self.mainCode = mainCode
        self.subCode = subCode
        self.displayName = codeName
        self.imgUrl = imageUrl
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> Foodcodelis? {
        do {
            return try Foodcodelis(with: json)
        } catch {
            print("Foodcodelis json parse error: \(error)")
            return nil
        }
    }
}



struct Restaurantlis {
    let restaurantCode:String
    let restaurantName:String
    let restaurantFullName:String
    let distance:String
    let averagePay:String
    let shopThumImage:URL
    let averageRate:String
    let ver:String
    let salesCount:Int
    init(with json: JSONDictionary) throws {
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode")}
        guard let distance = json["distance"] as? String else { throw ParseError.notFound(key: "distance")}
        guard let restaurantName = json["restaurantName"] as? String else { throw ParseError.notFound(key: "restaurantName")}
        guard let restaurantFullName = json["restaurantFullName"] as? String else { throw ParseError.notFound(key: "restaurantFullName")}
        guard let averagePay = json["averagePay"] as? String else { throw ParseError.notFound(key: "averagePay")}
        guard let shopThumImageString = json["shopThumImage"] as? String else { throw ParseError.notFound(key: "shopThumImage")}
        guard let shopThumImage = URL(string: shopThumImageString)  else { throw ParseError.failedToGenerate(property: "shopThumImage") }
        guard let averageRate = json["averageRate"] as? String else { throw ParseError.notFound(key: "averageRate")}
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver")}
        guard let salesCount = json["salesCount"] as? Int else { throw ParseError.notFound(key: "salesCount")}
        self.restaurantCode = restaurantCode
        self.distance = distance
        self.restaurantName = restaurantName
        self.restaurantFullName = restaurantFullName
        self.averagePay = averagePay
        self.shopThumImage = shopThumImage
        self.averageRate = averageRate
        self.ver = ver
        self.salesCount = salesCount
    }
    static func create(with json: JSONDictionary) -> Restaurantlis? {
        do {
            return try Restaurantlis(with: json)
        } catch {
            print("Restaurantlis json parse error: \(error)")
            return nil
        }
    }
}


struct Restaurant {
    let currentPage: Int
    let nextPage: Int
    let restaurantList: [Restaurantlis]
    init(with json: JSONDictionary) throws {
        guard let currentPage = json["currentPage"] as? Int else { throw ParseError.notFound(key: "currentPage") }
        guard let nextPage = json["nextPage"] as? Int else { throw ParseError.notFound(key: "nextPage") }
        guard let restaurantListJSONArray = json["restaurantList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "restaurantList") }
        let restaurantList = restaurantListJSONArray.map({ Restaurantlis.create(with: $0) }).flatMap({ $0 })
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.restaurantList = restaurantList
    }
    static func create(with json: JSONDictionary) -> Restaurant? {
        do {
            return try Restaurant(with: json)
        } catch {
            print("Restaurant json parse error: \(error)")
            return nil
        }
    }
}


struct Advertiselis {
    let adImage: String
    let adTitle: String
    let linkURL: String
    let restaurantCode:String
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let adImage = json["imgUrl"] as? String else { throw ParseError.notFound(key: "adImage") }
        guard let adTitle = json["adTitle"] as? String else { throw ParseError.notFound(key: "adTitle") }
        guard let linkURL = json["linkURL"] as? String else { throw ParseError.notFound(key: "linkURL") }
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode")}
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.adImage = adImage
        self.adTitle = adTitle
        self.linkURL = linkURL
        self.ver = ver
        self.restaurantCode = restaurantCode
    }
    static func create(with json: JSONDictionary) -> Advertiselis? {
        do {
            return try Advertiselis(with: json)
        } catch {
            print("Advertiselis json parse error: \(error)")
            return nil
        }
    }
}


struct OrderAdvertise {
    let advertiseList: [Advertiselis]
    init(with json: JSONDictionary) throws {
        guard let advertiseListJSONArray = json["advertiseList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "advertiseList") }
        let advertiseList = advertiseListJSONArray.map({ Advertiselis.create(with: $0) }).flatMap({ $0 })
        self.advertiseList = advertiseList
    }
    static func create(with json: JSONDictionary) -> OrderAdvertise? {
        do {
            return try OrderAdvertise(with: json)
        } catch {
            print("Advertise json parse error: \(error)")
            return nil
        }
    }
}




struct OrderMainData {
    let advertise: OrderAdvertise
    let foodCode: Foodcode
    let restaurant: Restaurant
    init(with json: JSONDictionary) throws {
        guard let advertiseJSONDictionary = json["advertise"] as? JSONDictionary else { throw ParseError.notFound(key: "advertise") }
        guard let advertise = OrderAdvertise.create(with: advertiseJSONDictionary) else { throw ParseError.failedToGenerate(property: "advertise") }
        guard let foodCodeJSONDictionary = json["foodCode"] as? JSONDictionary else { throw ParseError.notFound(key: "foodCode") }
        guard let foodCode = Foodcode.create(with: foodCodeJSONDictionary) else { throw ParseError.failedToGenerate(property: "foodCode") }
        guard let restaurantJSONDictionary = json["restaurant"] as? JSONDictionary else { throw ParseError.notFound(key: "restaurant") }
        guard let restaurant = Restaurant.create(with: restaurantJSONDictionary) else { throw ParseError.failedToGenerate(property: "restaurant") }
        self.advertise = advertise
        self.foodCode = foodCode
        self.restaurant = restaurant
    }
    static func create(with json: JSONDictionary) -> OrderMainData? {
        do {
            return try OrderMainData(with: json)
        } catch {
            print("Data json parse error: \(error)")
            return nil
        }
    }
}


struct OrderMoreRestaurant {
    
    let data:Restaurant
    init(with json:JSONDictionary) throws {
        guard let dataJsonDictionary = json["data"] as? JSONDictionary else { throw ParseError.notFound(key: "data") }
        guard let data = Restaurant.create(with: dataJsonDictionary) else { throw ParseError.failedToGenerate(property: "data")}
        self.data = data
    }
    
    static func create(with json:JSONDictionary) -> OrderMoreRestaurant? {
        do{
            return try OrderMoreRestaurant(with:json)
        }catch {
            print("orderMoreRestaurant json parse error:\(error)")
            return nil
        }
    
    }
    
}


struct OrderMainPageModel {
    let data: OrderMainData
    let msg: String
    let status: Int
    init(with json: JSONDictionary) throws {
        guard let dataJSONDictionary = json["data"] as? JSONDictionary else { throw ParseError.notFound(key: "data") }
        guard let data = OrderMainData.create(with: dataJSONDictionary) else { throw ParseError.failedToGenerate(property: "data") }
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        self.data = data
        self.msg = msg
        self.status = status
    }
    static func create(with json: JSONDictionary) -> OrderMainPageModel? {
        do {
            return try OrderMainPageModel(with: json)
        } catch {
            print("User json parse error: \(error)")
            return nil
        }
    }
}




extension OrderMainPageModel{
    
     static func GetWithDivcode(_ divCode:String,failureHandler:FailureHandler?,completion:@escaping (OrderMainPageModel?) -> Void){
        
        let parse:(JSONDictionary) -> OrderMainPageModel? = { json in
            let model = OrderMainPageModel.create(with: json)
            return model
        }
        let resource = AlmofireResource(Type: .canteen, path:canteenMainPagekey, method: .post, requestParameters: ["divcode":divCode], urlEncoding:URLEncoding(destination: .queryString) , parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
       }
}


extension OrderMainPageModel {
    
    static func getWith(divCode divcode:String,completion:@escaping (NetWorkResult<OrderMainPageModel>)->Void)
    {
        let parse: (JSONDictionary) -> OrderMainPageModel? = { json in
            let model = OrderMainPageModel.create(with: json)
            return model
        }
        let parameter:[String:Any] = [
            "divCode":divcode,
        ]
        let resource = NetResource(baseURL: BaseType.canteen.URI,
                                   path: "/MainPage",
                                   method: .post,
                                   parameters: parameter,
                                   parameterEncoding: URLEncoding(destination: .queryString),
                                   parse: parse)
        YCProvider.requestDecoded(resource) { (result) in
            completion(result)
        }
    }
}




extension OrderMoreRestaurant  {
    
    static func GetWithDivcode(_ divCode:String,
                               currentPage Page:Int,
                               completion:@escaping(NetWorkResult<OrderMoreRestaurant>) -> Void)
    {
        let parse:(JSONDictionary) -> OrderMoreRestaurant? = { json in
             let model = OrderMoreRestaurant.create(with: json)
             return model
        }
        let requestParameters:[String:Any] = [
           "divCode":divCode,
           "currentPage":Page
        ]
        let netResource = NetResource(baseURL: BaseType.canteen.URI,
                                      path: "/MainPageRestaurantList",
                                      method: .post,
                                      parameters: requestParameters,
                                      parameterEncoding: URLEncoding(destination: .queryString),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
}




