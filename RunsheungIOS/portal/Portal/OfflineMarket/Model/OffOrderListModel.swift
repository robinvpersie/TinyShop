//
//  OffOrderListModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

public struct OffOrderListModel {
    
        let CurrentPage: Int
        let NextPage: Int
        let flag: String
        let msg: String
    
        public struct Orderlis {
            let couponsAmount: String
            let customId: String
            let itemNameCnt: String
            let onlineOrderStatus: String
            let orderDate: String
            let orderNum: String
            let orderO: String
            let paymentComplete: String
            let pointAmount: String
            let realAmount: String
            let rnum: String
            init(with json: JSONDictionary) throws {
                guard let couponsAmount = json["coupons_amount"] as? String else { throw ParseError.notFound(key: "coupons_amount") }
                guard let customId = json["custom_id"] as? String else { throw ParseError.notFound(key: "custom_id") }
                guard let itemNameCnt = json["item_name_cnt"] as? String else { throw ParseError.notFound(key: "item_name_cnt") }
                guard let onlineOrderStatus = json["online_order_status"] as? String else { throw ParseError.notFound(key: "online_order_status") }
                guard let orderDate = json["order_date"] as? String else { throw ParseError.notFound(key: "order_date") }
                guard let orderNum = json["order_num"] as? String else { throw ParseError.notFound(key: "order_num") }
                guard let orderO = json["order_o"] as? String else { throw ParseError.notFound(key: "order_o") }
                guard let paymentComplete = json["payment_complete"] as? String else { throw ParseError.notFound(key: "payment_complete") }
                guard let pointAmount = json["point_amount"] as? String else { throw ParseError.notFound(key: "point_amount") }
                guard let realAmount = json["real_amount"] as? String else { throw ParseError.notFound(key: "real_amount") }
                guard let rnum = json["rnum"] as? String else { throw ParseError.notFound(key: "rnum") }
                self.couponsAmount = couponsAmount
                self.customId = customId
                self.itemNameCnt = itemNameCnt
                self.onlineOrderStatus = onlineOrderStatus
                self.orderDate = orderDate
                self.orderNum = orderNum
                self.orderO = orderO
                self.paymentComplete = paymentComplete
                self.pointAmount = pointAmount
                self.realAmount = realAmount
                self.rnum = rnum
            }
            static func create(with json: JSONDictionary) -> Orderlis? {
                do {
                    return try Orderlis(with: json)
                } catch {
                    print("Orderlis json parse error: \(error)")
                    return nil
                }
            }
        }
        let orderList: [Orderlis]
        let status: String
        let totCnt: Int
        init(with json: JSONDictionary) throws {
            guard let CurrentPage = json["CurrentPage"] as? Int else { throw ParseError.notFound(key: "CurrentPage") }
            guard let NextPage = json["NextPage"] as? Int else { throw ParseError.notFound(key: "NextPage") }
            guard let flag = json["flag"] as? String else { throw ParseError.notFound(key: "flag") }
            guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
            guard let orderListJSONArray = json["orderList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "orderList") }
            let orderList = orderListJSONArray.map({ Orderlis.create(with: $0) }).flatMap({ $0 })
            guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
            guard let totCnt = json["tot_cnt"] as? Int else { throw ParseError.notFound(key: "tot_cnt") }
            self.CurrentPage = CurrentPage
            self.NextPage = NextPage
            self.flag = flag
            self.msg = msg
            self.orderList = orderList
            self.status = status
            self.totCnt = totCnt
       }
        
        static func create(with json: JSONDictionary) -> OffOrderListModel? {
            do {
                return try OffOrderListModel(with: json)
            } catch {
                print("OffOrderListModel json parse error: \(error)")
                return nil
            }
        }
    

       static func requestOrderList(offset:Int,completion:@escaping (NetWorkResult<OffOrderListModel>)->Void){
          let parse:(JSONDictionary) -> OffOrderListModel? = { OffOrderListModel.create(with: $0) }
          let requestParameters:[String:Any] = [
            "lang_type":"2",
            "custom_code":YCAccountModel.getAccount()?.memid ?? "",
            "CurrentPage":offset,
            "RowCount":"10"
          ]
          let netResource = NetResource(baseURL: BaseType.off.URI,
                                      path: "/api/apiOrder/requestOrderList",
                                      method: .post,
                                      parameters: requestParameters,
                                      parameterEncoding:JSONEncoding(),
                                      parse: parse)
          YCProvider.requestDecoded(netResource, completion: completion)
       }
    
}
