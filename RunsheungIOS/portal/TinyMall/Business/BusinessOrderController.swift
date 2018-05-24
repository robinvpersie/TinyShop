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
	lazy var orderTypeView = OrderMenuView()
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
        
        orderMenu = OrderMenuView()
        view.addSubview(orderMenu)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height: CGFloat = 60
        orderMenu.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0)
    
    }
    
    func requestTypeWithGroupId(_ groupId: String) {
        showLoading()
        let storeDetail = StoreDetailTarget(groupId: groupId)
        API.request(storeDetail)
            .filterSuccessfulStatusCodes()
            .map(StoreDetail.self, atKeyPath: "data")
            .subscribe { [weak self] event in
                self?.hideLoading()
                switch event {
                case let .success(value):
                    if let window = self?.view.window {
                        OperationQueue.main.addOperation {
                            self?.orderTypeView.showInView(window)
                            self?.orderTypeView.reloadDataWith(value)
                        }
                    }
                case .error:
                    break
                }
        }.disposed(by: Constant.dispose)
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
            
        }
        cell.buyAction = { [weak self] in
            if let strongself = self {
                strongself.requestTypeWithGroupId(strongself.productList[indexPath.row].GroupId)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}
