//
//  CustomPicker.swift
//  CustomPicker
//
//  Created by 周逸文 on 17/2/21.
//  Copyright © 2017年 TZSY. All rights reserved.
//

import UIKit

class ShopAddressPicker: UIView {
	let coverView:UIView = UIView()
	var inputSearch:UITextField = UITextField()
	var btnSearch:UIButton = UIButton()
	var tableview:UITableView = UITableView()
	var data:NSMutableArray = NSMutableArray()
	var lbl:UILabel = UILabel()
	var pickerMap:(NSDictionary)->Void = {(dict:NSDictionary)->Void in}
 	enum RefreshType: Int {
		case topfresh
		case loadmore
	}
	var pg:Int = 1
	var isFetching:Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.white
 		addSuvs()
		addTableView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
 }

extension ShopAddressPicker:UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell:ShopAddrSearResultCell = tableview.dequeueReusableCell(withIdentifier: "ShopAddrSearResultCellID") as! ShopAddrSearResultCell
		cell.choiceMap = {(dict:NSDictionary)->Void in
			self.pickerMap(dict)
			self.hiddens()
		}
 		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		cell.getDic(dic:dic)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
 		let addrdic:NSDictionary = dic.object(forKey: "address") as! NSDictionary
		let addrsecdic:NSDictionary = dic.object(forKey: "addrjibun") as! NSDictionary
 		let addr:String = addrdic.object(forKey: "cdatasection") as! String
		let addrsec:String = addrsecdic.object(forKey: "cdatasection") as! String
 		let size:CGSize = textSize(text: addr + addrsec, font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width:(screenWidth-130) , height: CGFloat(MAXFLOAT)))

		return 65 + size.height
	}
	
	
	private func addTableView(){
		
		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.estimatedRowHeight = 0
		self.tableview.tableFooterView = UIView()
		self.tableview.estimatedSectionFooterHeight = 0
		self.tableview.estimatedSectionHeaderHeight = 0
 		self.tableview.separatorColor = UIColor(red: 242, green: 244, blue: 246)
 		self.tableview.register(UINib.init(nibName: "ShopAddrSearResultCell", bundle: nil), forCellReuseIdentifier: "ShopAddrSearResultCellID")
		
		self.tableview.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
			self.resquestData(refreshtype: RefreshType.topfresh, complete: {
				self.tableview.mj_header.endRefreshing()
				self.tableview.mj_header.removeFromSuperview()
				self.tableview.mj_footer.resetNoMoreData()
 			})
		})
		self.tableview.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
			self.resquestData(refreshtype: RefreshType.loadmore, complete: {
				self.tableview.mj_footer.endRefreshing()
			})
		})
		
 		self.addSubview(self.tableview)
 		self.tableview.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(btnSearch.snp.bottom).offset(30)
			make.bottom.equalToSuperview().offset(-10)
		}
		
		let tableheadview:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
  		self.tableview.tableHeaderView = tableheadview
		
		
		let line:UILabel = UILabel()
		line.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		tableheadview.addSubview(line)
		line.snp.makeConstraints { (make) in
 			make.top.equalToSuperview()
			make.height.equalTo(1)
			make.left.equalToSuperview().offset(20)
			make.right.equalToSuperview().offset(-20)
		}
		let numberStr:String = String(self.data.count)
  		let attrbut:NSMutableAttributedString = NSMutableAttributedString.init(string: " 共搜索出 " + numberStr + " 条")
  		attrbut.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value:UIColor(red: 33, green: 192, blue: 67), range: NSMakeRange(1,3))
 		lbl.attributedText = attrbut
		tableheadview.addSubview(lbl)
		lbl.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(15)
			make.bottom.right.equalToSuperview()
			make.top.equalToSuperview().offset(5)
		}

		
	}

}

