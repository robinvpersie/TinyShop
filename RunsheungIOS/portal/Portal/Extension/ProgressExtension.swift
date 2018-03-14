//
//  ProgressExtension.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import MBProgressHUD
import SnapKit


extension MBProgressHUD{
   
    class func  getrootWindow() -> UIWindow? {
      let windows = UIApplication.shared.windows
      for x in windows.reversed() {
         if let appdelegate = UIApplication.shared.delegate {
            if x.isKind(of: UIWindow.self) && x == (appdelegate.window)! && x.bounds.equalTo(UIScreen.main.bounds){
                return x
              }
        }
      }
        return nil
    }
    
    
   class func getRootView() -> UIView? {
    if let window = self.getrootWindow() {
        let frontview = window.subviews[0]
        var result:UIViewController!
        if let nextResponser = frontview.next {
            if nextResponser.isKind(of: UIViewController.self){
                result = nextResponser as! UIViewController
                return result.view
            }
        }else {
           result = window.rootViewController!
           return result.view
        }
     }
       return nil
   }
        
        
    
   @discardableResult
   public class func showLoading() -> MBProgressHUD?{
       return self.showLoadingtoView()
    }
        
        
    
    public class func hideHud() {
        guard let rootView = self.getRootView() else {
                return
        }
        for  subView  in rootView.subviews.reversed(){
            if (subView is MBProgressHUD) {
               let y = subView as! MBProgressHUD
               y.hide(animated: true)
            }
        }
    }
    
    
    @discardableResult
    public class func show(view:UIView) -> MBProgressHUD{
      let hud = MBProgressHUD.showAdded(to: view, animated: true)
      hud.removeFromSuperViewOnHide = true
      return hud
    }
    
    @discardableResult
    public class func progressHud(view:UIView) -> MBProgressHUD{
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        hud.mode = .annularDeterminate
        return hud
    }
    
    
   public class func showLoadingtoView(view:UIView? = nil) -> MBProgressHUD?{
        if let view  = view {
          let hud = show(view: view)
            return hud
        }else {
            guard let rootView = self.getRootView() else { return nil }
            let hud = show(view: rootView)
            return hud
        }
    }
    
    public class func hideAfterDelay(view:UIView,interval:TimeInterval = 1,text:String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.detailsLabel.text = text
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: interval)
  }
    
    class func delay(view:UIView,interval:TimeInterval = 1,text:String? = nil,completionAction:(()->Void)? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.detailsLabel.text = text
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: interval)
        hud.completionBlock = completionAction
    }
    
    
    
    @discardableResult
    public class func showCustomInView(_ view:UIView) -> MBProgressHUD{
        
        let mb = MBProgressHUD(frame: view.bounds)
        mb.bezelView.color = UIColor.clear
        mb.backgroundView.color = UIColor.white
        mb.mode = .customView
        mb.removeFromSuperViewOnHide = true
        let custom = YCMBProgressView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        mb.customView = custom
        view.addSubview(mb)
        mb.show(animated: true)
        return mb
    }
    
}


class YCMBProgressView:UIView{
    
    var activity:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        addSubview(activity)
        activity.hidesWhenStopped = true
        activity.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
        }
        activity.startAnimating()
    }
    
    override var intrinsicContentSize: CGSize{
       return CGSize(width: 37, height: 37)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









