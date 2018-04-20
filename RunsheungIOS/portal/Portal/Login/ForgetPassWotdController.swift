//
//  ForgetPassWotdController.swift
//  Portal
//
//  Created by PENG LIN on 2017/7/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CryptoSwift
import SwiftyJSON
import TPKeyboardAvoiding

class ForgetPassWotdController: BaseViewController {

    var phoneField: InputFieldView!
    var messagefield: InputFieldView!
	var getVerifyCode: UIButton!
	var newpwdField:InputFieldView!
	var timer:Timer!
	var countInt:Int!
	
    var scrollView: TPKeyboardAvoidingScrollView!
	
//    var newPasswordField:YCTextField!
//    var confirmPasswordField:YCTextField!
    var resetBtn: UIButton!
//    var codebtn:YCAuthCodeBtn!
//    let disbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countInt = 60
        title = "忘记密码".localized
        
        makeUI()
        
//        tableView.tableHeaderView = self.headerView()
//        tableView.tableFooterView = UIView()
//        tableView.showsVerticalScrollIndicator = false
//        tableView.keyboardDismissMode = .onDrag
//        tableView.backgroundColor = UIColor.BaseControllerBackgroundColor
        
//        self.addObserve()
    }
    
    func makeUI() {
        
        scrollView = TPKeyboardAvoidingScrollView()
        scrollView.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(view)
        }
        
        phoneField = InputFieldView()
        phoneField.font = UIFont.systemFont(ofSize: 14)
		phoneField.placeHolder = "휴대전화 번호를 입력해 주세요"
        scrollView.addSubview(phoneField)
        phoneField.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView).multipliedBy(0.85)
            make.height.equalTo(40)
            make.top.equalTo(scrollView).offset(30)
        }
        
        messagefield = InputFieldView()
        messagefield.font = UIFont.systemFont(ofSize: 14)
		messagefield.placeHolder = "인증번호를 입력해 주세요"
        scrollView.addSubview(messagefield)
        messagefield.snp.makeConstraints { (make) in
            make.leading.height.equalTo(phoneField)
			make.trailing.equalTo(phoneField.snp.trailing).offset(-120)
            make.top.equalTo(phoneField.snp.bottom).offset(20)
        }
		
		getVerifyCode = UIButton()
		getVerifyCode.titleLabel?.font=UIFont.systemFont(ofSize: 14)
		getVerifyCode.setTitle("接受验证码".localized, for: .normal)
		getVerifyCode.setBackgroundImage(UIImage(named: "green"), for: .normal)
		getVerifyCode.addTarget(self, action: #selector(getVerifyCodeBtn), for: .touchUpInside)
		scrollView.addSubview(getVerifyCode)
		getVerifyCode.snp.makeConstraints { (make) in
			make.bottom.top.equalTo(messagefield)
			make.leading.equalTo(messagefield.snp.trailing).offset(8)
			make.trailing.equalTo(phoneField.snp.trailing)
		}
		
		newpwdField = InputFieldView()
		newpwdField.font = UIFont.systemFont(ofSize: 14)
		newpwdField.placeHolder = "휴대전화 번호를 입력해 주세요"
		scrollView.addSubview(newpwdField)
		newpwdField.snp.makeConstraints { (make) in
			make.leading.trailing.height.equalTo(phoneField)
			make.top.equalTo(messagefield.snp.bottom).offset(20)
			
		}

        resetBtn = UIButton(type: .custom)
        resetBtn.addTarget(self, action: #selector(didReset), for: .touchUpInside)
        resetBtn.setTitle("확인", for: .normal)
        resetBtn.setTitleColor(UIColor.white, for: .normal)
        resetBtn.backgroundColor = UIColor(red: 28, green: 141, blue: 36)
        scrollView.addSubview(resetBtn)
        resetBtn.snp.makeConstraints { (make) in
            make.leading.width.height.equalTo(phoneField)
            make.top.equalTo(newpwdField.snp.bottom).offset(20)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
    }
    
    override func yc_back() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

	@objc private func getVerifyCodeBtn(){
//		self.getVerifyCode.setTitle("还剩".localized + "60"+"s", for: .normal)
		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reverseCountTime), userInfo: nil, repeats: true)
		self.timer.fire()
		if phoneField.text.count>0 {
			
			KLHttpTool.tinySMSlogin(withPhone: phoneField.text, success: { (response) in
				let dic:NSDictionary = response as! NSDictionary
				let status:String = dic["status"] as! String
				if Int(status) == 1 {
					self.getVerifyCode.setTitle("还剩".localized + "60"+"s", for: .normal)
					self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reverseCountTime), userInfo: nil, repeats: true)
					self.timer.fire()
				}
				
			}) { (error) in
				
			}

		}
	}
	@objc private func reverseCountTime(){
		
		if countInt > 0{
			self.getVerifyCode.setTitle("还剩".localized + String(self.countInt)+"s", for: .normal)
			countInt = countInt-1
		}else {
			self.getVerifyCode.setTitle("接受验证码".localized , for: .normal)
			timer.invalidate()
		}
		
	}
    
    @objc func didReset() {
		
		self.resetPassword(phone: self.phoneField.text,password: self.newpwdField.text,authNum: self.messagefield.text,failureHandler: { reason, errormessage in
			self.hideLoading()
			self.showMessage(errormessage)
		}, completion: { json in
			self.hideLoading()
			let json = JSON(json!)
			let status = json["status"].intValue
			let msg = json["msg"].string
			if status == 1 {
				self.showMessage("成功")
				delay(1.5, work: {
					self.navigationController?.popViewController(animated: true)
				})
			}else {
			   self.showMessage(msg)
			}
		})
	}
