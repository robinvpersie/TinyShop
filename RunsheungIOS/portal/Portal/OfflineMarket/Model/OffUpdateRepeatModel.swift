//
//  OffUpdateRepeatModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

struct OffUpdateRepeatModel {
    
    static func updateRepeatPayStatus(tickets:String,completion:@escaping (NetWorkResult<JSONDictionary>)->Void){
        
        let parse:(JSONDictionary) -> JSONDictionary = { data in
            return data
        }
        let requestParameters:[String:Any] = [
            "tickets":tickets,
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let netResource = NetResource(baseURL: BaseType.superMarket.URI,
                                      path: "/freshmart/OfflineShopping/UpdateRepeatPayStatus",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
        
    }

}
