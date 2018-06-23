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
		self.tableview.separatorColor = UIColor(red: 242, green: 244, blue: 246)
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
			
			
		}) { (err) in
			
		}
		
	}
}

extension GMEditCellTableView:UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView.tag == 1 {
			return 2
		}
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100.0
	}
	
	
	
}
