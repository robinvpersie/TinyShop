//
//  BundleExtension.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

let language_set = "langeuageset"

public class languageTool:NSObject {
    
    static let shared = languageTool()
    var language:String?
    var path:String?
    var bundle:Bundle?
    
    override init() {
        super.init()
        initLanguage()
    }
    
    func set_SystemLanguage(_ language:String){
        let original = YCUserDefaults.language.value
        if let value = original {
            if language == value {
               return
            }else {
              YCUserDefaults.language.value = value
            }
        }else {
           YCUserDefaults.language.value = language
        }
    }
    
    func initLanguage(){
        
        let languageType:String? = YCUserDefaults.language.value
        self.language = languageType
        if let lan = languageType {
            self.path = Bundle.main.path(forResource: lan, ofType: "lproj")
            self.bundle = Bundle(path: self.path!)
        }
    }
    
    func getString(_ original:String) ->String{
        if let bud = self.bundle {
          return bud.localizedString(forKey: original, value: nil, table: nil)
        }
       return original
    }

}
