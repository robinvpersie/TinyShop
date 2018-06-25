//
//  CommentCellTableView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentCellTableView: UIView {
	var tableview:UITableView = UITableView()
	var refreshHeight:CGFloat = 0.0
	var refreshIndexPath:IndexPath?
	var data:NSMutableArray = [true,false]

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
		self.tableview.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.tableview.register(UINib(nibName: "CommetnTableCell", bundle: nil), forCellReuseIdentifier: "cell_id")
		self.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
}

extension CommentCellTableView:UITableViewDelegate,UITableViewDataSource{
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:CommetnTableCell = tableview.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! CommetnTableCell
		let hasReturn:Bool = self.data.object(at: indexPath.section) as! Bool
		cell.getMark(mark: indexPath.section,haveReturn:hasReturn)
		cell.refreshCellHeightMap = {(cellHeight:CGFloat,indexSection:Int)->Void in
			self.refreshIndexPath = indexPath
			self.refreshHeight = cellHeight
			self.data.replaceObject(at: indexPath.section, with: true)
			tableView.reloadSections([indexPath.section], with: .fade)
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 250.0
		}

		if indexPath.section == self.refreshIndexPath?.section {
			return (150.0 + self.refreshHeight + 66.0)
		}
		return 150.0
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
		view.backgroundColor =  UIColor(red: 242, green: 244, blue: 246)
		return view
	}

	func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return 10.0
	}

	
	
}
