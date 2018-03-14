//
//  OffCheckTicketModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OffCheckTicketModel {
    
    static func checkTicket(ticket:String,completion:@escaping(TokenResult<JSON>) -> Void){
            let parse:(JSONDictionary) -> JSON = {data in
                return JSON(data)
            }
            let requestParameters:JSONDictionary = [
                "tickets":ticket,
                "token":YCAccountModel.getAccount()?.token ?? ""
            ]
            let netResource = tokenResource(baseURL: BaseType.superMarket.URI,
                                          path: "/freshmart/OfflineShopping/CheckTicketsInfo",
                                          method: .post,
                                          parameters: requestParameters,
                                          parse: parse)
           netResource.requestApi(completion: completion)
       }
}
