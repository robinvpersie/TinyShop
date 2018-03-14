//
//  LoginProtocols.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

enum LoginValidationResult {
    case ok
    case empty
    case failed(message:String)
    
    var isValid:Bool {
        switch self {
        case .ok:
            return true
        default:
            return false 
        }
    }
}

protocol LoginAPI {
    func signup(_ username:String, password:String) -> Observable<JSON>
}


protocol LoginValidationService {
    func validatePassword(_ password:String) -> LoginValidationResult
    func validateRepeatedPassword(_ password:String,repeatPassword:String) -> LoginValidationResult
}
