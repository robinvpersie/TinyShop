//
//  ShopMTableViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopMTableViewController: UIViewController {
	var data:NSArray = [["店铺头像".localized,"店铺名称".localized,"客服电话".localized,"店铺地址".localized,"公司主页".localized],["行业分类".localized,"营业执照编号".localized,"法人编号".localized,"营业者分类".localized,"是否应税".localized,"合同状态".localized],["代表人".localized,"手机号".localized,"结算账户".localized],["物流公司".localized,"售后电话".localized,"退货地址".localized]]
	var contents:NSMutableArray = [["","","","",""],["","",""],["","",""],["","",""]]
	var infoDic:NSDictionary?
	var wuliuInfoDic:NSDictionary?
	var wuliuInfoDicList:NSArray?
	var categoryDicList1:NSArray?
	var categoryDicList2:NSArray?
	
 	let avator:UIImageView = UIImageView()
	var changeHeadAvatorMap:(String)->Void = {(imageurl:String)->Void in}
	var stateBtn: ShopMchoiceView!
	var stateBtn1: ShopMchoiceView!
	var stateBtn2: ShopMchoiceView!
	var stateBtn3: ShopMchoiceView!

	var stateBtnfst: ShopMchoiceView!
	var stateBtnsec:ShopMchoiceView!
	var tableView:UITableView!
 	var popEditView:ShopMpopBankView?
	
	var mallAvator:String?
	var mallName:String?
	var mallPhone:String?
	var mallAddress:String?
	var mallMainAddr:String?
	var mallAddressDetial:String?
	var mallZipCode:String?
	var homepage:String?
	var 营业执照号:String?
	var 法人编号:String?
	var 代表人:String?
	var 法人手机号:String?
	var 结算账户:String?
	var 物流公司:String?
	var 售后电话号码:String?
	var 公司地址:String?
	var 银行名称:String?
	var 银行卡号:String?
	var 行业类别1:String?
	var 行业类别2:String?
	var 经营者类别:String?
	var 税收类别:String?
	var 合同状态:String?
	var 物流公司编码:String?
	var 物流公司URL:String?
	var 物流公司邮编:String?
	var 退货地址:String?
	var 退货头部地址:String?
	var 退货详细地址:String?
	
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		requestData()
		setNavi()
	}
	
	private func requestData(){
		
		//基本信息显示
		DispatchQueue.global().async {
			KLHttpTool.requestMyStoreDetailedAmountwithUri("merchantinfo/queryInfo",level1: nil, success: { (response) in
				let reuslt:NSDictionary = (response as? NSDictionary)!
				let status:Int = reuslt.object(forKey: "status") as! Int
				
				if status == 1 {
					let dis:NSDictionary = reuslt["data"] as! NSDictionary
					self.infoDic = dis["info"] as? NSDictionary
					self.mallAvator = ""
					self.mallName = self.infoDic?.object(forKey: "custom_name") as? String
					self.mallPhone = self.infoDic?.object(forKey: "telephon") as? String
					self.mallZipCode = self.infoDic?.object(forKey: "zip_code") as? String
					self.mallAddressDetial = self.infoDic?.object(forKey: "kor_addr_detail") as? String
					self.mallMainAddr = self.infoDic?.object(forKey: "kor_addr") as? String
					self.mallAddress = ((self.mallMainAddr ?? "") + (self.mallAddressDetial ?? ""))
					self.homepage = self.infoDic?.object(forKey: "company_homepage") as? String
					self.营业执照号 = self.infoDic?.object(forKey: "company_num") as? String
					self.法人编号 = self.infoDic?.object(forKey: "work_memid") as? String
					self.代表人 = self.infoDic?.object(forKey: "jungsan_holder") as? String
					self.法人手机号 = self.infoDic?.object(forKey: "corp_no") as? String
					self.银行卡号 = self.infoDic?.object(forKey: "jungsan_bank_code") as? String
					self.银行名称 = self.infoDic?.object(forKey: "jungsan_bank") as? String
					let 卡号:NSMutableString = self.infoDic?.object(forKey: "jungsan_bank_code") as! NSMutableString
					if 卡号.length > 3 {
						let 账户尾号:String = 卡号.substring(from: 卡号.length - 3)
						self.结算账户 = self.代表人! + " " + self.银行名称! + " " + "尾号" + 账户尾号
					}
					
					self.行业类别1 = self.infoDic?.object(forKey: "comp_type") as? String
					self.行业类别2 = self.infoDic?.object(forKey: "comp_class") as? String
					self.经营者类别 = self.infoDic?.object(forKey: "saup_gubun") as? String
					self.税收类别 = self.infoDic?.object(forKey: "tax_gubun") as? String
					self.合同状态 = self.infoDic?.object(forKey: "contract_type") as? String
					
					self.contents = [[self.mallAvator,self.mallName,self.mallPhone,self.mallAddress,self.homepage],["",self.营业执照号,self.法人编号],[self.代表人,self.法人手机号,self.结算账户],[self.物流公司 == nil ? "" : self.物流公司,self.售后电话号码 == nil ? "" : self.售后电话号码,self.退货地址 == nil ? "" : self.退货地址]]
					DispatchQueue.main.async {
						self.tableView.reloadData()
						
					}
				}
			}) { (error) in
				
			}
			
		}
		//物流信息显示
		DispatchQueue.global().async {
			KLHttpTool.requestMyStoreDetailedAmountwithUri("merchantinfo/otherInfo",level1: nil, success: { (response) in
				let reuslt:NSDictionary = (response as? NSDictionary)!
				let status:Int = reuslt.object(forKey: "status") as! Int
				
				if status == 1 {
					let dis:NSDictionary = reuslt["data"] as! NSDictionary
					self.wuliuInfoDic = dis["otherInfo"] as? NSDictionary
					self.物流公司 = self.wuliuInfoDic?.object(forKey: "delivery_corp") as? String
					self.售后电话号码 = self.wuliuInfoDic?.object(forKey: "return_as_tel") as? String
					self.退货头部地址 = self.wuliuInfoDic?.object(forKey: "return_addr1") as? String
					self.退货详细地址 = self.wuliuInfoDic?.object(forKey: "return_addr2") as? String
					self.退货地址 = (self.退货头部地址 ?? "") + (self.退货详细地址 ?? "")
					self.contents = [[self.mallAvator,self.mallName,self.mallPhone,self.mallAddress,self.homepage],["",self.营业执照号,self.法人编号],[self.代表人,self.法人手机号,self.结算账户],[self.物流公司,self.售后电话号码,self.退货地址]]
					self.物流公司编码 = self.wuliuInfoDic?.object(forKey: "delivery_corp_code") as? String
					self.物流公司URL = self.wuliuInfoDic?.object(forKey: "delivery_url") as? String
					self.物流公司邮编 = self.wuliuInfoDic?.object(forKey: "return_post_no") as? String
					
					DispatchQueue.main.async {
						self.tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .none)
						
					}
				}
			}) { (error) in
				
			}
		}
		
		
		//物流公司列表
		DispatchQueue.global().async {
			KLHttpTool.requestMyStoreDetailedAmountwithUri("merchantinfo/QueryExpresslist", level1: nil,success: { (response) in
				let reuslt:NSDictionary = (response as? NSDictionary)!
				let status:Int = reuslt.object(forKey: "status") as! Int
				
				if status == 1 {
					self.wuliuInfoDicList = reuslt["data"] as? NSArray
					DispatchQueue.main.async {
						self.tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .none)
						
					}
				}
			}) { (error) in
				
			}
		}
		
		//行业分类1列表
		DispatchQueue.global().async {
			KLHttpTool.requestMyStoreDetailedAmountwithUri("merchantinfo/requestCate1DepthList",level1: nil, success: { (response) in
				let reuslt:NSDictionary = (response as? NSDictionary)!
				let status:Int = reuslt.object(forKey: "status") as! Int
				
				if status == 1 {
					let dis:NSDictionary = reuslt["data"] as! NSDictionary
					self.categoryDicList1 = dis["Cate1Depth"] as? NSArray
					DispatchQueue.main.async {
						self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
					}
				}
			}) { (error) in
				
			}
		}
		
		//行业分类2列表
		DispatchQueue.global().async {
			KLHttpTool.requestMyStoreDetailedAmountwithUri("merchantinfo/requestCate2DepthList",level1: "1", success: { (response) in
				let reuslt:NSDictionary = (response as? NSDictionary)!
				let status:Int = reuslt.object(forKey: "status") as! Int
				
				if status == 1 {
					let dis:NSDictionary = reuslt["data"] as! NSDictionary
					self.categoryDicList2 = dis["Cate1Depth"] as? NSArray
					DispatchQueue.main.async {
						self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
					}
				}
			}) { (error) in
				
			}
		}
	}
	
	//修改供应商基本信息
	fileprivate func UpdateInfoMerchant(){
		let currentAccount:YCAccountModel = YCAccountModel.getAccount()!
		let params:NSDictionary = [
			
			
			"lang_type" : "chn",
			"token" : currentAccount.combineToken,
			"custom_code" : currentAccount.customCode,
			"custom_name" : mallName,
			"telephon" : mallPhone,
			"zip_code" : mallZipCode,
			"kor_addr" : mallMainAddr,
			"kor_addr_detail" : mallAddressDetial,
			"company_homepage" : homepage,
			"company_num" : 营业执照号,
			"corp_no" : 法人编号,
			"ceo_hp_no1" : 法人手机号,
			"jungsan_holder" : 代表人,
			"jungsan_bank" : 银行名称,
			"jungsan_bank_code" : 银行卡号,
			"comp_type" : 行业类别1,
			"comp_class" : 行业类别2,
			"FAX_NUM" : "22222222",
			"regi_gubun" : "",
			"maker_code" : "0",
			"supplier_code" : "0",
			"saup_gubun" : 经营者类别,
			"tax_gubun" : 税收类别,
			"contract_date" : "",
			"contract_type" : 合同状态,
			"ceo_name" : "我",
			"ceo_hp_no2" : "",
			"ceo_hp_no3" : "",
			"from_site" : "",
			"from_site_code" : "",
			"md_id" : "",
			"md_commission_rate" : ""
		]
		KLHttpTool.merchantinfoUpdateInfoAmountwithParam(params as? [AnyHashable : Any], withUri: "merchantinfo/updateInfo", success: { (response) in
			let reuslt:NSDictionary = (response as? NSDictionary)!
			let status:Int = reuslt.object(forKey: "status") as! Int
			
			if status == 1 {
				print("修改成功")
			}
		}, failure: { (error) in
			
		})
	}
	
	
	fileprivate func updateotherInfomerchantinfo(){
		let currentAccount:YCAccountModel = YCAccountModel.getAccount()!
		let params:NSDictionary = [
			"delivery_corp": 物流公司,
			"delivery_corp_code": 物流公司编码,
			"delivery_url": 物流公司URL,
			"return_as_tel": 售后电话号码,
			"return_post_no": 物流公司邮编,
			"return_addr1": 退货头部地址,
			"return_addr2": 退货详细地址,
			"lang_type": "chn",
			"custom_code": currentAccount.customCode,
			"token": currentAccount.combineToken
		]
		KLHttpTool.merchantinfoUpdateInfoAmountwithParam(params as? [AnyHashable : Any], withUri: "merchantinfo/updateotherInfo", success: { (response) in
			let reuslt:NSDictionary = (response as? NSDictionary)!
			let status:Int = reuslt.object(forKey: "status") as! Int
			if status == 1 {
				print("修改成功")
			}
		}, failure: { (error) in
			
		})
	}
	
	
	public func setNavi(){
		
		self.tableView = UITableView(frame: .zero, style: .grouped)
		self.tableView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.tableView.contentInset = UIEdgeInsetsMake(10, 0, -10, 0)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.estimatedRowHeight = 0
		self.tableView.estimatedSectionHeaderHeight = 0
		self.tableView.estimatedSectionFooterHeight = 0
		self.tableView.tableFooterView = UIView()
		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
		})
		self.title = "店铺信息".localized
		let backItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .plain, target: self, action: #selector(back))
		self.navigationItem.leftBarButtonItem = backItem
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationController?.navigationBar.tintColor = UIColor.black
		
		
	}
	
	@objc private func back(){
		self.stateBtn1.hiddenPopView()
		self.stateBtn2.hiddenPopView()
		self.stateBtn3.hiddenPopView()
		self.stateBtnfst.hiddenPopView()
		self.stateBtnsec.hiddenPopView()

		self.navigationController?.popViewController(animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}

extension ShopMTableViewController:UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.data.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return (self.data[section] as! NSArray).count
		
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.accessoryType = .disclosureIndicator
		cell.selectionStyle = .none
		cell.textLabel?.text = (self.data[indexPath.section] as! NSArray).object(at: indexPath.row) as? String
		
		let section:NSArray = self.contents[indexPath.section] as! NSArray
		
		if indexPath.section == 0 {
			switch indexPath.row {
			case 0:
				do {
					
					avator.layer.cornerRadius = 5
					avator.layer.masksToBounds = true
					avator.setImageWith(NSURL(string: section.firstObject as! String)! as URL)
					cell.contentView.addSubview(avator)
					avator.snp.makeConstraints { (make) in
						make.width.height.equalTo(80)
						make.right.equalToSuperview().offset(-5)
						make.top.equalToSuperview().offset(10)
					}
				}
				
			default:
				do {
					let content:UILabel = UILabel()
					content.textAlignment = .right
					content.numberOfLines = 0
					content.font = UIFont.systemFont(ofSize: 14.0)
					content.text = section.object(at: indexPath.row) as? String
					cell.contentView.addSubview(content)
					content.snp.makeConstraints { (make) in
						make.bottom.top.equalToSuperview()
						make.right.equalToSuperview().offset(-2)
						make.left.equalToSuperview().offset(100)
					}
				}
			}
		} else if(indexPath.section == 1){
			
			let content:UILabel = UILabel()
			content.textAlignment = .right
			content.numberOfLines = 0
			content.font = UIFont.systemFont(ofSize: 14.0)
			cell.contentView.addSubview(content)
			content.snp.makeConstraints { (make) in
				make.bottom.top.equalToSuperview()
				make.right.equalToSuperview()
				make.left.equalToSuperview().offset(100)
			}
			if indexPath.row == 1 || indexPath.row == 2{
				content.text = section.object(at: indexPath.row) as? String
				
			}else if indexPath.row == 0 {
				
				stateBtnsec = ShopMchoiceView()
				cell.contentView.addSubview(stateBtnsec)
				stateBtnsec.snp.makeConstraints { (make) in
					make.bottom.top.equalToSuperview()
					make.top.equalToSuperview().offset(8)
					make.right.equalToSuperview()
					make.width.equalTo(100)
				}
				
				if self.categoryDicList2 != nil {
					var delist:[NSDictionary] = []
					for dic in self.categoryDicList2! {
						let dic1:NSDictionary = dic as! NSDictionary
						let category1name:String = dic1.object(forKey: "LEVEL_NAME") as! String
						let tempdic:NSMutableDictionary = NSMutableDictionary(dictionary: dic1)
						tempdic.setObject(category1name, forKey: "LEVEL_NAME" as NSCopying)
						tempdic.setObject("1", forKey: "id" as NSCopying)
						if self.行业类别2 == category1name {
							delist.insert(tempdic, at: 0)
						}else{
							delist.append(tempdic)
							
						}
						
						
						
					}
					stateBtnsec.choiceMap = {(dic:NSDictionary,_:Int,_:Int) in
						print(dic)
						self.行业类别2 = dic.object(forKey: "LEVEL_NAME") as? String
						self.UpdateInfoMerchant()
					}
					stateBtnsec.getTitlesArray(titles: delist as NSArray)
					
					
				}
				
				self.stateBtnfst = ShopMchoiceView()
				if self.categoryDicList1 != nil {
					var delist:[NSDictionary] = []
					for dic in self.categoryDicList1! {
						let dic1:NSDictionary = dic as! NSDictionary
						let category1name:String = dic1.object(forKey: "LEVEL_NAME") as! String
						let tempdic:NSMutableDictionary = NSMutableDictionary(dictionary: dic1)
						tempdic.setObject(category1name, forKey: "LEVEL_NAME" as NSCopying)
						tempdic.setObject("1", forKey: "id" as NSCopying)
						if self.行业类别1 == category1name {
							delist.insert(tempdic, at: 0)
						}else{
							delist.append(tempdic)
							
						}
						
					}
					self.stateBtnfst.choiceMap = {(dic:NSDictionary,_:Int,_:Int) in
						print(dic)
						self.行业类别1 = dic.object(forKey: "LEVEL_NAME") as? String
						//行业分类2列表
						DispatchQueue.global().async {
							KLHttpTool.requestMyStoreDetailedAmountwithUri("merchantinfo/requestCate2DepthList",level1: dic.object(forKey: "LEVEL1") as? String, success: { (response) in
								let reuslt:NSDictionary = (response as? NSDictionary)!
								let status:Int = reuslt.object(forKey: "status") as! Int
								
								if status == 1 {
									let dis:NSDictionary = reuslt["data"] as! NSDictionary
									self.categoryDicList2 = dis["Cate1Depth"] as? NSArray
									DispatchQueue.main.async {
										var delist2:[NSDictionary] = []
										
										for dic in self.categoryDicList2! {
											let dic1:NSDictionary = dic as! NSDictionary
											let category1name:String = dic1.object(forKey: "LEVEL_NAME") as! String
											let tempdic:NSMutableDictionary = NSMutableDictionary(dictionary: dic1)
											tempdic.setObject(category1name, forKey: "LEVEL_NAME" as NSCopying)
											tempdic.setObject("1", forKey: "id" as NSCopying)
											if self.行业类别1 == category1name {
												delist2.insert(tempdic, at: 0)
											}else{
												delist2.append(tempdic)
											}
										}
										self.行业类别2 = delist2.first?.object(forKey: "LEVEL_NAME") as? String
										self.stateBtnsec.getTitlesArray(titles: delist2 as NSArray)
										self.UpdateInfoMerchant()
										
									}
								}
							}) { (error) in
								
							}
						}
						
					}
					self.stateBtnfst.getTitlesArray(titles: delist as NSArray)
					
				}
				cell.contentView.addSubview(self.stateBtnfst)
				self.stateBtnfst.snp.makeConstraints { (make) in
					make.bottom.top.equalToSuperview()
					make.top.equalToSuperview().offset(8)
					make.left.equalTo(Constant.screenWidth - 250)
					make.width.equalTo(100)
				}
				
				let arrow:UIImageView = UIImageView()
				arrow.image = UIImage(named: "icon_list_arrow")
				cell.contentView.addSubview(arrow)
				arrow.snp.makeConstraints { (make) in
					make.centerY.equalToSuperview()
					make.left.equalTo(self.stateBtnfst.snp.right).offset(8)
				}
				
				
			}else{
				content.isHidden = true
 				if indexPath.row == 3{
					self.stateBtn1 = ShopMchoiceView()
					cell.contentView.addSubview(self.stateBtn1)
					self.stateBtn1.snp.makeConstraints { (make) in
						make.bottom.top.equalToSuperview()
						make.top.equalToSuperview().offset(8)
						make.right.equalToSuperview()
						make.width.equalTo(100)
					}
					self.stateBtn1.choiceMap = {(dic:NSDictionary,_:Int,_:Int) in
						print(dic)
						let type:String = dic.object(forKey: "LEVEL_NAME") as! String
						if type == "一般事业者".localized{
							self.经营者类别 = "pers"
						}else if type == "法人事业者".localized {
							self.经营者类别 = "corp"
						}else if type == "简易事业者".localized {
							self.经营者类别 = "simp"
							
						}
						self.UpdateInfoMerchant()
						
					}
					if self.经营者类别 == "pers"{
						let titles:NSArray = [["LEVEL_NAME":"一般事业者".localized,"id":"1"],["LEVEL_NAME":"法人事业者".localized,"id":"1"],["LEVEL_NAME":"简易事业者".localized,"id":"1"]]
						self.stateBtn1.getTitlesArray(titles: titles)
						
					}else if self.经营者类别 == "corp" {
						let titles:NSArray = [["LEVEL_NAME":"法人事业者".localized,"id":"1"],["LEVEL_NAME":"一般事业者".localized,"id":"1"],["LEVEL_NAME":"简易事业者".localized,"id":"1"]]
						self.stateBtn1.getTitlesArray(titles: titles)
						
					}else {
						let titles:NSArray = [["LEVEL_NAME":"简易事业者".localized,"id":"1"],["LEVEL_NAME":"法人事业者".localized,"id":"1"],["LEVEL_NAME":"一般事业者".localized,"id":"1"]]
						self.stateBtn1.getTitlesArray(titles: titles)
						
					}
					
					
				}else if indexPath.row == 4{
					self.stateBtn2 = ShopMchoiceView()
					cell.contentView.addSubview(self.stateBtn2)
					self.stateBtn2.snp.makeConstraints { (make) in
						make.bottom.top.equalToSuperview()
						make.top.equalToSuperview().offset(8)
						make.right.equalToSuperview()
						make.width.equalTo(100)
					}
					self.stateBtn2.choiceMap = {(dic:NSDictionary,_:Int,_:Int) in
						print(dic)
						let type:String = dic.object(forKey: "LEVEL_NAME") as! String
						if type == "不选择".localized{
							self.税收类别 = "nosel"
						}else if type == "应税企业".localized {
							self.税收类别 = "tax".localized
						}else if type == "免税企业".localized {
							self.税收类别 = "notax"
							
						}
						self.UpdateInfoMerchant()
						
						
					}
					
					if self.税收类别 == "nosel"{
						let titles:NSArray = [["LEVEL_NAME":"不选择".localized,"id":"1"],["LEVEL_NAME":"应税企业".localized,"id":"1"],["LEVEL_NAME":"免税企业".localized,"id":"1"]]
						self.stateBtn2.getTitlesArray(titles: titles)
						
					}else if self.税收类别 == "tax"{
						let titles:NSArray = [["LEVEL_NAME":"应税企业".localized,"id":"1"],["LEVEL_NAME":"不选择".localized,"id":"1"],["LEVEL_NAME":"免税企业".localized,"id":"1"]]
						self.stateBtn2.getTitlesArray(titles: titles)
						
					}else if self.税收类别 == "notax"{
						let titles:NSArray = [["LEVEL_NAME":"免税企业".localized,"id":"1"],["LEVEL_NAME":"应税企业".localized,"id":"1"],["LEVEL_NAME":"不选择".localized,"id":"1"]]
						self.stateBtn2.getTitlesArray(titles: titles)
						
					}
					
					
				}else if indexPath.row == 5{
					self.stateBtn3 = ShopMchoiceView()
					cell.contentView.addSubview(self.stateBtn3)
					self.stateBtn3.snp.makeConstraints { (make) in
						make.bottom.top.equalToSuperview()
						make.top.equalToSuperview().offset(8)
						make.right.equalToSuperview()
						make.width.equalTo(100)
					}

					self.stateBtn3.choiceMap = {(dic:NSDictionary,_:Int,_:Int) in
						print(dic)
						let type:String = dic.object(forKey: "LEVEL_NAME") as! String
						if type == "进行中".localized{
							self.合同状态 = "contract_progress"
						}else if type == "已结束".localized {
							self.合同状态 = "contract_end"
						}
						self.UpdateInfoMerchant()
						
					}
					
					if self.合同状态 == "contract_progress"{
						let titles:NSArray = [["LEVEL_NAME":"进行中".localized,"id":"1"],["LEVEL_NAME":"已结束".localized,"id":"1"]]
						self.stateBtn3.getTitlesArray(titles: titles)
						
					}else if self.合同状态 == "contract_end"{
						let titles:NSArray = [["LEVEL_NAME":"已结束".localized,"id":"1"],["LEVEL_NAME":"进行中".localized,"id":"1"]]
						self.stateBtn3.getTitlesArray(titles: titles)
					}
					
				}
				
			}
		}
		else {
			
			let content:UILabel = UILabel()
			content.textAlignment = .right
			content.numberOfLines = 0
			content.font = UIFont.systemFont(ofSize: 14.0)
			cell.contentView.addSubview(content)
			content.snp.makeConstraints { (make) in
				make.bottom.top.equalToSuperview()
				make.right.equalToSuperview()
				make.left.equalToSuperview().offset(100)
			}
			content.text = section.object(at: indexPath.row) as? String
			
			if indexPath.section == 3 {
				
				if self.wuliuInfoDicList != nil && indexPath.row == 0 {
					let  deliveryState:ShopMchoiceView = ShopMchoiceView()
					deliveryState.choiceMap = { (dic:NSDictionary,_:Int,_:Int) in
						self.物流公司 = dic.object(forKey: "CDNAME") as? String
						self.物流公司编码 = dic.object(forKey: "CDCODE") as? String
						self.物流公司URL = dic.object(forKey: "CDDESC2") as? String
						self.物流公司邮编 = dic.object(forKey: "CDORDER") as? String
						
						self.updateotherInfomerchantinfo()
						
					}
					var delist:[NSDictionary] = []
					
					for dic in self.wuliuInfoDicList! {
						let dic1:NSDictionary = dic as! NSDictionary
						let wuliuname:String = dic1.object(forKey: "CDNAME") as! String
						let tempdic:NSMutableDictionary = NSMutableDictionary(dictionary: dic1)
						tempdic.setObject(wuliuname, forKey: "LEVEL_NAME" as NSCopying)
						tempdic.setObject("1", forKey: "id" as NSCopying)
						if self.物流公司 == wuliuname {
							delist.insert(tempdic, at: 0)
						}else{
							delist.append(tempdic)
						}
					}
					deliveryState.getTitlesArray(titles: delist as NSArray)
					
					cell.contentView.addSubview(deliveryState)
					deliveryState.snp.makeConstraints { (make) in
						make.bottom.top.equalToSuperview()
						make.top.equalToSuperview().offset(8)
						make.right.equalToSuperview()
						make.width.equalTo(100)
					}
					
				}
			}
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			switch indexPath.row {
			case 0:
				return 100.0
			case 3:
				return 60.0
				
			default:
				return 44.0
			}
		} else {
			return  44.0
		}
		
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10.0
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				let alert:UIAlertController = UIAlertController(title: "", message: "选择图片来源".localized, preferredStyle: .actionSheet)
				let action = UIAlertAction(title:"相册".localized, style: .default) {[weak self](action)in
					if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
						
						let picker = UIImagePickerController()
						picker.delegate = self
						picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
						picker.allowsEditing = true
						self?.present(picker, animated:true, completion: {() -> Void in })
						
					}
				}
				let action1 = UIAlertAction(title:"照相".localized, style: .default) { [weak self](action)in
					if UIImagePickerController.isSourceTypeAvailable(.camera){
						
						let picker = UIImagePickerController()
						picker.delegate = self
						picker.sourceType = UIImagePickerControllerSourceType.camera
						picker.allowsEditing = true
						self?.present(picker, animated:true, completion: { () -> Void in })
						
					}
				}
				let action2 = UIAlertAction(title:"取消".localized, style: .cancel, handler:nil)
				alert.addAction(action)
				alert.addAction(action1)
				alert.addAction(action2)
				self.present(alert, animated:true, completion: nil)
			}else if indexPath.row == 1 {
				clickInputBtn(type: "修改名字".localized,flag:indexPath.row, section: indexPath.section)
				
			}else if indexPath.row == 2 {
				
				clickInputBtn(type: "修改联系方式".localized,flag:indexPath.row, section: indexPath.section)
				
			}else if indexPath.row == 3 {
				
				let vc:ShopNameChangeController = ShopNameChangeController()
				vc.preDic(dic: self.infoDic!)
				vc.editFinish = {(mainaddr:String,detailaddr:String)->Void in
					self.mallMainAddr = mainaddr
					self.mallAddressDetial = detailaddr
					self.mallAddress = ((self.mallMainAddr ?? "") + (self.mallAddressDetial ?? ""))
					let sectionCopy:NSArray = self.contents[0] as! NSArray
					let sectionTemp:NSMutableArray = NSMutableArray(array: sectionCopy)
					sectionTemp.replaceObject(at: 3, with: self.mallAddress as Any)
					self.contents.replaceObject(at: 0, with: sectionTemp)
					self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
					
					self.UpdateInfoMerchant()
				}
				vc.title = self.data.object(at: indexPath.row) as? String
				self.navigationController?.pushViewController(vc, animated: true)
				
				//				clickInputBtn(type: "修改公司地址".localized,flag:indexPath.row, section: indexPath.section)
			}else if indexPath.row == 4 {
				
				clickInputBtn(type: "修改".localized + "公司主页".localized,flag:indexPath.row, section: indexPath.section)
				
			}
		} else {
			if indexPath.section == 1 {
				if indexPath.row == 1 {
					clickInputBtn(type: "修改".localized + "营业执照编号".localized,flag:indexPath.row, section: indexPath.section)
					
				}else if indexPath.row == 2 {
					clickInputBtn(type: "修改".localized + "法人编号".localized,flag:indexPath.row, section: indexPath.section)
					
				}
			}else if indexPath.section == 2 {
				if indexPath.row == 0 {
					clickInputBtn(type: "修改".localized + "代表人".localized,flag:indexPath.row, section: indexPath.section)
					
				}else if indexPath.row == 1 {
					clickInputBtn(type: "修改".localized + "手机号".localized,flag:indexPath.row, section: indexPath.section)
					
				}else {
					self.popEditView = ShopMpopBankView()
					self.popEditView?.getTag(tag:100)
					self.popEditView?.finishCompleteMap = {(name:String,bankname:String,no:String)->Void in
						
					}
					UIApplication.shared.delegate?.window??.addSubview(self.popEditView!)
					
					self.popEditView?.snp.makeConstraints({ (make) in
						make.centerX.equalToSuperview()
						make.centerY.equalToSuperview().offset(-40)
						make.width.equalTo(screenWidth - 60)
						make.height.equalTo( screenHeight/3)
					})
				}
				
			}else if indexPath.section == 3  {
				
				
				if indexPath.row == 1 {
					clickInputBtn(type: "修改".localized + "售后电话".localized,flag:indexPath.row, section: indexPath.section)
					
				}else if indexPath.row == 2{
					let vc:ShopNameChangeController = ShopNameChangeController()
					vc.preDic(dic: self.infoDic!)
					vc.editFinish = {(mainaddr:String,detailaddr:String)->Void in
						self.退货头部地址 = mainaddr
						self.退货详细地址 = detailaddr
						self.退货地址 = ((self.退货头部地址 ?? "") + (self.退货详细地址 ?? ""))
						let sectionCopy:NSArray = self.contents[3] as! NSArray
						let sectionTemp:NSMutableArray = NSMutableArray(array: sectionCopy)
						sectionTemp.replaceObject(at: 2, with: self.退货地址 as Any)
						self.contents.replaceObject(at: 3, with: sectionTemp)
						self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
						
						self.updateotherInfomerchantinfo()
					}
					vc.title = self.data.object(at: indexPath.row) as? String
					self.navigationController?.pushViewController(vc, animated: true)
					
				}
			}
		}
	}
	
	//弹出带有输入框的提示框
	private func clickInputBtn(type:String,flag:Int,section:Int) {
		var inputText:UITextField = UITextField();
		let msgAlertCtr = UIAlertController.init(title:nil, message: type, preferredStyle: .alert)
		let ok = UIAlertAction.init(title: "确定".localized, style:.default) { (action:UIAlertAction) ->() in
			for textFields in msgAlertCtr.textFields! {
				switch section {
				case 0:
					if flag == 1{
						self.mallName = textFields.text
					}else if flag == 2{
						self.mallPhone = textFields.text
					}
						//					else if flag == 3 {
						//						self.公司地址 = textFields.text
						//					}
					else if flag == 4 {
						self.homepage = textFields.text
					}
				case 1:
					
					if flag == 1{
						self.营业执照号 = textFields.text
					}else if flag == 2{
						self.法人编号 = textFields.text
					}
					
				case 2:
					if flag == 0{
						self.代表人 = textFields.text
					}else if flag == 1{
						self.法人手机号 = textFields.text
					}
				default:
					if flag == 1{
						self.售后电话号码 = textFields.text
					}else if flag == 2{
						self.退货地址 = textFields.text
					}
					self.updateotherInfomerchantinfo()
					
					break
				}
				
				let sectionCopy:NSArray = self.contents[section] as! NSArray
				let sectionTemp:NSMutableArray = NSMutableArray(array: sectionCopy)
				sectionTemp.replaceObject(at: flag, with: textFields.text as Any)
				self.contents.replaceObject(at: section, with: sectionTemp)
				self.tableView?.reloadData()
				self.UpdateInfoMerchant()
			}
			
			// 			KLHttpTool.requestStoreImageUpdatewithUri("/api/AppSM/requestStoreImageUpdate", withStoreImageurl: self.mallAvator, withCustomName: self.mallName, withTelephon: self.mallPhone, withZipcode: self.mallZipCode, withKoraddr: self.mallAddress, withkoraddrDetail: self.mallAddressDetial, success: { (response) in
			//					let res:NSDictionary = (response as? NSDictionary)!
			//					let status:String = (res.object(forKey: "status") as! String)
			//					if status == "1" {
			//						self.changeHeadAvatorMap(self.mallAvator!)
			//					}
			// 				}, failure: { (error) in
			// 				})
		}
		
		let cancel = UIAlertAction.init(title: "取消".localized, style:.cancel) { (action:UIAlertAction) -> ()in
			print("取消输入")
		}
		
		msgAlertCtr.addAction(ok)
		msgAlertCtr.addAction(cancel)
		msgAlertCtr.addTextField { (textField) in
			inputText = textField
			
			switch section {
			case 0:
				if flag == 1{
					inputText.placeholder = "输入".localized + "商铺名称".localized
				}else if flag == 2{
					inputText.placeholder = "输入".localized + "商铺电话".localized
				}else if flag == 4{
					inputText.placeholder = "输入".localized + "公司网页".localized
				}
				
			case 1:
				
				if flag == 1{
					inputText.placeholder = "输入".localized + "营业执照编号".localized
				}else if flag == 2{
					inputText.placeholder = "输入".localized + "法人编号".localized
				}
			case 2:
				if flag == 0{
					inputText.placeholder = "输入".localized + "代表人".localized
				}else if flag == 1{
					inputText.placeholder = "输入".localized + "电话号码".localized
				}
			default:
				if flag == 1{
					inputText.placeholder = "输入".localized + "售后电话".localized
				}else if flag == 2{
					inputText.placeholder = "输入".localized + "退货地址".localized
				}
				
				break
			}
			
			
		}
		self.present(msgAlertCtr, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = info[UIImagePickerControllerEditedImage] as! UIImage
		picker.dismiss(animated: true, completion: { () -> Void in
			self.avator.image = image
			KLHttpTool.sendGoodLogoPicture(withUrl: "fileUp/postFile", with: image, success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let status:Int = (res.object(forKey: "status") as! Int)
				if status == 1 {
					let imageurls:NSArray = res.object(forKey: "data") as! NSArray
					self.mallAvator = "http://gigaMerchantManager.gigawon.co.kr:8825/" + (imageurls.firstObject as! String)
					KLHttpTool.requestStoreImageUpdatewithUri("/api/AppSM/requestStoreImageUpdate", withStoreImageurl: self.mallAvator, withCustomName: self.mallName, withTelephon: self.mallPhone, withZipcode: "12344", withKoraddr: self.mallAddress, withkoraddrDetail: self.mallAddress, success: { (response) in
						let res:NSDictionary = (response as? NSDictionary)!
						let status:String = (res.object(forKey: "status") as! String)
						if status == "1" {
							self.changeHeadAvatorMap(self.mallAvator!)
						}
						
					}, failure: { (error) in
						
					})
				}
				
			}, failure: { (error) in
				
			})
			
			
		})
		
	}
}
