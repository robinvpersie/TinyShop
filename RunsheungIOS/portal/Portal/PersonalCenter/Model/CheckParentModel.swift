//
//  CheckParentModel.swift
//  Portal
//
//  Created by linpeng on 2018/1/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

struct CheckParentModel {
    var custom_name: String?
    var custom_id: String?
    var mobilepho: String?
    var seller_type: String?
    var custom_code: String?
    
    init(json: JSONDictionary) throws {
        guard let data = json["data"] as? JSONDictionary else {
            throw ParseError.notFound(key: "data")
        }
        self.custom_name = data["custom_name"] as? String
        self.custom_id = data["custom_id"] as? String
        self.mobilepho = data["mobilepho"] as? String
        self.seller_type = data["seller_type"] as? String
        self.custom_code = data["custom_code"] as? String
    }
    
    func isMatch() -> Bool {
        if let name = self.custom_name,
            let id = self.custom_id,
            let pho = self.mobilepho,
            let code = self.custom_code
        {
            return true
        }else {
            return false 
        }
    }
    
    static func checkParentWithParentId(_ parentId: String,
                                        completion: @escaping (NetWorkResult<JSONDictionary>) -> Void)
    {
        let requestParameter: [String:Any] = [
            "lang_type":"chn",
            "parent_id":parentId,
            "custom_code":YCAccountModel.getAccount()?.customCode ?? ""
        ]
        
        func map(_ jsonDictionary: JSONDictionary) throws -> JSONDictionary {
            return jsonDictionary
        }
        let resource = TargetResource(baseURL: BaseType.recommend.URI,
                                      path: "api/apiMember/checkParent",
                                      method: .post,
                                      parameters: requestParameter,
                                      map: map)
        YCProvider.requestTarget(target: resource, completion: completion)
        
    }
}
