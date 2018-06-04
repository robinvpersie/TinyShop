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
    
    @objc (goToLogin:)
    func goToLogin(completion: (() -> Void)? = nil) {
         let loginContainer = MemberEnrollController()
         let navi = UINavigationController(rootViewController: loginContainer)
         present(navi, animated: true, completion: nil)
     }
    
    @objc (showMessage:interval:completionAction:)
    func showMessage(_ message: String?, interval: TimeInterval = 2, completionAction: (() -> Void)? = nil){
        OperationQueue.main.addOperation {
             MBProgressHUD.delay(view: self.view, interval: interval, text: message, completionAction: completionAction)
        }
    }
    
    @objc (showCustomloading)
    func showCustomloading(){
        MBProgressHUD.showCustomInView(view)
    }
    
    @objc (showLoading)
    func showLoading(){
        OperationQueue.main.addOperation {
            MBProgressHUD.show(view: self.view)
        }
    }
    
    @objc (hideLoading)
    func hideLoading(){
        OperationQueue.main.addOperation {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc (yc_showErrMessage:subtitle:)
    func yc_showErrMessage(_ message: String?, subtitle: String?) {
       MBProgressHUD.hideAfterDelay(view: view, interval: 1.5, text: subtitle)
    }
   
    @objc (yc_back)
    func yc_back(){
        if let navi = navigationController {
           navi.popViewController(animated: true)
        }
    }
    
}

