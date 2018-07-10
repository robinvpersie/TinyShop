//
//  ShopNameChangeViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/7/5.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopNameChangeController: MyStoreBaseViewController {
	var tableview:UITableView = UITableView()
	var titles:NSArray = ["邮编","地址"]
	var textView:UITextView = UITextView()
	var showCode:UILabel = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
 		self.view.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		addTableView()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
	private func addTableView(){
		
 		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.estimatedRowHeight = 0
		self.tableview.tableFooterView = UIView()
		self.tableview.estimatedSectionFooterHeight = 0
		self.tableview.estimatedSectionHeaderHeight = 0
		self.tableview.separatorColor = UIColor(red: 212, green: 214, blue: 216)
		self.tableview.backgroundColor =  UIColor(red: 242, green: 244, blue: 246)
 		self.view.addSubview(self.tableview)
		
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
	@objc private func choiceAction(){
		
	}
	
}

extension ShopNameChangeController:UITableViewDelegate,UITableViewDataSource{

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
 		}
		return 1
	}
 	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = UITableViewCell()
		cell.textLabel?.textColor = UIColor(red: 160, green: 160, blue: 160)
		if indexPath.section == 0 {
 
			cell.textLabel?.text = self.titles.object(at: indexPath.row) as? String
			cell.selectionStyle = .none
			
			cell.contentView.addSubview(self.showCode)
  			self.showCode.snp.makeConstraints { (make) in
				make.bottom.top.equalToSuperview()
				make.width.equalTo(150)
				make.left.equalTo(80)
			}
			
			if indexPath.row == 0 {
				
 				let choiceBtn:UIButton = UIButton()
				choiceBtn.setTitle("选择", for: .normal)
				choiceBtn.layer.cornerRadius = 3
				choiceBtn.layer.masksToBounds = true
				choiceBtn.layer.borderColor = UIColor(red: 201, green: 201, blue: 201).cgColor
				choiceBtn.setTitleColor(UIColor(red: 180, green: 180, blue: 180), for: .normal)
				choiceBtn.layer.borderWidth = 1
				choiceBtn.addTarget(self, action: #selector(choiceAction), for: .touchUpInside)
				cell.contentView.addSubview(choiceBtn)
				choiceBtn.snp.makeConstraints { (make) in
					make.width.equalTo(60)
					make.height.equalTo(30)
					make.right.equalToSuperview().offset(-15)
					make.centerY.equalToSuperview()
				}
				
				
			}
 		}else{
			textView.text = "请输入详细地址"
			textView.textColor = UIColor(red: 211, green: 211, blue: 211)
			cell.contentView.addSubview(textView)
			textView.snp.makeConstraints { (make) in
				make.left.top.equalTo(5)
				make.right.bottom.equalTo(-5)
 			}
 		}
 
		return cell
	}
 	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 1 {
			return 120
		}
		return 50
	}
 	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10
	}
	
}
