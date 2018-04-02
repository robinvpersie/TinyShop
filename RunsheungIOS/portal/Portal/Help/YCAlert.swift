//
//  YCAlert.swift
//  Portal
//
//  Created by linpeng on 2016/11/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Foundation

public extension DispatchQueue {

    func safeAsync(_ block: @escaping () -> ()) {
        if self == DispatchQueue.main && Thread.isMainThread{
          block()
        }else {
            async {
                block()
            }
        }
    }

}


final class YCAlert {
   @objc (alert:message:dismissTitle:inViewController:withDismissAction:)
   class func alert(title: String,
                    message: String?,
                    dismissTitle: String,
                    inViewController viewController: UIViewController?,
                    withDismissAction dismissAction: (() -> Void)?)
   {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .default) { action in
                if let dismissAction = dismissAction {
                    dismissAction()
                }
            }
            alertController.addAction(action)
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func alertSorry(message: String?, inViewController viewController: UIViewController?, withDismissAction dismissAction: @escaping () -> Void) {
        
        alert(title: NSLocalizedString("Sorry", comment: ""), message: message, dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: viewController, withDismissAction: dismissAction)
    }
    
    class func alertSorry(message: String?, inViewController viewController: UIViewController?) {
        
        alert(title: NSLocalizedString("Sorry", comment: ""), message: message, dismissTitle: NSLocalizedString("OK", comment: ""), inViewController: viewController, withDismissAction: nil)
    }
    
    @objc (textInput:placeholder:oldText:dismissTitle:inViewController:withFinishedAction:)
    class func textInput(title: String,
                         placeholder: String?,
                         oldText: String?,
                         dismissTitle: String,
                         inViewController viewController: UIViewController?,
                         withFinishedAction finishedAction: ((_ text: String) -> Void)?)
    {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = placeholder
                textField.text = oldText
            }
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .default) { action in
                if let finishedAction = finishedAction,
                    let textField = alertController.textFields?.first,
                    let text = textField.text
                {
                    finishedAction(text)
                }
            }
            alertController.addAction(action)
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    static weak var confirmAlertAction: UIAlertAction?
    
    @objc (textInput:message:placeholder:oldText:confirmTitle:cancelTitle:inViewController:withConfirmAction:cancelAction:)
    class func textInput(title: String,
                         message: String?,
                         placeholder: String?,
                         oldText: String?,
                         confirmTitle: String,
                         cancelTitle: String,
                         inViewController viewController: UIViewController?,
                         withConfirmAction confirmAction: ((_ text: String) -> Void)?,
                         cancelAction: (() -> Void)?)
    {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addTextField { textField in
                textField.placeholder = placeholder
                textField.text = oldText
                textField.addTarget(self, action: #selector(YCAlert.handleTextFieldTextDidChangeNotification(sender:)), for: .editingChanged)
            }
            
            let _cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancelAction?()
            }
            
            alertController.addAction(_cancelAction)
            
            let _confirmAction = UIAlertAction(title: confirmTitle, style: .default) { action in
                if let textField = alertController.textFields?.first,
                   let text = textField.text {
                    confirmAction?(text)
                }
            }
            _confirmAction.isEnabled = false
            self.confirmAlertAction = _confirmAction
            alertController.addAction(_confirmAction)
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc class func handleTextFieldTextDidChangeNotification(sender: UITextField) {
        YCAlert.confirmAlertAction?.isEnabled = (sender.text?.utf16.count)! >= 1
    }
    
    @objc (confirmOrCancel:message:confirmTitle:cancelTitle:inViewController:withConfirmAction:cancelAction:)
    class func confirmOrCancel(title: String?,
                               message: String?,
                               confirmTitle: String,
                               cancelTitle: String,
                               inViewController viewController: UIViewController?,
                               withConfirmAction confirmAction: @escaping () -> Void,
                               cancelAction:(() -> Void)? = nil)
    {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancelAction?()
            }
            alertController.addAction(cancelAction)
            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { action in
                confirmAction()
            }
            alertController.addAction(confirmAction)
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    /// 提醒数组Array
    ///
    /// - Parameters:
    ///   - array: 显示的数组
    ///   - title: 标题
    ///   - message: 提示消息
    ///   - style: 风格
    ///   - viewController: 显示的controller
    class func alertWithModelArray(_ array: [AlertActionModel],
                                   title: String? = nil,
                                   message: String? = nil,
                                   style: UIAlertControllerStyle = .alert,
                                   viewController: UIViewController?)
    {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            array.forEach { model in
                let alertAction = UIAlertAction(title: model.title, style: model.style, handler: model.action)
                alertController.addAction(alertAction)
            }
            let cancleAction = UIAlertAction(title: "取消", style: .cancel) { action in }
            alertController.addAction(cancleAction)
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
}




struct AlertActionModel: AlertProtocol {
    
    var title: String?
    var style: UIAlertActionStyle
    var action: ((UIAlertAction)->Swift.Void)?
    var isEnabled: Bool = true
    
    init(title: String?, style: UIAlertActionStyle = .default, action: ((UIAlertAction) -> Swift.Void)?) {
        self.title = title
        self.style = style
        self.action = action
    }
}

protocol AlertProtocol {
    var title: String? {get}
    var style: UIAlertActionStyle {get}
    var action: ((UIAlertAction) -> Swift.Void)? {get}
    var isEnabled: Bool {get}
}

extension AlertProtocol {
    var isEnabled: Bool {
        return true 
    }
}









