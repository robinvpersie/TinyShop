//
//  OffShopCarDeleteModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

struct OffShopCarDeleteModel {
    
    static func deleteOfflineCarts(tickets ticket:String,
                                   cartOfDetailld:Int,
                                   completion:@escaping(NetWorkResult<JSONDictionary>)->Void){
        let parse:(JSONDictionary) -> JSONDictionary = { data in
            return data
        }
        let requestParameters:[String:Any] = [
            "tickets":ticket,
            "cartOfDetailId":cartOfDetailld,
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let netResource = NetResource(baseURL: BaseType.superMarket.URI,
                                      path: "/freshmart/OfflineShopping/DeleteOfflineCarts",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
    
}
