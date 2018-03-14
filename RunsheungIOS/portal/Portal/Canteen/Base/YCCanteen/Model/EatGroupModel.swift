//
//  EatGroupModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

struct EatGroupModel {
    
    struct Data{
        let groupID:String
        init?(json:JSONDictionary) throws {
            guard let groupID = json["groupID"] as? String else { throw ParseError.notFound(key: "groupID") }
            self.groupID = groupID
        }
        static func createWith(json:JSONDictionary) -> Data? {
            do{
             return try Data(json: json)
            }catch {
             return nil
            }
        }
     }
    
    let status:Int
    let data:Data
    let msg:String
    
    init?(json:JSONDictionary) throws {
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        guard let dataDic = json["data"] as? JSONDictionary else { throw ParseError.notFound(key: "data")}
        guard let data = Data.createWith(json: dataDic) else { throw ParseError.failedToGenerate(property: "data") }
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg")}
        self.data = data
        self.status = status
        self.msg = msg
    }
    
    static func createWith(json:JSONDictionary) -> EatGroupModel? {
        do{
          return try EatGroupModel(json: json)
        }catch {
          return nil
        }
    }
    
}

extension EatGroupModel {
    
    
    static func AddGroupWithReserveID(_ reserveId:String,
                                      goldenBellYN:String,
                                      groupDescription:String,
                                      groupBellCode:String,
                                      memid:String,
                                      token:String,
                                      completion:@escaping (NetWorkResult<EatGroupModel>) -> Void)
    {
    
       let parse:(JSONDictionary) -> EatGroupModel? = { json in
           let model = EatGroupModel.createWith(json: json)
           return model
       }
        let requestParameter:[String:Any] = [
            "userId":memid,
            "reserveId":reserveId,
            "goldenBellYN":goldenBellYN,
            "groupDescription":groupDescription,
            "goldenBellCode":groupBellCode,
            "token":token,
        ]
        let netresource = NetResource(baseURL: BaseType.canteen.URI,
                                      path: "/AddGroup",
                                      method: .post,
                                      parameters: requestParameter,
                                      parameterEncoding: URLEncoding(destination: .queryString),
                                      parse: parse)
        YCProvider.requestDecoded(netresource, completion: completion)
    }
}



extension GoldenBellCode{
    
    static func Get(failureHandler:FailureHandler?,completion:@escaping (GoldenBellCode?) -> Void){
        
        let parse:(JSONDictionary) -> GoldenBellCode? = { json in
            let model = GoldenBellCode.createWith(json)
            return model
        }

        let resource = AlmofireResource(Type: .canteen, path: "/ArrGoldenBellCode", method: .post, requestParameters: nil, parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
 
    }
}




struct BellData{
    
    let CODE_NAME:String
    let SUB_CODE:String
    
    init?(json:JSONDictionary) throws {
        guard let CodeName = json["CODE_NAME"] as? String else { throw ParseError.notFound(key: "CODE_NAME")}
        guard let subcode = json["SUB_CODE"] as? String else { throw ParseError.notFound(key: "SUB_CODE")}
        self.CODE_NAME = CodeName
        self.SUB_CODE = subcode
    }
    
    static func createWith(_ json:JSONDictionary) -> BellData? {
        do {
            return try BellData(json: json)
        }catch {
            return nil
        }
    }
}



struct GoldenBellCode {
    
    let status:Int
    let msg:String
    let BellDataArray:[BellData]
    
    init?(json:JSONDictionary) throws {
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status")}
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg")}
        guard let BellDataArr = json["data"] as? [JSONDictionary] else { throw ParseError.notFound(key: "Data")}
        self.BellDataArray = BellDataArr.map({ BellData.createWith($0) }).flatMap({ $0 })
        self.status = status
        self.msg = msg
    }
    
    static func createWith(_ json:JSONDictionary) -> GoldenBellCode? {
        do {
          return try GoldenBellCode(json: json)
        }catch {
          return nil
        }
    }

}



