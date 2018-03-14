//
//  OffCartOrderModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct errorDataModel {
    let itemCode:String
    let stockQuantity:String
    
    init(json:JSON){
        self.itemCode = json["itemCode"].stringValue
        self.stockQuantity = json["stockQuantity"].stringValue
    }
    
    static func geterrorData(json:JSON) -> [errorDataModel] {
        var errorDatas:[errorDataModel] = []
        if let messageParam = json["messageParam"].dictionary,
            let errorDataArray = messageParam["errorData"] {
            errorDataArray.forEach({ (data) in
                let newjson = JSON(data)
                let newdata = errorDataModel(json: newjson)
                errorDatas.append(newdata)
            })
        }
        return errorDatas
    }
}

struct OffCartOrderModel {
    
    var amount:Float
    var order_code:String
    
    init(json:JSON){
        self.amount = json["amount"].floatValue
        self.order_code = json["order_code"].string ?? ""
    }
    
    static func CreateOfflineCartsOrder(tickets:String,completion:@escaping (NetWorkResult<JSONDictionary>) -> Void){
        let parse:(JSONDictionary) -> JSONDictionary? = { data in
            return data
        }
        let requestParameters:[String:Any] = [
            "tickets":tickets,
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let resource = NetResource(baseURL: BaseType.superMarket.URI,
                                     path: "/freshmart/OfflineShopping/CreateOfflineCartsOrder",
                                     method: .post,
                                     parameters: requestParameters,
                                     parse: parse)
        YCProvider.requestDecoded(resource, completion: completion)
        
    }
}
