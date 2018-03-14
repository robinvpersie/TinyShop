//
//  OrderConfirmModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/22.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct Orderitemlis {
    let amount: Double
    let itemCode: String
    let itemName: String
    let quantity: Int
    init(with json: JSONDictionary) throws {
        guard let amount = json["amount"] as? Double else {
            throw ParseError.notFound(key: "amount")
        }
        guard let itemCode = json["itemCode"] as? String else {
            throw ParseError.notFound(key: "itemCode")
        }
        guard let itemName = json["itemName"] as? String else {
            throw ParseError.notFound(key: "itemName")
        }
        guard let quantity = json["quantity"] as? Int else {
            throw ParseError.notFound(key: "quantity")
        }
        self.amount = amount
        self.itemCode = itemCode
        self.itemName = itemName
        self.quantity = quantity
    }
    static func create(with json: JSONDictionary) -> Orderitemlis? {
        do {
            return try Orderitemlis(with: json)
        } catch {
            print("Orderitemlis json parse error: \(error)")
            return nil
        }
    }
}



struct OrderConfirmModel {
    let address: String
    let orderItemList: [Orderitemlis]
    let orderNum: String
    let personCnt: String
    let phone: String?
    let reserveDate: String
    let restaurantCode: String
    let restaurantName: String
    let shopThumImage: URL
    let totalAmount: String
    let actualOrderAmount:String?
    let point:String
    let canConsumePoint:String
    let ver: String
    let payer:String?
    
    init(with json: JSONDictionary) throws {
        self.actualOrderAmount = json["actualOrderAmount"] as? String
        guard let point = json["point"] as? String else {
            throw ParseError.notFound(key: "point")
        }
        guard let canconsumepoint = json["canConsumePoint"] as? String else {
            throw ParseError.notFound(key: "canComsumePoint")
        }
        guard let address = json["address"] as? String else {
            throw ParseError.notFound(key: "address")
        }
        guard let orderItemListJSONArray = json["orderItemList"] as? [JSONDictionary] else {
            throw ParseError.notFound(key: "orderItemList")
        }
        let orderItemList = orderItemListJSONArray.map({ Orderitemlis.create(with: $0) }).flatMap({ $0 })
        guard let orderNum = json["orderNum"] as? String else {
            throw ParseError.notFound(key: "orderNum")
        }
        guard let personCnt = json["personCnt"] as? String else {
            throw ParseError.notFound(key: "personCnt")
        }
        guard let reserveDate = json["reserveDate"] as? String else {
            throw ParseError.notFound(key: "reserveDate")
        }
        guard let restaurantCode = json["restaurantCode"] as? String else {
            throw ParseError.notFound(key: "restaurantCode")
        }
        guard let restaurantName = json["restaurantName"] as? String else {
            throw ParseError.notFound(key: "restaurantName")
        }
        guard let shopThumImageString = json["shopThumImage"] as? String else {
            throw ParseError.notFound(key: "shopThumImage")
        }
        guard let shopThumImage = URL(string: shopThumImageString) else {
            throw ParseError.failedToGenerate(property: "shopThumImage")
        }
        guard let totalAmount = json["totalAmount"] as? String else {
            throw ParseError.notFound(key: "totalAmount") }
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver")
        }
        self.payer = json["payer"] as? String
        self.phone = json["phone"] as? String
        self.address = address
        self.orderItemList = orderItemList
        self.orderNum = orderNum
        self.personCnt = personCnt
        self.reserveDate = reserveDate
        self.restaurantCode = restaurantCode
        self.restaurantName = restaurantName
        self.shopThumImage = shopThumImage
        self.totalAmount = totalAmount
        self.ver = ver
        self.point = point
        self.canConsumePoint = canconsumepoint
    }
    static func create(with json: JSONDictionary) -> OrderConfirmModel? {
        do {
            return try OrderConfirmModel(with: json)
        } catch {
            print("OrderConfirmModel json parse error: \(error)")
            return nil
        }
    }
}


struct confirmModel {
    var data:OrderConfirmModel?
    let status:Int
    init?(with json:JSONDictionary) throws {
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        if let dataDic = json["data"] as? JSONDictionary {
           self.data = OrderConfirmModel.create(with: dataDic)
        }
        self.status = status
     }
    
    static func create(with json:JSONDictionary) -> confirmModel? {
        do{
          return try confirmModel(with: json)
        }catch {
          return nil
        }
    }
    
}


extension confirmModel{
    
    static func GetWithOrderNum(_ orderNum:String,
                                completion:@escaping (NetWorkResult<confirmModel>) -> Void)
    {
        let parse:(JSONDictionary) -> confirmModel? = { json in
            let model = confirmModel.create(with:json)
            return model
        }
        guard let account = YCAccountModel.getAccount() else {
            return
        }
        let requestParameter:[String:Any] = [
           "memberID":account.memid!,
           "orderNum":orderNum,
           "token":account.token!
        ]
        
        let netResource = NetResource(baseURL: BaseType.canteen.URI,
                                      path: "/GetOrderInfo",
                                      method: .post,
                                      parameters: requestParameter,
                                      parameterEncoding: URLEncoding(destination: .queryString) ,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)


    }
    


}


/// 删除订单
///
/// - Parameters:
///   - reserveId:
///   - cancelCode:
///   - cancelReason:
///   - failureHandler:
///   - completion:
public func DeleteOrderWithReserveId(_ reserveId:String,
                                     cancelCode:String,
                                     cancelReason:String,
                                     token:String,
                                     memid:String,
                                     failureHandler:FailureHandler?,
                                     completion:@escaping (JSONDictionary?) -> Void)
{
    let parse:(JSONDictionary) -> JSONDictionary = { json in
        return json
    }
    guard let account = YCAccountModel.getAccount() else { return }
    let requestParameter:[String:Any] = [
       "reserveID":reserveId,
       "userId":memid,
       "token":token,
       "cancelCode":cancelCode,
       "cancelReason":cancelReason
    ]
    let resource = AlmofireResource(
        Type: .canteen,
        path:canteenSetCancelReserveKey,
        method: .post,
        requestParameters: requestParameter,
        urlEncoding:URLEncoding(destination: .queryString),
        parse: parse
    )
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
}


public func AddPaymentAdvanceWithhPayType(_  paytype:String,
                                          authno:String,
                                          point:String,
                                          orderNum:String,
                                          orderAmount:String,
                                          memid:String,
                                          token:String,
                                          failureHandler:FailureHandler?,
                                          completion:@escaping (JSONDictionary?) -> Void)
{
    
    let parse:(JSONDictionary) -> JSONDictionary = { json in
        return json
    }
    let requestParameters:[String:Any] = [
        "memberID":memid,
        "payType":paytype,
        "orderNum":orderNum,
        "orderAmount":orderAmount,
        "token":token,
        "point":point,
        "wsPayAuthNo":authno
        ]
    let resource = AlmofireResource(
        Type: .canteen,
        path: canteenAddPaymentAdvanceKey,
        method: .post, requestParameters:requestParameters,
        urlEncoding: URLEncoding(destination: .queryString),
        parse: parse
    )
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
}









