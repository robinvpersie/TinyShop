//
//  UIButton + YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/1.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit


enum style {
    case top
    case left
    case bottom
    case right
}

extension UIButton {
    
    func layoutWthStyle(style:style,space:CGFloat){
        let imagewidth:CGFloat = (self.imageView?.frame.size.width)!
        let imageheight:CGFloat = (self.imageView?.frame.size.height)!
        let labelWidth:CGFloat = (self.titleLabel?.intrinsicContentSize.width)!
        let labelHeight:CGFloat = (self.titleLabel?.intrinsicContentSize.height)!
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .top:
             imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth)
             labelEdgeInsets = UIEdgeInsetsMake(0, -imagewidth, -imageheight-space/2.0, 0)
        case .left:
             imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0)
             labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0)
        case .bottom:
             imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth)
             labelEdgeInsets = UIEdgeInsetsMake(-imageheight - space/2.0, -imagewidth, 0, 0)
        case .right:
             imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space/2.0, 0, -labelWidth-space/2.0)
             labelEdgeInsets = UIEdgeInsetsMake(0, -imagewidth - space/2.0, 0, imagewidth + space/2.0)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    
       
    }
    
}
