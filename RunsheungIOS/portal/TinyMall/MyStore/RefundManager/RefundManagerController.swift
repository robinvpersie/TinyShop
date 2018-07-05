//
//  RefundManagerController.swift
//  Portal
//
//  Created by 이정구 on 2018/6/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RefundManagerController: MyStoreBaseViewController {
    
    enum Section: Int {
        case profile
        case orderMenu
        case refundDetail
        
        init(indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(section: Int) {
            self.init(rawValue: section)!
        }
    }
    
    var tableView: UITableView!
    var model: OrderReturnModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "환불정보"
        //        view.backgroundColor = UIColor(hex: 0xf2f4f6)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor(hex: 0xf2f4f6)
        tableView.backgroundColor = UIColor(hex: 0xf2f4f6)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(RefundHeaderCell.self)
        tableView.registerClassOf(RefundOrderMenuCell.self)
        //        tableView.register(UINib(nibName: "RefundInfoCell", bundle: nil), forCellReuseIdentifier: "RefundInfoCell")
        tableView.registerClassOf(RefundInfoTableViewCell.self)
        tableView.regisiterHeaderFooterClassOf(UITableViewHeaderFooterView.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func footerView() -> UIView? {
        
        let footer = UIView()
        footer.backgroundColor = UIColor(hex: 0xf2f4f6)
        footer.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 100)
        
        let agreenBtn = UIButton(type: .custom)
        agreenBtn.layer.backgroundColor = UIColor(hex: 0xe92c1e).cgColor
        agreenBtn.layer.cornerRadius = 5
        agreenBtn.setTitle("同意退款", for: .normal)
        agreenBtn.setTitleColor(UIColor.white, for: .normal)
        agreenBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footer.addSubview(agreenBtn)
        agreenBtn.snp.makeConstraints { make in
            make.width.equalTo(footer).multipliedBy(0.85)
            make.height.equalTo(45)
            make.top.equalTo(footer).offset(25)
            make.centerX.equalTo(footer)
        }
        
        return footer
    }
    
    @objc func didAgreen() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension RefundManagerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(indexPath: indexPath)
        switch section {
        case .profile:
            return RefundHeaderCell.getHeight()
        case .orderMenu:
            return RefundOrderMenuCell.getHeightWithModel(model)
        case .refundDetail:
            return RefundInfoCell.getHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooter()
        //        footer.backgroundColor = UIColor(hex: 0xf2f4f6)
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = Section(section: section)
        switch section {
        case .profile, .orderMenu:
            return 10
        case .refundDetail:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension RefundManagerController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(indexPath: indexPath)
        switch section {
        case .profile:
            let cell: RefundHeaderCell = tableView.dequeueReusableCell()
            cell.configureWithModel(model)
            return cell
        case .orderMenu:
            let cell: RefundOrderMenuCell = tableView.dequeueReusableCell()
            cell.configureWithModel(model)
            return cell
        case .refundDetail:
            let cell: RefundInfoTableViewCell = tableView.dequeueReusableCell()
            cell.configureWithModel(model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
