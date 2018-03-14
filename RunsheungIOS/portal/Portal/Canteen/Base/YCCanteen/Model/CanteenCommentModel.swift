//
//  CanteenCommentModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire


struct CommentLis {
    struct Imagelis {
        let imgUrl: URL
        let ver: String
        init(with json: JSONDictionary) throws {
            guard let imgUrlString = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
            guard let imgUrl = URL(string: imgUrlString) else { throw ParseError.failedToGenerate(property: "imgUrl") }
            guard let ver = json["ver"] as? String else { throw ParseError.notFound(key: "ver") }
            self.imgUrl = imgUrl
            self.ver = ver
        }
        static func create(with json: JSONDictionary) -> Imagelis? {
            do {
                return try Imagelis(with: json)
            } catch {
                print("Imagelis json parse error: \(error)")
                return nil
            }
        }
    }
    let ImageList: [Imagelis]
    let commentCode: String
    let content: String
    let date: String
    let divCode: String
    let iconImgUrl: URL?
    let nickName: String?
    let rate: String
    let recommandCount: String
    let restaurantCode: String
    let restaurantName: String?
    let averagePay:String?
    let thumnailImage:URL?
    let customName:String?
    let restaurantType:String?
    init(with json: JSONDictionary) throws {
        guard let ImageListJSONArray = json["ImageList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "ImageList") }
        let ImageList = ImageListJSONArray.map({ Imagelis.create(with: $0) }).flatMap({ $0 })
        guard let commentCode = json["commentCode"] as? String else { throw ParseError.notFound(key: "commentCode") }
        guard let content = json["content"] as? String else { throw ParseError.notFound(key: "content") }
        guard let date = json["date"] as? String else { throw ParseError.notFound(key: "date") }
        guard let divCode = json["divCode"] as? String else { throw ParseError.notFound(key: "divCode") }
        guard let iconImgStr = json["iconImg"] as? String else { throw ParseError.notFound(key: "iconImg") }
        let iconImgUrl = URL(string: iconImgStr)
        self.nickName = json["nickName"] as? String
        guard let rate = json["rate"] as? String else { throw ParseError.notFound(key: "rate") }
        guard let recommandCount = json["recommandCount"] as? String else { throw ParseError.notFound(key: "recommandCount") }
        guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode") }
        self.restaurantName = json["restaurantName"] as? String
        self.averagePay = json["averagePay"] as? String
        guard let thumnailImageString = json["thumnailImage"] as? String else { throw ParseError.notFound(key: "thumnailImage")}
        self.thumnailImage = URL(string: thumnailImageString)
        self.customName = json["customName"] as? String
        self.restaurantType = json["restaurantType"] as? String
        self.ImageList = ImageList
        self.commentCode = commentCode
        self.content = content
        self.date = date
        self.divCode = divCode
        self.iconImgUrl = iconImgUrl
        self.rate = rate
        self.recommandCount = recommandCount
        self.restaurantCode = restaurantCode
    }
    
    static func create(with json: JSONDictionary) -> CommentLis? {
        do {
            return try CommentLis(with: json)
        } catch {
            print("CommentLis json parse error: \(error)")
            return nil
        }
    }
}


struct CanteenCommentModel {
    let List: [CommentLis]
    init(with json: JSONDictionary) throws {
        guard let ListJSONArray = json["List"] as? [JSONDictionary] else { throw ParseError.notFound(key: "List") }
        let List = ListJSONArray.map({ CommentLis.create(with: $0) }).flatMap({ $0 })
        self.List = List
    }
    static func create(with json: JSONDictionary) -> CanteenCommentModel? {
        do {
            return try CanteenCommentModel(with: json)
        } catch {
            print("CanteenCommentModel json parse error: \(error)")
            return nil
        }
    }
}

struct CanComment {
    
    var data:CanteenCommentModel? = nil
    let status:Int
    
    init?(with json:JSONDictionary) throws {
        if let dataDic = json["data"] as? JSONDictionary {
            self.data = CanteenCommentModel.create(with: dataDic)
        }
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        self.status = status
    }
    
    static func create(with json:JSONDictionary) -> CanComment? {
        do{
          return try CanComment(with: json)
        }catch {
          return nil
        }
    }

}


extension CanComment {
    
    static func GetWithDivCode(_ divCode:String,
                               currentPage:Int,
                               memberId:String,
                               token:String,
                               failureHandler:FailureHandler?,
                               completion:@escaping (CanComment?) -> Void)
    {
        
        let parse:(JSONDictionary) -> CanComment? = { json in
            let model =  CanComment.create(with:json)
            return model
        }
        let requestParameters:[String:Any] = [
           "divCode":divCode,
           "currentPage":currentPage,
           "userID":memberId,
           "token":token
        ]
        let resource = AlmofireResource(Type: .canteen,
                                        path:canteenMyCommentKey,
                                        method: .post,
                                        requestParameters: requestParameters,
                                        urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
      }

}





