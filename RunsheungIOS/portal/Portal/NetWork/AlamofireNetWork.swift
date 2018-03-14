//
//  AlamofireNetWork.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/9.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public enum Router: URLRequestConvertible {
    
    case playVideo(videoId: String, kind: Int ,userId:String?)
    case playLiveVideo(videoId:Int,kind:Int ,userId:String?)
    
    public func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .playVideo(videoId, kind ,userId):
                return (KLOnlineVideoPlayApiKey, ["videoId": videoId, "kind": kind , "userId":userId ?? ""])
            case let .playLiveVideo(videoId,kind,userId):
                return (KLOnlineVideoPlayApiKey, ["videoId": videoId, "kind": kind , "userId":userId ?? ""])
            }
        }()
        guard let url = URL(string: BaseType.MediaPlayVideo.baseURL) else { throw ParseError.failedToGenerate(property: "url") }
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}



public struct AlamofireResource<A>{
    
    let path:String
    let method:HTTPMethod
    let requestBody:[String:Any]?
    let headers:[String:String]?
    let parse:(JSONDictionary) -> A?
    var baseType:BaseType
    var encoding:ParameterEncoding
    
    init(baseType:BaseType,
         path: String,
         method: HTTPMethod,
         requestBody: [String:Any]?,
         encoding:ParameterEncoding,
         headers:[String:String]?,
         parse:@escaping (JSONDictionary) -> A?) {
          self.path = path
          self.method = method
          self.requestBody = requestBody
          self.headers = headers
          self.parse = parse
          self.baseType = baseType
          self.encoding = encoding
    }
}


public func AlmofireResource<A>(Type:BaseType = .MediaBase,
                                 token:String? = nil,
                                 header:[String:String]? = nil,
                                 path:String,
                                 method:HTTPMethod,
                                 requestParameters:JSONDictionary?,
                                 urlEncoding:ParameterEncoding = URLEncoding.default,
                                 parse:@escaping (JSONDictionary) ->A?) -> AlamofireResource<A>
   {
    let jsonParse:(JSONDictionary) -> A? = { data in
         return parse(data)
    }
    return AlamofireResource(baseType:Type,
                             path: path,
                             method: method,
                             requestBody: requestParameters,
                             encoding:urlEncoding ,
                             headers: header,
                             parse: jsonParse)
}


public func AlamofireRequest<A>(resource:AlamofireResource<A>,failure:FailureHandler?,completion: @escaping (A?) -> Void){
    
    NetActivityIndicator.share.increment()
    if !(NetworkReachabilityManager()!.isReachable){
        DispatchQueue.main.async {
            failure?(.noNet,Reason.noNet.description)
        }
        NetActivityIndicator.share.decrement()
        return
    }	
    let urlpath = (resource.baseType.baseURL) + resource.path
    Alamofire.request(urlpath, method: resource.method, parameters: resource.requestBody,encoding:resource.encoding, headers: resource.headers).responseJSON{ response in
        NetActivityIndicator.share.decrement()
        switch response.result {
        case .success(let value):
            guard value is JSONDictionary else { return }
            DispatchQueue.main.async {
                completion(resource.parse(value as! JSONDictionary))
            }
        case .failure(let error):
            DispatchQueue.main.async {
                failure?(.other(error),Reason.other(error).description)
           }
        }
       
    }

}
