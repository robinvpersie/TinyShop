//
//  WelcomeModel.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/14.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import FMDB

struct Bannerdatss {
    let imgUrl: String
    let url: String
    let ver: String
    init?(json info: JSONDictionary) throws {
        guard let imgUrl = info["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
        guard let url = info["url"] as? String else { throw ParseError.notFound(key: "url") }
        guard let ver = info["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.imgUrl = imgUrl
        self.url = url
        self.ver = ver
    }
    
    static func create(with json:JSONDictionary) -> Bannerdatss? {
        do{
            return try Bannerdatss(json: json)
        }catch {
            print("Bannerdatss json parse error \(error)")
            return nil
        }
    }
}


struct Branchdat {
    let name: String
    let type: String
    init?(json info: JSONDictionary) throws {
        guard let name = info["name"] as? String else { throw ParseError.notFound(key: "name") }
        guard let type = info["type"] as? String else { throw ParseError.notFound(key: "type") }
        self.name = name
        self.type = type
    }
    static func create(with json:JSONDictionary) -> Branchdat? {
        do {
          return try Branchdat(json: json)
        }catch {
          return nil
        }
    }
}

struct dataModel {
    
    let AppVersion: String
    let EventUrl: String
    let ExtraInfo: String
    let NoticeUrl: String
    let UpdateTime: String
    let UpdateType: String
    let bannerData: [Bannerdatss]
    let branchData: [Branchdat]
    let token: String
    let divCode:String
    let divName:String
    var iphoneForceVersion:String?
    var notice:String?
    var noticeVersion:String?
    
    init?(json info: JSONDictionary) throws {
        
        guard let AppVersion = info["AppVersion"] as? String else { throw ParseError.notFound(key: "AppVersion")}
        guard let EventUrl = info["EventUrl"] as? String else { throw ParseError.notFound(key: "EventUrl")}
        guard let ExtraInfo = info["ExtraInfo"] as? String else { throw ParseError.notFound(key: "ExtraInfo") }
        guard let NoticeUrl = info["NoticeUrl"] as? String else { throw ParseError.notFound(key: "NoticeUrl") }
        guard let UpdateTime = info["UpdateTime"] as? String else { throw ParseError.notFound(key: "UpdateTime") }
        guard let UpdateType = info["UpdateType"] as? String else { throw ParseError.notFound(key: "UpdateType") }
        guard let divCode = info["divCode"] as? String else { throw ParseError.notFound(key: "divCode")}
        guard let divName = info["divName"] as? String else { throw ParseError.notFound(key: "divName")}
        guard let bannerDataJSONArray = info["bannerData"] as? [JSONDictionary] else { throw ParseError.notFound(key: "bannerData") }
        let bannerData = bannerDataJSONArray.map({ Bannerdatss.create(with: $0) }).flatMap({ $0 })
        guard let branchDataJSONArray = info["branchData"] as? [JSONDictionary] else { throw ParseError.notFound(key: "branchData") }
        let branchData = branchDataJSONArray.map({ Branchdat.create(with: $0) }).flatMap({ $0 })
        guard let token = info["token"] as? String else { throw ParseError.notFound(key: "token") }
        self.iphoneForceVersion = info["iphone_force_ver"] as? String
        self.notice = info["notice"] as? String
        self.noticeVersion = info["notice_ver"] as? String
        self.AppVersion = AppVersion
        self.EventUrl = EventUrl
        self.ExtraInfo = ExtraInfo
        self.NoticeUrl = NoticeUrl
        self.UpdateTime = UpdateTime
        self.UpdateType = UpdateType
        self.bannerData = bannerData
        self.branchData = branchData
        self.token = token
        self.divCode = divCode
        self.divName = divName
    }
    
    
    
    static func create(with json: JSONDictionary) -> dataModel? {
        do {
            return try dataModel(json: json)
        } catch {
            print("dataModel json parse error: \(error)")
            return nil
        }
    }
    
}


extension dataModel {
    
   static func intro(completion:@escaping (NetWorkResult<dataModel>) -> Void){
    
        let parse:(JSONDictionary) -> dataModel? = { Data in
            let model = dataModel.create(with: Data)
            return model
        }
        let requestParameters:[String:Any] = [
           "MemberID":YCAccountModel.getAccount()?.memid ?? "",
           "token":YCAccountModel.getAccount()?.token ?? "",
           "type":8,
           "lon":113.027417,
           "lat":28.184747
        ]
    
       let netResource = NetResource(path: "/JsonCreate/JsonIntroCreate",
                                     method: .post,
                                     parameters: requestParameters,
                                     parse: parse)
       YCProvider.requestDecoded(netResource, completion: completion)
    }
    
}
