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
		self.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
}

extension GMEditCellTableView {
	@objc public func getData(tag:Int){
		KLHttpTool.getGoodManagerListCatewithUri("product/queryList", withselling: String(tag), withCategoryId: "0", withpg: "1", success: { (response) in
		
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
				self.data = NSMutableArray(array:res.object(forKey: "data") as! NSArray )
 				self.tableview.reloadData()
 			}
		}) { (err) in
			
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
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100.0
	}
	
	
	
}
