//
//  OrderLocationModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

struct OrderLocationModel {
    
    let divInfo:OrderdivInfo
    let currentCity:String
    let availableCityList:[availableCity]
    
    init(with json:JSONDictionary) throws {
        guard let divinfoDictionary = json["divInfo"] as? JSONDictionary else { throw ParseError.notFound(key: "divInfo") }
        guard let divinfo = OrderdivInfo.create(with: divinfoDictionary) else { throw ParseError.failedToGenerate(property: "divInfo") }
        guard let currentCity = json["currentCity"] as? String else { throw ParseError.notFound(key: "currentCity") }
        guard let availableCityListArray = json["availableCityList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "availableCityList")
        }
        let availableCityList = availableCityListArray.map({ availableCity.create(with: $0) }).flatMap({ $0 })
        self.divInfo = divinfo
        self.currentCity = currentCity
        self.availableCityList = availableCityList
    }
    
    static func create(with json:JSONDictionary) -> OrderLocationModel?{
        do{
           return try OrderLocationModel(with: json)
        }catch{
           print("orderLocationModel json parse error:\(error)")
         return nil
        }
    }
}

struct OrderdivInfo {
    
    let divCode:String
    let divName:String
    let zipCode:String?
    let lon:String
    let lat:String
    
    init(with json:JSONDictionary) throws {
        guard let divCode = json["divCode"] as? String else { throw ParseError.notFound(key: "divCode") }
        guard let divName = json["divName"] as? String else { throw ParseError.notFound(key: "divName") }
        let zipCode = json["zipCode"] as? String
        guard let lon = json["lon"] as? String else { throw ParseError.notFound(key: "lon") }
        guard let lat = json["lat"] as? String else { throw ParseError.notFound(key: "lat") }
        self.divCode = divCode
        self.divName = divName
        self.zipCode = zipCode
        self.lon = lon
        self.lat = lat 
    }
    
    static func create(with json: JSONDictionary) -> OrderdivInfo? {
        do {
            return try OrderdivInfo(with: json)
        } catch {
            print(" divInfo json parse error: \(error)")
            return nil
        }
    }
}

struct availableCity{
    
    let cityZipcode:String
    let cityName:String
    
    init(with json:JSONDictionary) throws {
        guard let cityZipcode = json["cityZipcode"] as? String else { throw ParseError.notFound(key: "cityZipCode")}
        guard let cityName = json["cityName"] as? String else { throw ParseError.notFound(key: "cityName")}
        self.cityZipcode = cityZipcode
        self.cityName = cityName
    }
    
    static func create(with json:JSONDictionary) -> availableCity?{
        do{
           return try availableCity(with: json)
        }catch{
           print("availableCity json parse error:\(error)")
        return nil
        }
    }
}

extension OrderLocationModel{
    
    static func GetWithCoordinate(lon:Double,lat:Double,completion:@escaping (NetWorkResult<OrderLocationModel>) -> Void){
        
        let parse:(JSONDictionary) -> OrderLocationModel? = { json in
            let model = OrderLocationModel.create(with: json)
            return model
        }
        let requestParameters:[String:Any] = [
            "type":1,
            "lon":lon,
            "lat":lat
        ]
        let netResource = NetResource(baseURL: BaseType.PortalAddress.URI,
                                      path: "/Location/GetMyLocation",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)

    }
}

