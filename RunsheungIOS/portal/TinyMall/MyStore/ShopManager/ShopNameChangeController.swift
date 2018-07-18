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
 	var dic:NSDictionary?
	var addsec:String = ""
	var pstcode:String = "010237"

	
    override func viewDidLoad() {
        super.viewDidLoad()
		addNavgationItem()
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
		cell.selectionStyle = .none

		let title:UILabel = UILabel()
 		cell.contentView.addSubview(title)
 		title.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.width.equalTo(80)
			make.top.equalTo(10)
			make.height.equalTo(30)
		}
		
		
 		title.text = (indexPath.section == 1 ) ? "详细地址" : (self.titles.object(at: indexPath.row) as? String)
 
 		if indexPath.section == 0 {
			let showContent:UILabel = UILabel()
			showContent.numberOfLines = 0
			showContent.font = UIFont.systemFont(ofSize: 15)
			showContent.textColor = UIColor(red: 180, green: 180, blue: 180)
			cell.contentView.addSubview(showContent)
			showContent.snp.makeConstraints { (make) in
				make.bottom.equalToSuperview().offset(-10)
				make.top.equalToSuperview().offset(10)
				make.right.equalToSuperview().offset(-15)
				make.left.equalTo(title.snp.right).offset(10)
			}
  			showContent.text = (indexPath.row == 1) ? self.addsec : self.pstcode
   		}else{
			let textView:UITextView = UITextView()
 			textView.font = UIFont.systemFont(ofSize: 15)
			textView.textColor = UIColor(red: 180, green: 180, blue: 180)
			cell.contentView.addSubview(textView)
			textView.snp.makeConstraints { (make) in
				make.bottom.equalToSuperview().offset(-10)
				make.top.equalToSuperview().offset(10)
				make.right.equalToSuperview().offset(-15)
				make.left.equalTo(title.snp.right).offset(10)
			}
			textView.text = "首尔特别行政区江岸区城东189COEXmalll首尔特别行政区江岸区城东189COEXmalll"
   		}
		
  		return cell
	}
 	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 1 {
			
			return 100
		}
 		return 50
	}
 	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10
	}
	
	private func addNavgationItem(){
		let right:UIBarButtonItem = UIBarButtonItem(title: "编辑修改", style: .plain, target: self, action: #selector(editaction))
 		self.navigationItem.rightBarButtonItem = right
	}
	
	@objc private func editaction(){
		let picker:ShopAddressPicker = ShopAddressPicker()
		picker.pickerMap = {(dict:NSDictionary)->Void in
			self.dic = dict
			guard self.dic != nil else {return ;}
 			let pstdic:NSDictionary = self.dic?.object(forKey: "postcd") as! NSDictionary
			let addrsecdic:NSDictionary = self.dic?.object(forKey: "addrjibun") as! NSDictionary
			self.pstcode = pstdic.object(forKey: "cdatasection") as! String
			self.addsec = addrsecdic.object(forKey: "cdatasection") as! String
			
			self.tableview.reloadData()
		}
		UIApplication.shared.delegate?.window??.addSubview(picker)
		picker.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(10)
			make.top.equalToSuperview().offset(150)
		}
		
	}
	
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
 		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	
	}
	
	
}
