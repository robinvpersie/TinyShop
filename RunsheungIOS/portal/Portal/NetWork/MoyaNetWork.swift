//
//  MoyaNetWork.swift
//  Portal
//
//  Created by PENG LIN on 2017/7/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Moya
import Result

#if !DEBUG // 判断是否在测试环境下
    
private let portalBaseURL = "http://portal.dxbhtm.com:8488"
private let mediaBaseURL = "http://klcm.dxbhtm.com:81"
private let MediaPlayVideoURL = "http://klcm.dxbhtm.com:89"
private let PortalAddressURL = "https://portal.dxbhtm.com"
private let canteenURL = "http://foodapi.dxbhtm.com:843"
private let superMarketURL = "http://pay.dxbhtm.com:81"
private let shopURL = "http://api1.dxbhtm.com:82"
private let shopbURL = "http://pay.dxbhtm.com:81"
private let cancleURI = "http://api1.dxbhtm.com:8088"
private let offURI = "http://editapi.dxbhtm.com:8866"
private let pointURI = "http://api.dxbhtm.com:8083"
private let editProileURI = "http://rsmember.dxbhtm.com:8800"

private let recommendURI = "http://api1.dxbhtm.com:7778"
private let payURL = "http://api1.gigawon.co.kr:82"
#else

private let portalBaseURL = "http://portal.gigawon.co.kr:8488"
private let mediaBaseURL = "http://klcm.dxbhtm.com:81"
private let MediaPlayVideoURL = "http://klcm.dxbhtm.com:89"
private let PortalAddressURL = "https://portal.dxbhtm.com"
private let canteenURL = "http://foodapi.dxbhtm.com:843"
private let superMarketURL = "http://pay.dxbhtm.com:81"
private let shopURL = "http://api1.dxbhtm.com:82"
private let shopbURL = "http://pay.dxbhtm.com:81"
private let cancleURI = "http://api1.dxbhtm.com:8088"
private let offURI = "http://editapi.dxbhtm.com:8866"
private let pointURI = "http://api.dxbhtm.com:8083"
private let editProileURI = "http://rsmember.dxbhtm.com:8800"
private let recommendURI = "http://api1.dxbhtm.com:7778"
private let payURL = "http://api1.gigawon.co.kr:82"
#endif


public enum BaseType {
    case PortalBase
    case MediaBase
    case MediaPlayVideo
    case PortalAddress
    case canteen
    case superMarket
    case shop
    case shopb
    case cancle
    case off
    case point
    case editProfile
    case recommend
    case pay
    
    var baseURL: String{
        switch self {
        case .PortalBase:
            return portalBaseURL
        case .MediaBase:
            return mediaBaseURL
        case .MediaPlayVideo:
            return MediaPlayVideoURL
        case .PortalAddress:
            return PortalAddressURL
        case .canteen:
            return canteenURL
        case .superMarket:
            return superMarketURL
        case .shop:
            return shopURL
        case .shopb:
            return shopbURL
        case .cancle:
            return cancleURI
        case .off:
            return offURI
        case .point:
            return pointURI
        case  .editProfile:
            return editProileURI
        case .recommend:
            return recommendURI
        case .pay:
            return payURL
        }
    }
    
    var URI: URL {
        return URL(string: baseURL)!
    }
}





let activityPlugin = NetworkActivityPlugin { type, _ in
    switch type {
    case .began:
        NetActivityIndicator.share.increment()
    case .ended:
        NetActivityIndicator.share.decrement()
    }
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: data)
      let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return prettyData
    }catch {
      return data
    }
}

let loggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)

#if !DEBUG
let pluginTypeArray:[PluginType] = [activityPlugin]
#else
let pluginTypeArray:[PluginType] = [activityPlugin, loggerPlugin]
#endif

public typealias JSONDictionary = [String:Any]

protocol DecodableTargetType: Moya.TargetType {
    associatedtype resultType
    var parse:(_ object: [String:Any]) -> resultType? {get}
}


protocol MapTargetType: Moya.TargetType {
    associatedtype resultType
    var map:(_ object: [String:Any]) throws -> resultType { get }
}



