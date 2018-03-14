//
//  OffShopCarModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class OffShopCarModel {
    let cartOfDetailId: Int
    let code: String
    let name: String?
    var price: Double
    var quantity: Int
    var unitPrice:String?
    var stockQuantity:String?
    var unitQuantity:String?
    var imgUrl:URL?
    var isEmptyStock:Bool = false 
    init(with json: JSONDictionary) throws {
        guard let cartOfDetailId = json["cartOfDetailId"] as? Int else { throw ParseError.notFound(key: "cartOfDetailId") }
        guard let code = json["code"] as? String else { throw ParseError.notFound(key: "code") }
        let name = json["name"] as? String
        guard let price = json["price"] as? Double else { throw ParseError.notFound(key: "price") }
        guard let quantity = json["quantity"] as? Int else { throw ParseError.notFound(key: "quantity") }
        if let imgeurlString = json["imgUrl"] as? String {
            self.imgUrl = URL(string: imgeurlString) 
        }
        self.unitQuantity = json["unitQuantity"] as? String
        self.stockQuantity = json["stockQuantity"] as? String
        self.unitPrice = json["unitPrice"] as? String
        self.cartOfDetailId = cartOfDetailId
        self.code = code
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    static func create(with json: JSONDictionary) -> OffShopCarModel? {
        do {
            return try OffShopCarModel(with: json)
        } catch {
            print("OffShopCarModel json parse error: \(error)")
            return nil
        }
    }
}


struct OffShopCarTotalModel {
    var data: [OffShopCarModel] = []
    let status: Int
    let msg:String?
    init(with json: JSONDictionary) throws {
        if let dataJSONArray = json["data"] as? [JSONDictionary] {
          self.data = dataJSONArray.map({ OffShopCarModel.create(with: $0) }).flatMap({ $0 })
        }
        self.status = json["status"] as! Int
        self.msg = json["message"] as? String
    }
    static func create(with json: JSONDictionary) ->  OffShopCarTotalModel? {
        do {
            return try OffShopCarTotalModel(with: json)
        } catch {
            return nil
        }
    }
    
    static func GetOfflineCartsList(with ticket:String,completion:@escaping (NetWorkResult<OffShopCarTotalModel>)->Void){
        let parse:(JSONDictionary) -> OffShopCarTotalModel? = { data in
            let json = OffShopCarTotalModel.create(with: data)
            return json
        }
        let requestParameters:JSONDictionary = [
            "tickets":ticket,
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let resource = NetResource(baseURL: BaseType.superMarket.URI,
                                   path: "/freshmart/OfflineShopping/GetOfflineCartsList",
                                   method: .post,
                                   parameters: requestParameters,
                                   parse: parse)
        YCProvider.requestDecoded(resource, completion: completion)
    }

    
}


