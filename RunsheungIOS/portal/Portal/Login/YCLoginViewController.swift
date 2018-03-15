//
//  YCLoginViewController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/1.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AdSupport



let textfieldHeight: CGFloat = 44
let leftEdges: CGFloat = Ruler.iPhoneHorizontal(20, 30, 30).value
let toTopEdges: CGFloat = Ruler.iPhoneVertical(30, 30, 40, 45).value
let textfieldEdges: CGFloat = Ruler.iPhoneVertical(20, 20, 20, 25).value
let textfieldrighttopedges: CGFloat = 15

class YCLoginViewController: UITableViewController {
    
    var isChattingLogin: Bool? = false
    var Phonetextfield: YCTextField!
    var PassWorkfield: YCTextField!
    var loginBtn: UIButton!
    var forgetPasswordBtn: UIButton!
    var loginSuccessCallBack: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
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
        Phonetextfield.rightView = UIImageView(image: UIImage.phone)
        Phonetextfield.keyboardType = .numberPad
        Phonetextfield.font = UIFont.systemFont(ofSize: 13)
        Phonetextfield.addTarget(self, action: #selector(YCLoginViewController.phoneValueChanaged(sender:)), for: .editingChanged)
        
        
        PassWorkfield = YCTextField(frame: CGRect(x: leftEdges, y:self.Phonetextfield.frame.maxY + textfieldEdges , width: screenWidth -  leftEdges * 2, height: textfieldHeight))
        PassWorkfield.backgroundColor = UIColor.white
        PassWorkfield.placeholder = "请输入登录密码".localized
        PassWorkfield.isSecureTextEntry = true
        PassWorkfield.delegate = self
        PassWorkfield.layer.masksToBounds = true
        PassWorkfield.cornerRadius = textfieldHeight/2
        PassWorkfield.rightviewWidth = 10
        PassWorkfield.righttopedges = textfieldrighttopedges
        PassWorkfield.rightViewMode = .always
        PassWorkfield.rightView = UIImageView(image: UIImage.password)
        PassWorkfield.addTarget(self, action: #selector(YCLoginViewController.phoneValueChanaged(sender:)), for: .editingChanged)
        PassWorkfield.font = UIFont.systemFont(ofSize: 13)
        
        loginBtn = UIButton(type: .custom)
        loginBtn.addTarget(self, action: #selector(YCLoginViewController.clickLogin), for: .touchUpInside)
        loginBtn.frame = CGRect(x: leftEdges, y: self.PassWorkfield.frame.maxY + textfieldEdges * 2, width: self.Phonetextfield.frame.size.width, height: textfieldHeight)
        loginBtn.setTitle("登录".localized, for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = UIColor.lightGray
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = textfieldHeight/2
        
        forgetPasswordBtn = UIButton(type: .custom)
        forgetPasswordBtn.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
        forgetPasswordBtn.setTitle("忘记密码".localized, for: .normal)
        forgetPasswordBtn.setTitleColor(UIColor.navigationbarColor, for: .normal)
        forgetPasswordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        let width = "忘记密码".localized.widthWithConstrainedWidth(height: 16, font: UIFont.systemFont(ofSize: 13)) + 10
        forgetPasswordBtn.frame = CGRect(x: (screenWidth - width)/2, y: loginBtn.maxy + 10, width: width, height: 16)
        
        let versionLabel = UILabel(frame: CGRect(x:0,y:self.view.frame.size.height - 64 - 40 - 40 ,width:screenWidth,height:35))
        versionLabel.textAlignment = .center
        versionLabel.textColor = UIColor.gray
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        
        headerView.addSubview(versionLabel)
        var versionString = "人生药业Version:" + "1.0.0"
        #if DEBUG
            versionString = versionString + "(D)"
        #else
            // TODO
        #endif
        versionLabel.text = versionString
        
        headerView.addSubview(Phonetextfield)
        headerView.addSubview(PassWorkfield)
        headerView.addSubview(loginBtn)
        headerView.addSubview(forgetPasswordBtn)
        
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: forgetPasswordBtn.maxy + 10)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func forgetPassword(){
        let forget = ForgetPassWotdController()
        self.navigationController?.pushViewController(forget, animated: true)
    }
    
    @objc func phoneValueChanaged(sender:YCTextField){
        guard let text = PassWorkfield.text,
            let phone = Phonetextfield.text else {
            return
        }
        if text.count >= 6 && phone.count>8 {
           loginBtn.backgroundColor = UIColor.navigationbarColor
           loginBtn.isEnabled = true
        }else {
           loginBtn.backgroundColor = UIColor.lightGray
           loginBtn.isEnabled = false
        }
        
    }
    
    
    private func loginWithPhoneNumber(_ phoneNumber: String,
                                      _ password: String)
    {
         showLoading()
         loginEnc(memberId: phoneNumber, password: password) { [weak self] result in
            guard let strongself = self else { return }
            strongself.hideLoading()
            switch result{
            case .success(let dataJson):
                var json = JSON(dataJson)
                let flag = json["flag"].stringValue
                var idfa: String = ""
                if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                    idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
                if flag == "success" {
                    let accountModel = YCAccountModel()
                    let token = json["token"].stringValue
                    let newtoken = token + "|" + idfa
                    accountModel.memid = json["memid"].string
                    accountModel.token = newtoken
                    accountModel.customId = json["custom_id"].stringValue
                    accountModel.mall_home_id = json["mall_home_id"].string
                    accountModel.password = strongself.PassWorkfield.text
                    let objectTodata = NSKeyedArchiver.archivedData(withRootObject: accountModel)
                    YCUserDefaults.accountModel.value = objectTodata
                    NotificationCenter.default.post(name: NSNotification.Name.longinState, object: true)
                    strongself.loginSuccessCallBack?()
                    if strongself.isChattingLogin == true {
                        let shareModel = YCShareModel()
                        shareModel.action_type = "100"
                        shareModel.phone_number = ""
                        shareModel.password = ""
                        shareModel.token = ""
                        shareModel.type = "100"
                        let shareString = YCShareAddress.getWith(shareModel)
                        YCShareAddress.share(with: shareString)
                    }
                }else {
                    strongself.yc_showErrMessage(nil, subtitle: json["msg"].string)
                }

            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
            
        }
    }
    
    
    @objc func clickLogin(){
        view.endEditing(true )
        loginWithPhoneNumber(Phonetextfield.text!,PassWorkfield.text!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YCLoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
}

extension YCLoginViewController {
    
    func loginEnc(memberId: String, password: String,completion:@escaping(NetWorkResult<JSONDictionary>) -> Void)
    {
        
        var idfa:String = ""
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        let parse:(JSONDictionary) -> JSONDictionary? = { $0 }
        let sha512 = password.sha512()
        let requestParameter:[String:Any] = [
            "MemberID":memberId,
            "PassWord":sha512,
            "deviceNo":idfa
        ]
        
//        let resource = NetResource.init( path: "/Member/MemberLoginENC", method: .post, parameters: requestParameter, parameterEncoding: JSONEncoding.init(), parse: parse)
        let netResource = NetResource(path: "/Member/MemberLoginENC",method: .post,parameters: requestParameter,parse: parse)
        YCProvider.requestDecoded(netResource, queue: nil, completion: completion)
    }
}
