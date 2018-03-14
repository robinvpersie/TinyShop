//
//  ActivityDetailModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

struct ActivityDetailModel {
    
    static func getWith(divCode:String,activityId:String,completion:@escaping (TokenResult<JSONDictionary>)->Void){
        let parse:(JSONDictionary)->JSONDictionary = { data in
            return data
        }
        let memid = YCAccountModel.getAccount()?.memid ?? ""
        let requestParameters:[String:Any] = [
            "lang_type":"chn",
            "memid":memid,
            "mall_home_id":memid,
            "mem_grade":"",
            "mall_grade":"",
            "ssoId":"",
            "regiKey":"",
            "div_code":divCode,
            "activity_Id":activityId
        ]
        let netresource = tokenResource(baseURL: BaseType.shop.URI,
                                             path: "/api/ycO2o/ActivityDetail",
                                             method: .post,
                                             parameters: requestParameters,
                                             parse: parse)
        netresource.requestApi(completion: completion)
        
    }
}
