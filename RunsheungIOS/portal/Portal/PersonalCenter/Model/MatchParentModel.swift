//
//  MatchParentModel.swift
//  Portal
//
//  Created by linpeng on 2018/1/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

struct MatchParentModel {
    let status: String?
    let flag: String?
    let msg: String?
    
    init(json: [String:Any]) {
        self.status = json["status"] as? String
        self.flag = json["flag"] as? String
        self.msg = json["msg"] as? String
    }
    
    static func matchingParentWith(customCode code: String,
                                   sellerTyp: String,
                                   parentId: String,
                                   completion: @escaping (NetWorkResult<MatchParentModel>) -> Void)
    {
        let requestParameter: [String:Any] = [
            "lang_type":"chn",
            "parent_id":parentId,
            "custom_code":code,
            "seller_type": sellerTyp
        ]
        
        func map(_ json: JSONDictionary) throws -> MatchParentModel {
            return MatchParentModel(json: json)
        }
        
        let resource = TargetResource(baseURL: BaseType.recommend.URI,
                                      path: "/api/apiMember/matchingParent",
                                      method: .post,
                                      parameters: requestParameter,
                                      map: map)
        YCProvider.requestTarget(target: resource, completion: completion)
        
    }
}
