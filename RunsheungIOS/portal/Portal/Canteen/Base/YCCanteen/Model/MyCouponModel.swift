//
//  MyCouponModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct Listcoupon {
    let couponName: String
    let couponNo: String
    let couponType: Int
    let dcAmount: Double
    let endDate: String
    let overAmount: Int
    let startDate: String
    let upperLimitAmount: Int
    let vcRestaurantName: String
    var canUse:Bool = false 
    init(with json: JSONDictionary) throws {
        guard let couponName = json["coupon_name"] as? String else { throw ParseError.notFound(key: "coupon_name") }
        guard let couponNo = json["coupon_no"] as? String else { throw ParseError.notFound(key: "coupon_no") }
        guard let couponType = json["coupon_type"] as? Int else { throw ParseError.notFound(key: "coupon_type") }
        guard let dcAmount = json["dc_amount"] as? Double else { throw ParseError.notFound(key: "dc_amount") }
        guard let endDateString = json["end_date"] as? String else { throw ParseError.notFound(key: "end_date") }

        guard let overAmount = json["over_amount"] as? Int else { throw ParseError.notFound(key: "over_amount") }
        guard let startDateString = json["start_date"] as? String else { throw ParseError.notFound(key: "start_date") }

        guard let upperLimitAmount = json["upper_limit_amount"] as? Int else { throw ParseError.notFound(key: "upper_limit_amount") }
        guard let vcRestaurantName = json["vcRestaurantName"] as? String else { throw ParseError.notFound(key: "vcRestaurantName") }
        self.couponName = couponName
        self.couponNo = couponNo
        self.couponType = couponType
        self.dcAmount = dcAmount
        self.endDate = endDateString
        self.overAmount = overAmount
        self.startDate = startDateString
        self.upperLimitAmount = upperLimitAmount
        self.vcRestaurantName = vcRestaurantName
    }
    static func create(with json: JSONDictionary) -> Listcoupon? {
        do {
            return try Listcoupon(with: json)
        } catch {
            print("Listcoupon json parse error: \(error)")
            return nil
        }
    }
}

struct MyCouponModel {
    let currentPage: Int
    let listCoupons: [Listcoupon]
    let nextPage: Int
    init(with json: JSONDictionary) throws {
        guard let currentPage = json["currentPage"] as? Int else { throw ParseError.notFound(key: "currentPage") }
        guard let listCouponsJSONArray = json["listCoupons"] as? [JSONDictionary] else { throw ParseError.notFound(key: "listCoupons") }
        let listCoupons = listCouponsJSONArray.map({ Listcoupon.create(with: $0) }).flatMap({ $0 })
        guard let nextPage = json["nextPage"] as? Int else { throw ParseError.notFound(key: "nextPage") }
        self.currentPage = currentPage
        self.listCoupons = listCoupons
        self.nextPage = nextPage
    }
    static func create(with json: JSONDictionary) -> MyCouponModel? {
        do {
            return try MyCouponModel(with: json)
        } catch {
            print(" MyCouponModel json parse error: \(error)")
            return nil
        }
    }
}


extension MyCouponModel {
    
    static func GetWithType(_ type:Int = 2,isUsed:Int,currentPage:Int,failureHandler:FailureHandler?,completion:@escaping (MyCouponModel?) -> Void){
        
        let parse:(JSONDictionary) -> MyCouponModel? = { json in
            guard let data = json["data"] as? JSONDictionary  else { return nil }
            let model = MyCouponModel.create(with: data)
            return model
        }
        let memid = YCAccountModel.getAccount()?.memid ?? ""
        let resource = AlmofireResource(Type: .canteen, path: canteenCouponKey, method: .post, requestParameters: ["userId":memid,"appType":type,"isUsed":isUsed,"currentPage":currentPage], urlEncoding: URLEncoding(destination: .queryString), parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

    }
}




