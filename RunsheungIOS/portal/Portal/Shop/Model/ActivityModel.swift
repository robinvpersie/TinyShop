//
//  ActivityModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ActivityModel {
    let title:String
    let activityid:String
    let imageUrl:URL?
    
    init(json:JSON) {
        title = json["title"].stringValue
        activityid = json["activity_id"].stringValue
        let imageurlstring = json["image_url"].stringValue
        imageUrl = URL(string: imageurlstring)
    }
    
    static func requestData(currentPage:Int,divCode:String,progress:Int,completion:@escaping (TokenResult<JSONDictionary>)->Void){
        
        let parse:(JSONDictionary) -> JSONDictionary? = { data in
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
            "div_code":"",
            "in_progress":progress,
            "current_page":"\(currentPage)",
            "page_size":"10"
        ]
        let netResource = tokenResource(baseURL: BaseType.shop.URI,
                                        path: "/api/ycO2o/ListActivity",
                                        method: .post,
                                        parameters: requestParameters,
                                        parse: parse)
        netResource.requestApi(completion: completion)
    }

    
}
