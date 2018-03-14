//
//  OffGetTicketModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TicketsInfo {
    
    var tickets:String
    
    init(json:JSON){
        tickets = json["tickets"].stringValue
    }
    
}

struct OffGetTicketModel {
    
    var status:Int
    var ticketsInfo:TicketsInfo?
    var msg:String?
    
    init(json:JSON){
        status = json["status"].intValue
        ticketsInfo = TicketsInfo(json:json["ticketsInfo"])
        msg = json["message"].string
    }
    
    static func GetTickets(token:String,completion:@escaping (NetWorkResult<OffGetTicketModel>)->Void){
        let parse:(JSONDictionary) -> OffGetTicketModel? = { data in
            let json = JSON(data)
            return OffGetTicketModel(json: json)
        }
        let requestParameters:[String:Any] = [
            "token":YCAccountModel.getAccount()?.token ?? ""
        ]
        let netResource = NetResource(baseURL: BaseType.superMarket.URI,
                                      path: "/freshmart/OfflineShopping/GetTickets",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
        
    }
    
}
