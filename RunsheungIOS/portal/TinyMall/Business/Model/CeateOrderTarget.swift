//
//  CeateOrderTarget.swift
//  Portal
//
//  Created by 이정구 on 2018/5/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya

struct CreateOrderTarget: TargetType {
    
    var baseURL: URL = URL(string: "http://pay.gigawon.co.kr:81")!
    var path: String = "FreshMart/Order/CreateOrder"
    var method: Moya.Method = .post
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
    
    
    
    
}
