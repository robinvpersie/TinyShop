//
//  OffShopIdModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

struct OffShopIdModel {
    
    static func createShopCar(tickets:String,completion:@escaping (NetWorkResult<JSONDictionary>)->Void){
        let parse:(JSONDictionary) -> JSONDictionary? = { data in
             return data
        }
        let netResource = NetResource(baseURL: BaseType.superMarket.URI,
                                      path: "/freshmart/OfflineShopping/CreatedShopCart",
                                      method: .post,
                                      parameters: nil,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
    
}
