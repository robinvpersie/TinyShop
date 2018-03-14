//
//  LoginViewModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CryptoSwift
import AdSupport
import Alamofire
import SwiftyJSON


///mvvm还是不行，要绑定的东西太多了。

class LoginViewModel {
    
    let validatePassword:Observable<LoginValidationResult>
    let validatePasswordRepeated:Observable<LoginValidationResult>
    let signupEnabled:Observable<Bool>
    let signedIn:Observable<JSON>
    
    init(input:(
        userName:Observable<String>,
        password:Observable<String>,
        repeatPassword:Observable<String>,
        loginTaps:Observable<Void>
        ),
        dependency:(
        validateService:LoginValidationService,
        API:LoginAPI
        )
    ){
        validatePassword = input.password.map({ dependency.validateService.validatePassword($0) }).shareReplay(1)
        
        validatePasswordRepeated = Observable.combineLatest(input.password, input.repeatPassword, resultSelector: dependency.validateService.validateRepeatedPassword).shareReplay(1)
        
        signupEnabled = Observable.combineLatest(validatePassword, validatePasswordRepeated, resultSelector: {
            $0.isValid && $1.isValid
        }).distinctUntilChanged().shareReplay(1)
        
        let passwordAndUserName = Observable.combineLatest(input.userName, input.password) { (username:$0,password:$1) }
        signedIn = input.loginTaps.withLatestFrom(passwordAndUserName).flatMapLatest({ username,password in
            return dependency.API.signup(username, password: password).observeOn(MainScheduler.instance).catchErrorJustReturn(false)
        }).shareReplay(1)
        
    }
    
}


class LoginDefaultAPI:LoginAPI {
    
    let URLSession:URLSession
    
    static let sharedAPI = LoginDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )

    init(URLSession:URLSession){
        self.URLSession = URLSession
    }
    
    func signup(_ username: String, password: String) -> Observable<JSON> {
        let urlstring = BaseType.PortalBase.baseURL + "/Member/MemberLoginENC"
        let url = URL(string: urlstring)!
        let request = URLRequest(url: url)
        let sha512 = password.sha512()
        var idfa:String = ""
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        let requestParameter:[String:Any] = [
            "MemberID":username,
            "PassWord":sha512,
            "deviceNo":idfa
        ]
        let encoding = URLEncoding(destination: .httpBody)
        let urlRequest = try! encoding.encode(request, with: requestParameter)
        return self.URLSession.rx.response(request: urlRequest).map({ (response,data) in
            let json = JSON(data)
            let flag = json["flag"].stringValue
            if flag == "success" {
                let accountModel = YCAccountModel()
                let token = json["token"].stringValue
                let newtoken = token + "|" + idfa
                accountModel.memid = json["memid"].string
                accountModel.token = newtoken
                accountModel.customId = json["custom_id"].stringValue
                accountModel.mall_home_id = json["mall_home_id"].string
                accountModel.password = password
                let objectTodata = NSKeyedArchiver.archivedData(withRootObject: accountModel)
                YCUserDefaults.accountModel.value = objectTodata
                NotificationCenter.default.post(name: NSNotification.Name.longinState, object: true)
            }
            return json
        })
            
    }

}
