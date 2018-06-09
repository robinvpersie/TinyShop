//
//  UIColor+YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit


extension UIColor{
    
    static var navigationbarColor: UIColor{
        return UIColor(hex:0xf23c48)
    }
    
    static var textfieldColor: UIColor{
        return UIColor(hex:0xffffff)
    }
    
    static var classBackGroundColor: UIColor{
        return UIColor(hex:0xf2f2f2)
    }
    
    @objc static var darkcolor: UIColor{
        return UIColor(hex: 0x333333)
    }
    
    static var BaseControllerBackgroundColor: UIColor{
        return UIColor(hex: 0xf2f2f2)
    }
    
    static var YClightGrayColor: UIColor{
        return UIColor(hex: 0x999999)
    }
    
    static var YClightBlueColor: UIColor{
        return UIColor(hex:0x3dbcf1)
    }
    
    static var YCGrayColor: UIColor {
        return UIColor(hex:0xe6e6e6)
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

