//
//  ShopNameChangeViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/7/5.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopNameChangeController: MyStoreBaseViewController {
	let textView:UITextView = UITextView()
 	var tableview:UITableView = UITableView()
	var titles:NSArray = ["邮编".localized,"地址".localized]
 	var dic:NSDictionary?
	var addsec:String = ""
	var pstcode:String = "010237"
	var addDetail:String = "请填写详细地址"
	var dit:NSDictionary?
	var editFinish:()->Void = {()->Void in}
	
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
			make.top.left.right.equalToSuperview()
			make.height.equalTo(250)
		}
		
		let save:UIButton = UIButton()
		save.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		save.setTitle("确定".localized, for: .normal)
		save.addTarget(self, action: #selector(saveBtn), for: .touchUpInside)
		self.view.addSubview(save)
		save.snp.makeConstraints { (make) in
			make.bottom.left.right.equalToSuperview()
 			make.height.equalTo(50)
		}
	}
	
	@objc private func saveBtn(){
		let imageurl:String = self.dit?.object(forKey: "shop_thumnail_image") as! String
		let name:String = self.dit?.object(forKey: "custom_name") as! String
		let tel:String = self.dit?.object(forKey: "telephon") as! String
		self.addDetail = self.textView.text
  		KLHttpTool.requestStoreImageUpdatewithUri("/api/AppSM/requestStoreImageUpdate", withStoreImageurl: imageurl, withCustomName: name, withTelephon: tel, withZipcode: self.pstcode, withKoraddr: self.addsec, withkoraddrDetail: self.addDetail, success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:String = (res.object(forKey: "status") as! String)
			if status == "1" {
				self.editFinish()
				self.navigationController?.popViewController(animated: true)
				
 			}
			
		}, failure: { (error) in
			
		})

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
		
		
 		title.text = (indexPath.section == 1 ) ? "详细地址".localized : (self.titles.object(at: indexPath.row) as? String)
 
 		if indexPath.section == 0 {
			let showContent:UILabel = UILabel()
			showContent.numberOfLines = 0
			showContent.font = UIFont.systemFont(ofSize: 15)
			showContent.textColor = UIColor(red: 180, green: 180, blue: 180)
			cell.contentView.addSubview(showContent)
			showContent.snp.makeConstraints { (make) in
				make.bottom.equalToSuperview().offset(0)
				make.top.equalToSuperview().offset(0)
				make.right.equalToSuperview().offset(-15)
				make.left.equalTo(title.snp.right).offset(10)
			}
  			showContent.text = (indexPath.row == 1) ? self.addsec : self.pstcode
   		}else{
			
			textView.font = UIFont.systemFont(ofSize: 15)
			textView.textColor = UIColor(red: 180, green: 180, blue: 180)
			cell.contentView.addSubview(textView)
			textView.snp.makeConstraints { (make) in
				make.bottom.equalToSuperview().offset(-10)
				make.top.equalToSuperview().offset(10)
				make.right.equalToSuperview().offset(-15)
				make.left.equalTo(title.snp.right).offset(10)
			}
			textView.text = addDetail
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
		
		let right:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
		right.setTitle("编辑修改".localized, for: .normal)
  		right.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		right.setTitleColor(UIColor(red: 45, green: 45, blue: 45), for: .normal)
		right.addTarget(self, action: #selector(editaction), for: .touchUpInside)
  		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: right)
	}
	
	@objc private func editaction(){
		self.textView.resignFirstResponder()
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
	
	public func preDic(dic:NSDictionary){
		self.dit = dic
		self.addsec = self.dit?.object(forKey: "kor_addr") as! String
		self.pstcode = self.dit?.object(forKey: "zip_code") as! String
		self.addDetail = self.dit?.object(forKey: "kor_addr_detail") as! String
	}
	
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
 		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
 	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		self.textView.resignFirstResponder()
 	}
	
	
}
