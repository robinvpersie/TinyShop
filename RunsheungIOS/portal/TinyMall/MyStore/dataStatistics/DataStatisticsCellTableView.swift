//
//  DataStatisticsCellTableView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataStatisticsCellTableView: UIView {
	var tableview:UITableView = UITableView()
	var data:NSArray = ["今日","本周","本月","期间"]
	var tableHeadView:DataStatisticCellHeadView?

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
		self.tableview.estimatedRowHeight = 0
		self.tableview.tableFooterView = UIView()
		self.tableview.estimatedSectionFooterHeight = 0
		self.tableview.estimatedSectionHeaderHeight = 0
		self.tableview.separatorColor = UIColor.white
		self.tableview.register(UINib(nibName: "DataSingleOrderCell", bundle: nil), forCellReuseIdentifier: "cell_id")
		self.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		self.tableHeadView = DataStatisticCellHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth/4.0 + 70))
		self.tableview.tableHeaderView = self.tableHeadView
		
	}
}

extension DataStatisticsCellTableView:UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 156.0
	}
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
		view.backgroundColor = UIColor.white
		view.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		view.layer.borderWidth = 1.0
		
		let content:String = self.data.object(at: self.tag) as! String
		let label:UILabel = UILabel()
		label.text = content + "订单"
		label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.4))
		view.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview().offset(15)
			make.height.equalTo(20)
		}
		self.tableHeadView?.getTitle(text: content)
		return view

	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50.0
	}


	
}
