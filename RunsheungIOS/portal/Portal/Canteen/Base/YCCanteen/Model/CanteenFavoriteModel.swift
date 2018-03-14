//
//  CanteenFavoriteModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct Favoritedat {
    let averagePay: String
    let averageRate: String
    let date: String
    let distance: String
    let floor: String
    let restaurantCode: String
    let restaurantName: String
    let salesCount: Int
    let shopThumImage: URL
    let ver: String
    init(with json: JSONDictionary) throws {
        guard let averagePay = json["averagePay"] as? String else { throw ParseError.notFound(key: "averagePay") }
        guard let averageRate = json["averageRate"] as? String else { throw ParseError.notFound(key: "averageRate") }
        guard let date = json["date"] as? String else { throw ParseError.notFound(key: "date") }
        guard let distance = json["distance"] as? String else { throw ParseError.notFound(key: "distance") }
        guard let floor = json["floor"] as? String else { throw ParseError.notFound(key: "floor") }
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode") }
        guard let restaurantName = json["restaurantName"] as? String else { throw ParseError.notFound(key: "restaurantName") }
        guard let salesCount = json["salesCount"] as? Int else { throw ParseError.notFound(key: "salesCount") }
        guard let shopThumImageString = json["shopThumImage"] as? String else { throw ParseError.notFound(key: "shopThumImage") }
        guard let shopThumImage = URL(string: shopThumImageString) else { throw ParseError.failedToGenerate(property: "shopThumImage") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.averagePay = averagePay
        self.averageRate = averageRate
        self.date = date
        self.distance = distance
        self.floor = floor
        self.restaurantCode = restaurantCode
        self.restaurantName = restaurantName
        self.salesCount = salesCount
        self.shopThumImage = shopThumImage
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> Favoritedat? {
        do {
            return try Favoritedat(with: json)
        } catch {
            print("Favoritedat json parse error: \(error)")
            return nil
        }
    }
}


struct CanteenFavoriteModel {
    let FavoriteData: [Favoritedat]
    let currentPage: Int
    let nextPage: Int
    init(with json: JSONDictionary) throws {
        guard let FavoriteDataJSONArray = json["FavoriteData"] as? [JSONDictionary] else { throw ParseError.notFound(key: "FavoriteData") }
        let FavoriteData = FavoriteDataJSONArray.map({ Favoritedat.create(with: $0) }).flatMap({ $0 })
        guard let currentPage = json["currentPage"] as? Int else { throw ParseError.notFound(key: "currentPage") }
        guard let nextPage = json["nextPage"] as? Int else { throw ParseError.notFound(key: "nextPage") }
        self.FavoriteData = FavoriteData
        self.currentPage = currentPage
        self.nextPage = nextPage
    }
    static func create(with json: JSONDictionary) -> CanteenFavoriteModel? {
        do {
            return try CanteenFavoriteModel(with: json)
        } catch {
            print("CanteenFavoriteModel json parse error: \(error)")
            return nil
        }
    }
}

extension CanteenFavoriteModel {
    
    static func GetWithCurrentPage(_ page:Int,memberId:String,token:String,completion:@escaping (NetWorkResult<CanteenFavoriteModel>) -> Void)
    {
        let parse:(JSONDictionary) -> CanteenFavoriteModel? = { json in
            guard let data = json["data"] as? JSONDictionary,let status = json["status"] as? Int else {
                return nil
            }
            if status == -9001 {
               YCUserDefaults.accountModel.value = nil
               return nil
            }
            let model = CanteenFavoriteModel.create(with:data)
            return model
        }
      let requestParameters:[String:Any] = [
            "currentPage":page,
            "userID":memberId,
            "token":token
        ]
        let netResource = NetResource(baseURL: BaseType.canteen.URI,
                                           path: "/MyFavorite",
                                           method: .post,
                                           parameters: requestParameters,
                                           parameterEncoding: URLEncoding.init(destination: .queryString),
                                           parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)

    }
}


