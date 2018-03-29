//
//  PlainAvatar.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import Kingfisher

private let screenScale = UIScreen.main.scale

struct PlainAvatar {
    let avatarURLString: String
    let avatarStyle: AvatarStyle
}

extension PlainAvatar: Avatar{
    
    var url: URL?{
       return URL(string: avatarURLString)
    }
    
    var style: AvatarStyle{
       return avatarStyle
    }
    
    var placeholderImage: UIImage? {
        return UIImage(named: "img_headphoto")
    }
    
    var localOriginalImage: UIImage? {
        return UIImage(named:"")
    }
    
    var localStyledImage: UIImage? {
        return UIImage(named: "")
    }
    
    func save(originalImage: UIImage, styledImage: UIImage){
    
    }
}
