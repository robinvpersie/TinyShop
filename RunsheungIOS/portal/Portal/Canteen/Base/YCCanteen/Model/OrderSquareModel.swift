//
//  OrderSquareModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation


struct Squarelis {
    let divCode: String
    let divName: String
    let lat: String
    let lon: String
    let zipCode: String
    init(with json: JSONDictionary) throws {
        guard let divCode = json["divCode"] as? String else { throw ParseError.notFound(key: "divCode") }
        guard let divName = json["divName"] as? String else { throw ParseError.notFound(key: "divName") }
        guard let lat = json["lat"] as? String else { throw ParseError.notFound(key: "lat") }
        guard let lon = json["lon"] as? String else { throw ParseError.notFound(key: "lon") }
        guard let zipCode = json["zipCode"] as? String else { throw ParseError.notFound(key: "zipCode") }
        self.divCode = divCode
        self.divName = divName
        self.lat = lat
        self.lon = lon
        self.zipCode = zipCode
    }
    static func create(with json: JSONDictionary) -> Squarelis? {
        do {
            return try Squarelis(with: json)
        } catch {
            print("Squarelis json parse error: \(error)")
            return nil
        }
    }
}


struct Areaandsquar {
    let areaName: String
    let squareList: [Squarelis]?
    let zipCode: String
    init(with json: JSONDictionary) throws {
        guard let areaName = json["areaName"] as? String else { throw ParseError.notFound(key: "areaName") }
        guard let zipCode = json["zipCode"] as? String else { throw ParseError.notFound(key: "zipCode") }
        if let squareListArray = json["squareList"] as? [JSONDictionary] {
            let squareList = squareListArray.map({ Squarelis.create(with: $0)}).flatMap({ $0 })
            self.squareList = squareList
        }else {
           self.squareList = nil
        }
        self.areaName = areaName
        self.zipCode = zipCode
    }
    static func create(with json: JSONDictionary) -> Areaandsquar? {
        do {
            return try Areaandsquar(with: json)
        } catch {
            print("Areaandsquar json parse error: \(error)")
            return nil
        }
    }
}


struct OrderSquareModel {
    let areaAndSquare: [Areaandsquar]
    init(with json: JSONDictionary) throws {
        guard let areaAndSquareJSONArray = json["areaAndSquare"] as? [JSONDictionary] else { throw ParseError.notFound(key: "areaAndSquare") }
        let areaAndSquare = areaAndSquareJSONArray.map({ Areaandsquar.create(with: $0) }).flatMap({ $0 })
        self.areaAndSquare = areaAndSquare
    }
    static func create(with json: JSONDictionary) -> OrderSquareModel? {
        do {
            return try  OrderSquareModel(with: json)
        } catch {
            print(" OrderSquareModel json parse error: \(error)")
            return nil
        }
    }
}

extension OrderSquareModel{
   
    static func GetWithZipCode(_ code:String,cityName name:String,failureHandler:FailureHandler?,completion:@escaping (OrderSquareModel?) -> Void){
       
        let parse:(JSONDictionary) -> OrderSquareModel? = { json in
            let model = OrderSquareModel.create(with: json)
            return model
        }
        let resource = AlmofireResource(Type: .PortalAddress, path: canteenSquareKey, method: .post, requestParameters: ["zipcode":code,"cityName":name], parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

        
    }

}
