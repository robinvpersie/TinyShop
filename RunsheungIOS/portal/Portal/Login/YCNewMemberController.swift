//
//  YCNewMemberController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/3.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class YCNewMemberController: UITableViewController {
    
    private var Phonetextfield: YCTextField!
    private var PassWorkfield: YCTextField!
    private var messagefield: YCTextField!
    private var passwordAgainfield: YCTextField!
    private var loginBtn: UIButton!
    private var codebtn: YCAuthCodeBtn!
    var AddmemberSuccessCallBack:(() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.groupTableViewBackground

        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 115))
        headerView.backgroundColor = UIColor.clear
        
        Phonetextfield = YCTextField(frame: CGRect(x: leftEdges, y: toTopEdges, width: screenWidth -  leftEdges * 2, height: textfieldHeight))
        Phonetextfield.layer.backgroundColor = UIColor.white.cgColor
        Phonetextfield.placeholder = "请输入您的手机号码".localized
        Phonetextfield.cornerRadius = textfieldHeight/2
        Phonetextfield.rightviewWidth = 10
        Phonetextfield.righttopedges = textfieldrighttopedges
        Phonetextfield.delegate = self
        Phonetextfield.rightViewMode = .always
        Phonetextfield.rightView = UIImageView(image:UIImage.phone)
        Phonetextfield.keyboardType = .numberPad
        Phonetextfield.font = UIFont.systemFont(ofSize: 13)
        Phonetextfield.addTarget(self, action: #selector(phoneValueChanaged(sender:)), for: .editingChanged)
        
        PassWorkfield = YCTextField(frame: CGRect(x: leftEdges, y:self.Phonetextfield.frame.maxY + textfieldEdges , width: screenWidth - leftEdges * 2, height: textfieldHeight))
        PassWorkfield.layer.backgroundColor = UIColor.white.cgColor
        PassWorkfield.placeholder = "请输入登录密码".localized
        PassWorkfield.isSecureTextEntry = true
        PassWorkfield.delegate = self
        PassWorkfield.cornerRadius = textfieldHeight/2
        PassWorkfield.rightviewWidth = 10
        PassWorkfield.righttopedges = textfieldrighttopedges
        PassWorkfield.rightViewMode = .always
        PassWorkfield.addTarget(self, action: #selector(phoneValueChanaged(sender:)), for: .editingChanged)
        let passwordimageview = UIImageView(image: UIImage.password)
        PassWorkfield.rightView = passwordimageview
        PassWorkfield.font = UIFont.systemFont(ofSize: 13)
        
        passwordAgainfield = YCTextField(frame: CGRect(x: leftEdges, y: PassWorkfield.maxy + textfieldEdges, width: screenWidth - leftEdges * 2, height: textfieldHeight))
        passwordAgainfield.layer.backgroundColor = UIColor.white.cgColor
        passwordAgainfield.placeholder = "再次输入登录密码".localized
        passwordAgainfield.isSecureTextEntry = true
        passwordAgainfield.delegate = self
        passwordAgainfield.cornerRadius = textfieldHeight/2
        passwordAgainfield.rightviewWidth = 10
        passwordAgainfield.righttopedges = textfieldrighttopedges
        passwordAgainfield.rightViewMode = .always
        passwordAgainfield.addTarget(self, action: #selector(phoneValueChanaged(sender:)), for: .editingChanged)
        passwordAgainfield.rightView = UIImageView(image: UIImage.password)
        passwordAgainfield.font = UIFont.systemFont(ofSize: 13)
        
        messagefield = YCTextField(frame: CGRect(x: leftEdges, y: passwordAgainfield.maxy + textfieldEdges, width: screenWidth -  leftEdges * 2, height: textfieldHeight))
        messagefield.layer.backgroundColor = UIColor.white.cgColor
        messagefield.placeholder = "请输入短信验证码".localized
        messagefield.cornerRadius = textfieldHeight/2
        messagefield.rightviewWidth = 80
        messagefield.righttopedges = 8
        messagefield.delegate = self
        messagefield.rightViewMode = .always
        messagefield.keyboardType = .numberPad
        
        codebtn = YCAuthCodeBtn(type: .custom)
        codebtn.frame = CGRect(x: 0, y: 8, width: 80, height: textfieldHeight - 16)
        codebtn.layer.masksToBounds = true
        codebtn.layer.cornerRadius = (textfieldHeight - 16)/2
        codebtn.clickAuth = { [weak self] in
            guard let strongself = self,
                  let text = strongself.Phonetextfield.text,
                  text.count >= 7
            else {
                self?.showMessage("请输入正确的电话号码".localized)
                return
            }
            strongself.acceptcheckcode(sender: strongself.codebtn)
         }
        
        codebtn.canstart = { [weak self] in
            guard let strongself = self,
                  let text = strongself.Phonetextfield.text,
                      text.count > 7
            else {
                return false
            }
            return true
        }
        messagefield.rightView = codebtn
        messagefield.font = UIFont.systemFont(ofSize: 13)
        
        loginBtn = UIButton(type: .custom)
        loginBtn.addTarget(self, action: #selector(YCNewMemberController.clickLogin), for: .touchUpInside)
        loginBtn.frame = CGRect(x: leftEdges, y: self.messagefield.maxy + textfieldEdges * 2, width: Phonetextfield.frame.size.width, height: textfieldHeight)
        loginBtn.setTitle("注册并登录".localized, for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.isEnabled = false
        loginBtn.layer.backgroundColor = UIColor.lightGray.cgColor
        loginBtn.layer.cornerRadius = textfieldHeight/2
        
        let versionLabel = UILabel(frame: CGRect(x:0,y:self.view.frame.size.height - 64 - 40 - 40 ,width:screenWidth,height:35))
        versionLabel.textAlignment = .center
        versionLabel.textColor = UIColor.gray
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        let versionString = "人生药业Version:" + "1.0.0"
        versionLabel.text = versionString
        
        headerView.addSubview(Phonetextfield)
        headerView.addSubview(PassWorkfield)
        headerView.addSubview(passwordAgainfield)
        headerView.addSubview(messagefield)
        headerView.addSubview(loginBtn)
        headerView.addSubview(versionLabel)
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: loginBtn.maxy + 10)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
     }
    
    
    @objc func phoneValueChanaged(sender:YCTextField){
        guard let password = PassWorkfield.text,
            let passwordagain = passwordAgainfield.text,
            let phone = Phonetextfield.text else {
                return
            }
        if password.count >= 6 && phone.count >= 8 && passwordagain.count >= 6 {
            loginBtn.layer.backgroundColor = UIColor.navigationbarColor.cgColor
            loginBtn.isEnabled = true
        }else {
            loginBtn.layer.backgroundColor = UIColor.lightGray.cgColor
            loginBtn.isEnabled = false
         }
    }
    
    
    private func addNewMemberWithPhone(_ phone:String?,password:String?,authNum:String?){
        showLoading()
        addMemberEnc(phone: phone ?? "", password: password ?? "", AuthNum: authNum ?? "") { [weak self] result in
            guard let strongself = self else { return }
            strongself.hideLoading()
            switch result {
            case .success(let value):
                var json = JSON(value)
                let flag = json["flag"].string
                let msg = json["msg"].string
                if flag == "success" {
                   strongself.AddmemberSuccessCallBack?()
                }else {
                   strongself.showMessage(msg)
                }
            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
        }
    }
    
    @objc private func clickLogin(){
        guard let phonetext = self.Phonetextfield.text,
            phonetext.count >= 7 else {
            self.yc_showErrMessage(nil,subtitle:"请输入正确的电话号码".localized)
            return
        }
        guard let passwordtext = self.PassWorkfield.text,
            passwordtext.count >= 6 else {
            self.yc_showErrMessage(nil,subtitle:"请输入不少于6位的密码".localized)
            return
        }
        
        guard let againText = passwordAgainfield.text,
            againText == passwordtext else {
            self.yc_showErrMessage(nil,subtitle:"密码不一致".localized)
            return
        }
        
        guard let messagetext = self.messagefield.text,
            messagetext.count >= 4 else {
             self.yc_showErrMessage(nil, subtitle: "请输入完整的验证码".localized)
             return
        }
        addNewMemberWithPhone(Phonetextfield.text, password: PassWorkfield.text, authNum: messagefield.text)
    }
    
    @objc private func acceptcheckcode(sender:UIButton){
        NetWorkManager.manager.SendSMSAuthWithPhoneNumber(Phonetextfield.text) { [weak self] (result) in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
            case .success(let jsonDictionary):
                 let json = JSON(jsonDictionary)
                 let flag = json["flag"].string
                 if flag == "success" {
                    this.showMessage("验证码发送成功".localized)
                 }else if flag == "duplicate" {
                   this.showMessage("已经加入的号码".localized)
                   this.codebtn.restore()
                 }else {
                   this.showMessage("发送验证码失败".localized)
                   this.codebtn.restore()
                 }
            case .failure(let error):
                this.showMessage(error.localizedDescription)
            }
        }
   }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YCNewMemberController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}

extension YCNewMemberController{
    
    func addMemberEnc(phone:String,
                      password:String,
                      AuthNum:String,
                      completion:@escaping ((NetWorkResult<JSONDictionary>) -> Void))
    {
        let parse:(JSONDictionary) -> JSONDictionary? = { json in
          return json
        }
        let sha512 = password.sha512()
        let requestParameter = [
          "HPNum":phone,
          "Password":sha512,
          "AuthNum":AuthNum
        ]
        let netResource = NetResource(path: "/Member/AddMemberENC",
                                      method: .post,
                                      parameters: requestParameter,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }

}
