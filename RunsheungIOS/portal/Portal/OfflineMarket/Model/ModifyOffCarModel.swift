//
//  ModifyOffCarModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ModifyOffCarModel {
    var status:Int?
    var message:String?
    
    init (json:JSON){
       self.status = json["status"].int
       self.message = json["message"].string
    }
    
    static func ModifyOfflineCarts(tickets:String,cartOfDetailld:Int,quantity:Int,completion:@escaping ((NetWorkResult<ModifyOffCarModel>) -> Void)){
        
        let parse:(JSONDictionary) -> ModifyOffCarModel? = { data in
            let json = JSON(data)
            return ModifyOffCarModel(json: json)
        }
        let requestParameters:[String:Any] = [
            "tickets":tickets,
            "cartOfDetailId":cartOfDetailld,
            "quantity":quantity,
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let netResource = NetResource(baseURL: BaseType.superMarket.URI,
                                      path: "/freshmart/OfflineShopping/ModifyOfflineCarts",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }

}
