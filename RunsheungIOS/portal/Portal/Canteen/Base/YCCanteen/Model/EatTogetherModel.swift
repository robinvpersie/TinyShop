//
//  EatTogetherModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Orderlis {
    
    let amount: Int
    let itemCode: String
    let itemName: String
    let orderAmount: Int
    let quantity: Int
    init(with json: JSONDictionary) throws {
        guard let amount = json["amount"] as? Int else { throw ParseError.notFound(key: "amount") }
        guard let itemCode = json["itemCode"] as? String else { throw ParseError.notFound(key: "itemCode") }
        guard let itemName = json["itemName"] as? String else { throw ParseError.notFound(key: "itemName") }
        guard let orderAmount = json["orderAmount"] as? Int else { throw ParseError.notFound(key: "orderAmount") }
        guard let quantity = json["quantity"] as? Int else { throw ParseError.notFound(key: "quantity") }
        self.amount = amount
        self.itemCode = itemCode
        self.itemName = itemName
        self.orderAmount = orderAmount
        self.quantity = quantity
    }
    static func create(with json: JSONDictionary) -> Orderlis? {
        do {
            return try Orderlis(with: json)
        } catch {
            print("Orderlis json parse error: \(error)")
            return nil
        }
    }
}

extension Orderlis {
   
        func configureCell(_ cell: OrderConfirmBodyfoodCell) {
            cell.leadlable.text = itemName
            cell.trainglable.text = "\(amount)元"
            cell.centerlable.text = "x\(quantity)"
        }
    
        func height()->CGFloat {
           return OrderConfirmBodyfoodCell.getHeight()
        }
    
        var cellDescriptor:CellDesciptor {
           return CellDesciptor(reuseIdentifier: UITableViewCell.portal_reuseIdentifier, configure: self.configureCell, height: self.height)
        }
}




struct Groupmemberlis {
    
    var OrderList: [Orderlis]
    var amountSum: Int? = nil
    var iconImg: URL? = nil
    let masterYN: String
    let memberID: String
    let myYN: String
    var nickName: String? = nil
    let orderYN: String
    let status: String
    init(with json: JSONDictionary) throws {
        guard let OrderListJSONArray = json["OrderList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "OrderList") }
        let OrderList = OrderListJSONArray.map({ Orderlis.create(with: $0) }).flatMap({ $0 })
        if let amountSum = json["amountSum"] as? Int {
           self.amountSum = amountSum
        }
        guard let iconImgString = json["iconImg"] as? String else { throw ParseError.notFound(key: "iconImg") }
        self.iconImg = URL(string: iconImgString)
        guard let masterYN = json["masterYN"] as? String else { throw ParseError.notFound(key: "masterYN") }
        guard let memberID = json["memberID"] as? String else { throw ParseError.notFound(key: "memberID") }
        guard let myYN = json["myYN"] as? String else { throw ParseError.notFound(key: "myYN") }
        if let nickName = json["nickName"] as? String {
           self.nickName = nickName
        }
        guard let orderYN = json["orderYN"] as? String else { throw ParseError.notFound(key: "orderYN") }
        guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
        self.OrderList = OrderList
        self.masterYN = masterYN
        self.memberID = memberID
        self.myYN = myYN
        self.orderYN = orderYN
        self.status = status
    }
    static func create(with json: JSONDictionary) -> Groupmemberlis? {
        do {
            return try Groupmemberlis(with: json)
        } catch {
            print("Groupmemberlis json parse error: \(error)")
            return nil
        }
    }
}



struct EatTogetherModel {
    struct Data {
        let GroupMemberList: [Groupmemberlis]
        let address: String
        let desc: String
        var gameCode: String? = nil
        var gameName: String? = nil
        var gameStatus: String? = nil
        var gameUrl:String? = nil
        let gameYN: String
        let goldenBellYN: String?
        var goldenbellType: String?
        let groupDesc: String
        let groupId: String
        var groupStatus: String? = nil
        let imgUrl: URL
        let totalAmount: Int
        let restaurantCode:String
        let orderMemberCnt:Int
        var groupFixYN:String? = nil
        var groupMasterYN:String? = nil
        init(with json: JSONDictionary) throws {
            guard let GroupMemberListJSONArray = json["GroupMemberList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "GroupMemberList") }
            let GroupMemberList = GroupMemberListJSONArray.map({ Groupmemberlis.create(with: $0) }).flatMap({ $0 })
            guard let address = json["address"] as? String else { throw ParseError.notFound(key: "address") }
            guard let desc = json["desc"] as? String else { throw ParseError.notFound(key: "desc") }
            if let gameCode = json["gameCode"] as? String {
              self.gameCode = gameCode
            }
            if let gameStatus = json["gameStatus"] as? String {
              self.gameStatus = gameStatus
            }
            if let gameName = json["gameName"] as? String {
              self.gameName = gameName
            }
            if let groupMasterYN = json["groupMasterYN"] as? String {
               self.groupMasterYN = groupMasterYN
            }
            if let gameurl = json["gameUrl"] as? String {
               self.gameUrl = gameurl
            }
            guard let orderMemberCnt = json["orderMemberCnt"] as? Int else { throw ParseError.notFound(key: "orderMemberCnt") }
            guard let restaurantCode = json["restaurantCode"] as? String else { throw ParseError.notFound(key: "restaurantCode")}
            guard let gameYN = json["gameYN"] as? String else { throw ParseError.notFound(key: "gameYN") }
            self.goldenBellYN = json["goldenBellYN"] as? String
            self.goldenbellType = json["goldenbellType"] as? String
            guard let groupDesc = json["groupDesc"] as? String else { throw ParseError.notFound(key: "groupDesc") }
            guard let groupId = json["groupId"] as? String else { throw ParseError.notFound(key: "groupId") }
            if let groupStatus = json["groupStatus"] as? String {
               self.groupStatus = groupStatus
            }
            if let groupFixYN = json["groupFixYN"] as? String {
               self.groupFixYN = groupFixYN
            }
            guard let imgUrlString = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
            guard let imgUrl = URL(string: imgUrlString) else { throw ParseError.failedToGenerate(property: "imgUrl") }
            guard let totalAmount = json["totalAmount"] as? Int else { throw ParseError.notFound(key: "totalAmount") }
            self.GroupMemberList = GroupMemberList
            self.address = address
            self.desc = desc
            self.gameYN = gameYN
            self.groupDesc = groupDesc
            self.groupId = groupId
            self.imgUrl = imgUrl
            self.totalAmount = totalAmount
            self.restaurantCode = restaurantCode
            self.orderMemberCnt = orderMemberCnt
        }
        static func create(with json: JSONDictionary) -> Data? {
            do {
                return try Data(with: json)
            } catch {
                print("Data json parse error: \(error)")
                return nil
            }
        }
    }
    let data: Data
    let msg: String
    let status: Int
    init(with json: JSONDictionary) throws {
        guard let dataJSONDictionary = json["data"] as? JSONDictionary else { throw ParseError.notFound(key: "data") }
        guard let data = try? Data(with: dataJSONDictionary) else { throw ParseError.failedToGenerate(property: "data") }
        guard let msg = json["msg"] as? String else { throw ParseError.notFound(key: "msg") }
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        self.data = data
        self.msg = msg
        self.status = status
    }
    static func create(with json: JSONDictionary) -> EatTogetherModel? {
        do {
            return try EatTogetherModel(with: json)
        } catch {
            print("EatTogetherModel json parse error: \(error)")
            return nil
        }
    }
}

extension EatTogetherModel {
    
