//
//  ChangePassWordController.swift
//  Portal
//
//  Created by PENG LIN on 2017/7/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import CryptoSwift

class ChangePassWordController: BaseViewController {
    
    var newPasswordfield: YCTextField!
    var newPasswordConfirmfield: YCTextField!
    var oldPasswordfield: YCTextField!
    var confirmBtn: UIButton!
    
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
		title = "비밀번호 변경";
        view.backgroundColor = UIColor.groupTableViewBackground
        
        oldPasswordfield = YCTextField(frame: CGRect(x: leftEdges, y: toTopEdges + 64, width: (screenWidth - leftEdges*2), height: textfieldHeight))
        oldPasswordfield.placeholder = "기존비밀번호"
        oldPasswordfield.layer.backgroundColor = UIColor.white.cgColor
        oldPasswordfield.cornerRadius = textfieldHeight/2
        oldPasswordfield.clearButtonMode = .whileEditing
        oldPasswordfield.isSecureTextEntry = true
        oldPasswordfield.delegate = self
        view.addSubview(oldPasswordfield)

        newPasswordfield = YCTextField(frame:CGRect(x: leftEdges,
                                                    y: oldPasswordfield.maxy + textfieldEdges,
                                                    width: oldPasswordfield.width,
                                                    height: oldPasswordfield.height))
        newPasswordfield.placeholder = "새 비밀번호"
        newPasswordfield.cornerRadius = textfieldHeight/2
        newPasswordfield.clearButtonMode = .whileEditing
        newPasswordfield.isSecureTextEntry = true
        newPasswordfield.layer.backgroundColor = UIColor.white.cgColor
        newPasswordfield.delegate = self
        view.addSubview(newPasswordfield)
        
        newPasswordConfirmfield = YCTextField(frame:CGRect(x: leftEdges,
                                                           y: newPasswordfield.maxy + textfieldEdges,
                                                           width: oldPasswordfield.width,
                                                           height: oldPasswordfield.height))
        newPasswordConfirmfield.placeholder = "새 비밀번호 확인"
        newPasswordConfirmfield.cornerRadius = textfieldHeight/2
        newPasswordConfirmfield.clearButtonMode = .whileEditing
        newPasswordConfirmfield.isSecureTextEntry = true
        newPasswordConfirmfield.layer.backgroundColor = UIColor.white.cgColor
        newPasswordConfirmfield.delegate = self
        view.addSubview(newPasswordConfirmfield)
            
        confirmBtn = UIButton(type: .custom)
        confirmBtn.frame = CGRect(x: leftEdges, y: newPasswordConfirmfield.maxy + textfieldEdges, width: oldPasswordfield.width, height: oldPasswordfield.height)
        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.layer.cornerRadius = textfieldHeight/2
        confirmBtn.layer.backgroundColor = UIColor.YClightGrayColor.cgColor
        confirmBtn.isEnabled = false
        view.addSubview(confirmBtn)
        confirmBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            if self?.newPasswordConfirmfield.text != self?.newPasswordfield.text {
                YCAlert.alertSorry(message: "您设置的密码不相同", inViewController: self)
                return
            }
            self?.showLoading()
            guard let this = self else { return }
            this.changePassword(new: this.newPasswordfield.text!, old: this.oldPasswordfield.text!, completion: { result in
                  self?.hideLoading()
                  switch result {
                  case .success(let json):
                     let swiftjson = JSON(json)
                     let status = swiftjson["status"].intValue
                     if status == 1 {
                        let account = YCAccountModel.getAccount()!
                        account.password = self?.newPasswordfield.text
                        let objectTodata = NSKeyedArchiver.archivedData(withRootObject: account)
                        YCUserDefaults.accountModel.value = objectTodata
                        self?.showMessage("변경완료")
                        delay(1.5, work: {
                            self?.view.endEditing(true)
                            self?.yc_back()
                        })
                    }else {
                        let msg = swiftjson["msg"].string
                        self?.showMessage(msg)
                    }
                  case .failure:
                    break
                }
            })
        }).disposed(by: disposebag)
        
        Observable.combineLatest(newPasswordfield.rx.text.orEmpty,
                                 oldPasswordfield.rx.text.orEmpty,
                                 newPasswordConfirmfield.rx.text.orEmpty)
        { newpassword, oldpassword ,confirmpassword -> Bool in
            if newpassword.count >= 6 && oldpassword.count >= 6 && confirmpassword.count >= 6{
               self.confirmBtn.layer.backgroundColor = UIColor.navigationbarColor.cgColor
               return true
            }else {
               self.confirmBtn.layer.backgroundColor = UIColor.YClightGrayColor.cgColor
               return false
            }
        }.bind(to: confirmBtn.rx.isEnabled).disposed(by: disposebag)
     }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
       return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChangePassWordController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChangePassWordController {

    func changePassword(new: String, old: String, completion: @escaping (NetWorkResult<JSONDictionary>) -> Void){
        
        let parse:(JSONDictionary) -> JSONDictionary? = { json in
            return json
        }
        let newhash = new.sha512()
        let oldhash = old.sha512()
        let customId = YCAccountModel.getAccount()?.customCode
        
        let requestParameter: [String:Any] = [
            "newPassword":newhash,
            "oriPassword":oldhash,
            "custom_code":customId ?? ""
        ]
        
        let netResource = NetResource(baseURL: URL(string: "http://api1.gigawon.co.kr:82")!,
                                      path: "/api/MemberInfo/changePassword",
                                      method: .post,
                                      parameters: requestParameter,
                                      parameterEncoding: JSONEncoding(),
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)

    }
}
