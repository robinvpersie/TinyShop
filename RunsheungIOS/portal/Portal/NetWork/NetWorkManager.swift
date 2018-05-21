//
//  File.swift
//  Portal
//
//  Created by linpeng on 2016/11/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift
import AdSupport


public let baseImgUrl = "http://222.240.51.146:8488"
public let recommendlistAPI = "/media_json/main_data.js"
public let HomeAPI = "/portal_json/main_data.js"
public let newsAPI = "/portal_json/news_data.js"
public let AddMemberAPI = "/Member/AddMemberENC"
public let loginAPI = "/Member/MemberLoginENC"
public let SMSAuthAPI = "/Member/MemberSMSAuth"


struct CheckToken{
    
    var status:String = ""
    var ssoId:String = ""
    var custom_code:String = ""
    var flag:String = ""
    var msg:String = ""
    var token:String = ""
    var deviceNo:String = ""
    var newtoken:String = ""
    
    init(json:JSONDictionary){
        if let status:String = json["status"] as? String,status == "1" {
          self.status = json["status"] as! String
          self.ssoId = json["ssoId"] as! String
          self.custom_code = json["custom_code"] as! String
          self.flag = json["flag"]  as! String
          self.msg = json["msg"] as! String
          self.token = json["token"] as! String
          self.deviceNo = json["deviceNo"] as! String
          var idfa:String = ""
          if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          }
          self.newtoken = self.token + "|" + self.ssoId + "|" + self.custom_code + "|" + idfa
      }

    }
    
   static func chekcTokenAPI(completion:@escaping (NetWorkResult<CheckToken>) -> Void){
        
        let parse:(JSONDictionary) -> CheckToken? = { json in
            let checkToken = CheckToken(json: json)
            return checkToken
        }
        var idfa:String
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }else {
            idfa = UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
        let sign = idfa + "ycssologin1212121212121"
        let sign512 = sign.sha512()
        let requestParameters:[String:Any] = [
           "deviceNo":idfa,
           "sign":sign512,
        ]
        #if !DEBUG
            let baseURI = URL(string: "http://192.168.2.165:89")!
        #else
            let baseURI = URL(string:"http://member.dxbhtm.com:89")!
        #endif
        let netResource = NetResource(baseURL: baseURI,
                                      path: "/ws2016/srvJoinModule/10_Login/checkLogin_0911",
                                      method: .get,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
  
    
    
}

public class NetWorkManager{
    static let manager = NetWorkManager()
    private init(){}
}


extension NetWorkManager {
    
    
    
    
    func Home(failureHandler:FailureHandler?,
              completion:@escaping (MainModel?) -> Void)
    {
        
        let parse:(JSONDictionary) -> MainModel? = { Data in
            let model = MainModel.createWithJson(Data)
            return model
        }
        let resource = AlmofireResource(Type: .PortalBase,
                                        path: HomeAPI,
                                        method: .get,
                                        requestParameters: nil,
                                        parse: parse)
        AlamofireRequest(resource: resource,
                         failure: failureHandler,
                         completion: completion)
    }
    
    
    func news(failureHandler:FailureHandler?,
              completion:@escaping (([Newsdat],String,String)?) -> Void){
        
        let parse:(JSONDictionary) -> ([Newsdat],String,String)? = { Data in
            var DataArray = [Newsdat]()
            let newsCurrentPage = Data["newsCurrentPage"] as? String
            let newsNextPage = Data["newsNextPage"] as? String
            let bannerData = Data["newsData"] as? [JSONDictionary]
            bannerData?.forEach({ json in
                let model = Newsdat.createWithJson(json)
                DataArray.append(model!)
            })
            return (DataArray,newsCurrentPage!,newsNextPage!)
        }
        let resource = AlmofireResource(Type: .PortalBase,
                                        path: newsAPI,
                                        method: .get,
                                        requestParameters: nil,
                                        parse: parse)
        AlamofireRequest(resource: resource,
                         failure: failureHandler,
                         completion: completion)
    }
    
    func biz(divCode:String,
             restaurantCode:String,
             tableName:String,
             token:String,
             completion:@escaping(NetWorkResult<JSONDictionary>)->Void)
    {
        let parse:(JSONDictionary) -> (JSONDictionary) = { data in
            return data
        }
        let requestParameters:[String:Any] = [
            "restaurantCode":restaurantCode,
            "tableName":tableName,
            "userID":YCAccountModel.getAccount()?.memid ?? "",
            "token":token
        ]
        let netResource = NetResource(baseURL: BaseType.canteen.URI,
                                      path: "/AddQRCodeReserve",
                                      method: .post,
                                      parameters: requestParameters,
                                      parameterEncoding: URLEncoding(destination: .queryString),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
    
   func pay(divcode:String,
         restaurantCode:String,
         tempOrderNum:String,
         failureHandler:FailureHandler?,
         completion:@escaping (JSONDictionary?)->Void)
   {
        let parse:(JSONDictionary) -> (JSONDictionary) = { data in
            return data
        }
        let userId = YCAccountModel.getAccount()?.memid ?? ""
        let requestParameters:[String:Any] = [
            "divCode":divcode,
            "restaurantCode":restaurantCode,
            "userID":userId,
            "tempOrderNum":tempOrderNum
        ]
        let resource = AlmofireResource(Type: .canteen,
                                        path: set_Order_ByQR,
                                        method: .post,
                                        requestParameters: requestParameters,
                                        urlEncoding: URLEncoding(destination: .queryString),
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    
    }
    
    func deleteCanteenCollect(restaurantCode:String,
                              memid:String,
                              token:String,
                              failureHandler:FailureHandler?,
                              completion:@escaping (JSONDictionary?)->Void)
    {
        let parse:(JSONDictionary) -> (JSONDictionary) = { data in
          return data
        }
        let requestParameters = [
           "customCode":memid,
           "restaurantCode":restaurantCode,
           "token":token
        ]
        let resource = AlmofireResource(Type: .canteen,
                                        path: addFavoriteKey,
                                        method: .post,
                                        requestParameters: requestParameters,
                                        urlEncoding: URLEncoding(destination: .queryString),
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
}


///login

extension NetWorkManager {
    
    func SMSAuthNumSend(HPnum:String?,
                        failureHandler:FailureHandler?,
                        completion:@escaping (JSONDictionary?) -> Void)
    {
        
        let parse:(JSONDictionary) -> JSONDictionary? = { Data in
            return Data
        }
        let requestParameters:JSONDictionary = ["HPnum":HPnum ?? ""]
        let resource = AlmofireResource(Type: .PortalBase,
                                        path: "/Member/SMSAuthNumSend",
                                        method: .get,
                                        requestParameters: requestParameters,
                                        parse: parse)
        AlamofireRequest(resource: resource,
                         failure: failureHandler,
                         completion: completion)
    }
    
    
    
    func AddMember(HPnum:String?,
                   Password:String?,
                   failureHandler:FailureHandler?,
                   completion:@escaping (JSONDictionary?) -> Void)
    {
        let parse:(JSONDictionary) -> JSONDictionary? = { Data in
            return Data
        }
        let requestParameters:JSONDictionary = [
            "MemberID":HPnum ?? "",
            "Password":Password ?? ""
        ]
        let resource = AlmofireResource(Type: .PortalBase,
                                        path: AddMemberAPI,
                                        method: .get,
                                        requestParameters: requestParameters,
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)

    }
    
    func login<T>(MemberID:String?,
                  Password:String?,
                  failureHandler:((Error) -> Void)?,
                  completion:@escaping (T) -> Void)
    {
        let parse:((JSON) -> T) = { value in
            return (value as? T)!
        }
        let requestParameters:JSONDictionary = [
            "MemberID":MemberID ?? "",
            "Password":Password ?? ""
        ]
        let url = BaseType.PortalBase.baseURL + loginAPI
        Alamofire.request(url, method: .post,parameters:requestParameters).responseJSON {
            response in
            switch response.result{
            case .success(let value):
                completion(parse(JSON(value)))
            case .failure(let error):
                failureHandler?(error)
            }
        }
    }
    
    
    func MemberSMSAuth(AuthNum:String?,
                       failureHandler:FailureHandler?,
                       completion:@escaping (JSONDictionary?) -> Void)
    {
        let parse:(JSONDictionary) -> JSONDictionary? = { Data in
            return Data
        }
        let requestParameters:JSONDictionary = [
            "AuthNum":AuthNum ?? ""
        ]
        let resource = AlmofireResource(Type: .PortalBase,
                                        path: SMSAuthAPI,
                                        method: .get,
                                        requestParameters: requestParameters,
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
      }
    
    
    
    func SendSMSAuthWithPhoneNumber(_ phonenumber:String?,
                                    completion:@escaping (NetWorkResult<JSONDictionary>) -> Void)
    {
        
        let parse:(JSONDictionary) -> JSONDictionary? = { data in
             return data
        }
        let requestParameters:JSONDictionary = [
           "HPnum":phonenumber ?? ""
        ]
        let resource = NetResource(path: "/Member/SMSAuthNumSend",
                                   method: .post,
                                   parameters: requestParameters,
                                   parse: parse)
        YCProvider.requestDecoded(resource, completion: completion)
    }
}


let PersonalSetStar = "/NewsView/SetRecommand"

let canteen_commentUploadPath = "/Common/MultiFileUploader.ashx"
let set_Order_ByQR = "/SetOrderByQR"
let addFavoriteKey = "/AddFavorite"



public extension NetWorkManager {
    
    public func SetStar(newsSeq:Int,
                        replySeq:Int,
                        failureHandler:FailureHandler?,
                        completion:@escaping (JSONDictionary?) -> Void)
    {
        
        let parse:(JSONDictionary) -> JSONDictionary = { json in
            return json
        }
        var requestParameter = [String:Any]()
        if let account = YCAccountModel.getAccount(),
            let memberID = account.memid {
              requestParameter = ["NewsSeq":newsSeq,
                                  "ReplySeq":replySeq,
                                  "MemberID":memberID]
        }
        let resource = AlmofireResource(Type: .PortalBase,
                                        path:PersonalSetStar,
                                        method: .post,
                                        requestParameters: requestParameter,
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
   }
}


public let KLOnlineVideoTypeTotal = "/api/VideoList"
public let KLOnlineVideoSearchKeyAPI = "/api/Search"
public let KLOnlineActivityTypeAndSearchKeyAPI = "/api/Activity"
public let KLOnlineMyCenterTypeApiKey = "/api/MyKuangle"
public let KLOnlineArtCenterApiKey = "/api/ArtCenter"
public let KLOnlineMovieBannerApiKey = "/api/Cinema"
public let KLOnlineGetMovieApiKey = "/api/Movie"
public let KLOnlineHomeDataApiKey = "/api/KLHome"
public let KLOnlineVideoPlayApiKey = "/WAP/videoplay"
public let KLOnlineActivityStarKey = "/api/Project"
public let KLOnlineCommentKey = "/api/Comment"
public let KLOnlineScreenKey = "/api/Screening"
public let KLOnlineChooseSeatsKey = "/api/ChooseSeat"
public let KLOnlineVideoPlayBaseUrl = "http://222.240.51.144:89"

public let canteenSquareKey = "/Location/GetAreaAndSquare"
public let canteenMainPagekey = "/MainPage"
public let canteenOrderFoodKey = "/RestaurantView"
public let canteenCommonCodeKey = "/CommonCode"
public let canteenRestaurantListKey = "/RestaurantList"
public let canteenRestaurantMenuListKey = "/RestaurantMenuList"
public let canteenAddReserveKey = "/AddReserve"
public let canteenAddReserveListKey = "/ArrReserveList"
public let canteenAddOrderKey = "/AddOrder"
public let canteenDinnerTableListKey = "/DinnerTable/ReserveTableList"
public let AddGroupMemberOrderKey = "/AddGroupMemberOrder"
public let canteenGetOrderInfoKey = "/GetOrderInfo"
public let canteenGetReserveKey = "/GetReserve"
public let canteenSetCancelReserveKey = "/SetCancelReserve"
public let canteenAddCommentKey = "/AddComment"
public let canteenMyCommentKey = "/MyComment"
public let canteenAddPaymentAdvanceKey = "/AddPaymentAdvance"
public let canteenCouponKey = "/api/Coupon"



public let shopBrandKey = "/api/ycO2O/getBrandMainList"
#if !DEBUG
public let shopGoodListKey = "/Freshmart/Goods/GetGoodsList"
#else
public let shopGoodListKey = "/Goods/GetGoodsList"
#endif
public let shopFloorDetailKey = "/api/ycO2o/getFloorDetail"
public let shopMallMainKey = "/api/ycO2o/getMallMain"
#if !DEBUG
public let shopClassifyKey = "/Freshmart/Goods/GetCategoryOfList"
#else
public let shopClassifyKey = "/Goods/GetCategoryOfList"
#endif


