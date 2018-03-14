//
//  CanteenHomeTypeModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

///////////A
struct CanteenAllTypeModel{
    let CUSTOMCount: String
    let MAINCode: String
    let MAINCodeName: String
    let REFCode1: String
    let SUBCode: String
    let SUBCodeName: String
    init(with json: JSONDictionary) throws {
        guard let CUSTOMCount = json["CUSTOM_COUNT"] as? String else { throw ParseError.notFound(key: "CUSTOM_COUNT") }
        guard let MAINCode = json["MAIN_CODE"] as? String else { throw ParseError.notFound(key: "MAIN_CODE") }
        guard let MAINCodeName = json["MAIN_CODE_NAME"] as? String else { throw ParseError.notFound(key: "MAIN_CODE_NAME") }
        guard let REFCode1 = json["REF_CODE1"] as? String else { throw ParseError.notFound(key: "REF_CODE1") }
        guard let SUBCode = json["SUB_CODE"] as? String else { throw ParseError.notFound(key: "SUB_CODE") }
        guard let SUBCodeName = json["SUB_CODE_NAME"] as? String else { throw ParseError.notFound(key: "SUB_CODE_NAME") }
        self.CUSTOMCount = CUSTOMCount
        self.MAINCode = MAINCode
        self.MAINCodeName = MAINCodeName
        self.REFCode1 = REFCode1
        self.SUBCode = SUBCode
        self.SUBCodeName = SUBCodeName
    }
    static func create(with json: JSONDictionary) -> CanteenAllTypeModel? {
        do {
            return try CanteenAllTypeModel(with: json)
        } catch {
            print("CanteenAllTypeModel json parse error: \(error)")
            return nil
        }
    }
}

extension CanteenAllTypeModel{
    
    static func GetWithdivCode(_ divCode:String,codeType:String,failureHandler:FailureHandler?,completion:@escaping ([CanteenAllTypeModel]?) -> Void){
        
        let parse:(JSONDictionary) -> [CanteenAllTypeModel]? = { json in
            print(json)
            guard let dataJSONArray = json["data"] as? [JSONDictionary] else { return nil }
            let array = dataJSONArray.map({ CanteenAllTypeModel.create(with: $0) }).flatMap({ $0 })
            return array
        }
        let resource = AlmofireResource(Type: .canteen, path:canteenCommonCodeKey, method: .post, requestParameters: ["divCode":divCode,"codeType":codeType], urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
      }
}




////////////B
struct Floorlis {
    let CUSTOMCount: String
    let MAINCode: String
    let MAINCodeName: String
    let SUBCode: String
    let SUBCodeName: String
    init(with json: JSONDictionary) throws {
        guard let CUSTOMCount = json["CUSTOM_COUNT"] as? String else { throw ParseError.notFound(key: "CUSTOM_COUNT") }
        guard let MAINCode = json["MAIN_CODE"] as? String else { throw ParseError.notFound(key: "MAIN_CODE") }
        guard let MAINCodeName = json["MAIN_CODE_NAME"] as? String else { throw ParseError.notFound(key: "MAIN_CODE_NAME") }
        guard let SUBCode = json["SUB_CODE"] as? String else { throw ParseError.notFound(key: "SUB_CODE") }
        guard let SUBCodeName = json["SUB_CODE_NAME"] as? String else { throw ParseError.notFound(key: "SUB_CODE_NAME") }
        self.CUSTOMCount = CUSTOMCount
        self.MAINCode = MAINCode
        self.MAINCodeName = MAINCodeName
        self.SUBCode = SUBCode
        self.SUBCodeName = SUBCodeName
    }
    static func create(with json: JSONDictionary) -> Floorlis? {
        do {
            return try Floorlis(with: json)
        } catch {
            print("Floorlis json parse error: \(error)")
            return nil
        }
    }
}


struct CanteenPlaceModel {
    let FloorList: [Floorlis]
    let PlaceName: String
    init(with json: JSONDictionary) throws {
        guard let FloorListJSONArray = json["FloorList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "FloorList") }
        let FloorList = FloorListJSONArray.map({ Floorlis.create(with: $0) }).flatMap({ $0 })
        guard let PlaceName = json["PlaceName"] as? String else { throw ParseError.notFound(key: "PlaceName") }
        self.FloorList = FloorList
        self.PlaceName = PlaceName
    }
    static func create(with json: JSONDictionary) -> CanteenPlaceModel? {
        do {
            return try CanteenPlaceModel(with: json)
        } catch {
            print("CanteenPlaceModel json parse error: \(error)")
            return nil
        }
    }
}

extension CanteenPlaceModel {
    
