//
//  MyPointModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct PointBalance {
    
    let tot_mysave:Float
    
    init?(json:JSONDictionary) throws {
        guard let tot_mysave = json["tot_mysave"] as? Float else { throw ParseError.notFound(key: "tot_mysave") }
        self.tot_mysave = tot_mysave
    }
    
    static func createWithJson(_ json:JSONDictionary) -> PointBalance? {
        do {
          return try PointBalance(json: json)
        }catch{
          return nil
        }
    }
}

struct PointList {
    
    let card_no:String
    let store_code:String
    let store_name:String
    let trade_date:String
    let trade_money:String
    let trade_type:String
    
    init?(json:JSONDictionary) throws {
        guard let cardno = json["card_no"] as? String else { throw ParseError.notFound(key: "card_no")}
        guard let storecode = json["store_code"] as? String else { throw ParseError.notFound(key: "store_code")}
        guard let storename = json["store_name"] as? String else { throw ParseError.notFound(key: "store_name")}
        guard let tradedate = json["trade_date"] as? String else { throw ParseError.notFound(key: "trade_date")}
        guard let trademoney = json["trade_money"] as? String else { throw ParseError.notFound(key:"trade_money")}
        guard let tradetype = json["trade_type"] as? String else { throw ParseError.notFound(key: "trade_type")}
        self.card_no = cardno
        self.store_code = storecode
        self.store_name = storename
        self.trade_date = tradedate
        self.trade_money = trademoney
        self.trade_type = tradetype
    }
    
    static func createWithJson(_ json:JSONDictionary) -> PointList? {
        do {
           return try PointList(json: json)
        } catch {
           return nil
        }
    }
    
}

struct MyPointModel {
    
    let pointBalance:PointBalance
    let pointList:[PointList]
    
    init?(json:JSONDictionary) throws {
        guard let pointBalanceDic = json["PointBalance"] as? JSONDictionary else { throw ParseError.notFound(key: "PointBalance") }
        guard let pointBalance = PointBalance.createWithJson(pointBalanceDic) else { throw ParseError.failedToGenerate(property: "PointBalance") }
        guard let pointlistDic = json["PointList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "PointList") }
        let pointlist = pointlistDic.map({ PointList.createWithJson($0) }).flatMap({ $0 })
        self.pointBalance = pointBalance
        self.pointList = pointlist
    }
    
    static func createWithJson(_ json:JSONDictionary) -> MyPointModel? {
        do{
            return try MyPointModel(json:json)
        }catch {
            return nil
        }
    }
    
}

extension MyPointModel {
    
    static func GetWithOption(_ option:String,pageIndex:Int,memid:String,token:String,completion:@escaping (NetWorkResult<MyPointModel>) -> Void){
       
        let parse:(JSONDictionary) -> MyPointModel? = { json in
            guard let data = json["data"] as? JSONDictionary,
                let status = json["status"] as? Int
                else {
                    return nil
                }
               if status == -9001 {
                 YCUserDefaults.accountModel.value = nil
                  return nil
              }
              let model = MyPointModel.createWithJson(data)
              return model
        }
        let requestParameter:[String:Any] = [
           "token":token,
           "memid":memid,
           "s_option":option,
           "PageIndex":pageIndex,
           "PageSize":10
        ]
        let netResource = NetResource.init(baseURL: BaseType.point.URI,
                                           path: "/pl_Point/api/PointGetListAndBalance",
                                           method: .post,
                                           parameters: requestParameter,
                                           parameterEncoding:URLEncoding(destination: .httpBody),
                                           parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
}
