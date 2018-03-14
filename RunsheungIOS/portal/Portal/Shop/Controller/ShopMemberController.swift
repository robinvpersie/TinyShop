//
//  ShopMemberController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopMemberController: ShopBaseViewController {
    
    fileprivate enum rowType:Int {
       case baihuo
       case jiameng
       case ruzhu
       case xianshang
       case piliang
       
       var title:String{
            switch self {
            case .baihuo:
                return "百货商场入驻咨询"
            case .jiameng:
                return "加盟咨询"
            case .ruzhu:
                return "商品入驻咨询"
            case .xianshang:
                return "线上开店咨询"
            case .piliang:
                return "批量购买咨询"
            }
        }
        
    }

    private lazy var tableview:UITableView = {
       let tableview = UITableView(frame: CGRect.zero, style: .plain)
       tableview.delegate = self
       tableview.dataSource = self
       tableview.registerClassOf(UITableViewCell.self)
       tableview.backgroundColor = UIColor.groupTableViewBackground
       tableview.tableFooterView = UIView()
       return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "入驻及购买咨询"
        self.view.addSubview(tableview)
        self.tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShopMemberController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = rowType(rawValue: indexPath.row) else { fatalError() }
        let consult = ShopConsultController()
        consult.title = type.title
        self.navigationController?.pushViewController(consult, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShopMemberController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = rowType(rawValue: indexPath.row) else { fatalError() }
        let cell = tableView.dequeueReusableCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = rowType.title
        cell.textLabel?.textColor = UIColor.darkcolor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
