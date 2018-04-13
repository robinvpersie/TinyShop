//
//  InputAmountController.swift
//  Portal
//
//  Created by 이정구 on 2018/4/11.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SnapKit
import SwiftyJSON

class InputAmountController: BaseViewController {
    
    var scrollView: TPKeyboardAvoidingScrollView!
    var amountField: UITextField!
    @objc var numcode: String!
    @objc var payCompletion: ((Bool) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        title = "付款".localized
        
        scrollView = TPKeyboardAvoidingScrollView()
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
    
        let whiteWarrperView = UIView()
        whiteWarrperView.layer.backgroundColor = UIColor.white.cgColor
        whiteWarrperView.layer.cornerRadius = 5
        scrollView.addSubview(whiteWarrperView)
        
        let topImageView = UIImageView()
        topImageView.image = UIImage(named: "img_default_business")
        scrollView.addSubview(topImageView)
        
        let titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.text = "向商家付款".localized
        titlelb.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(titlelb)
        
        let inputWrapper = UIView()
        inputWrapper.backgroundColor = UIColor.groupTableViewBackground
        scrollView.addSubview(inputWrapper)
        
        let moneylb = UILabel()
        moneylb.text = ""
        moneylb.textColor = UIColor.darkText
        moneylb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        inputWrapper.addSubview(moneylb)
        
        amountField = UITextField()
        amountField.placeholder = "请输入付款金额".localized
        amountField.delegate = self
        amountField.keyboardType = .numberPad
        amountField.textAlignment = .right
        inputWrapper.addSubview(amountField)
        
        let payBtn = UIButton(type: .custom)
        payBtn.setTitle("付款".localized, for: .normal)
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        payBtn.layer.backgroundColor = UIColor(red: 32, green: 183, blue: 58).cgColor
        payBtn.layer.cornerRadius = 4
        payBtn.addTarget(self, action: #selector(pay), for: .touchUpInside)
        scrollView.addSubview(payBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(view)
        }
        
        topImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(scrollView).offset(ratioHeight(60))
            make.width.height.equalTo(ratioWidth(40))
        }
        
        titlelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(topImageView)
            make.top.equalTo(topImageView.snp.bottom).offset(15)
        }
        
        inputWrapper.snp.makeConstraints { (make) in
            make.leading.equalTo(whiteWarrperView).offset(ratioWidth(15))
            make.trailing.equalTo(whiteWarrperView).offset(-ratioWidth(15))
            make.top.equalTo(titlelb.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        moneylb.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputWrapper)
            make.leading.equalTo(inputWrapper).offset(10)
        }
        
        amountField.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputWrapper)
            make.trailing.equalTo(inputWrapper).offset(-10)
        }
        
        payBtn.snp.makeConstraints { (make) in
            make.width.equalTo(inputWrapper)
            make.height.equalTo(40)
            make.top.equalTo(inputWrapper.snp.bottom).offset(30)
            make.centerX.equalTo(inputWrapper)
        }
        
        
        whiteWarrperView.snp.makeConstraints { (make) in
            make.width.equalTo(scrollView).offset(-ratioWidth(30))
            make.centerX.equalTo(scrollView)
            make.top.equalTo(scrollView).offset(ratioHeight(15))
            make.bottom.equalTo(payBtn).offset(20)
            make.bottom.equalTo(scrollView).offset(-20)
        }
    }
    
    @objc func pay() {
        guard let amount = amountField.text,
            !amount.isEmpty else {
            showMessage("금액을 입력하세요")
            return
        }
        
        let passwordView = CYPasswordView()
        passwordView.title = "결제 비밀번호를 입력해주세요"
        passwordView.loadingText = "결제중..."
        passwordView.show(in: view.window!)
        passwordView.finish = { [weak self] password in
            guard let this = self else { return }
            if let password = password, let account = YCAccountModel.getAccount() {
                    let target = PayTarget(password: password, customCode: account.customCode, storeCustomCode: this.numcode, amount: this.amountField.text!)
                    target.pay { result in
                        switch result {
                        case .success(let json):
                            let json = JSON(json)
                            if json["status"].string == "1" {
                                passwordView.requestComplete(true, message: "success")
                                this.payCompletion?(true)
                            } else {
                                passwordView.requestComplete(false, message: json["msg"].string)
                                this.payCompletion?(false)
                            }
                        case .failure(let error):
                            passwordView.requestComplete(false, message: error.localizedDescription)
                            this.payCompletion?(false)
                        }
                    }
                } else {
                    this.goToLogin(completion: nil)
                }
            
        }
    
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension InputAmountController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
