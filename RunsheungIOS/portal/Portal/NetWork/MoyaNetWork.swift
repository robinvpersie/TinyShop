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
import Alamofire

#if !DEBUG // 判断是否在测试环境下
    
let portalBaseURL = "http://portal.dxbhtm.com:8488"
let mediaBaseURL = "http://klcm.dxbhtm.com:81"
let MediaPlayVideoURL = "http://klcm.dxbhtm.com:89"
let PortalAddressURL = "https://portal.dxbhtm.com"
let canteenURL = "http://foodapi.dxbhtm.com:843"
let superMarketURL = "http://pay.dxbhtm.com:81"
let shopURL = "http://api1.dxbhtm.com:82"
let shopbURL = "http://pay.dxbhtm.com:81"
let cancleURI = "http://api1.dxbhtm.com:8088"
let offURI = "http://editapi.dxbhtm.com:8866"
let pointURI = "http://api.dxbhtm.com:8083"
let recommendURI = "http://api1.dxbhtm.com:7778"

#else

let portalBaseURL = "http://portal.dxbhtm.com:8488"
let mediaBaseURL = "http://klcm.dxbhtm.com:81"
let MediaPlayVideoURL = "http://klcm.dxbhtm.com:89"
let PortalAddressURL = "https://portal.dxbhtm.com"
let canteenURL = "http://foodapi.dxbhtm.com:843"
let superMarketURL = "http://pay.dxbhtm.com:81"
let shopURL = "http://api1.dxbhtm.com:82"
let shopbURL = "http://pay.dxbhtm.com:81"
let cancleURI = "http://api1.dxbhtm.com:8088"
let offURI = "http://editapi.dxbhtm.com:8866"
let pointURI = "http://api.dxbhtm.com:8083"
let editProileURI = "http://rsmember.dxbhtm.com:8800"
let recommendURI = "http://api1.dxbhtm.com:7778"
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
    
    var baseURL:String{
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
        }
    }
    
    var URI:URL {
        return URL(string: baseURL)!
    }
}





let activityPlugin = NetworkActivityPlugin { type in
    switch type {
    case .began:
        NetActivityIndicator.share.increment()
    case .ended:
        NetActivityIndicator.share.decrement()
    }
}

private func JSONResponseDataFormatter(_ data:Data) -> Data {
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
    var parse:(_ object:JSONDictionary) -> resultType? {get}
}


protocol MapTargetType: Moya.TargetType {
    associatedtype resultType
    var map:(_ object:JSONDictionary) throws -> resultType { get }
}

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let shareManager:DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

final class MultiMoyaProvider:MoyaProvider<MultiTarget> {
    
    typealias Target = MultiTarget
    
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                manager: Manager = DefaultAlamofireManager.shareManager,
                plugins: [PluginType] = pluginTypeArray,
                trackInflights: Bool = false) {
        
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   manager: manager,
                   plugins: plugins,
                   trackInflights: trackInflights)
        
    }
    
    @discardableResult
    func requestDecoded<T: DecodableTargetType>(
                        _ target: T,
                        queue: DispatchQueue? = nil,
                        completion: @escaping (_ result:NetWorkResult<T.resultType>) -> Void)
                         -> Cancellable
    {
        let cancellable = request(MultiTarget(target), queue: queue) { result in
                switch result {
                case .success(let response):
                    if let json: JSONDictionary = try? response.mapJSON() as! JSONDictionary,
                        let parsed = target.parse(json) {
                        DispatchQueue.main.async(execute: {
                             completion(.success(parsed))
                        })
                    }else {
                        DispatchQueue.main.async(execute: {
                            completion(.failure(.jsonMapping(response)))
                        })
                    }
                case .failure(let error):
                    DispatchQueue.main.async(execute: { 
                        completion(.failure(error))
                    })
                }
            }
        return cancellable
      }
    
    @discardableResult
    func requestTarget<T: MapTargetType>(target:T,
                                         queue: DispatchQueue? = nil,
                                         completion: @escaping (_ result:NetWorkResult<T.resultType>) -> Void)
                                         -> Cancellable
    {
        let cancellable = request(MultiTarget(target), queue: queue) { result in
            switch result {
            case .success(let response):
                if let json: [String:Any] = try? response.mapJSON() as! JSONDictionary {
                    do {
                        let parse = try target.map(json)
                        DispatchQueue.main.async(execute: {
                            completion(.success(parse))
                        })
                    }catch let error {
                        DispatchQueue.main.async {
                            completion(.failure(.objectMapping(error,response)))
                        }
                    }
                }else {
                    DispatchQueue.main.async(execute: {
                        completion(.failure(.jsonMapping(response)))
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    completion(.failure(error))
                })
            }
       }
       return cancellable
    }
}


let YCProvider = MultiMoyaProvider()




struct NetResource<T>:DecodableTargetType {

    typealias resultType = T
    var baseURL: URL
    var path: String
    var method:Moya.Method
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var parse: (JSONDictionary) -> T?

    init(baseURL: URL = BaseType.PortalBase.URI,
         path: String,
         method: Moya.Method,
         parameters: [String:Any]?,
         parameterEncoding: ParameterEncoding = URLEncoding.default,
         sampleData: Data = Data(),
         task: Task = .request,
         parse :@escaping (JSONDictionary) -> T?
        )
    {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        self.task = task
        self.parse = parse
    }
}


struct RSEditProfileResource<T>:DecodableTargetType {
    
    typealias resultType = T
    var baseURL: URL
    var path: String
    var method:Moya.Method
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var parse: (JSONDictionary) -> T?
    
    init(baseURL:URL = BaseType.editProfile.URI,
         path:String,
         method:Moya.Method,
         parameters:[String:Any]?,
         parameterEncoding:JSONEncoding = JSONEncoding.default,
         sampleData:Data = Data(),
         task:Task = .request,
         parse:@escaping (JSONDictionary) -> T?
        )
    {
        
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        self.task = task
        self.parse = parse
    }
}







class tokenResource<T>:DecodableTargetType {
    
    typealias resultType = T
    var baseURL: URL
    var path: String
    var method:Moya.Method
    var parameters: [String : Any]?
    var parameterEncoding: ParameterEncoding
    var sampleData: Data
    var task: Task
    var checktoken:CheckToken?
    var parse: (JSONDictionary) -> T?
    
    
    init(baseURL:URL = BaseType.PortalBase.URI,
         path:String,
         method:Moya.Method,
         parameters:[String:Any]?,
         parameterEncoding:ParameterEncoding = URLEncoding.default,
         sampleData:Data = Data(),
         task:Task = .request,
         parse:@escaping (JSONDictionary) -> T?)
    {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.sampleData = sampleData
        self.task = task
        self.parse = parse
    }
    
    func requestApi(completion:@escaping (TokenResult<T>)->Void,check:((CheckToken)->Void)? = nil){
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
