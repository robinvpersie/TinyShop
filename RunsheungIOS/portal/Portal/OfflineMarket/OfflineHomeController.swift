//
//  OfflineHomeController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON

class OfflineHomeController: OfflineBaseController {
    
    var phoneImageView:UIImageView!
    var imgView:UIImageView!
    var QRImageView:UIImageView!
    var qrcode:DCQRCode!
    var cancleable:CancelableTask?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancleable?(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancleable?(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "线下商城"
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "img_small_banner")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgView)

        QRImageView = UIImageView()
        QRImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(QRImageView)
        
        phoneImageView = UIImageView()
        phoneImageView.image = UIImage(named: "img_scan")
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneImageView)

        let lb = UILabel()
        lb.text = "出示二维码扫码进入无人超市"
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = UIColor.YClightGrayColor
        lb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lb)
        
        imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            imgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            imgView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        imgView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        QRImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        QRImageView.topAnchor.constraint(equalTo: imgView.bottomAnchor,constant:30).isActive = true
        QRImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        QRImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        if let customId = YCAccountModel.getAccount()?.memid {
            let code = "1," + customId
            qrcode = DCQRCode(info: code, size: CGSize(width: 150, height: 150))
            QRImageView.image = qrcode.image()
        }
        
        phoneImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneImageView.topAnchor.constraint(equalTo: QRImageView.bottomAnchor, constant: 10).isActive = true
        phoneImageView.widthAnchor.constraint(equalToConstant: Ruler.iPhoneVertical(64, 50, 64, 64).value).isActive = true
        phoneImageView.heightAnchor.constraint(equalToConstant: Ruler.iPhoneVertical(150, 130, 130, 140).value).isActive = true
        
        lb.topAnchor.constraint(equalTo: phoneImageView.bottomAnchor, constant: 10).isActive = true
        lb.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cancleable = delay(0.2, work: { [weak self] in
             self?.requestByTimer()
        })
    }
    
    func requestByTimer(){
        handleDivCode { isSuccess in
            if !isSuccess {
                self.cancleable?(false)
            }else {
                self.cancleable?(true)
            }
        }
    }
    
    func handleDivCode(finish:((Bool)->Void)?){
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    getTicket(token: check.newtoken)
                }else {
                    self.goToLogin()
                }
            case .failure(let error):
                finish?(false)
            }
        }
        
        func getTicket(token:String){
            OffGetTicketModel.GetTickets(token: token) { (result) in
                switch result {
                case .success(let model):
                    if model.status == 1 {
                        YCUserDefaults.tickets.value = model.ticketsInfo!.tickets
                        let shopcar = OfflineShopCarController()
                        shopcar.tickets = model.ticketsInfo!.tickets
                        self.navigationController?.pushViewController(shopcar, animated: true)
                    }else {
                        finish?(false)
                    }
                case .failure(_):
                    finish?(false)
                }
            }
        }
    }
    
    
    
   override func yc_back() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
