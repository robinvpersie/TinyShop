//
//  KoreaPlaceModel.swift
//  Portal
//
//  Created by 이정구 on 2018/3/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya
import Alamofire

struct KoreaPlaceModel {
    
    var address: String
    var postcd: String
    
    init(dic: NSDictionary) {
        self.address = dic["address"] as! String
        self.postcd = dic["postcd"] as! String
    }
    
    static let callbackQueue = DispatchQueue(label: "robin v persie")
    
    static func fetchWithQuery(_ place: String?, offset: Int, success:@escaping (NSMutableArray?) -> Void) {
        guard let place = place else { return }
        let ecu = ECU()
        ecu.requestArea(withQuery: place, offset: offset)
        
        ecu.success = { array in
            success(array)
        }
    }
}

struct KoreaPlaceTarget: TargetType {
    
    var method: Moya.Method
    var baseURL: URL
    var path: String
    var sampleData: Data
    var task: Task
    var headers: [String : String]?
    
    init(parameters: [String:Any]) {
        self.baseURL = URL(string: "http://biz.epost.go.kr")!
        self.path = "/KpostPortal/openapi"
        self.method = .get
        self.sampleData = Data()
        self.task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        self.headers = nil
    }
    
}


