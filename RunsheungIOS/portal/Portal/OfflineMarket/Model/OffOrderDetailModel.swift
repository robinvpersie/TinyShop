//
//  OffOrderDetailModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

public struct OffOrderDetailModel {
    
        let flag: String
        let msg: String
        var custominoutstatus:String?
         public class Orderdetai {
            let itemCode: String
            let itemImage: String
            let itemName: String
            let orderNum: String
            let orderO: String
            let orderP: String
            let orderQ: String
            var refundStatus: String?
            var isNeedDelete:Bool = false
            var canDelete:Bool = false
            let serNo: String
            var str300t_refund_status:String?
            var sof110t_refund_status:String?
            init(with json: JSONDictionary) throws {
                guard let itemCode = json["item_code"] as? String else { throw ParseError.notFound(key: "item_code") }
                guard let itemImage = json["item_image"] as? String else { throw ParseError.notFound(key: "item_image") }
                guard let itemName = json["item_name"] as? String else { throw ParseError.notFound(key: "item_name") }
                guard let orderNum = json["order_num"] as? String else { throw ParseError.notFound(key: "order_num") }
                guard let orderO = json["order_o"] as? String else { throw ParseError.notFound(key: "order_o") }
                guard let orderP = json["order_p"] as? String else { throw ParseError.notFound(key: "order_p") }
                guard let orderQ = json["order_q"] as? String else { throw ParseError.notFound(key: "order_q") }
                self.refundStatus = json["refund_status"] as? String
                let str300 = json["str300t_refund_status"] as? String
                let str100 = json["sof110t_refund_status"] as? String
                if (str300 == "CR" || str100 == "5") {
                    self.canDelete = false
                }else {
                    self.canDelete = true
                }
                guard let serNo = json["ser_no"] as? String else { throw ParseError.notFound(key: "ser_no") }
                self.itemCode = itemCode
                self.itemImage = itemImage
                self.itemName = itemName
                self.orderNum = orderNum
                self.orderO = orderO
                self.orderP = orderP
                self.orderQ = orderQ
                self.serNo = serNo
                self.str300t_refund_status = str300
                self.sof110t_refund_status = str100
            }
            static func create(with json: JSONDictionary) -> Orderdetai? {
                do {
                    return try Orderdetai(with: json)
                } catch {
                    print("Orderdetai json parse error: \(error)")
                    return nil
                }
            }
        }
        let orderDetail: [Orderdetai]
        let status: String
        var custom_refund_status:String?
        init(with json: JSONDictionary) throws {
            guard let flag = json["flag"] as? String else { throw ParseError.notFound(key: "flag") }
            guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
            guard let orderDetailJSONArray = json["orderDetail"] as? [JSONDictionary] else { throw ParseError.notFound(key: "orderDetail") }
            let orderDetail = orderDetailJSONArray.map({ Orderdetai.create(with: $0) }).flatMap({ $0 })
            guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
            self.custominoutstatus = json["custom_inout_status"] as? String 
            self.custom_refund_status = json["custom_inout_status"] as? String
            self.flag = flag
            self.msg = msg
            self.orderDetail = orderDetail
            self.status = status
        }
        static func create(with json: JSONDictionary) ->  OffOrderDetailModel? {
            do {
                return try  OffOrderDetailModel(with: json)
            } catch {
                print(" OffOrderDetailModel json parse error: \(error)")
                return nil
            }
        }
    

    
    static func requestOrderDetail(orderNum:String?,cottype:OffOrderDetailController.controllerType,completion:@escaping (NetWorkResult<OffOrderDetailModel>)->Void){
        let parse:(JSONDictionary) -> OffOrderDetailModel? = { OffOrderDetailModel.create(with: $0) }
        let requestParameters:[String:Any] = [
            "lang_type":"2",
            "order_num":orderNum ?? "",
            "custom_code":YCAccountModel.getAccount()?.memid ?? ""
        ]
        var path:String!
        switch cottype {
        case .noServiceMarket:
            path = "/api/apiOrder/requestOrderDetail"
        case .eatAndDrink:
            path = "/api/apiOrder/requestFoodOrderDetail"
        }
        let netResource = NetResource(baseURL: BaseType.off.URI,
                                      path: path,
                                      method:.post ,
                                      parameters: requestParameters,
                                      parameterEncoding: JSONEncoding(),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
    
    
    
}
