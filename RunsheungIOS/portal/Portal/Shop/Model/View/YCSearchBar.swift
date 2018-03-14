//
//  YCSearchBar.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class YCSearchBar: UISearchBar {
    
    var size:CGSize!

    convenience init(size:CGSize){
        self.init(frame: .zero)
        self.size = size
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: size.width, height: size.height)
    }
}
