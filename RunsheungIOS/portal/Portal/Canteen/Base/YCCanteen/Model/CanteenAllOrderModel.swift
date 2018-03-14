//
//  CanteenAllOrderModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire


extension CanteenAll {
    
    static func GetWithMemberId(_ memberId:String,
                                token:String,
                                reserveType:String,
                                currentPage:Int,
                                failureHandler:FailureHandler?,
                                completion:@escaping (CanteenAll?) -> Void){
        
        let parse:(JSONDictionary) -> CanteenAll? = { json in
            print(json)
            let model = CanteenAll.create(with:json)
            return model
        }
        let requestParameters:[String:Any] = [
           "memberID":memberId,
           "reserveType":reserveType,
           "currentPage":currentPage,
           "token":token
        ]
        let resource = AlmofireResource(Type: .canteen,
                                        path:canteenAddReserveListKey,
                                        method: .post,
                                        requestParameters: requestParameters,
                                        urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

    }
}

struct CanteenAll {
    
    var data:CanteenAllOrderModel? = nil
    let status:Int
    
    init?(with json:JSONDictionary) throws {
        if let data = json["data"] as? JSONDictionary {
           self.data = CanteenAllOrderModel.create(with: data)
        }
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        self.status = status
    }
    
    static func create(with json:JSONDictionary) -> CanteenAll? {
        do{
           return try CanteenAll(with: json)
        }catch {
           return nil
        }
    }
    
}


struct CanteenAllOrderModel {
    let currentPage: Int
    let nextPage: Int
    let reserveList: [Reservelis]
    init(with json: JSONDictionary) throws {
        guard let currentPage = json["currentPage"] as? Int else { throw ParseError.notFound(key: "currentPage") }
        guard let nextPage = json["nextPage"] as? Int else { throw ParseError.notFound(key: "nextPage") }
        guard let reserveListJSONArray = json["reserveList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "reserveList") }
        let reserveList = reserveListJSONArray.map({ Reservelis.create(with: $0) }).flatMap({ $0 })
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.reserveList = reserveList
    }
    static func create(with json: JSONDictionary) -> CanteenAllOrderModel? {
        do {
            return try CanteenAllOrderModel(with: json)
        } catch {
            print("CanteenAllOrderModel json parse error: \(error)")
            return nil
        }
    }
}

struct Reservelis {
    let amount: String
    let date: String
    let orderMenu: String
    let orderNum: String
    let personCount: Int
    let reserveDate: String
    var reserveStatus: String
    let restaurantCode: String
    let restaurantName: String
    let reserveId:String
    let groupId:String
    let groupYN:String
    let visit: String
    let realAmount:String
    let pointAmount:String
    init(with json: JSONDictionary) throws {
        guard let groupId = json["groupId"] as? String else { throw ParseError.notFound(key: "groupId") }
        guard let amount = json["amount"] as? String else { throw ParseError.notFound(key: "amount") }
        guard let date = json["date"] as? String else { throw ParseError.notFound(key: "date") }
        guard let orderMenu = json["orderMenu"] as? String else { throw ParseError.notFound(key: "orderMenu") }
        guard let orderNum = json["orderNum"] as? String else { throw ParseError.notFound(key: "orderNum") }
        guard let personCount = json["personCount"] as? Int else { throw ParseError.notFound(key: "personCount") }
        guard let reserveDate = json["reserveDate"] as? String else { throw ParseError.notFound(key: "reserveDate") }
        guard let reserveStatus = json["reserveStatus"] as? String else { throw ParseError.notFound(key: "reserveStatus") }
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode") }
        guard let restaurantName = json["restaurantName"] as? String else { throw ParseError.notFound(key: "restaurantName") }
        guard let visit = json["visit"] as? String else { throw ParseError.notFound(key: "visit") }
        guard let reserveId = json["reserveId"] as? String else { throw ParseError.notFound(key: "reserveId")}
        guard let groupYN = json["groupYN"] as? String else { throw ParseError.notFound(key: "groupYN") }
        guard let realAmount = json["realAmount"] as? String else { throw ParseError.notFound(key: "realAmount")}
        guard let pointAmount = json["pointAmount"] as? String else { throw ParseError.notFound(key: "pointAmount")}
        self.groupYN = groupYN
        self.groupId = groupId
        self.amount = amount
        self.date = date
        self.orderMenu = orderMenu
        self.orderNum = orderNum
        self.personCount = personCount
        self.reserveDate = reserveDate
        self.reserveStatus = reserveStatus
        self.restaurantCode = restaurantCode
        self.restaurantName = restaurantName
        self.visit = visit
        self.reserveId = reserveId
        self.realAmount = realAmount
        self.pointAmount = pointAmount
    }
    static func create(with json: JSONDictionary) -> Reservelis? {
        do {
            return try Reservelis(with: json)
        } catch {
            print("Reservelis json parse error: \(error)")
            return nil
        }
    }
}


