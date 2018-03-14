//
//  PersonalCenterModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/1/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PersonalShareModel {
    var RecommandData: [RecommanddatPersonalCenter]
    init?(json info: [String: Any]) {
        guard let RecommandDataJSONArray = info["RecommandData"] as? [[String: Any]] else { return nil }
        let RecommandData = RecommandDataJSONArray.map({ RecommanddatPersonalCenter(json: $0) }).flatMap({ $0 })
        self.RecommandData = RecommandData
    }
}

public struct RecommanddatPersonalCenter {
    var BannerSeq: Int
    var Content: String
    var MemberID: String
    var NickName: String
    var ReplySeq: Int
    var Title: String
    var recommandCount: Int
    var isStar: Bool?
    var imgUrl: String?
    var url: String?
    var date: String?
    init?(json info: [String: Any]) {
        guard let BannerSeq = info["bannerSeq"] as? Int else { return nil }
        guard let Content = info["content"] as? String else { return nil }
        guard let MemberID = info["memberID"] as? String else { return nil }
        guard let NickName = info["nickName"] as? String else { return nil }
        guard let ReplySeq = info["replySeq"] as? Int else { return nil }
        guard let Title = info["title"] as? String else { return nil }
        guard let recommandCount = info["recommandCount"] as? Int else {return nil}
        self.imgUrl = info["imgUrl"] as? String
        self.url = info["url"] as? String
        self.date = info["date"] as? String
        self.BannerSeq = BannerSeq
        self.Content = Content
        self.MemberID = MemberID
        self.NickName = NickName
        self.ReplySeq = ReplySeq
        self.Title = Title
        self.recommandCount = recommandCount
    }
    
    mutating func changeIsStar(_ isStar:Bool){
       self.isStar = isStar
    }
}




//个人中心评论模型

public struct PersonalCommentModel {
    let ReplyData: [Replydat]

    init?(json info: [String: Any]) {
        guard let ReplyDataJSONArray = info["ReplyData"] as? [[String: Any]] else { return nil }
        let ReplyData = ReplyDataJSONArray.map({ Replydat(json: $0) }).flatMap({ $0 })
        self.ReplyData = ReplyData
    }
}

public struct Replydat {
    let BannerSeq: Int
    let Content: String
    let MemberID: String
    let ReplySeq: Int
    let Title: String
    let dtRegDate: String
    let iRecommandCount: Int
    let url:String?
    let date:String?
    init?(json info: [String: Any]) {
        guard let BannerSeq = info["bannerSeq"] as? Int else { return nil }
        guard let Content = info["content"] as? String else { return nil }
        guard let MemberID = info["memberID"] as? String else { return nil }
        guard let ReplySeq = info["replySeq"] as? Int else { return nil }
        guard let Title = info["title"] as? String else { return nil }
        guard let dtRegDate = info["date"] as? String else { return nil }
        guard let iRecommandCount = info["recommandCount"] as? Int else { return nil }
        if let url = info["url"] as? String {
          self.url = url
        }else {
            self.url = nil
        }
        if let date = info["date"] as? String {
          self.date = date
        }else {
            self.date = nil
        }
        self.BannerSeq = BannerSeq
        self.Content = Content
        self.MemberID = MemberID
        self.ReplySeq = ReplySeq
        self.Title = Title
        self.dtRegDate = dtRegDate
        self.iRecommandCount = iRecommandCount
    }
}





/// 个人中心收藏模型
public struct PersonalMyScrab {
    
    let scrabSeq:Int
    let bannerSeq:Int
    let title:String
    let memberID:String
    let date:String
    let ver:String
    let content:String
    let imgUrl:String
    let scrabUrl:String
    let replyCount:Int
    
    init?(json:JSON) throws {
        
        if let scrabSeq = json["scrabSeq"].int {
            self.scrabSeq = scrabSeq
        } else {
            throw ParseError.notFound(key: "scrabSeq")
        }
        
        if let bannerSeq = json["bannerSeq"].int{
            self.bannerSeq = bannerSeq
        }else {
            throw ParseError.notFound(key: "bannerSeq")
        }
        
        if let title = json["title"].string{
            self.title = title
        }else {
            throw ParseError.notFound(key: "title")
        }
        if let memberID = json["memberID"].string { self.memberID = memberID } else { throw ParseError.notFound(key: "memberID") }
        if let date = json["date"].string{ self.date = date } else { throw ParseError.notFound(key: "date") }
        if let ver = json["ver"].string{ self.ver = ver } else { throw ParseError.notFound(key: "ver") }
        if let content = json["content"].string { self.content = content } else { throw ParseError.notFound(key: "content") }
        if let imgUrl = json["imgUrl"].string { self.imgUrl = imgUrl } else { throw ParseError.notFound(key: "imgUrl") }
        if let scrabUrl = json["url"].string { self.scrabUrl = scrabUrl } else { throw ParseError.notFound(key: "url") }
        if let replyCount = json["ReplyCount"].int { self.replyCount = replyCount } else { throw ParseError.notFound(key: "ReplyCount") }
    }
    
