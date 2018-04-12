//
//  PayTarget.swift
//  Portal
//
//  Created by 이정구 on 2018/4/12.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya
import Result

struct PayTarget: TargetType {
    
    var baseURL: URL = BaseType.pay.URI
    
    var path: String = "/api/wPay/requestQRpayment"
    
    var method: Moya.Method = .post
    
    var sampleData: Data = Data()
    
    var task: Task
    
    var headers: [String : String]?
    
    init(password: String, customCode: String, storeCustomCode: String, amount: String) {
        let shaPassword = password.sha512()
        let requestParameters: [String:Any] = [
            "custom_code": customCode,
            "password": shaPassword,
            "store_custom_code": storeCustomCode,
            "amount": amount
        ]
        self.task = .requestParameters(parameters: requestParameters, encoding: URLEncoding.default)
    }
    
    func pay(_ completion:@escaping ((Result<[String:Any], MoyaError>) -> Void)) {
        let provider = MoyaProvider<PayTarget>(callbackQueue: DispatchQueue.global(), plugins: pluginTypeArray)
        provider.request(self) { result in
            switch result {
            case let .success(value):
                if let json = try? value.mapJSON() as! [String:Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(MoyaError.jsonMapping(value)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
