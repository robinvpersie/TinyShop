//
//  GoodManagerCollectView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//


import UIKit

class GMEditCellTableView: UIView {
	var tableview:UITableView = UITableView()
	var data:NSMutableArray = NSMutableArray()
	var selftag:Int = 0
	var pg:Int = 1
	var isFetching:Bool = false

	
	enum RefreshType: Int {
		case topfresh
		case loadmore
 	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createSuv()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func createSuv(){
		createTableView()
 	}
	
	private func createTableView(){
		
		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.tableFooterView = UIView()
		self.tableview.estimatedRowHeight = 0
		self.tableview.estimatedSectionFooterHeight = 0
		self.tableview.estimatedSectionHeaderHeight = 0
		self.tableview.separatorColor = UIColor(red: 232, green: 234, blue: 236)
		self.tableview.register(UINib(nibName: "GoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_id")
		self.tableview.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
			self.resquestData(refreshtype: RefreshType.topfresh, complete: {
				self.tableview.mj_header.endRefreshing()
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
			make.edges.equalToSuperview()
		}
		
	}
}

extension GMEditCellTableView {
	@objc public func getData(tag:Int){
		
		self.selftag = tag
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
		KLHttpTool.getGoodManagerListCatewithUri("product/queryList", withselling: String(self.selftag), withCategoryId: "0", withpg: String(self.pg), success: { (response) in
 			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			self.isFetching = false

 			if status == 1 {
				let tempdata:NSArray = res.object(forKey: "data") as! NSArray
				if refreshtype == RefreshType.topfresh{
					
					self.data = NSMutableArray(array:tempdata)
 				}else{
					
					self.data.addObjects(from: tempdata as! [Any])
 				}
				self.tableview.reloadData()

			}
			complete()
			

		}) { (err) in
			complete()

		}

	}
}

extension GMEditCellTableView:UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:GoodsTableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! GoodsTableViewCell
		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		cell.getDic(dic:dic)
		cell.downProductMap = {(index:Int)->Void in
			
			self.data.removeObject(at: index - 1)
			self.tableview.reloadData()
		}
		return cell
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		let groupid:String = dic.object(forKey: "GroupId") as! String
		KLHttpTool.getGoodManagerDelproductwithUri("product/Delproduct", withgroupID: groupid, success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
				self.data.removeObject(at: indexPath.row)
				self.tableview.reloadData()

			}
		}) { (error) in
			
		}
		
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100.0
	}
	
	
	
}