    static func Get(groupId:String,
                    token:String,
                    memberId:String,
                    failureHandler:FailureHandler?,
                    completion:@escaping (EatTogetherModel?) -> Void)
    {
        
        let parse:(JSONDictionary) -> EatTogetherModel? = { json in
            let model = EatTogetherModel.create(with: json)
            return model
        }
        let requestParameter:[String:Any] = [
           "token":token,
           "groupId":groupId,
           "memberId":memberId
        ]
        let resource = AlmofireResource(Type: .canteen, path: "/ArrGroupMember", method: .post, requestParameters: requestParameter,urlEncoding: URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)


    }
}





//添加菜单
public func addOrderWithGroup(_ GroupId:String,
                              userid:String,
                              token:String,
                              uploadJson:[[compareMenuModel]],
                              failureHandler:FailureHandler?,
                              completion:@escaping (Int) -> Void)
   {
    
      var uploadDic = [[String:Any]]()
      uploadDic = uploadJson.map({
        var dic = [String:Any]()
        dic["itemCode"] = $0[0].menulis.itemCode
        dic["itemAmount"] = "\($0[0].menulis.itemAmount)"
        dic["count"] = $0.count
        return dic
      })
      let kim = KimRounter(groupMemberId: userid, token: token, groupId: GroupId, Json: uploadDic)
    do {
       let urlrequest = try kim.asURLRequest()
        Alamofire.request(urlrequest).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let json):
                let json = JSON(json)
                if let status = json["status"].int {
                   completion(status)
                }
            case .failure(let error):
                failureHandler?(.other(error),error.localizedDescription)
            }
        })
    }catch {
       failureHandler?(.other(error),error.localizedDescription)
    }
}


/// 删除自己点的菜
///
/// - Parameters:
///   - groupMemberId: memberId
///   - groupId: groupId

public func DelGroupMemberOrderWith(_ groupMemberId:String,
                                    groupId:String,
                                    token:String,
                                    failureHandler:FailureHandler?,
                                    completion:@escaping (JSON?) -> Void)
{
    
    let parse:(JSONDictionary) -> (JSON?) = { json in
         let json = JSON(json)
         return json
    }
    let token = YCAccountModel.getAccount()?.token
    let requestParameter:[String:Any] = [
       "groupMemberId":groupMemberId,
       "groupId":groupId,
       "token":token
    ]
    let resource = AlmofireResource(Type: .canteen, path: "/DelGroupMemberOrder", method: .post, requestParameters: requestParameter, urlEncoding: URLEncoding(destination: .queryString), parse: parse)
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
}


/// 删除一起吃的人
///
/// - Parameters:
///   - memberId: 自己的memberId
///   - groupId: groupId
///   - cancelMemberId: 删除的人的memberId

