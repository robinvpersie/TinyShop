//
//  YCUserDefaults.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation

public struct Listener<T>:Hashable{
    public typealias Action = (T) -> Void
    let action:Action
    let name:String
    public var hashValue: Int{
      return name.hashValue
    }
}

public func ==<T>(lhs:Listener<T>,rhs:Listener<T>) ->Bool{
    return lhs.name == rhs.name
}

final public class Listenable<T>{
    public var value:T{
        didSet{
          setterAction(value)
            for listener in listenerSet {
                listener.action(value)
            }
        }
    }
    public typealias SetterAction = (T) -> Void
    var setterAction:SetterAction
    var listenerSet = Set<Listener<T>>()
    
    public func bindListener(name:String,action:@escaping Listener<T>.Action){
        let listener = Listener(action: action, name: name)
        listenerSet.insert(listener)
    }
    
    public func bindAndFireListener(name:String,action:@escaping Listener<T>.Action){
        bindListener(name: name, action: action)
        action(value)
    }
    
    public func removeListenerWithName(name:String){
        for listener in listenerSet where listener.name == name{
                listenerSet.remove(listener)
                break
        }
    }
    
    public func removeAllListeners(){
       listenerSet.removeAll(keepingCapacity: false)
    }
    
    public init (_ v:T,setterAcion action:@escaping SetterAction){
          value = v
          setterAction = action
      }
 }


fileprivate let isFirstOpenKey = "YCisFirstOpen"
fileprivate let userCoordinateLatitudeKey = "userCoordinateLatitude"
fileprivate let userCoordinateLongtitudeKey = "userCoordinateLongtitude"
fileprivate let accountModelKey = "accountModel"
fileprivate let NickNameKey = "YCNickName"
fileprivate let SexKey = "YCSex"
fileprivate let AvatarUrlKey = "YCAvatarUrl"
fileprivate let KLNormalPlayVideoKey = "YCKLNormalPlayVideoKey"
fileprivate let KLNormalVideoCacheKey = "YCKLNormalVideoCacheKey"
fileprivate let KLMaxRequestCountKey = "YCKLMaxRequestCountKey"
fileprivate let KLUpdateDateKey = "YCUpdateDateKey"
fileprivate let canteenlocationKey = "CanteenLocationKey"
fileprivate let YCCurrentversionKey = "currentDate"
fileprivate let YCCurrentStateKey = "currentState"
fileprivate let YCPushUrlKey = "YCPushUrl"
fileprivate let YCCanteenDivcodeKey = "canteendivcode"
fileprivate let YCShopDivCodeKey = "shopDivcode"



final public class YCUserDefaults{
    
    static let defaults = UserDefaults(suiteName: "YCSheLongWang")
    
    public static var isAcceptProtocol: Listenable<Bool?> = {
       let firstLanuch = defaults?.bool(forKey: "isAcceptProtocol")
        return Listenable<Bool?> (firstLanuch) { firstLanuch in
            defaults?.set(firstLanuch, forKey: "isAcceptProtocol")
        }
    }()
    
    public static var locationAddress:Listenable<String?> = {
        let locationAddress = defaults?.string(forKey:canteenlocationKey)
        return Listenable<String?>(locationAddress){ locationAddress in
            defaults?.setValue(locationAddress, forKey: canteenlocationKey)
        }
    }()
    
    public static var shopDivcode:Listenable<String?> = {
        let divcode = defaults?.string(forKey: YCShopDivCodeKey)
        return Listenable<String?>(divcode){ divcode in
            defaults?.setValue(divcode, forKey: YCShopDivCodeKey)
        }
    }()
    
    public static var canteendivCode:Listenable<String?> = {
        let divcode = defaults?.string(forKey: YCCanteenDivcodeKey)
        return Listenable<String?>(divcode){ divcode in
            defaults?.setValue(divcode, forKey: YCCanteenDivcodeKey)
        }
    }()
    
    public static var lastUpdateDate:Listenable<Date?> = {
        let update = defaults?.object(forKey: KLUpdateDateKey) as? Date
        return Listenable<Date?>(update){ update in
            defaults?.setValue(update,forKey:KLUpdateDateKey)
        }
    }()
    
    public static var KLMaxRequestCount:Listenable<Int?> = {
       let maxCount = defaults?.integer(forKey:KLMaxRequestCountKey)
        return  Listenable<Int?>(maxCount){ maxCount in
            defaults?.setValue(maxCount, forKey: KLMaxRequestCountKey)
        }
    }()
    
    public static var isFirstOpen:Bool{
        if YCUserDefaults.FirstOpen.value != nil && YCUserDefaults.FirstOpen.value == true {
           return false
        }else {
           return true 
        }
    }
    
