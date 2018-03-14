//
//  UIViewController+YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func goToLogin(completion:(()->Void)? = nil){
         let loginContainer = RSLoginContainerController()
         let navi = UINavigationController(rootViewController: loginContainer)
         self.present(navi, animated: true) {}
    }
    
    func showMessage(_ message:String?,interval:TimeInterval = 2,completionAction:(()->Void)? = nil){

        MBProgressHUD.delay(view: self.view, interval: interval, text: message, completionAction: completionAction)
    }
    
    func showCustomloading(){
        MBProgressHUD.showCustomInView(self.view)
    }
    
    func showLoading(){
        MBProgressHUD.show(view: self.view)
    }
    
    func hideLoading(){
       MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func yc_showErrMessage(_ message:String?,subtitle:String?){
       MBProgressHUD.hideAfterDelay(view: self.view, interval: 1.5, text: subtitle)
    }
   
    @objc func yc_back(){
        if let navi = self.navigationController {
           navi.popViewController(animated: true)
        }
    }
}

