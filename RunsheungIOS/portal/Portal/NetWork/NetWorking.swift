//
//  NetWorking.swift
//  LPPlayer
//
//  Created by linpeng on 2016/10/25.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Alamofire


public enum Method:String,CustomStringConvertible{
    case GET = "GET"
    case POST = "POST"
    case OPTIONS = "OPTIONS"
    case HEAD = "HEAD"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case CONNECT = "CONNECT"
    case TRACE = "TRACE"
    case PATCH = "PATCH"
    
    public var description: String{
        return self.rawValue
    }
    
}

public struct Resource<A>:CustomStringConvertible{
    let path:String
    let method:Method
    let requestBody:Data?
    let headers:[String:String]
    let parse:(Data) -> A?
    
    init(path: String,method: Method,requestBody: Data? ,headers:[String:String],parse:@escaping (Data) -> A?) {
        self.path = path
        self.method = method
        self.requestBody = requestBody
        self.headers = headers
        self.parse = parse
        
    }
    
    public var description: String{
        let decodeRequestBody:JSONDictionary
        if let requestBody = requestBody{
            decodeRequestBody = decodeJSON(requestBody)!
        }else {
            decodeRequestBody = [:]
        }
        return "Resource(Method:\(method),path:\(path),headers:\(headers),requestBody:\(decodeRequestBody)"
    }
}

public enum ErrorCode:String{
    case BlockedByRecipient = "rejected_your_message"
    case NotYetRegistered = "not_yet_registered"
    case UserWasBlocked = "user_was_blocked"
}

public enum Reason:CustomStringConvertible{
    case couldNotParseJson
    case noData
    case noSuccessStatusCode(statusCode:Int,errorCode:ErrorCode?)
    case other(Error?)
    case noNet
    
    public var description: String{
        switch self {
        case .couldNotParseJson:
            return "couldNotParseJson"
        case .noData:
            return "NoData"
        case .noSuccessStatusCode(let statusCode):
            return "NOSuccessStatusCode:\(statusCode)"
        case .other(let error):
            return "Other error:\(String(describing: error?.localizedDescription))"
        case .noNet:
            return "没有网络"
        }
    }
}

public typealias FailureHandler = (_ reason:Reason,_ errorMessage:String?) -> Void

public let defaultFailureHandler:FailureHandler = {reason,errorMessage in
    print("\n***************************** Networking Failure *****************************")
    print("Reason: \(reason)")
    if let errorMessage = errorMessage {
        print("errorMessage: >>>\(errorMessage)<<<\n")
    }
}

func queryComponents(_ key:String,value:AnyObject) ->[(String,String)]{
    
    func escape(_ string:String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharacters(in: generalDelimitersToEncode + subDelimitersToEncode)
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet) ?? string
    }
    
    var components:[(String,String)] = []
    if let dictionary = value as? [String:AnyObject]{
        for (nestedKey,value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value: value)
        }
    }else if let array = value as? [AnyObject]{
        for value in array {
            components += queryComponents("\(key)[]", value: value)
        }
    }else {
        components.append((escape(key),escape("(\(value))")))
    }
    
    return components
    
}

func query(_ parameters:[String:AnyObject]) -> String {
    var components:[(String,String)] = []
    for key in Array(parameters.keys).sorted(by: <){
        let value:AnyObject! = parameters[key]
        components += queryComponents(key, value: value)
    }
    return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
}






private let SuccessStatusCodeRange:CountableRange<Int> = 200..<300



