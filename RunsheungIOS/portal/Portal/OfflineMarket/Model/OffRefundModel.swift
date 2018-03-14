//
//  OffRefundModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/12/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire


struct OffRefundModel {
    
    static func requestOrderRefund(inoutStatus:String?,divcode:String,orderNum:String,orderItemRefund:[[String:Any]],completion: @escaping (NetWorkResult<JSONDictionary>)->Void){
        
        let parse:(JSONDictionary) -> JSONDictionary? = { $0 }
        let requestParameters:[String:Any] = [
            "lang_type":"chn",
            "div_code": "divcode",
            "order_num":orderNum,
            "orderItemRefund":orderItemRefund
        ]
        var path:String!
        if inoutStatus == "0" {
           path = "/api/apiOrder/requestOrderItemRefundReceipt"
        }else {
           path = "/api/apiOrder/requestOrderRefund"
        }
        let netresource = NetResource(baseURL: BaseType.off.URI, path: path, method: .post, parameters: requestParameters, parameterEncoding: JSONEncoding(), parse: parse)
        YCProvider.requestDecoded(netresource, completion: completion)
        
    }
 
}
