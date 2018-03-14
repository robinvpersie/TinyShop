//
//  OfflineShopCarController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftDate
import MBProgressHUD
import SwiftyJSON
import CryptoSwift

class OfflineShopCarController: OfflineBaseController {
        
    var tableView:UITableView!
    var dataSource = [OffShopCarModel](){
        didSet{
            underView.canPay = dataSource.isEmpty ? .empty:.canpay
        }
    }
    var indicator:UIActivityIndicatorView!
    var isloading = true
    var tickets:String = YCUserDefaults.tickets.value ?? ""
    lazy var passwordView = OffPasswordView()
    lazy var backView = OffBackView()
    var underView:OffShopCarUnderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "无人超市"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_esc"), style: .plain, target: self, action: #selector(backMarket))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self 
        tableView.emptyDataSetSource = self
        tableView.registerClassOf(OffShopCarCell.self)
        tableView.regisiterHeaderFooterClassOf(OrderDetailHeaderView.self)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.01))
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        underView = OffShopCarUnderView()
        underView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(underView)
        underView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        underView.widthAnchor.constraint(equalToConstant: Ruler.iPhoneHorizontal(300, 320, 330).value).isActive = true
        underView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        if #available(iOS 11.0, *) {
            underView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            underView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        }
        underView.Action = { [weak self] payState in
            guard let strongself = self else { return }
            switch payState {
            case .canpay:
                strongself.createTickets()
            case .empty:
                strongself.didRight()
            }
        }
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        indicator.startAnimating()
        requestData()
        
    }
    
    func backMarket(){
        showLoading()
        OffOutQrModel.CreateOffOutQR(tickets: tickets) { (result) in
            self.hideLoading()
            switch result {
            case .success(let data):
                let json = JSON(data)
                if json["status"] == 1 {
                    self.backView.code = json["qrData"].stringValue
                    self.backView.showInView(self.view.window!)
                    self.backView.continueAction = { [weak self] in
                        guard let strongself = self else { return }
                        strongself.checkTickets()
                    }
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            }
        }
    }
    
    func checkTickets(){
        if let ticket = YCUserDefaults.tickets.value {
            showLoading()
            OffCheckTicketModel.checkTicket(ticket: ticket, completion: { [weak self] (result) in
                guard let strongself = self else { return }
                strongself.hideLoading()
                switch result {
                case .failure(let error):
                    strongself.showMessage(error.localizedDescription)
                case .success(let value):
                    if value["status"].int == 1 {
                        YCUserDefaults.tickets.value = value["tickets"].stringValue
                        strongself.tickets = value["tickets"].stringValue
                    }else {
                        strongself.goRoot()
                    }
                case .tokenError:
                    strongself.goToLogin()
                }
            })
        }else {
            self.goRoot()
        }
    }
    
    func goRoot(){
        let offlineHome = OfflineHomeController()
        var viewcontrollers = self.navigationController!.viewControllers
        viewcontrollers.insert(offlineHome, at: 0)
        self.navigationController!.setViewControllers(viewcontrollers, animated: false)
        self.navigationController?.popToRootViewController(animated: true)

    }

    func pushToScanMarket(){
        let offlinescan = OfflineScanQRController()
        offlinescan.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(offlinescan, animated: true)
    }
    
    func createTickets(){
        self.showLoading()
        OffCartOrderModel.CreateOfflineCartsOrder(tickets: tickets, completion: { [weak self] (result) in
            guard let strongself = self else { return }
            strongself.hideLoading()
            switch result {
            case .success(let data):
                let json = JSON(data)
                if json["status"].int == 1 {
                   let model = OffCartOrderModel(json: json)
                    strongself.passwordView.showInView(strongself.view.window!)
                    strongself.passwordView.totalMoney = "￥\(model.amount)"
                    strongself.passwordView.passwordInputView.state = .normal
                    strongself.passwordView.payAction = {
                        strongself.payMoney(amount: "\(model.amount)", orderCode: model.order_code, password: strongself.passwordView.tempString)
                    }
                }else if json["status"].int == -9004 {
                    strongself.showMessage("需要重新扫描商场二维码", completionAction: {
                        strongself.pushToScanMarket()
                    })
                }else if json["status"].int == -16387 {
                   let modelArray = errorDataModel.geterrorData(json: json)
                   strongself.dataSource.forEach({ (element) in
                    for modelelement in modelArray {
                        if element.code == modelelement.itemCode {
                           element.isEmptyStock = true
                           element.stockQuantity = modelelement.stockQuantity
                           continue
                        }
                     }
                   })
                   strongself.tableView.reloadData()
                   strongself.showMessage(json["message"].string)
               }
            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
          })
        }
    
    func payMoney(amount:String,orderCode:String,password:String){
        let sha512 = password.sha512()
        let customId = YCAccountModel.getAccount()?.memid ?? ""
        KLHttpTool.supermarketPay(withUserID: customId, orderNumber: orderCode, orderMoney: amount, actualMoney: amount, point: "0", couponCode: "0", password: sha512, success: {  (data) in
             self.passwordView.passwordInputView.state = .normal
             self.passwordView.hide()
             let newjson = JSON(data!)
            if newjson["status"].int == 1 {
                OffUpdateRepeatModel.updateRepeatPayStatus(tickets:self.tickets,completion: { data in })
                let paysuccess = OfflinePaySuccessController()
                paysuccess.hidesBottomBarWhenPushed = true
                paysuccess.backAction = { [weak self] in
                    guard let strongself = self else { return }
                    strongself.requestData()
                }
                self.navigationController?.pushViewController(paysuccess, animated: true)
            }else {
                self.showMessage(newjson["msg"].string)
            }
        }) { (error) in
             self.passwordView.passwordInputView.state = .normal
             self.passwordView.hide()
        }
        
    }
    
    
    func requestData(){
        
        OffShopCarTotalModel.GetOfflineCartsList(with:tickets) { (result) in
            self.isloading = false
            self.hideLoading()
            self.indicator.stopAnimating()
            switch result {
            case .success(let json):
                if json.status == 1 {
                    self.dataSource = json.data
                }else if json.status == -9004 {
                    self.showMessage("需要重新扫描商场二维码", completionAction: {
                        self.pushToScanMarket()
                    })
                }else {
                    self.showMessage(json.msg)
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            }
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            waytoUpdate.performWithTableView(tableview: self.tableView)
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length + 66, 0)
        
    }
    
    override func yc_back() {
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func didRight(){
        let offScan = OfflineScanQRController()
        offScan.hidesBottomBarWhenPushed = true
        offScan.type = .goods
        offScan.backAction = { [weak self] model in
            guard let strongself = self else { return }
            if model.status == 1 {
                strongself.showLoading()
                strongself.requestData()
            }else {
                strongself.showMessage(model.message)
            }
        }
        navigationController?.pushViewController(offScan, animated: true)
    }
    
    func modifyQuantity(tickets:String,cartOfDetailld:Int,quantity:Int){
        
            showLoading()
            ModifyOffCarModel.ModifyOfflineCarts(tickets: tickets,
                                                 cartOfDetailld: cartOfDetailld,
                                                 quantity: quantity,
                                                 completion:
                { (result) in
                    self.hideLoading()
                    switch result {
                    case .success(let model):
                        if model.status == 1{
                            self.showLoading()
                            self.requestData()
                        }else if model.status == -9004 {
                            self.showMessage("需要重新扫描商场二维码", completionAction: {
                                self.pushToScanMarket()
                            })
                        }else {
                            self.showMessage(model.message)
                        }
                    case .failure(let error):
                        self.showMessage(error.localizedDescription)
                    }
               })
     }
    
    func deleteOfflineCarts(tickets:String,cartOfDetailld:Int){
        OffShopCarDeleteModel.deleteOfflineCarts(tickets: tickets, cartOfDetailld: cartOfDetailld) { (result) in
            switch result {
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            case .success(let data):
                let json = JSON(data)
                if json["status"].int == -9004 {
                    self.showMessage("需要重新扫描商场二维码", completionAction: {
                        self.pushToScanMarket()
                    })
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OfflineShopCarController:DZNEmptyDataSetSource{
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if isloading {
            return nil
        }else {
            return UIImage(named: "img_nothing")
        }
    }
    
}

extension OfflineShopCarController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OffShopCarCell.getHeight()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! OffShopCarCell
        cell.model = dataSource[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "删除") { [weak self] (action, index) in
            guard let this = self else { return }
            this.deleteOfflineCarts(tickets: this.tickets, cartOfDetailld: this.dataSource[index.row].cartOfDetailId)
            this.dataSource.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.left)
            tableView.endUpdates()
        }
        return [deleteRowAction]
    }
}


extension OfflineShopCarController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:OrderDetailHeaderView = tableView.dequeueReusableHeaderFooter()
        let mutableAtrributeString = NSMutableAttributedString()
        let first = NSAttributedString(string: "已选购", attributes: [NSForegroundColorAttributeName:UIColor(hex:0x333333)])
        mutableAtrributeString.append(first)
        let number = NSAttributedString(string: "\(dataSource.count)", attributes: [NSForegroundColorAttributeName:UIColor(hex: 0x43c3ff)])
        mutableAtrributeString.append(number)
        let second = NSAttributedString(string: "种商品",attributes:[NSForegroundColorAttributeName:UIColor(hex:0x333333)])
        mutableAtrributeString.append(second)
        header.titlelb.attributedText = mutableAtrributeString
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OffShopCarCell = tableView.dequeueReusableCell()
        cell.actionBlock = { [weak self] actionType , price in
            guard let strongself = self else { return }
            var quantity = strongself.dataSource[indexPath.row].quantity
            switch actionType {
            case .add:
               quantity += 1
            case .minus:
               quantity -= 1
            }
           strongself.modifyQuantity(tickets: strongself.tickets,
                                     cartOfDetailld: strongself.dataSource[indexPath.row].cartOfDetailId,
                                     quantity: quantity)
        }
        return cell
    }
    
}





