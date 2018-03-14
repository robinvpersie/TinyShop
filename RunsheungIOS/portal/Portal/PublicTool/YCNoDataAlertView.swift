//
//  YCNoDataAlertView.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

public enum alertType{
    case withoutData
    case withoutWifi
    
    var alertImage:UIImage {
        switch self {
        case .withoutData:
            return UIImage(named: "img_no_vedio")!
        case .withoutWifi:
            return UIImage(named: "img_no_network")!
        }
    }
}


class YCNoDataAlertView: UIView {
    
    
    var freshAction:(() -> ())?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var alertImageView: UIImageView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
                fromNib()
    }
    init() {
        super.init(frame: CGRect())
        fromNib()
        refreshBtn.layer.masksToBounds = true
        refreshBtn.layer.cornerRadius = 5
        activity.hidesWhenStopped = true
        activity.stopAnimating()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        beginAnimating()
        if let freshAction = freshAction {
           freshAction()
        }
    }
    
    func showInView(_ view:UIView,type:alertType = .withoutData,condition:Bool = true,action:(()->())?){
       if let _ = self.superview {
        stopAnimating()
      if !condition { hide() }
       }else {
        view.addSubview(self)
        freshAction = action
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        alertImageView.image = type.alertImage
       }
    }
    
    func hide(){
        self.removeFromSuperview()
        activity.stopAnimating()
    }
    
    fileprivate func beginAnimating(){
        activity.startAnimating()
        refreshBtn.setTitle("", for: .normal)
     }
    
    fileprivate func stopAnimating(){
        refreshBtn.setTitle("点击刷新".localized, for: .normal)
        activity.stopAnimating()
     }
    
    override var intrinsicContentSize: CGSize{
       //return CGSize(width: 375, height: 450)
//        if let superView = self.superview {
//           return superView.frame.size
//        }
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    
    
}