    static func GetWithdivCode(_ divCode:String,codeType:String,failureHandler:FailureHandler?,completion:@escaping ([CanteenPlaceModel]?) -> Void){
        
        let parse:(JSONDictionary) -> [CanteenPlaceModel]? = { json in
            guard let data = json["data"] as? JSONDictionary else { return nil }
            guard let plac = data["Place"] as? [JSONDictionary] else { return nil }
            let modelArray = plac.map({ CanteenPlaceModel.create(with:$0)}).flatMap({ $0 })
            return modelArray
        }
        let resource = AlmofireResource(Type: .canteen, path:canteenCommonCodeKey, method: .post, requestParameters: ["divCode":divCode,"codeType":codeType], urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }

   
}



//////////////C


struct CanteenSortModel {
    let CUSTOMCount: String
    let MAINCode: String
    let MAINCodeName: String
    let REFCode1: String
    let SUBCode: String
    let SUBCodeName: String
    init(with json: JSONDictionary) throws {
        guard let CUSTOMCount = json["CUSTOM_COUNT"] as? String else { throw ParseError.notFound(key: "CUSTOM_COUNT") }
        guard let MAINCode = json["MAIN_CODE"] as? String else { throw ParseError.notFound(key: "MAIN_CODE") }
        guard let MAINCodeName = json["MAIN_CODE_NAME"] as? String else { throw ParseError.notFound(key: "MAIN_CODE_NAME") }
        guard let REFCode1 = json["REF_CODE1"] as? String else { throw ParseError.notFound(key: "REF_CODE1") }
        guard let SUBCode = json["SUB_CODE"] as? String else { throw ParseError.notFound(key: "SUB_CODE") }
        guard let SUBCodeName = json["SUB_CODE_NAME"] as? String else { throw ParseError.notFound(key: "SUB_CODE_NAME") }
        self.CUSTOMCount = CUSTOMCount
        self.MAINCode = MAINCode
        self.MAINCodeName = MAINCodeName
        self.REFCode1 = REFCode1
        self.SUBCode = SUBCode
        self.SUBCodeName = SUBCodeName
    }
    static func create(with json: JSONDictionary) ->  CanteenSortModel? {
        do {
            return try  CanteenSortModel(with: json)
        } catch {
            print(" CanteenSortModel json parse error: \(error)")
            return nil
        }
    }
}


extension CanteenSortModel {
    
    static func GetWithdivCode(_ divCode:String,codeType:String,failureHandler:FailureHandler?,completion:@escaping ([CanteenSortModel]?) -> Void){
        
        let parse:(JSONDictionary) -> [CanteenSortModel]? = { json in
            guard let data = json["data"] as? [JSONDictionary] else {
                return nil
            }
            let modelArray = data.map({ CanteenSortModel.create(with: $0)}).flatMap({ $0 })
            return modelArray
        }
        let resource = AlmofireResource(Type: .canteen,
                                        path:canteenCommonCodeKey,
                                        method: .post,
                                        requestParameters: ["divCode":divCode,"codeType":codeType],
                                        urlEncoding:URLEncoding(destination: .queryString),
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }


}


////////////////D

struct CanteenFilterSubModel{
    let CUSTOM_COUNT:String
    let MAIN_CODE:String
    let MAIN_CODE_NAME:String
    let SUB_CODE:String
    let SUB_CODE_NAME:String
    init(with json:JSONDictionary) throws {
        guard let CUSTOMCount = json["CUSTOM_COUNT"] as? String else { throw ParseError.notFound(key: "CUSTOM_COUNT") }
        guard let MAINCode = json["MAIN_CODE"] as? String else { throw ParseError.notFound(key: "MAIN_CODE") }
        guard let MAINCodeName = json["MAIN_CODE_NAME"] as? String else { throw ParseError.notFound(key: "MAIN_CODE_NAME") }
        guard let SUBCode = json["SUB_CODE"] as? String else { throw ParseError.notFound(key: "SUB_CODE") }
        guard let SUBCodeName = json["SUB_CODE_NAME"] as? String else { throw ParseError.notFound(key: "SUB_CODE_NAME") }
        self.CUSTOM_COUNT = CUSTOMCount
        self.MAIN_CODE = MAINCode
        self.MAIN_CODE_NAME = MAINCodeName
        self.SUB_CODE = SUBCode
        self.SUB_CODE_NAME = SUBCodeName
    }
    