public func SetGroupMemberCancel(groupId:String,
                                 cancelMemberId:String,
                                 memberId:String,
                                 token:String,
                                 failureHandler:FailureHandler?,
                                 completion:@escaping (JSON?) ->Void)
{
    
    let parse:(JSONDictionary) -> JSON? = { json in
        let json = JSON(json)
        return json
    }
   
    let requestParameter:[String:Any] = [
        "memberId":memberId,
        "groupId":groupId,
        "cancelMemberId":cancelMemberId,
        "token":token
    ]
    let resource = AlmofireResource(Type: .canteen, path: "/SetGroupMemberCancel", method: .post, requestParameters: requestParameter, urlEncoding: URLEncoding(destination: .queryString), parse: parse)
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    
}



struct GroupInfoModel{
    
    struct Dat {
        let address:String
        let businessTime:String
        let goldenbellType:String
        let imgurl:URL?
        let restaurantName:String
        let status:String
        let phone:String
        init?(json:JSONDictionary) throws {
            guard let address = json["address"] as? String else { throw ParseError.notFound(key: "address") }
            guard let businessTime = json["businessTime"] as? String else { throw ParseError.notFound(key:"businessTime")}
            guard let goldenbelltype = json["goldenbellType"] as? String else { throw ParseError.notFound(key: "goldenbellType")}
            guard let imgUrlString = json["imgUrl"] as? String else { throw ParseError.notFound(key: "imgUrl") }
            self.imgurl = URL(string: imgUrlString)
            guard let resturantName = json["restaurantName"] as? String else { throw ParseError.notFound(key: "restaurantName") }
            guard let status = json["status"] as? String else { throw ParseError.notFound(key: "status") }
            guard let phone = json["phone"] as? String else { throw ParseError.notFound(key: "phone") }
            self.address = address
            self.businessTime = businessTime
            self.goldenbellType = goldenbelltype
            self.restaurantName = resturantName
            self.status = status
            self.phone = phone
        }
        
        static func createWithJson(_ json:JSONDictionary) -> Dat? {
            do{
             return try Dat(json: json)
            }catch {
             return nil
            }
        
        }
    }
    
    let status:Int
    let data:Dat?
    let msg:String?
    
    init?(json:JSONDictionary) throws {
        
        guard let status = json["status"] as? Int else { throw ParseError.notFound(key: "status") }
        guard let dataJsonDic = json["data"] as? JSONDictionary else { throw ParseError.notFound(key: "data") }
        let data =  Dat.createWithJson(dataJsonDic)
        self.status = status
        self.data = data
        self.msg = json["msg"] as? String
    }
    
    static func createWithJson(_ json:JSONDictionary) -> GroupInfoModel? {
        do{
          return try GroupInfoModel(json: json)
        }catch {
          return nil
        }
    }
}


extension GroupInfoModel {
    
/// 获取推送过来的人的数据
///
/// - Parameters:
///   - groupId: groupId
///   - memberId:
///   - token:
    static func GetGroupInviteInfo(groupId:String,
                               memberId:String,
                               token:String,
                               failureHandler:FailureHandler?,
                               completion:@escaping (JSONDictionary?) ->Void) {
    let parse:(JSONDictionary) -> JSONDictionary? = { json in
            return json
    }
    let requestParameter = [
       "groupID":groupId,
       "memberID":memberId,
       "token":token
    ]
    let resource = AlmofireResource(Type: .canteen, path: "/GetGroupInviteInfo", method: .post, requestParameters: requestParameter, urlEncoding: URLEncoding(destination: .queryString), parse: parse)
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
}
    
}


/// 加入群组
///
/// - Parameters:
///   - groupMemberId: 加入的MemberId
///   - groupId: 组的ID
///   - token: 加入的人的token
public func SetJoinGroup(groupMemberId:String,
                         groupId:String,
                         token:String,
                         failureHandler:FailureHandler?,
                         completion:@escaping (Int?) ->Void) {
    let parse:(JSONDictionary) -> Int? = { json in
        print(json)
       let swiftjson = JSON(json)
       return swiftjson["status"].int
    }
    let requestParameter = [
       "groupMemberId":groupMemberId,
       "groupId":groupId,
       "token":token
    ]
    let resource = AlmofireResource(Type: .canteen, path: "/SetJoinGroup", method: .post, requestParameters: requestParameter, urlEncoding: URLEncoding(destination: .queryString), parse: parse)
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
}



/// 获得支付的reserveId
///
/// - Parameters:
public func AddGroupOrder(groupMasterId:String,groupId:String,token:String,failureHandler:FailureHandler?,completion:@escaping (JSONDictionary?)->Void) {
    
    let parse:(JSONDictionary) -> JSONDictionary = { json in
         return json
    }
    let requestParameter = [
       "groupMasterId":groupMasterId,
       "groupId":groupId,
       "token":token
    ]
    let resource = AlmofireResource(Type: .canteen, path: "/AddGroupOrder", method: .post, requestParameters: requestParameter, urlEncoding: URLEncoding.init(destination: .queryString), parse: parse)
    AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
}


