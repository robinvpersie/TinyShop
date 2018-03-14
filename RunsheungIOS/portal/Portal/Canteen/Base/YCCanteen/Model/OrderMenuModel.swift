//
//  OrderMenuModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct Menulis {
    let groupCode: String
    let groupName: String
    let imageURL: URL
    let itemAmount: Float
    let itemCode: String
    let itemName: String
    let moneyUnit: String
    let spec: String
    let ver: String
    var count = 0 
    init(with json: JSONDictionary) throws {
        guard let groupCode = json["groupCode"] as? String else { throw ParseError.notFound(key: "groupCode") }
        guard let groupName = json["groupName"] as? String else { throw ParseError.notFound(key: "groupName") }
        guard let imageURLString = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
        guard let imageURL = URL(string: imageURLString) else { throw ParseError.failedToGenerate(property: "imgurL") }
        guard let itemAmount = json["itemAmount"] as? Float else { throw ParseError.notFound(key: "itemAmount") }
        guard let itemCode = json["itemCode"] as? String else { throw ParseError.notFound(key: "itemCode") }
        guard let itemName = json["itemName"] as? String else { throw ParseError.notFound(key: "itemName") }
        guard let moneyUnit = json["moneyUnit"] as? String else { throw ParseError.notFound(key: "moneyUnit") }
        guard let spec = json["spec"] as? String else { throw ParseError.notFound(key: "spec") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.groupCode = groupCode
        self.groupName = groupName
        self.imageURL = imageURL
        self.itemAmount = itemAmount
        self.itemCode = itemCode
        self.itemName = itemName
        self.moneyUnit = moneyUnit
        self.spec = spec
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> Menulis? {
        do {
            return try Menulis(with: json)
        } catch {
            print("Menulis json parse error: \(error)")
            return nil
        }
    }
}


struct OrderMenuModel {
    var MenuList: [Menulis]
    let groupCode: String
    let groupName: String
    init(with json: JSONDictionary) throws {
        guard let MenuListJSONArray = json["MenuList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "MenuList") }
        let MenuList = MenuListJSONArray.map({ Menulis.create(with: $0) }).flatMap({ $0 })
        guard let groupCode = json["groupCode"] as? String else { throw ParseError.notFound(key: "groupCode") }
        guard let groupName = json["groupName"] as? String else { throw ParseError.notFound(key: "groupName") }
        self.MenuList = MenuList
        self.groupCode = groupCode
        self.groupName = groupName
    }
    static func create(with json: JSONDictionary) -> OrderMenuModel? {
        do {
            return try OrderMenuModel(with: json)
        } catch {
            print("OrderMenuModel json parse error: \(error)")
            return nil
        }
    }
}






/// check is belong the same model ,big use 
public struct compareMenuModel:Equatable {
    
    var menulis:selectMenulis
    let itemCode:String
    
    init(itemCode code:String,menu menulis:selectMenulis){
       self.menulis = menulis
       self.itemCode = code
    }
    
    public static func ==(lhs:compareMenuModel,rhs:compareMenuModel) -> Bool{
        if lhs.itemCode == rhs.itemCode {
            return true
        }else {
            return false
        }
    }
}

public struct selectMenulis {
    
    let itemCode:String
    let itemAmount:Float
    let itemName:String
    
}







extension OrderMenuModel {
    
    static func GetWithRestaurantCode(_ restaurantCode:String,failureHandler:FailureHandler?,completion:@escaping ([OrderMenuModel]?) -> Void){
        
        let parse:(JSONDictionary) -> [OrderMenuModel]? = { json in
            guard let data = json["data"] as? JSONDictionary else { return nil }
            guard let menu = data["Menu"] as? [JSONDictionary] else { return nil}
            let modelArray = menu.map({ OrderMenuModel.create(with:$0)}).flatMap({ $0 })
            return modelArray
        }
        let resource = AlmofireResource(Type: .canteen, path:canteenRestaurantMenuListKey, method: .post, requestParameters: ["customCode":restaurantCode], urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

    }
}


public func OrderAddReserve(restaurantCode:String,userId:String,reserveDate:String,personCount:Int,userName:String,phoneNumber:String,roomUse:Int,description:String?,token:String,groupYN:String? = nil,failureHandler:FailureHandler?,completion:@escaping(JSONDictionary?) -> Void){
    
    let parse:(JSONDictionary) -> JSONDictionary = { json in
       return json
    }
    var requestParameters:[String:Any] = [
       "saleCustomCode":restaurantCode,
       "customCode":userId,
       "reserveDate":reserveDate,
       "personCount":personCount,
       "userName":userName,
       "phoneNumber":phoneNumber,
       "roomUse":roomUse,
       "description":description ?? "",
       "token":token
    ]
    if let groupYN = groupYN {
       requestParameters["groupYN"] = groupYN
    }
    let resource = AlmofireResource(Type: .canteen, path:canteenAddReserveKey, method: .post, requestParameters: requestParameters, urlEncoding:URLEncoding(destination: .queryString),parse: parse)
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)


    
}




