//
//  CanteenShareModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/31.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation


open class CustomActivity: UIActivity {
    

    fileprivate let title: String
    fileprivate let message: String
    fileprivate let image:UIImage?
    fileprivate let completionHandler:((Bool)->Void)?
    
    public init(title: String,image:UIImage?, message: String, completionHandler: @escaping(Bool)->Void ) {
        
        self.title = title
        self.message = message
        self.completionHandler = completionHandler
        self.image = image
        super.init()
    }
    
    override open class var activityCategory : UIActivityCategory {
        return .share
    }
    
    override open var activityTitle : String? {
        return title
    }
    
    override open var activityImage : UIImage? {
        return image
    }

    
    override open func canPerform(withActivityItems activityItems: [Any]) -> Bool {
         return true
    }
    
    override open func perform() {
        completionHandler?(true)
        activityDidFinish(true)
    }
}

