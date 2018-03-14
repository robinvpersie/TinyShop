//
//  Reference.swift
//  Portal
//
//  Created by PENG LIN on 2017/7/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

public struct Reference {
    let view:UIView
    public let image:UIImage?
    
    var imageView:UIImageView {
       let imageView = UIImageView(frame: view.bounds)
       imageView.contentMode = .scaleAspectFill
       imageView.image = image
       return imageView
    }
    
    public init (view:UIView,image:UIImage?){
        self.view = view
        self.image = image
    }
    
}