final class MultiMoyaProvider: MoyaProvider<MultiTarget> {
    
    typealias Target = MultiTarget
    
    override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                manager: Manager = DefaultAlamofireManager.shareManager,
                plugins: [PluginType] = pluginTypeArray,
                trackInflights: Bool = false) {
        
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   manager: manager,
                   plugins: plugins,
                   trackInflights: trackInflights)
        
    }
    
    @discardableResult
    func requestDecoded<T: DecodableTargetType>(
                        _ target: T,
                        completion: @escaping (_ result:NetWorkResult<T.resultType>) -> Void)
                         -> Cancellable
    {
        let cancellable = request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    if let json: JSONDictionary = try? response.mapJSON() as! JSONDictionary,
                        let parsed = target.parse(json) {
                        completion(.success(parsed))
                    }else {
                        completion(.failure(.jsonMapping(response)))
                        
                    }
                case .failure(let error):
                  completion(.failure(error))
                }
            }
        return cancellable
    }
    
    
    @discardableResult
    func requestTarget<T: MapTargetType>(target:T,
                                         completion: @escaping (_ result: NetWorkResult<T.resultType>) -> Void)
                                         -> Cancellable
    {
        let cancellable = request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                if let json: [String:Any] = try? response.mapJSON() as! [String:Any] {
                    do {
                        let parse = try target.map(json)
                        completion(.success(parse))
                    }catch let error {
                        completion(.failure(.objectMapping(error,response)))
                    }
                }else {
                   completion(.failure(.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
       }
       return cancellable
    }
    
    

}


let YCProvider = MultiMoyaProvider()


struct NetResource<T>: DecodableTargetType {
    typealias resultType = T
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var parse: (JSONDictionary) -> T?
    var headers: [String:String]?

    init(baseURL: URL = BaseType.PortalBase.URI,
         path: String,
         method: Moya.Method,
         parameters: [String:Any]?,
         parameterEncoding: ParameterEncoding = URLEncoding.default,
         sampleData: Data = Data(),
         task: Task = .requestPlain ,
         parse :@escaping (JSONDictionary) -> T?
        )
    {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        if let parameters = parameters {
           self.task = .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }else {
           self.task = task
        }
        self.parse = parse
    }
}


struct RSEditProfileResource<T>: DecodableTargetType {
    
    var headers: [String : String]?
    typealias resultType = T
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var parse: (JSONDictionary) -> T?
    
    init(baseURL: URL = BaseType.editProfile.URI,
         path: String,
         method: Moya.Method,
         parameters: [String:Any]?,
         parameterEncoding: JSONEncoding = JSONEncoding.default,
         sampleData: Data = Data(),
         task: Task = .requestPlain,
         parse:@escaping (JSONDictionary) -> T?
        )
    {
        
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        if let parameters = parameters {
            self.task = .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }else {
            self.task = task
        }
        self.parse = parse
    }
}







class tokenResource<T>:DecodableTargetType {
    
    var headers: [String : String]?
    typealias resultType = T
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var checktoken:CheckToken?
    var parse: (JSONDictionary) -> T?
    
    
    init(baseURL: URL = BaseType.PortalBase.URI,
         path: String,
         method: Moya.Method,
         parameters: [String:Any]?,
         parameterEncoding: ParameterEncoding = URLEncoding.default,
         sampleData: Data = Data(),
         task: Task = .requestPlain,
         parse: @escaping (JSONDictionary) -> T?)
    {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        
        if let parameters = parameters {
            self.task = .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }else {
            self.task = task
        }
       self.parse = parse
    }
    
    func requestApi(completion:@escaping (TokenResult<T>) -> Void, check:( (CheckToken) -> Void)? = nil){
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .failure(let error):
                 completion(.failure(error))
            case .success(let checks):
                if checks.status == "1" {
                    self.parameters!["token"] = checks.newtoken
                    check?(checks)
                    YCProvider.requestDecoded(self, completion: { (result) in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let json):
                            completion(.success(json))
                        }
                    })
                }else {
                 completion(.tokenError)
                }
            }
        }
    }
    
}

public enum TokenResult<T>{
    case success(T)
    case tokenError
    case failure(MoyaError)
}