extension ShopAddressPicker{
	private func addSuvs(){

		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		
		coverView.backgroundColor = UIColor.black
		coverView.isUserInteractionEnabled = true
		coverView.alpha = 0.3
		let taps:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hiddens))
		coverView.addGestureRecognizer(taps)
		UIApplication.shared.delegate?.window??.addSubview(coverView)
		coverView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		let title:UILabel = UILabel()
		title.textAlignment = .center
		title.text = "选择地址"
		self.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(15)
			make.centerX.equalToSuperview()
 		}
		
		let cancel:UIButton = UIButton()
		cancel.addTarget(self, action: #selector(hiddens), for: .touchUpInside)
		cancel.setImage(UIImage(named: "icon_close_date"), for: .normal)
		self.addSubview(cancel)
		cancel.snp.makeConstraints { (make) in
			make.right.equalTo(-15)
			make.top.equalTo(15)
			make.width.height.equalTo(30)
		}
		
		addSearchView()
 	}
	
	private func addSearchView(){
		self.addSubview(self.btnSearch)
		
		
		self.btnSearch.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		self.btnSearch.setTitle("搜索", for: .normal)
		self.btnSearch.setTitleColor(UIColor.white, for: .normal)
		self.btnSearch.titleLabel?.font = UIFont.systemFont(ofSize: 15)
		self.btnSearch.layer.cornerRadius = 5
		self.btnSearch.layer.masksToBounds = true
		self.btnSearch.addTarget(self, action: #selector(searchBtn), for: .touchUpInside)
		self.btnSearch.snp.makeConstraints { (make) in
			make.width.equalTo(66)
			make.height.equalTo(40)
			make.right.equalToSuperview().offset(-20)
			make.top.equalTo(60)
		}
		
 		self.inputSearch.placeholder = "  搜索地址"
		self.inputSearch.layer.borderWidth = 1
		self.inputSearch.layer.borderColor = UIColor(red: 212, green: 212, blue: 212).cgColor
 		self.inputSearch.layer.cornerRadius = 3
		self.inputSearch.layer.masksToBounds = true
		self.addSubview(self.inputSearch)
		self.inputSearch.snp.makeConstraints { (make) in
 			make.left.equalToSuperview().offset(20)
			make.right.equalTo(btnSearch.snp.left).offset(-10)
			make.top.equalTo(self.btnSearch.snp.top)
			make.bottom.equalTo(self.btnSearch.snp.bottom)

		}
		
	}

	@objc private func searchBtn(sender:UIButton){
		self.tableview.mj_header.beginRefreshing()

	}
	
	private func resquestData(refreshtype:RefreshType,complete:@escaping ()->Void){
		
		if (self.isFetching) {
			complete()
			return
		}
		
		if refreshtype == RefreshType.topfresh {
			self.pg = 1
			
		}else{
			self.pg += 1
			
		}
 
		KLHttpTool.getKorAddresswithUri("common/GetKorAddressList", withPg: String(self.pg), withPageSize: "3", withKey: "정보화길", success: { (response) in
			
			let res:NSDictionary = response as! NSDictionary
			let status:Int = res.object(forKey: "status") as! Int
			self.isFetching = false
			if status == 1 {
				if (res.object(forKey: "data") is NSDictionary) {
					
					let dit:NSDictionary = res.object(forKey: "data") as! NSDictionary
					let dit1:NSDictionary = dit.object(forKey: "post") as! NSDictionary
					let dit2:NSDictionary = dit1.object(forKey: "itemlist") as! NSDictionary
					let tempdata:NSArray = dit2.object(forKey: "item") as! NSArray
					
					if refreshtype == RefreshType.topfresh{
						self.data.addObjects(from: tempdata as! [Any])
						
					}else{
						self.data.addObjects(from: tempdata as! [Any])
					}
					self.lbl.text = " 共搜索出 " + String(self.data.count) + " 条"
					self.tableview.reloadData()

				}
			}
			complete()
		}) { (error) in
			
			complete()
 
		}

		
	}
	
	@objc private func hiddens(){
		
		coverView.removeFromSuperview()
        self.removeFromSuperview()
	}
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
		
	}

	

 }
