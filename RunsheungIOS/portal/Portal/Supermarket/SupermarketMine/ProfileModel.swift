//
//  ProfileModel.swift
//  Portal
//
//  Created by linpeng on 2018/1/10.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

struct ProfileModel {
    
    let nick_name:String?
    let mobile:String
    var head_url:URL?
    let point:String?
    let assess_count:Int
    let custom_code:String?
    let custom_id:String
    let coupons_count:Int
    let collection_count:Int
    var waitPayCount:Int?
    var waitSendCount:Int?
    var waitPickCount:Int?
    var waitReceiveCount:Int?
    var waitCommentCount:Int?
    
    init(json:JSONDictionary) {
        self.nick_name = json["nick_name"] as? String
        self.mobile = json["mobile"] as! String
        if let headurlString = json["head_url"] as? String {
           self.head_url = URL(string: headurlString)
        }
        self.point = json["point"] as? String
        self.assess_count = json["assess_count"] as! Int
        self.custom_code = json["custom_code"] as? String
        self.custom_id = json["custom_id"] as! String
        self.coupons_count = json["coupons_count"] as! Int
        self.collection_count = json["collection_count"] as! Int
        if let orders = json["orders"] as? [JSONDictionary] {
           
            orders.forEach({ (element) in
                let status = element["ONLINE_ORDER_STATUS"] as? String
                let orderCount =  element["order_count"] as? Int
                if status == "1" {
                   self.waitPayCount = orderCount
                }else if status == "3" {
                   self.waitReceiveCount = orderCount
                }else if status == "5" {
                   self.waitCommentCount = orderCount
                }else if status == "4" {
                    
                }else {
                    
                }
            })
        }
    }
    
    static func requestWith(_ appType:Int,completion: @escaping (TokenResult<ProfileModel>) -> Void){
        guard let token = YCAccountModel.getAccount()?.token else { return }
        let parameters:[String:Any] = [
            "appType":appType,
            "token":token
        ]
        func map(_ json:JSONDictionary) -> ProfileModel? {
            let status = json["status"] as! Int
            if status == 1 {
                if let data = json["data"] as? JSONDictionary {
                   return ProfileModel(json: data)
                }
            }
            return nil
        }
        let resource = tokenResource(baseURL: BaseType.superMarket.URI,
                                     path: "FreshMart/User/GetUserInfo",
                                     method: .post,
                                     parameters: parameters,
                                     parse: map)
        resource.requestApi(completion: completion)
    }
    
}
