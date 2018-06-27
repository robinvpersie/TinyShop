//
//  GMcatagoryButton.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMcatagoryButton: UIView {
	var popView:UITableView?
	var popViewOrgY:CGFloat = 0.0
	var addOneState:Bool = false
	var data:NSMutableArray = NSMutableArray()
	
	
	
	let tableViewMap:(UIView,CGFloat)->UITableView = {(dele:UIView,orgY:CGFloat)->UITableView in
		let tableview:UITableView = UITableView()
		tableview.register(UINib(nibName: "GoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CELL_ID")
		tableview.frame = CGRect(x: 0, y: orgY, width: screenWidth, height: screenHeight)
		tableview.dataSource = dele as? UITableViewDataSource
		tableview.delegate = (dele as! UITableViewDelegate)
		tableview.estimatedRowHeight = 0
		tableview.tableFooterView = UIView()
		tableview.estimatedSectionFooterHeight = 0
		tableview.estimatedSectionHeaderHeight = 0
		return tableview
	}
	
	let okBtnMap:(Int)->UIButton = {(tag:Int)->UIButton in
		let btn:UIButton = UIButton(type: .custom)
		btn.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		btn.layer.borderWidth = 1.0
		btn.layer.cornerRadius = 2
		btn.layer.masksToBounds = true
		btn.tag = (tag+100)
		btn.isHidden = true
		btn.setTitle("确定", for: .normal)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
		btn.setTitleColor(UIColor(red: 136, green: 160, blue: 170), for: .normal)
		
		return btn
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initUI()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension GMcatagoryButton:UITableViewDelegate,UITableViewDataSource{
	 private func resquestData(){
		KLHttpTool.getGoodManagerQuerycategorywithUri("category/querycategory", withCatergoryID: "4", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
				self.data = NSMutableArray(array: res.object(forKey: "data") as! NSArray)
				self.popView?.reloadData()
			}

		}) { (error) in
			
		}
	}
	private func initUI(){
		
		let arrow:UIImageView = UIImageView(image: UIImage(named: "icon_open_category"))
		self.addSubview(arrow)
		arrow.snp.makeConstraints { (make) in
			make.width.equalTo(10)
			make.height.equalTo(7)
			make.top.equalTo(8)
			make.right.equalTo(-5)
		}
		let btn:UIButton  = UIButton(type: .custom)
		btn.setTitle("全部分类", for: .normal)
		btn.setTitleColor(UIColor.black, for: .normal)
		btn.addTarget(self, action: #selector(showPopTableView), for: .touchUpInside)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
		self.addSubview(btn)
		btn.snp.makeConstraints { (make) in
			make.left.bottom.top.equalToSuperview()
			make.right.equalTo(arrow.snp.left).offset(-3)
		}
	}
	
	@objc public func hidePopTableView(){
		self.popView?.isHidden = true

	}

	@objc public func getPopViewOrgY(y:CGFloat){
		popViewOrgY = y
	}

	@objc private func showPopTableView(){
		
		if (self.popView) == nil {
			self.popView = self.tableViewMap(self,CGFloat(popViewOrgY))
			self.resquestData()
			self.viewController().view.addSubview(self.popView!)

		}else{
			self.popView?.isHidden = !(self.popView?.isHidden)!

		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.data.count + 1)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		let dic:NSDictionary = self.data[indexPath.row - 1] as! NSDictionary
		KLHttpTool.getGoodManagerDelcategorywithUri("category/delcategory", withID: dic.object(forKey: "id") as! String, success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
  				self.resquestData()
			}
		}) { (error) in
			
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = UITableViewCell()
		cell.selectionStyle = .none
		cell.tag = 10+indexPath.row
		cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
		
		let gesImg:UIButton = UIButton()
		gesImg.tag = indexPath.row
		cell.contentView.addSubview(gesImg)
		gesImg.addTarget(self, action: #selector(cellAction), for: .touchUpInside)
		gesImg.snp.makeConstraints { (make) in
			make.width.height.equalTo(20)
			make.right.equalToSuperview().offset(-10)
			make.top.equalTo(12)
		}
		
		let sumbit:UIButton = self.okBtnMap(indexPath.row)
		sumbit.backgroundColor = UIColor.white
		sumbit.addTarget(self, action: #selector(sumbitAction), for: .touchUpInside)
		cell.contentView.addSubview(sumbit)
		sumbit.snp.makeConstraints { (make) in
			make.width.equalTo(44)
			make.bottom.equalTo(-10)
			make.right.equalToSuperview().offset(-10)
			make.top.equalTo(10)
		}
		
		
		let editfield:UITextField = UITextField()
		editfield.backgroundColor = UIColor.white
		editfield.tag = 1000+indexPath.row
		editfield.isHidden = true
		cell.contentView.addSubview(editfield)
		editfield.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.width.equalTo(150)
			make.top.equalTo(10)
			make.bottom.equalTo(-10)
		}
		
		switch indexPath.row {
		case 0:
			cell.textLabel?.text = "全部分类"
			gesImg.setImage(#imageLiteral(resourceName: "icon_add_category"), for: .normal)
		
		default:
			if !addOneState || (indexPath.row != (self.data.count)){
				let dic:NSDictionary = self.data[indexPath.row - 1] as! NSDictionary
				cell.textLabel?.text = dic["level_name"] as? String
				

			}
			gesImg.setImage(#imageLiteral(resourceName: "icon_edit_category"), for: .normal)
			break
		}
		if addOneState && (indexPath.row == (self.data.count)){
			editfield.placeholder = "输入分类名称"
			editfield.isHidden = false
			sumbit.isHidden = false
		}else{
			editfield.placeholder = cell.textLabel?.text

		}

		return cell
		
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row != 0 {
			hidePopTableView()

		}
	}
	@objc private func cellAction(sender:UIButton){
		if sender.tag != 0 {//修改分类
			let okbar:UIButton = self.popView?.viewWithTag(sender.tag+100) as! UIButton
			okbar.isHidden = false
			
			let editfield:UITextField = self.popView?.viewWithTag(sender.tag+1000) as! UITextField
			editfield.isHidden = false
			editfield.becomeFirstResponder()

		}else {//添加分类ggg
			
			if !self.addOneState {
				
				self.data.add(" ")
 			}
			self.addOneState = true
			self.popView?.reloadData()
		}

	}
	
	@objc private func sumbitAction(sender:UIButton){
		if sender.tag != 0 {
			let tagBit:Int = sender.tag%100
			sender.isHidden = true
			
			let editfield:UITextField = self.popView?.viewWithTag(tagBit+1000) as! UITextField
			editfield.isHidden = true
			editfield.resignFirstResponder()
			
			let cell:UITableViewCell = self.popView?.viewWithTag(tagBit + 10) as! UITableViewCell
			let content:String = editfield.text!
			cell.textLabel?.text = content.count != 0 ? content : (editfield.placeholder)
			if self.addOneState {
				KLHttpTool.getGoodManagerAddcategorywithUri("category/addcategory", withImage_url: " ", withRank: "0", withPid: "0", withRid: "0", withLevelName: content, success: { (response) in
					let res:NSDictionary = (response as? NSDictionary)!
					let status:Int = (res.object(forKey: "status") as! Int)
					if status == 1 {
 
						self.addOneState = false
						self.resquestData()
					}

				}) { (error) in
					
				}
			}else {
				var dic:NSMutableDictionary = NSMutableDictionary(dictionary: self.data.object(at: (tagBit - 1)) as! NSDictionary)
  
				KLHttpTool.getGoodManagerUpdatecategorywithUri("category/updatecategory", withDic: dic , withLevelName: content, success: { (response) in
					let res:NSDictionary = (response as? NSDictionary)!
					let status:Int = (res.object(forKey: "status") as! Int)
					if status == 1 {
						self.addOneState = false
 						self.resquestData()
						
					}
					
				}) { (err) in
					
				}
 			}
			

		}else{
			
		}
		
	}
}
