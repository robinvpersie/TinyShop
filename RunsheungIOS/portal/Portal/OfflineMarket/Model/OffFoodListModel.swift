//
//  OffFoodListModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

public struct OffFoodListModel {
    let CurrentPage: Int
    let NextPage: Int
    let flag: String
    public struct Foodorderlis {
        let couponsAmount: String
        let customId: String
        var itemImageUrl: URL?
        let itemNameCnt: String
        let orderDate: String
        let orderNum: String
        let orderO: String
        let orderSeq: String
        let pointAmount: String
        let realAmount: String
        let rnum: String
        init(with json: JSONDictionary) throws {
            guard let couponsAmount = json["coupons_amount"] as? String else { throw ParseError.notFound(key: "coupons_amount") }
            guard let customId = json["custom_id"] as? String else { throw ParseError.notFound(key: "custom_id") }
            if let itemImageUrlString = json["item_image_url"] as? String {
                self.itemImageUrl = URL(string: itemImageUrlString)
            }
            guard let itemNameCnt = json["item_name_cnt"] as? String else { throw ParseError.notFound(key: "item_name_cnt") }
            guard let orderDate = json["order_date"] as? String else { throw ParseError.notFound(key: "order_date") }
            guard let orderNum = json["order_num"] as? String else { throw ParseError.notFound(key: "order_num") }
            guard let orderO = json["order_o"] as? String else { throw ParseError.notFound(key: "order_o") }
            guard let orderSeq = json["order_seq"] as? String else { throw ParseError.notFound(key: "order_seq") }
            guard let pointAmount = json["point_amount"] as? String else { throw ParseError.notFound(key: "point_amount") }
            guard let realAmount = json["real_amount"] as? String else { throw ParseError.notFound(key: "real_amount") }
            guard let rnum = json["rnum"] as? String else { throw ParseError.notFound(key: "rnum") }
            self.couponsAmount = couponsAmount
            self.customId = customId
            self.itemNameCnt = itemNameCnt
            self.orderDate = orderDate
            self.orderNum = orderNum
            self.orderO = orderO
            self.orderSeq = orderSeq
            self.pointAmount = pointAmount
            self.realAmount = realAmount
            self.rnum = rnum
        }
        static func create(with json: JSONDictionary) -> Foodorderlis? {
            do {
                return try Foodorderlis(with: json)
            } catch {
                print("Foodorderlis json parse error: \(error)")
                return nil
            }
        }
    }
    let foodOrderList: [Foodorderlis]
    let msg: String
    let status: String
    let totCnt: Int
    init(with json: JSONDictionary) throws {
        guard let CurrentPage = json["CurrentPage"] as? Int else { throw ParseError.notFound(key: "CurrentPage") }
        guard let NextPage = json["NextPage"] as? Int else { throw ParseError.notFound(key: "NextPage") }
        guard let flag = json["flag"] as? String else { throw ParseError.notFound(key: "flag") }
        guard let foodOrderListJSONArray = json["foodOrderList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "foodOrderList") }
        let foodOrderList = foodOrderListJSONArray.map({ Foodorderlis.create(with: $0) }).flatMap({ $0 })
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
        guard let totCnt = json["tot_cnt"] as? Int else { throw ParseError.notFound(key: "tot_cnt") }
        self.CurrentPage = CurrentPage
        self.NextPage = NextPage
        self.flag = flag
        self.foodOrderList = foodOrderList
        self.msg = msg
        self.status = status
        self.totCnt = totCnt
    }
    static func create(with json: JSONDictionary) -> OffFoodListModel? {
        do {
            return try OffFoodListModel(with: json)
        } catch {
            print("OffFoodListModel json parse error: \(error)")
            return nil
        }
    }
    
    static func requestFoodOrderList(offset:Int,completion:@escaping (NetWorkResult<OffFoodListModel>) -> Void){
        let parse:(JSONDictionary) -> OffFoodListModel? = { OffFoodListModel.create(with:$0) }
        let requestParameters:[String:Any] = [
            "lang_type":"2",
            "custom_code":YCAccountModel.getAccount()?.memid ?? "",
            "CurrentPage":offset,
            "RowCount":10
        ]
        let netResource = NetResource(baseURL: BaseType.off.URI,
                                      path: "/api/apiOrder/requestFoodOrderList",
                                      method: .post,
                                      parameters: requestParameters,
                                      parameterEncoding: JSONEncoding(),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
    
}

