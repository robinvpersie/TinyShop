//
//  RSJudgeIsX.swift
//  Portal
//
//  Created by zhengzeyou on 2018/1/15.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RSJudgeIsX: UIDevice {
    override init() {
        super.init()
    }
}

extension UIDevice{
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