    static func createWith(_ Json:JSON) -> PersonalMyScrab? {
        do {
          let model = try PersonalMyScrab(json: Json)
          return model
        }catch let error {
           print("PersonalMyScrab fail To Generate \(error.localizedDescription)")
           return nil
        }
    }
   
}

extension PersonalMyScrab {
    
    static func Get(completion:@escaping (NetWorkResult<[PersonalMyScrab]>) -> Void){
    
        let parse:(JSONDictionary) -> [PersonalMyScrab] = { json in
           var scrabArray = [PersonalMyScrab]()
           let jsonDic = JSON(json)
           guard let scrabData = jsonDic["ScrabData"].array else {
             return scrabArray
            }
           scrabArray = scrabData.map({ PersonalMyScrab.createWith($0) }).flatMap({ $0 })
           return scrabArray
        }
        let MemberID = YCAccountModel.getAccount()!.customCode
        let requestParameters:[String:Any] = [
            "MemberID":MemberID
        ]
        let netResource = NetResource(baseURL: BaseType.PortalBase.URI,
                                           path: "/MyInfo/MyScrab",
                                           method: .post,
                                           parameters: requestParameters,
                                           parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
}


public struct PersonalMyShareModel {
    
    let ver:String
    let content:String
    let imgUrl:String
    let shareUrl:String
    let replyCount:Int
    let shareSeq:Int
    let bannerSeq:Int
    let title:String
    let memberID:String
    let date:String
    
    init?(json:JSON){
        if let ver = json["ver"].string { self.ver = ver } else { return nil}
        if let imgUrl = json["imgUrl"].string { self.imgUrl = imgUrl } else { return nil }
        if let content = json["content"].string { self.content = content } else { return nil }
        if let shareUrl = json["url"].string { self.shareUrl = shareUrl } else { return nil }
        if let replyCount = json["ReplyCount"].int { self.replyCount = replyCount } else { return nil }
        if let shareSeq = json["shareSeq"].int { self.shareSeq = shareSeq } else { return nil }
        if let bannerSeq = json["bannerSeq"].int { self.bannerSeq = bannerSeq } else { return nil }
        if let title = json["title"].string { self.title = title } else { return nil }
        if let memberID = json["memberID"].string { self.memberID = memberID } else { return nil }
        if let date = json["date"].string { self.date = date } else { return nil }
    }
}


extension PersonalMyShareModel {
    
    static func Get(completion:@escaping (NetWorkResult<[PersonalMyShareModel]>)-> Void){
        
        let parse:(JSONDictionary) -> [PersonalMyShareModel] = { json in
            var PersonalShareDataArray = [PersonalMyShareModel]()
            let jsonDic = JSON(json)
            if let shareArray = jsonDic["ShareData"].array {
                PersonalShareDataArray = shareArray.map({ PersonalMyShareModel(json: $0) }).flatMap({ $0 })
            }
            return PersonalShareDataArray
        }
        let memberID = YCAccountModel.getAccount()?.memid ?? ""
        let requestParameters:[String:Any] = [
            "MemberID":memberID
        ]
        let netResource = NetResource(path: "/MyInfo/MyShare",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
}




public struct PersonalGetProfileModel{
    
    let imagePath:String?
    let gender:String?
    let nickName:String?
    let memberID:String?
    let status:String?
    let msg:String?

    init(json:JSON) {
        self.imagePath = json["imagePath"].string
        self.gender = json["gender"].string
        self.nickName = json["nickName"].string
        self.memberID = json["memberID"].string
        self.status = json["status"].string
        self.msg = json["msg"].string
    }
    
    static func createWithJson(_ json:JSON) -> PersonalGetProfileModel {
          return  PersonalGetProfileModel(json: json)
    }
}

extension PersonalGetProfileModel {
    
    static func Get(memberID: String, token: String, completion:@escaping (NetWorkResult<PersonalGetProfileModel>) -> Void){
        
        let parse:(JSONDictionary) -> PersonalGetProfileModel? = { jsondic in
                let json = JSON(jsondic)
                YCAccountModel.saveAPIAccount(json)
                let returnjson = PersonalGetProfileModel.createWithJson(json)
                return returnjson
           }
           let requestParameters: [String:Any] = [
              "MemberID":memberID,
              "token":token
           ]
          let netResource = NetResource(path: "/Member/GetMemberProfile",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
          YCProvider.requestDecoded(netResource, completion: completion)
       }

}




