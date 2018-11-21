//
//  YCAccountModel.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/12.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

public class YCAccountModel: NSObject, NSCoding {
    
    public enum userSex: String{
        case boy = "男"
        case girl = "女"
    }
    
    public enum customlevType: String {
        case none = "70"
        case doctor = "121"
        case student = "122"
        case weixin = "123"
    }

    @objc var memid: String?
    @objc var mall_home_id: String?
    @objc var flag: String?
    @objc var token: String?
    @objc var userName: String?
    var usersex: userSex?
    @objc var avatarPath: String?
    @objc var password: String?
    @objc var customId: String = ""
    @objc var customCode: String = ""
    @objc var ssoId: String?
    @objc var pointCardNo: String?
    @objc var parentId: String?
    @objc var customlev: String?
    @objc var combineToken: String?
	@objc var business_type:String?
    public override init() {
        super.init()
    }
    
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(memid, forKey: "memid")
        aCoder.encode(mall_home_id, forKey: "mall_home_id")
        aCoder.encode(token, forKey: "session_id")
        aCoder.encode(flag, forKey: "flag")
        aCoder.encode(userName,forKey:"userName")
        aCoder.encode(usersex?.rawValue,forKey:"userSex")
        aCoder.encode(avatarPath,forKey:"avatarPath")
        aCoder.encode(password,forKey:"password")
        aCoder.encode(customId, forKey: "customId")
        aCoder.encode(customCode, forKey: "customCode")
        aCoder.encode(ssoId, forKey: "ssoId")
        aCoder.encode(pointCardNo, forKey: "pointCardNo")
        aCoder.encode(parentId, forKey: "parentId")
        aCoder.encode(customlev, forKey: "customlev")
        aCoder.encode(combineToken, forKey: "combinetoken")
		aCoder.encode(business_type, forKey: "business_type")

    }
    
    required public init?(coder aDecoder: NSCoder) {
        memid = aDecoder.decodeObject(forKey: "memid") as? String
        mall_home_id = aDecoder.decodeObject(forKey: "mall_home_id") as? String
        token = aDecoder.decodeObject(forKey: "session_id") as? String
        flag = aDecoder.decodeObject(forKey: "flag") as? String
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        if let sex = aDecoder.decodeObject(forKey: "userSex") as? String {
            usersex = userSex(rawValue: sex)
        }
        avatarPath = aDecoder.decodeObject(forKey: "avatarPath") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        customId = aDecoder.decodeObject(forKey: "customId") as? String ?? ""
        customCode = aDecoder.decodeObject(forKey: "customCode") as? String ?? ""
        ssoId = aDecoder.decodeObject(forKey: "ssoId") as? String
        pointCardNo = aDecoder.decodeObject(forKey: "pointCardNo") as? String
        parentId = aDecoder.decodeObject(forKey: "parentId") as? String
        customlev = aDecoder.decodeObject(forKey: "customlev") as? String
        combineToken = aDecoder.decodeObject(forKey: "combinetoken") as? String
		business_type = aDecoder.decodeObject(forKey: "business_type") as? String

    }
    
    
    @objc class func islogin() -> Bool {
        if let account = YCAccountModel.getAccount() {
            guard let token = account.token, !token.isEmpty else {
                return false
            }
            return true
        }else {
            return false
        }
    }
    
    @objc (getAccount)
    class func getAccount() -> YCAccountModel? {
		let accountData:Data? = YCUserDefaults.defaults?.object(forKey: "accountModel") as? Data
        if let data = accountData {
          let loaded = NSKeyedUnarchiver.unarchiveObject(with: data) as? YCAccountModel
          return loaded ?? nil
        }else {
          return nil 
        }
    }
    
    class func saveAccount(_ json:JSON){
        let accountModel = YCAccountModel()
        accountModel.memid = json["memid"].string
        accountModel.mall_home_id = json["mall_home_id"].string
        accountModel.token = json["token"].string
        accountModel.flag = json["flag"].string
        accountModel.customId = json["custom_id"].stringValue
        accountModel.customCode = json["custom_code"].stringValue
        accountModel.ssoId = json["ssoId"].string
        accountModel.pointCardNo = json["point_card_no"].string
		accountModel.business_type = json["business_type"].string

        let objectTodata = NSKeyedArchiver.archivedData(withRootObject: accountModel)
		
        YCUserDefaults.accountModel.value = objectTodata
    }
    
    class func saveAPIAccount(_ json:JSON){
        let imagePath = json["imagePath"].string
        let userName = json["nickName"].string
        let gender = json["gender"].string
        let memberId = json["memberID"].string
      
        func checkGender() -> userSex?{
            if let gender = gender {
                if gender.contains("M"){
                   return YCAccountModel.userSex.girl
                }else {
                   return YCAccountModel.userSex.boy
                }
            }else {
                return nil
            }
         }

        if let accountModel = YCAccountModel.getAccount() {
            accountModel.avatarPath = imagePath
            accountModel.userName = userName
            accountModel.usersex = checkGender()
            accountModel.memid = memberId
			
            let objectTodata = NSKeyedArchiver.archivedData(withRootObject: accountModel)
            YCUserDefaults.accountModel.value = objectTodata
        }else {
            let account = YCAccountModel()
            account.avatarPath = imagePath
            account.userName = userName
            account.memid = memberId
            account.usersex = checkGender()
            let objectTodata = NSKeyedArchiver.archivedData(withRootObject: account)
            YCUserDefaults.accountModel.value = objectTodata
        }
    }
    
    class func saveAccountData(dic:[String:Any]){
        var accountData:Data?
        do {
           accountData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        }catch let error {
           print(error)
        }
        YCUserDefaults.accountModel.value = accountData
    }
    
    func getAccountDicFromModel(_ model:YCAccountModel?) -> [AnyHashable:Any]? {
           if let models = model {
              let dic = models.dictionaryFromModel
              return dic()
         }else {
              return nil
        }
    }
}
