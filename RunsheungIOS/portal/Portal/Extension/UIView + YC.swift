//
//  UIView + YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


extension UIView{

    var height: CGFloat{
        set{
           var temp = self.frame
           temp.size.height = newValue
           self.frame = temp
        }
        get{
          return self.frame.size.height
        }
    }
    
    var width: CGFloat{
        set{
          var temp = self.frame
          temp.size.width = newValue
          self.frame = temp
        }
        get{
          return self.frame.size.width
        }
    }
    
    var x: CGFloat {
        set{
          var temp = self.frame
          temp.origin.x = newValue
          self.frame = temp
        }
        get{
          return self.frame.origin.x
        }
        
    }
    
    var y: CGFloat {
        set{
          var temp = self.frame
          temp.origin.y = newValue
          self.frame = temp
        }
        get {
          return self.frame.origin.y
        }
    }
    
    @objc (maxY)
    var maxy: CGFloat {
        get {
          return self.frame.maxY
        }
    }
    
    var minx: CGFloat{
        get{
          return self.frame.minX
        }
    }
    
    var miny: CGFloat {
        get {
          return self.frame.minY
        }
    }
    
    @objc (maxX)
    var maxx: CGFloat {
        get{
          return self.frame.maxX
        }
    }
    
    var midx: CGFloat {
        get{
          return self.frame.midX
        }
    }
    
    var midy: CGFloat{
        get{
          return self.frame.midY
        }
    }
    
    var centerx: CGFloat{
        set{
          var center = self.center
          center.x = centerx
          self.center = center
        }
        get{
          return self.center.x
        }
    }
}

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            return nil
        }
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        return view   
    }

}


extension UIView {
    
    func takeSnapshot(_ frame:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
           return nil
        }
        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

