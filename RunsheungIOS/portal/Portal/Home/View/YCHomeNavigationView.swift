//
//  YCHomeNavigationView.swift
//  Portal
//
//  Created by PENG LIN on 2017/1/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class YCHomeNavigationView: UIView {

    var didclicklogin: (() -> ())?
    var didclickqr: (() -> ())?
    var didclcckleft: (() -> ())?
    
    @IBOutlet weak var addressName: UILabel!
    var myImageView:UIImageView = {
       let my = UIImageView()
       my.image = UIImage.My
       return my
    }()
    
    var backGroundView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    @IBAction func clickLogin(_ sender: Any) {
        if let didclicklogin = didclicklogin{
            didclicklogin()
        }
      }
    
    @IBAction func clickqr(_ sender: Any) {
        if let didclickqr = didclickqr {
            didclickqr()
        }

    }
    @IBAction func clickLeft(_ sender: Any) {
        if let didclcckleft = didclcckleft {
            didclcckleft()
        }
    }
    
    required init(coder aDecoder: NSCoder) {   // 2 - storyboard initializer
        super.init(coder: aDecoder)!
        //        fromNib()   // 5.
    }
    init() {   // 3 - programmatic initializer
        super.init(frame: CGRect())  // 4.
        fromNib()
    }
    

}