    public static var KLNormalPlayVideo:Listenable<Bool?> = {
        let isFirstOpen = defaults?.bool(forKey: KLNormalPlayVideoKey)
        return Listenable<Bool?>(isFirstOpen){isFirstOpen in
            defaults?.setValue(isFirstOpen, forKey: KLNormalPlayVideoKey)
        }
    }()
    
    public static var KLNormalCacheVideo:Listenable<Bool?> = {
        let isFirstOpen = defaults?.bool(forKey: KLNormalVideoCacheKey)
        return Listenable<Bool?>(isFirstOpen){isFirstOpen in
            defaults?.setValue(isFirstOpen, forKey: KLNormalVideoCacheKey)
        }
    }()

    
    public static var FirstOpen:Listenable<Bool?> = {
         let isFirstOpen = defaults?.bool(forKey: isFirstOpenKey)
        return Listenable<Bool?>(isFirstOpen){isFirstOpen in
             defaults?.setValue(isFirstOpen, forKey: isFirstOpenKey)
        }
    }()
    
    public static var userCoordinateLatitude:Listenable<Double?> = {
         let userCoordinateLatitude =  defaults?.double(forKey: userCoordinateLatitudeKey)
        return Listenable<Double?>(userCoordinateLatitude){ userCoordinateLatitude in
             defaults?.setValue(userCoordinateLatitude, forKey: userCoordinateLatitudeKey)
        }
    }()
    
    public static var userCoordinateLongtitude:Listenable<Double?> = {
         let userCoordinateLongtitude = defaults?.double(forKey:  userCoordinateLongtitudeKey)
        return Listenable<Double?>(userCoordinateLongtitude){userCoordinateLongtitude in
           defaults?.setValue(userCoordinateLongtitude, forKey:userCoordinateLongtitudeKey)
        }
    }()
    
    public static var accountModel:Listenable<Data?> = {
        let model = UserDefaults.standard.object(forKey: "accountModel") as? Data
        return Listenable<Data?>(model){ model in
            UserDefaults.standard.set(model, forKey: "accountModel")
        }
    }()
    
    public static var NickName:Listenable<String?> = {
        let NickName = defaults?.string(forKey:NickNameKey)
        return Listenable<String?>(NickName){ NickName in
            defaults?.setValue(NickName, forKey: NickNameKey)
        }
    }()
    
    public static var Sex:Listenable<String?> = {
        let sex = defaults?.string(forKey: SexKey)
        return Listenable<String?>(sex){ sex in
            defaults?.setValue(sex, forKey: SexKey)
        }
    }()
    
    public static var AvatarUrlString:Listenable<String?> = {
        let avatarUrl = defaults?.string(forKey:AvatarUrlKey)
        return Listenable<String?>(avatarUrl){ avatarUrl in
           defaults?.setValue(avatarUrl, forKey: AvatarUrlKey)
        }
    }()
    
    public static var YCCurrentVersion:Listenable<String?> = {
        let currentstate =  defaults?.string(forKey: YCCurrentversionKey)
        return Listenable<String?>(currentstate){ currentState in
           defaults?.setValue(currentstate, forKey: YCCurrentversionKey)
        }
    }()
    
    public static var YCCurrentState:Listenable<String?> = {
        let currentstate = defaults?.string(forKey:YCCurrentStateKey)
        return Listenable<String?>(currentstate){ currentState in
           defaults?.setValue(currentstate, forKey:YCCurrentStateKey)
        }
    }()
    
    public static var HomeDivCode:Listenable<String?> = {
        let div = defaults?.string(forKey: "HomeDivCode")
        return Listenable<String?>(div){ div in
           defaults?.setValue(div, forKey: "HomeDivCode")
        }
    }()
    
    public static var HomeDicName:Listenable<String?> = {
        let divName = defaults?.string(forKey: "HomeDivName")
        return Listenable<String?>(divName){ divName in
           defaults?.setValue(divName, forKey: "HomeDivName")
        }
    }()
    
    public static var language:Listenable<String?> = {
        let language = defaults?.string(forKey: "setlanguage")
        return Listenable<String?>(language){ language in
            defaults?.setValue(language, forKey: "setlanguage")
        }
    }()
    
    public static var languageType:Listenable<Int?> = {
        let type = defaults?.integer(forKey: "languageType")
        return Listenable<Int?>(type){ type in
            defaults?.set(type, forKey: "languageType")
        }
    }()
    
    public static var tickets:Listenable<String?> = {
        let ticket = defaults?.string(forKey: "tickets")
        return Listenable<String?>(ticket){ ticket in
            defaults?.set(ticket, forKey: "tickets")
        }
    }()
    
    
}

