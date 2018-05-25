//
//  BusinessOrderController.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessOrderController: BaseController {
    
    var tableView: UITableView!
    var orderMenu: OrderMenuView!
	var pushView: OrderMenuPushView!
    var itemSelected = [SelectModel: Int]()
    var totalNum: Int = 0
    var totalPrice: Float = 0
    var pushDataSource = [(SelectModel, Int)]()
 
    lazy var orderTypeView = OrderTypeView()
    
    var productList = [Plist]() {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90.hrpx
        tableView.estimatedRowHeight = 90.hrpx
        tableView.registerClassOf(BusinessOrderCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        pushView = OrderMenuPushView()
        pushView.actionBlock = { [weak self] type, model in
            guard let this = self else {
                return
            }
            switch type {
            case .add:
                this.itemSelected[model.model, default: 0] += 1
                this.totalNum += 1
                this.totalPrice += model.model.itemP
            case .sub:
                if model.num == 0 {
                   this.itemSelected.removeValue(forKey: model.model)
                } else {
                   this.itemSelected[model.model, default: 0] -= 1
                }
                this.totalNum -= 1
                this.totalPrice -= model.model.itemP
            }
            this.menuReloadData()
        }
        view.addSubview(pushView)
        
        orderMenu = OrderMenuView()
        orderMenu.pushAction = { [weak self] in
            guard let this = self else { return }
            if this.pushView.isUp {
                this.pushView.hide()
            }else {
//                var dataSource = [(SelectModel, Int)]()
//                this.itemSelected.forEach({ select, num in
//                    let plist = this.productList[select.indexPath.row]
//                    let select
//                    dataSource.append((plist, num))
//                })
                this.pushView.showWithModel(this.itemSelected)
            }
        }
        orderMenu.payAction = { [weak self] in
            
        }
        view.addSubview(orderMenu)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height: CGFloat = 60
        orderMenu.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0)
        pushView.frame = view.frame
    
    }
    
    func requestTypeWithGroupId(_ groupId: String, plist: Plist, indexPath: IndexPath) {
        showLoading()
        let storeDetail = StoreDetailTarget(groupId: groupId)
        API.request(storeDetail)
            .filterSuccessfulStatusCodes()
            .map(StoreDetail.self, atKeyPath: "data")
            .subscribe { [weak self] event in
                self?.hideLoading()
                switch event {
                case let .success(value):
                   OperationQueue.main.addOperation {
                    if let window = self?.view.window {
                        self?.orderTypeView.showInView(window)
                        self?.orderTypeView.reloadDataWith(value, plist: plist)
                        self?.orderTypeView.buyAction = { itemCode, price, name in
                            guard let this = self else { return }
                            let model = SelectModel(indexPath: indexPath, itemCode: itemCode, name: name, itemp: price)
                            this.itemSelected[model, default: 0] += 1
                            this.totalPrice += price
                            this.totalNum += 1
                            this.menuReloadData()
                        }
                      }
                   }
                case .error:
                    break
                }
        }.disposed(by: Constant.dispose)
    }
    
    func menuReloadData() {
        orderMenu.totalPrice = totalPrice
        orderMenu.badgeValue = totalNum
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BusinessOrderController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! BusinessOrderCell
        cell.configureWithPlist(productList[indexPath.row])
    }
    
}

extension BusinessOrderController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessOrderCell = tableView.dequeueReusableCell()
        cell.addAction = { [weak self] in
            guard let this = self else {
                return
            }
            let plist = this.productList[indexPath.row]
            let selectModel = SelectModel(indexPath: indexPath, itemCode: plist.item_code, name: plist.item_name, itemp: Float(plist.item_p)!)
            this.itemSelected[selectModel, default: 0] += 1
            this.totalNum += 1
            this.orderMenu.badgeValue = this.totalNum
            this.totalPrice += Float(plist.item_p) ?? 0
            this.orderMenu.totalPrice = this.totalPrice
        }
        cell.buyAction = { [weak self] in
            if let strongself = self {
                let product = strongself.productList[indexPath.row]
                strongself.requestTypeWithGroupId(product.GroupId, plist: product, indexPath: indexPath)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}