    static func create(with json:JSONDictionary) -> CanteenFilterSubModel? {
        do {
          return try CanteenFilterSubModel(with: json)
        }catch {
            print("CanteenFiltersubModel json parse error: \(error)")
            return nil
        }
    }
    
    
}

struct CanteenFilterModel {
    let MAINCode: String
    let subCodeLis:[CanteenFilterSubModel]
    init(with json: JSONDictionary) throws {
        guard let MAINCode = json["MainCode"] as? String else {
            throw ParseError.notFound(key: "MainCode")
        }
        guard let subcodelisJsonArray = json["SubCodeList"] as? [JSONDictionary] else {
            throw ParseError.notFound(key: "SubCodeList")
        }
        let subCode = subcodelisJsonArray.map({ CanteenFilterSubModel.create(with: $0) }).flatMap({$0})
        self.MAINCode = MAINCode
        self.subCodeLis = subCode
    }
    static func create(with json: JSONDictionary) -> CanteenFilterModel? {
        do {
            return try CanteenFilterModel(with: json)
        } catch {
            print("CanteenFilterModel json parse error: \(error)")
            return nil
        }
    }
}

extension CanteenFilterModel{
    
    static func GetWithdivCode(_ divCode:String,codeType:String,failureHandler:FailureHandler?,completion:@escaping ([CanteenFilterModel]?) -> Void){
        
        let parse:(JSONDictionary) -> [CanteenFilterModel]? = { json in
            guard let data = json["data"] as? JSONDictionary else { return nil }
            guard let mainCodeList = data["MainCodeList"] as? [JSONDictionary] else { return nil }
            print(mainCodeList)
            let modelArray = mainCodeList.map({ CanteenFilterModel.create(with: $0)}).flatMap({ $0 })
            print(modelArray)
            return modelArray
        }
        let resource = AlmofireResource(Type: .canteen, path:canteenCommonCodeKey, method: .post, requestParameters: ["divCode":divCode,"codeType":codeType], urlEncoding:URLEncoding(destination: .queryString),parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
}



struct HomeTypelist {
        let currentPage: Int
        let nextPage: Int
        let restaurantList: [Restaurantlis]
        init(with json: JSONDictionary) throws {
            guard let currentPage = json["currentPage"] as? Int else { throw ParseError.notFound(key: "currentPage") }
            guard let nextPage = json["nextPage"] as? Int else { throw ParseError.notFound(key: "nextPage") }
            guard let restaurantListJSONArray = json["restaurantList"] as? [JSONDictionary] else { throw ParseError.notFound(key: "restaurantList") }
            let restaurantList = restaurantListJSONArray.map({ Restaurantlis.create(with: $0) }).flatMap({ $0 })
            self.currentPage = currentPage
            self.nextPage = nextPage
            self.restaurantList = restaurantList
        }
        static func create(with json: JSONDictionary) -> HomeTypelist? {
            do {
                return try HomeTypelist(with: json)
            } catch {
                print("HomeTypelist json parse error: \(error)")
                return nil
            }
        }
    }


extension HomeTypelist {
   
    static func GetWithDivCode(_ divCode:String,
                               floorCode:String = "",
                               categoryCode:String = "",
                               timeCode:String = "",
                               setMenuCode:String = "",
                               serviceCode:String = "",
                               searchValue:String = "",
                               smartSearch:String = "",
                               holyDay:String = "2",
                               takeOut:String = "2",
                               currentPage:Int,
                               failureHandler:FailureHandler?,
                               completion:@escaping (HomeTypelist?) -> Void)
    {
        
        let parse:(JSONDictionary) -> HomeTypelist? = { json in
            guard let data = json["data"] as? JSONDictionary else {
                return nil
            }
            let model =  HomeTypelist.create(with: data)
            return model
        }
        
        let requestParameters:[String:Any] = [
         "divCode":divCode,
         "floorCode":floorCode,
         "categoryCode":categoryCode,
         "timeCode":timeCode,
         "setMenuCode":setMenuCode,
         "serviceCode":serviceCode,
         "searchValue":searchValue,
         "smartSearch":smartSearch,
         "holyDay":holyDay,
         "takeOut":takeOut,
         "currentPage":currentPage
        ]
        let resource = AlmofireResource(Type: .canteen,
                                        path:canteenRestaurantListKey,
                                        method: .post,
                                        requestParameters: requestParameters,
                                        urlEncoding:URLEncoding(destination: .queryString),
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
     }
}


















