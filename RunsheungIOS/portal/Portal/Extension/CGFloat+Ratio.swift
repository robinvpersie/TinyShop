//
//  CGFloat+Ratio.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import UIKit

protocol NumberTransition {
    var toCGFloat: CGFloat { get }
}

protocol Ratio {
    var wrpx: CGFloat { get }
    var hrpx: CGFloat { get }
}

extension CGFloat: Ratio {
    var wrpx: CGFloat {
        let constant = self / 375.0 * Constant.screenWidth
        return constant
    }
    
    var hrpx: CGFloat {
        let constant = self / 667.0 * Constant.screenHeight
        return constant
    }
    
}

extension Int: NumberTransition {
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Int: Ratio {
    
    var wrpx: CGFloat {
        return self.toCGFloat.wrpx
    }
    
    var hrpx: CGFloat {
        return self.toCGFloat.hrpx
    }
    
}


