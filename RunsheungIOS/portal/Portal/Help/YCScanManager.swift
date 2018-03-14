//
//  YCScanManager.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct YCScanManager {
    
    static let share = YCScanManager()
    
    func done(token:String,memid:String,Parameters:[String]){

            let passwordView = CYPasswordView()
            passwordView.loadingText = "提交中...".localized
            passwordView.title = "输入交易密码".localized
            passwordView.show(in: UIApplication.shared.keyWindow!)
            passwordView.finish = {  password in
                let encryptPassword = password!.sha512()
                passwordView.hideKeyboard()
                passwordView.startLoading()
                let parse:(JSONDictionary)-> JSONDictionary = { json in
                    return json
                }
                let storeCode = Parameters[0]
                let parterkey = Parameters[1]
                let orderno = Parameters[2]
                let orderdate = Parameters[3]
                let orderamount = Parameters[4]

                let requestParameters:[String:Any] = [
                    "order_amount":orderamount,
                    "partner_key":parterkey,
                    "store_code":storeCode,
                    "sPay_user_id":memid,
                    "token":token,
                    "order_date":orderdate,
                    "spayPWD":encryptPassword,
                    "order_no":orderno
                ]
                let resource = NetResource(baseURL: URL(string:"http://192.168.2.179:82")!,
                                           path: "/api/QRPayment/posQRAppPayment",
                                           method: .post,
                                           parameters: requestParameters,
                                           parse: parse)
                YCProvider.requestDecoded(resource, completion: { result in
                    switch result {
                    case .success(let json):
                        let Json = JSON(json)
                        let status = Json["status"].intValue
                        if status == 1711 {
                            passwordView.requestComplete(false, message: "余额不足".localized)
                        }else if status == 1 {
                            passwordView.requestComplete(true, message: "支付成功".localized)
                        }else if status == 10 {
                            passwordView.requestComplete(false, message: "支付密码错误".localized)
                        }else if status == 1603 {
                            passwordView.requestComplete(false, message: "无法确认登录信息".localized)
                        }else if status == 1101 {
                            passwordView.requestComplete(false, message: "没有支付密码".localized)
                        }else if status == -9001{
                            passwordView.requestComplete(false, message: Json["msg"].stringValue)
                        }else {
                            passwordView.requestComplete(false, message: Json["msg"].stringValue)
                        }
                        delay(2, work: {
                            passwordView.hide()
                        })
                    case .failure(let error):
                        passwordView.requestComplete(false, message: error.localizedDescription)
                        delay(2, work: {
                            passwordView.hide()
                        })
                    }
                })
            }
        }
    

    
    func managerWith(didScanResult result: String!,inController controller:UIViewController?){
        
        let seperated = result.components(separatedBy: "?")
        guard let first = seperated.first else {
            return
        }
        if seperated.count > 1 {
            let query:String = seperated[1]
            if first.contains("yuchang") && first.contains("posPay") {
                let Parameters = query.components(separatedBy: "|")
                CheckToken.chekcTokenAPI(completion: { (result) in
                    switch result {
                    case .success(let value):
                        if value.status == "1" {
                            self.done(token:value.newtoken,memid:value.custom_code,Parameters:Parameters)
                        }else {
                            controller?.goToLogin()
                        }
                    case .failure(let error):
                        controller?.showMessage(error.localizedDescription)
                    }
                })
            }
        }else {
            let detail = GoodsDetailController()
            detail.item_code = result
            detail.isScan = true
            detail.hidesBottomBarWhenPushed = true
            controller?.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
}
