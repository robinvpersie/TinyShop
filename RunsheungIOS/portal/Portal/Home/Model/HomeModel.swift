//
//  HomeModel.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON
import FMDB


struct Bannerdat {
    let imgUrl: String
    let url: String
    let ver: String
    
    init(imgUrl: String, url: String, ver: String){
        self.imgUrl = imgUrl
        self.url = url
        self.ver = ver
    }
    
    init?(json info: JSONDictionary) throws {
        guard let imgUrl = info["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
        guard let url = info["url"] as? String else { throw ParseError.notFound(key: "url") }
        guard let ver = info["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        self.imgUrl = imgUrl
        self.url = url
        self.ver = ver
    }
    
    static func getFromCache() -> [Bannerdat] {
        var banerArray = [Bannerdat]()
        let manager = YCDataManager.shareManager
        manager.open()
        let sql = "select * from Bannerdat"
        if let result = try? manager.dataBase!.executeQuery(sql, values: nil){
            while result.next() {
                if let imgurl = result.string(forColumn: "imgUrl"),
                let url = result.string(forColumn: "url"),
                let ver = result.string(forColumn: "ver"){
                  let banner = Bannerdat(imgUrl: imgurl, url: url, ver: ver)
                  banerArray.append(banner)
                }
            }
        }
        manager.close()
        return banerArray
    }
    
    static func cacheToDB(bannerDat:[Bannerdat]){
        Bannerdat.deleteCache()
        let manager = YCDataManager.shareManager
        manager.open()
        let createsql = "create table if not exists Bannerdat (imgUrl text,url text,ver text)"
        let success = manager.dataBase?.executeStatements(createsql)
        if success == true {
            bannerDat.forEach({ banner in
                let insersql = "insert into Bannerdat (imgUrl,url,ver) values ('\(banner.imgUrl)','\(banner.url)','\(banner.ver)')"
                do {
                    try manager.dataBase?.executeUpdate(insersql, values: nil)
                }catch let error{
                    print(error.localizedDescription)
                }
 
            })
        }
        manager.close()
     }
    
    static func deleteCache(){
        let manager = YCDataManager.shareManager
        manager.open()
        let deletesql = "delete from Bannerdat"
        do {
          try manager.dataBase?.executeUpdate(deletesql, values: nil)
        }catch _ {}
        manager.close()
    }
    
    static func createWithJson(_ json:JSONDictionary) -> Bannerdat? {
        do {
          return try Bannerdat(json: json)
        }catch{
          return nil
        }
    }
}


struct Newsdat {
    let content: String
    let imgUrl: String
    let read: String
    let title: String
    let url: URL
    let ver: String
    let NewsSeq:Int
    let ReplyCount:Int
    let date:String
    
    
    init(content:String,imgUrl:String,read:String,title:String,url:URL,ver:String,NewsSeq:Int,ReplyCount:Int,date:String){
        self.content = content
        self.imgUrl = imgUrl
        self.read = read
        self.title = title
        self.url = url
        self.ver = ver
        self.NewsSeq = NewsSeq
        self.ReplyCount = ReplyCount
        self.date = date
   }
    
    init?(json info: JSONDictionary) throws {
        
        guard let content = info["content"] as? String else { throw ParseError.notFound(key: "content") }
        guard let imgUrl = info["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
        guard let read = info["read"] as? String else { throw ParseError.notFound(key: "read") }
        guard let title = info["title"] as? String else { throw ParseError.notFound(key: "title")}
        guard let urlString = info["url"] as? String else { throw ParseError.notFound(key: "url") }
        guard let url = URL(string: urlString) else { throw ParseError.failedToGenerate(property: "url") }
        guard let ver = info["ver"] as? String else { throw ParseError.notFound(key: "ver") }
        guard let newsseq = info["NewsSeq"] as? Int else { throw ParseError.notFound(key: "NewsSeq") }
        guard let replycount = info["ReplyCount"] as? Int else { throw ParseError.notFound(key: "ReplyCount")}
        guard let date = info["date"] as? String else { throw ParseError.notFound(key: "date") }
        self.content = content
        self.imgUrl = imgUrl
        self.read = read
        self.title = title
        self.url = url
        self.ver = ver
        self.NewsSeq = newsseq
        self.ReplyCount = replycount
        self.date = date
    }
    
    
    static func cacheToDB(newsData:[Newsdat]){
        Newsdat.deleteCache()
        let manager = YCDataManager.shareManager
        manager.open()
        let createsql = "create table if not exists Newsdat (content text,imgUrl text,read text,title text,url text,ver text,NewsSeq integer,ReplyCount integer,date text)"
        let success = manager.dataBase?.executeStatements(createsql)
        if success == true {
            newsData.forEach({ news in
               let insersql = "insert into Newsdat (content,imgUrl,read,title,url,ver,NewsSeq,ReplyCount,date) values ('\(news.content)','\(news.imgUrl)','\(news.read)','\(news.title)','\(news.url.absoluteString)','\(news.ver)','\(news.NewsSeq)','\(news.ReplyCount)','\(news.date)')"
                do {
                    try manager.dataBase?.executeUpdate(insersql, values: nil)
                }catch let error{
                    print(error.localizedDescription)
                }

            })
            manager.close()
        }
    }
    
    static func getFromCache() -> [Newsdat]{
       var newArray = [Newsdat]()
       let manager = YCDataManager.shareManager
       manager.open()
        let getsql = "select * from Newsdat"
        if let reuslt:FMResultSet = try? manager.dataBase!.executeQuery(getsql, values: nil){
           while reuslt.next() {
            if let content = reuslt.string(forColumn: "content"),
              let imgUrl = reuslt.string(forColumn: "imgUrl"),
              let read = reuslt.string(forColumn: "read"),
              let title = reuslt.string(forColumn: "title"),
              let url = reuslt.string(forColumn: "url"),
              let linkurl = URL(string: url),
              let ver = reuslt.string(forColumn: "ver"),
              let date = reuslt.string(forColumn: "date"){
                let NewsSeq = reuslt.long(forColumn: "NewsSeq")
                let ReplyCount = reuslt.long(forColumn: "ReplyCount")
                let news:Newsdat = Newsdat(content:content,
                                      imgUrl:imgUrl,
                                      read:read,
                                      title:title,
                                      url:linkurl,
                                      ver:ver,
                                      NewsSeq:NewsSeq,
                                      ReplyCount:ReplyCount,
                                      date:date)
                newArray.append(news)
              }
            }
        }
        manager.close()
        return newArray
     }
    
    static func deleteCache(){
        let manager = YCDataManager.shareManager
        manager.open()
        let deletesql = "delete from Newsdat"
        do {
           try manager.dataBase!.executeUpdate(deletesql, values: nil)
        }catch _ {}
        manager.close()
     }
    
    static func createWithJson(_ json:JSONDictionary) -> Newsdat? {
        do {
           return try Newsdat(json: json)
        }catch {
            return nil
        }
    }
}


struct MainModel {
    
    let bannerData: [Bannerdat]
    let newsCurrentPage: Int
    let newsData: [Newsdat]
    let newsNextPage: Int
    let currentVersion: String?
    let currentState: String?
    
    init?(json info: JSONDictionary) throws {
        guard let bannerDataJSONArray = info["bannerData"] as? [JSONDictionary] else { throw ParseError.notFound(key: "bannerData") }
        let bannerData = bannerDataJSONArray.map({ Bannerdat.createWithJson($0)}).flatMap({ $0 })
        guard let newsCurrentPage = info["currentPage"] as? Int else { throw ParseError.notFound(key: "currentPage")}
        guard let newsDataJSONArray = info["newsData"] as? [JSONDictionary] else { throw ParseError.notFound(key: "newsData") }
        let newsData = newsDataJSONArray.map({ Newsdat.createWithJson($0) }).flatMap({ $0 })
        guard let newsNextPage = info["nextPage"] as? Int else { throw ParseError.notFound(key: "nextPage") }
        self.currentVersion = info["menu_ver"] as? String
        self.currentState = info["menu_state"] as? String
        self.bannerData = bannerData
        self.newsCurrentPage = newsCurrentPage
        self.newsData = newsData
        self.newsNextPage = newsNextPage
    
    }
    
    static func createWithJson(_ json:JSONDictionary) -> MainModel? {
        do {
           return try MainModel(json: json)
        }catch {
           return nil
        }
        
    }
    
    static func mainHome(place: String, bannerType: Int, currentPage: Int, completion:@escaping (NetWorkResult<MainModel>) -> Void)
    {
		
        let parse:(JSONDictionary) -> MainModel? = { Data in
            let model = MainModel.createWithJson(Data)
            return model
        }
        let requestParameters: [String:Any] = [
            "place":place,
            "bannerType":bannerType,
            "CurrentPage":currentPage
        ]
        let netresource = NetResource(baseURL: BaseType.PortalBase.URI,
                                      path: "/JsonCreate/JsonBannerCreate",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netresource, completion: completion)
    }

    
    
}

