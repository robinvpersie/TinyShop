//
//  OfflineScanQRController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON

class OfflineScanQRController: ZFScanViewController {

    enum barCodeType {
        case market
        case goods
    }

    var navigationBar: UINavigationBar!
    var indicator: UIActivityIndicatorView!
    var type: barCodeType = .market
    var ticket: String = YCUserDefaults.tickets.value ?? ""
    var backAction:((OffAddCartsModel)->Void)?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.autoGoBack = false
        
        navigationBar = UINavigationBar()
        navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.systemFont(ofSize: 19)]
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        let naviItem = UINavigationItem(title: "扫二维/条形码")
        naviItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(yc_back))
        naviItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationBar.items = [naviItem]
        view.addSubview(navigationBar)
        
        returnScanBarCodeValue = { [weak self] result in
            guard let strongself = self else { return }
            switch strongself.type {
            case .market:
                strongself.handleResult(result: result)
            case .goods():
                strongself.handleGoodsResult(result)
            }

        }
    }
    
    func handleGoodsResult(_ results:String?){
        showLoading()
        OffAddCartsModel.addOfflineCarts(tickets: ticket, barCodeString: results ?? "") { (result) in
            self.hideLoading()
            switch result {
            case .success(let model):
                self.backAction?(model)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                UIApplication.shared.keyWindow!.rootViewController?.showMessage(error.localizedDescription)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    
    func getTicket(divcode:String,token:String){
        OffGetTicketModel.GetTickets(token: token) { (result) in
            self.hideLoading()
            switch result {
            case .success(let model):
                if model.status == 1 {
                   YCUserDefaults.tickets.value = model.ticketsInfo!.tickets
                }else {
                   self.startRunning()
                   self.showMessage(model.msg)
                }
            case .failure(let error):
                self.startRunning()
                self.showMessage(error.localizedDescription)
            }
        }
 
    }
    
    func handleDivCode(_ divCode:String?){
        showLoading()
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                    self.getTicket(divcode: divCode ?? "", token: check.newtoken)
                }else {
                    self.hideLoading()
                    self.goToLogin(completion: {
                        self.handleDivCode(divCode)
                    })
                }
            case .failure(let error):
                self.hideLoading()
                self.startRunning()
                self.showMessage(error.localizedDescription)
            }
        }
    }
    
    func handleResult(result:String?){
         if let newresult = result,
            let urlComponenrs = URLComponents(string: newresult),
            urlComponenrs.scheme == "yucheng",
            urlComponenrs.host == "offlinemall" {
            guard let queryItems = urlComponenrs.queryItems else {
                startRunning()
                showMessage("此二维码中没有参数")
                return
            }
            queryItems.forEach({ (item) in
                if item.name == "div_code" {
                    handleDivCode(item.value)
                }
           })
         }else {
            startRunning()
            showMessage("没有扫描到结果")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view)
            let statusHeight = UIApplication.shared.statusBarFrame.height
            let naviheight = navigationController?.navigationBar.height ?? 0
            make.height.equalTo(statusHeight + naviheight)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
