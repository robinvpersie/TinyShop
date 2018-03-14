//
//  OffPasswordView.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class OffPasswordView:UIView {
    

    var passwordInputView:OffPasswordInputView!
    var textResponsder:UITextField!
    var coverView:UIControl!
    var topConstraint:NSLayoutConstraint!
    var tempString:String = ""
    var payAction:() -> Void = {}
    var totalMoney:String! {
        didSet{
            passwordInputView.timelb.text = totalMoney
        }
    }
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        coverView = UIControl()
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        passwordInputView = OffPasswordInputView()
        passwordInputView.translatesAutoresizingMaskIntoConstraints = false 
        addSubview(passwordInputView)
        let leadingConstraint = NSLayoutConstraint(item: passwordInputView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: passwordInputView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: passwordInputView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: OffPasswordInputView.getHeight())
        topConstraint = NSLayoutConstraint(item: passwordInputView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,heightConstraint,topConstraint])
        passwordInputView.middleAction = { [weak self] in
            guard let strongself = self else { return }
            strongself.hide()
        }
        passwordInputView.payAction = { [weak self] in
            guard let strongself = self else { return }
            strongself.payAction()
        }
       
        textResponsder = UITextField()
        textResponsder.delegate = self
        textResponsder.keyboardType = .numberPad
        textResponsder.isSecureTextEntry = true
        addSubview(textResponsder)
      
    }
    
    
    func hide(_ finish:(()->Void)? = nil){
        hideKeyBoard { (finish) in
            self.tempString = ""
            NotificationCenter.default.post(name: Notification.Name.addstring, object: self.tempString, userInfo: nil)
            self.removeFromSuperview()
        }
    }
    
    func showInView(_ view:UIView){
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        showKeyBoard()
    }
    
    func showKeyBoard(){
        UIView.animate(withDuration: 0.3, animations: {
            self.topConstraint.constant = -(OffPasswordInputView.getHeight())
        }, completion: nil)
        textResponsder.becomeFirstResponder()

    }
    
    func hideKeyBoard(completion:@escaping(Bool)->Void){
        textResponsder.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.topConstraint.constant = 0
         }, completion: completion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OffPasswordView:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if  passwordInputView.state == .loading { return true }
        
        if string == "" {
            if !tempString.isEmpty {
                
                tempString = (tempString as NSString).substring(to: (tempString as NSString).length - 1)
            }
        }else {
            if tempString.characters.count < 6 {
                tempString = tempString + string
            }
        }
        NotificationCenter.default.post(name: Notification.Name.addstring, object: tempString, userInfo: nil)
        return true
    }
    
}
