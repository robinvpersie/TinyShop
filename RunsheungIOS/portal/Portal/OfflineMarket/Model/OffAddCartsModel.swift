//
//  OffAddCartsModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OffAddCartsModel {
    
    let status:Int?
    let message:String?
    
    init(json:JSON) {
        self.status = json["status"].int
        self.message = json["message"].string
    }
    
    static func addOfflineCarts(tickets:String,barCodeString:String,completion:@escaping (NetWorkResult<OffAddCartsModel>)->Void){
        let parse:(JSONDictionary) -> OffAddCartsModel = { data in
            let json = JSON(data)
            return OffAddCartsModel(json: json)
        }
        let requestParameters:[String:Any] = [
            "tickets":tickets,
            "barCodeStr":barCodeString,
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let netResource = NetResource(baseURL: BaseType.superMarket.URI,
                                      path: "/freshmart/OfflineShopping/AddOfflineCarts",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
        
    }
}
