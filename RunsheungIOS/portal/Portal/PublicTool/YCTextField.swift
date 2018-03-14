//
//  YCTextField.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/3.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit



final class YCTextField:UITextField {
    
    var leftviewWidth:CGFloat = 0
    var rightviewWidth:CGFloat = 0
    var cornerRadius:CGFloat = 0
    var righttopedges:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.size.width - rightviewWidth - cornerRadius - 2, y: righttopedges, width: rightviewWidth, height: (bounds.size.height - righttopedges * 2))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: cornerRadius, y: 0, width: leftviewWidth, height: bounds.size.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: cornerRadius + leftviewWidth, y: 0, width: bounds.width - 2 * cornerRadius - rightviewWidth - leftviewWidth, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        super.draw(rect)
        
        
    }
}