public func apiRequest<A>(_ modifyRequest:((URLRequest) ->())? = nil,baseURL:URL,resource:Resource<A>?,failure:FailureHandler?,completion: @escaping (A) -> Void){
    
    if !(NetworkReachabilityManager()?.isReachable)!{
        DispatchQueue.main.async {
            failure?(.noNet,Reason.noNet.description)
         }
        return
    }
    
    guard let resource = resource else {
        
        DispatchQueue.main.async {
            failure?(.other(nil),"No resource")
        }

        return
    }
    
    let session = URLSession.shared
    let url = baseURL.appendingPathComponent(resource.path)
    var request = URLRequest(url: url)
    request.httpMethod = resource.method.rawValue
    
    func needEncodesParametersForMethod(_ method:Method) ->Bool{
        switch method {
        case .GET,.HEAD,.DELETE:
            return true
        default:
            return false
        }
    }
    
    
    func handleParameters(){
        if needEncodesParametersForMethod(resource.method){
            guard let URL = request.url else {
                print("invalid URL of request:(\(request))")
                return
            }
            if let reuqestBody = resource.requestBody{
                if let URLComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false){
                    var urlcomponents = URLComponents
                    urlcomponents.percentEncodedQuery = (URLComponents.percentEncodedQuery != nil ? URLComponents.percentEncodedQuery! + "&" : "") + query(decodeJSON(reuqestBody)! as [String : AnyObject])
                    request.url = URLComponents.url
                }
            }
        }else {
            
            request.httpBody = resource.requestBody
        }
    }
    
    handleParameters()
    if let modifyRequest = modifyRequest {
        modifyRequest(request)
    }
    
    for (key,value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    let _failure:FailureHandler
    if let failure = failure{
        _failure = failure
    }else {
        _failure = defaultFailureHandler
    }
    
        let task =  session.dataTask(with: request) { (data, response, error) -> Void in
        if let httpResponse = response as? HTTPURLResponse {
            if  SuccessStatusCodeRange.contains(httpResponse.statusCode){
                if let responseData = data {
                    if let result = resource.parse(responseData){
                        DispatchQueue.main.async {
                            completion(result)
                         }
                    }else {
                        _ = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                        DispatchQueue.main.async {
                            _failure(.couldNotParseJson,errorMessageInData(data) )
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        _failure(.noData,errorMessageInData(data))
                     }
                    
                }
            }else {
                let errorCode = errorCodeInData(data)
                DispatchQueue.main.async {
                    _failure(.noSuccessStatusCode(statusCode:httpResponse.statusCode,errorCode:errorCode), errorMessageInData(data))
                }
            }
        }else {
            DispatchQueue.main.async {
                _failure(.other(error),errorMessageInData(data))
             }
        }
        DispatchQueue.main.async {
            NetActivityIndicator.share.decrement()
        }
    }
    
    task.resume()
    DispatchQueue.main.async {
        NetActivityIndicator.share.increment()
    }
}

func errorMessageInData(_ data:Data?) -> String?{
    if let data = data {
        if let json = decodeJSON(data){
            if let errorMessage = json["error"] as? String {
                return errorMessage
            }
        }
    }
    return nil
}

func errorCodeInData(_ data:Data?) -> ErrorCode?{
    if let data = data {
        if let json = decodeJSON(data){
            if let errorCodeString = json["code"] as? String {
                return ErrorCode(rawValue: errorCodeString)
            }
        }
    }
    return nil
    
}

public func decodeJSON(_ data: Data) -> JSONDictionary?{
    if data.count > 0{
        guard let result = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else {
            return JSONDictionary()
        }
        if let dictionary = result as? JSONDictionary {
            return dictionary
        }else if let array = result as? [JSONDictionary]{
            return ["data":array as AnyObject]
        }else {
            return JSONDictionary()
        }

    }else {
        return JSONDictionary()
    }
}

public func encodeJSON(_ dict:JSONDictionary) -> Data?{
    return dict.count > 0 ? (try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())) : nil
}

public func jsonResource<A>(path:String,method:Method,requestParameters:JSONDictionary,parse:@escaping (JSONDictionary) ->A?) -> Resource<A>{
    return jsonResource(token: nil, path: path, method: method, requestParameters: requestParameters, parse: parse)
}


public func jsonResource<A>(token:String?,path:String,method:Method,requestParameters:JSONDictionary,parse:@escaping (JSONDictionary) ->A?) -> Resource<A>{
    let jsonParse:(Data) -> A? = {data in
        
        if let json = decodeJSON(data){
            
            return parse(json)
        }
        return nil
    }
    
    let jsonBody = encodeJSON(requestParameters)
    var headers = [
        "Content-Type": "application/json",
        ]
    if let token = token {
        headers["Authorization"] = "Token token=\"\(token)\""
    }
//    let locale = Locale.autoupdatingCurrent
//    if let
//        languageCode = (locale as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String,
//        let countryCode = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String{
//        headers["Accept-Language"] = languageCode + "_" + countryCode
//    }
    
    return Resource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: jsonParse)
}

