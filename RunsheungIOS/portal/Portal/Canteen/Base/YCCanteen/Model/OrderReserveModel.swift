//
//  OrderReserveModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/23.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

extension OrderReserve{
    
    static func GetWithReserveID(_ reserveId:String,
                                 orderNum:String = "",
                                 reserveStatus:String,
                                 memid:String,
                                 token:String,
                                 failureHandler:FailureHandler?,
                                 completion:@escaping (OrderReserve?) -> Void){
        
        let parse:(JSONDictionary) -> OrderReserve? = { json in
            let model = OrderReserve.create(with: json)
            return model
        }
        let requestParameter:[String:Any] = [
           "memberID":memid,
           "orderNum":orderNum,
           "reserveID":reserveId,
           "reserveStatus":reserveStatus,
           "token":token
        ]
        let resource = AlmofireResource(Type: .canteen, path:canteenGetReserveKey, method: .post, requestParameters: requestParameter, urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

        
    }
}


struct OrderReserve{
    
    var data:OrderReserveModel?
    let status:Int
    init?(with json:JSONDictionary) throws {
        if let datadic = json["data"] as? JSONDictionary {
           self.data = OrderReserveModel.create(with: datadic)
        }
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status")}
        self.status = status
    }
    
    static func create(with json:JSONDictionary) -> OrderReserve? {
        do {
          return try OrderReserve(with: json)
        }catch {
          return nil
        }
    }
}

struct ReserveMen {
    let amount:Int
    let itemCode:String
    let itemName:String
    let quantity:Int
    
    init?(with json: JSONDictionary) throws {
        guard let amount = json["amount"] as? Int else { throw ParseError.notFound(key: "amount") }
        guard let itemCode = json["itemCode"] as? String else { throw ParseError.notFound(key: "itemCode")}
        guard let itemName = json["itemName"] as? String else { throw ParseError.notFound(key: "itemName")}
        guard let quantity = json["quantity"] as? Int else { throw ParseError.notFound(key: "quantity")}
        self.amount = amount
        self.itemName = itemName
        self.itemCode = itemCode
        self.quantity = quantity
    }
    
    static func create(with json: JSONDictionary) -> ReserveMen? {
        do {
            return try ReserveMen(with: json)
        } catch {
            print("ReserveMen json parse error: \(error)")
            return nil
        }
    }
}


struct GroupList {
    
    let iconImg:String
    let memberID:String
    let nickName:String
    
    init?(with json:JSONDictionary) throws {
        guard let iconImg = json["iconImg"] as? String else { throw ParseError.notFound(key: "iconImg") }
        guard let memberID = json["memberID"] as? String else { throw ParseError.notFound(key: "memberID") }
        guard let nickName = json["nickName"] as? String else { throw ParseError.notFound(key: "nickName") }
        self.iconImg = iconImg
        self.memberID = memberID
        self.nickName = nickName
    }
    
    static func create(_ json:JSONDictionary) -> GroupList? {
        do{
           return try GroupList(with: json)
        }catch {
           return nil
        }
    }
    
    
}


struct OrderReserveModel {
    var address: String?
    let averagePay: String
    let averageRate: String?
    let couponAmount: Int
    let couponName: String
    let date: String
    let distance: String
    let floor: String
    let menu: [ReserveMen]
    var name: String?
    let payType: String
    let personCnt: String
    let phone: String?
    let pointAmount: Int
    let remainingTime: Int
    let reserveDate: String
    let reserveId: String
    let reserveStatus: String
    let restaurantCode: String
    let restaurantName: String
    let shopThumImage: URL
    var groupId:String?
    var groupList:[GroupList]?
    var groupYN:String?
    let totalAmount: Float
    let actualTotalAmount:Float
    let ver: String
    init(with json: JSONDictionary) throws {
        
        guard let averagePay = json["averagePay"] as? String else { throw ParseError.notFound(key: "averagePay")}
        self.address = json["address"] as? String
        self.groupId = json["groupId"] as? String
        if let groupListArray = json["groupList"] as? [JSONDictionary] {
            let groupList:[GroupList] = groupListArray.map({
                return  GroupList.create($0)!
            })
            self.groupList = groupList
        }
        self.groupYN = json["groupYN"] as? String
        self.averageRate = json["averageRate"] as? String
        guard let couponAmount = json["couponAmount"] as? Int else { throw ParseError.notFound(key: "couponAmount") }
        guard let couponName = json["couponName"] as? String else { throw ParseError.notFound(key: "couponName") }
        guard let date = json["date"] as? String else { throw ParseError.notFound(key: "date") }
        guard let distance = json["distance"] as? String else { throw ParseError.notFound(key: "distance") }
        guard let floor = json["floor"] as? String else { throw ParseError.notFound(key: "floor") }
        guard let menuJSONArray = json["menu"] as? [JSONDictionary] else { throw ParseError.notFound(key: "menu") }
        let menu = menuJSONArray.map({ ReserveMen.create(with: $0) }).flatMap({ $0 })
        self.name = json["name"] as? String
        guard let payType = json["payType"] as? String else { throw ParseError.notFound(key: "payType") }
        guard let personCnt = json["personCnt"] as? String else { throw ParseError.notFound(key: "personCnt") }
        guard let pointAmount = json["pointAmount"] as? Int else { throw ParseError.notFound(key: "pointAmount") }
        guard let remainingTime = json["remainingTime"] as? Int else { throw ParseError.notFound(key: "remainingTime") }
        guard let reserveDate = json["reserveDate"] as? String else { throw ParseError.notFound(key: "reserveDate") }
        guard let reserveId = json["reserveId"] as? String else { throw ParseError.notFound(key: "reserveId") }
        guard let reserveStatus = json["reserveStatus"] as? String else { throw ParseError.notFound(key: "reserveStatus") }
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode") }
        guard let restaurantName = json["restaurantName"] as? String else { throw ParseError.notFound(key: "restaurantName") }
        guard let shopThumImageString = json["shopThumImage"] as? String else { throw ParseError.notFound(key: "shopThumImage") }
        guard let shopThumImage = URL(string: shopThumImageString) else { throw ParseError.failedToGenerate(property: "shopThumImage") }
        guard let totalAmount = json["totalAmount"] as? Float else { throw ParseError.notFound(key: "totalAmount") }
        guard let actualTotalAmount = json["actualTotalAmount"] as? Float else { throw ParseError.notFound(key: "acturalTotalAmount")}
        guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.phone = json["phone"] as? String
        self.actualTotalAmount = actualTotalAmount
        self.averagePay = averagePay
        self.couponAmount = couponAmount
        self.couponName = couponName
        self.date = date
        self.distance = distance
        self.floor = floor
        self.menu = menu
        self.payType = payType
        self.personCnt = personCnt
        self.pointAmount = pointAmount
        self.remainingTime = remainingTime
        self.reserveDate = reserveDate
        self.reserveId = reserveId
        self.reserveStatus = reserveStatus
        self.restaurantCode = restaurantCode
        self.restaurantName = restaurantName
        self.shopThumImage = shopThumImage
        self.totalAmount = totalAmount
        self.ver = ver
    }
    static func create(with json: JSONDictionary) -> OrderReserveModel? {
        do {
            return try OrderReserveModel(with: json)
        } catch {
            print("OrderReserveModel json parse error: \(error)")
            return nil
        }
    }
}