//    func addObserve(){
//
//        Observable.combineLatest(phoneField.rx.text.orEmpty, messagefield.rx.text.orEmpty,newPasswordField.rx.text.orEmpty) { [weak self] phone,sms,newpassword -> Bool in
//            guard let this = self else { return false }
//            if phone.characters.count >= 7 && sms.characters.count >= 4 && newpassword.characters.count >= 6 {
//               this.resetBtn.layer.backgroundColor = UIColor.navigationbarColor.cgColor
//               return true
//            }else {
//               this.resetBtn.layer.backgroundColor = UIColor.YClightGrayColor.cgColor
//               return false
//            }
//        }
//        .bind(to: resetBtn.rx.isEnabled)
//        .disposed(by: disbag)
//
//    }
    
    func headerView() {
       
//        phoneField = YCTextField(frame: CGRect(x: leftEdges, y: toTopEdges, width: screenWidth -  leftEdges * 2, height: textfieldHeight))
//        phoneField.layer.backgroundColor = UIColor.white.cgColor
//        phoneField.placeholder = "请输入您的手机号码".localized
//        phoneField.cornerRadius = textfieldHeight/2
//        phoneField.rightviewWidth = 10
//        phoneField.righttopedges = textfieldrighttopedges
//        phoneField.delegate = self
//        phoneField.rightViewMode = .always
//        let phoneimageview = UIImageView(image:UIImage.phone)
//        phoneField.rightView = phoneimageview
//        phoneField.keyboardType = .numberPad
//        phoneField.font = UIFont.systemFont(ofSize: 13)
//
//        messagefield = YCTextField(frame: CGRect(x: leftEdges, y: phoneField.maxy + textfieldEdges, width: screenWidth -  leftEdges * 2, height: textfieldHeight))
//        messagefield.layer.backgroundColor = UIColor.white.cgColor
//        messagefield.placeholder = "请输入短信验证码".localized
//        messagefield.cornerRadius = textfieldHeight/2
//        messagefield.rightviewWidth = 80
//        messagefield.righttopedges = 8
//        messagefield.delegate = self
//        messagefield.rightViewMode = .always
//        messagefield.keyboardType = .numberPad
//        messagefield.font = UIFont.systemFont(ofSize: 13)

//        codebtn = YCAuthCodeBtn(type: .custom)
//        codebtn.frame = CGRect(x: 0, y: 8, width: 80, height: textfieldHeight - 16)
//        codebtn.layer.masksToBounds = true
//        codebtn.layer.cornerRadius = (textfieldHeight - 16)/2
//        codebtn.clickAuth = { [weak self] in
//            guard let strongself = self,let text = strongself.phoneField.text,text.characters.count >= 7 else {
//                self?.showMessage("请输入正确的电话号码".localized)
//                return
//            }
//            strongself.acceptAuthCode(phone: text, failureHandler: { reason, errormessage in
//                strongself.showMessage(errormessage)
//            }, completion: { json in
//                let js = JSON(json!)
//                let status = js["status"].intValue
//                let msg = js["msg"].string
//                if status != 1 {
//                   strongself.codebtn.restore()
//                }
//                strongself.showMessage(msg)
//            })
//        }
//
//        codebtn.canstart = { [weak self] in
//            guard let strongself = self,let text = strongself.phoneField.text,text.characters.count > 7 else {
//                    return false
//            }
//            return true
//        }
//        messagefield.rightView = codebtn
//
//        newPasswordField = YCTextField(frame: CGRect(x: leftEdges, y:self.messagefield.maxy + textfieldEdges , width: screenWidth -  leftEdges * 2, height: textfieldHeight))
//        newPasswordField.layer.backgroundColor = UIColor.white.cgColor
//        newPasswordField.placeholder = "设置新密码".localized
//        newPasswordField.isSecureTextEntry = true
//        newPasswordField.delegate = self
//        newPasswordField.cornerRadius = textfieldHeight/2
//        newPasswordField.righttopedges = textfieldrighttopedges
//        newPasswordField.font = UIFont.systemFont(ofSize: 13)
//
//        confirmPasswordField = YCTextField(frame: CGRect(x: leftEdges, y:self.newPasswordField.maxy + textfieldEdges , width: screenWidth -  leftEdges * 2, height: textfieldHeight))
//        confirmPasswordField.layer.backgroundColor = UIColor.white.cgColor
//        confirmPasswordField.placeholder = "确认新密码".localized
//        confirmPasswordField.isSecureTextEntry = true
//        confirmPasswordField.delegate = self
//        confirmPasswordField.cornerRadius = textfieldHeight/2
//        confirmPasswordField.righttopedges = textfieldrighttopedges
//        confirmPasswordField.font = UIFont.systemFont(ofSize: 13)
//
//        resetBtn = UIButton(type: .custom)
//        resetBtn.setTitle("确认重置".localized, for: .normal)
//        resetBtn.frame = CGRect(x: leftEdges, y: self.confirmPasswordField.maxy + textfieldEdges, width: confirmPasswordField.width, height: textfieldHeight)
//        resetBtn.layer.backgroundColor = UIColor.YClightGrayColor.cgColor
//        resetBtn.layer.cornerRadius = textfieldHeight/2
//        resetBtn.isEnabled = false
//        resetBtn.rx.tap.subscribe(onNext:{ [weak self] in
//            guard let strongself = self else { return }
//            if strongself.newPasswordField.text != strongself.confirmPasswordField.text {
//               strongself.showMessage("设置的密码不一致".localized)
//                return
//            }
//            strongself.view.endEditing(true)
//            strongself.showLoading()
//            strongself.resetPassword(phone: strongself.phoneField.text,password: strongself.newPasswordField.text,authNum: strongself.messagefield.text,failureHandler: { reason, errormessage in
//                strongself.hideLoading()
//                strongself.showMessage(errormessage)
//            }, completion: { json in
//                strongself.hideLoading()
//                let json = JSON(json!)
//                let status = json["status"].intValue
//                let msg = json["msg"].string
//                if status == 1 {
//                    strongself.showMessage("成功")
//                    delay(1.5, work: {
//                        strongself.navigationController?.popViewController(animated: true)
//                    })
//                }else {
//                   strongself.showMessage(msg)
//                }
//            })
//        }).addDisposableTo(disbag)
//
//        let headerView = UIView()
//        headerView.addSubview(phoneField)
//        headerView.addSubview(messagefield)
//        headerView.addSubview(newPasswordField)
//        headerView.addSubview(confirmPasswordField)
//        headerView.addSubview(resetBtn)
//        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: resetBtn.maxy + 10)
//        return headerView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ForgetPassWotdController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
    }
}

extension ForgetPassWotdController {
    
    func resetPassword(phone:String?,password:String?,authNum:String?,failureHandler:@escaping FailureHandler,completion:@escaping (JSONDictionary?)->Void){
        let parse:(JSONDictionary) -> JSONDictionary? = { json in
            return json
        }
        let pass = password!.sha512()
        let requestParameters:[String:Any] = [
            "HPNum":phone!,
            "Password":pass,
            "AuthNum":authNum!
        ]
        let resource = AlmofireResource(Type: .PortalBase,path: "/Member/ForgotSetPassword",method: .post,requestParameters: requestParameters,parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
    
    
    func acceptAuthCode(phone:String?,failureHandler:@escaping FailureHandler,completion:@escaping (JSONDictionary?)->Void) {
        
        let parse:(JSONDictionary) -> JSONDictionary? = { json in
            return json
        }
        let resource = AlmofireResource(Type: .PortalBase,
                                        path: "/Member/SMSAuthNumSendByPWD",
                                        method: .post,
                                        requestParameters: ["HPNum":phone!],
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
}
