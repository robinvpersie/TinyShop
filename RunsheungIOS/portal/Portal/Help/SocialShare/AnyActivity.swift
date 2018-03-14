//
//  AnyActivity.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class AnyActivity:UIActivity {
    
    let type:UIActivityType?
    let title:String?
    let image:UIImage?
    let completion:()->Void
    let message:SocailShare.Message
    
    init(type:UIActivityType?,title:String?,image:UIImage?,message:SocailShare.Message,completion:@escaping ()->Void){
        self.type = type
        self.title = title
        self.image = image
        self.message = message
        self.completion = completion
        super.init()
    }
    
    override class var activityCategory:UIActivityCategory {
        return .share
    }
    
    override var activityType: UIActivityType?{
        return type
    }
    
    override var activityTitle: String?{
        return title
    }
    
    override var activityImage: UIImage?{
        return image
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return message.canBeDelivered
    }
    
    override func perform() {
        //SocailShare.deliver(message, completionHandler: completion)
        activityDidFinish(true)
    }
}
