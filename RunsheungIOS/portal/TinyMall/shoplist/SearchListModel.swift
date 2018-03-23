//
//  SearchListModel.swift
//  Portal
//
//  Created by 이정구 on 2018/3/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON

struct SearchListModel {
    
    struct Addrdetai {
        var ri: String
        var sido: String
        var country: String
        var dongmyun: String
        var rest: String
        var sigugun: String
        
        init(_ json: JSON) {
            self.ri = json["ri"].stringValue
            self.sido = json["sido"].stringValue
            self.country = json["country"].stringValue
            self.dongmyun = json["dongmyun"].stringValue
            self.rest = json["rest"].stringValue
            self.sigugun = json["sigugun"].stringValue
        }
    }
    
    struct Poin {
        var x: Double
        var y: Double
        
        init(_ json: JSON) {
            self.x = json["x"].doubleValue
            self.y = json["y"].doubleValue
        }
    }
    
    fileprivate static let dispose = DisposeBag()
    fileprivate static let callbackQueue = DispatchQueue(label: "callBack")
    
    var isRoadAddress: Bool
    var addrdetail: Addrdetai
    var address: String?
    var point: Poin
    
    init(_ json: JSON) {
        self.addrdetail = Addrdetai(json["addrdetail"])
        self.point = Poin(json["point"])
        self.isRoadAddress = json["isRoadAddress"].boolValue
        self.address = json["address"].string
    }
    
    static func requestWithQuery(_ query: String, completion:@escaping ([SearchListModel]) -> Void)
    {
        let searchResource = SearchSource(query: query)
        let provider = MoyaProvider<SearchSource>(plugins: [loggerPlugin])
        provider.request(searchResource) { (result) in
            switch result {
            case .success(let value):
                if let response = try? value.mapJSON() {
                    let json = JSON(response)
                    if let items = json["result"]["items"].array {
                        let list = items.map({ SearchListModel($0) })
                        completion(list)
                    }
                }
            case .failure:
                break
            }
        }
//        return provider.rx.request(searchResource, callbackQueue: self.callbackQueue)
//            .mapJSON()
//            .map({ (response) -> [SearchListModel] in
//                let json = JSON(response)
//                let items = json["result"]["items"].arrayValue
//                return items.map({ SearchListModel($0) })
//            }).asObservable()
       
    }
}

struct SearchSource: TargetType {
    
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var sampleData: Data = Data()
    var task: Task
    var headers: [String : String]?
   
    init(query: String) {
        self.baseURL = URL(string: "https://openapi.naver.com")!
        self.path = "/v1/map/geocode"
        self.task = .requestParameters(parameters: ["query":query], encoding: URLEncoding.default)
        let headers: [String : String] = [
            "X-Naver-Client-Id":"DDs0cS8ZfU_oVMqjWJd6",
            "X-Naver-Client-Secret":"nfGhGby9T4"
        ]
        self.headers = headers
        self.method = .get
    }
}


