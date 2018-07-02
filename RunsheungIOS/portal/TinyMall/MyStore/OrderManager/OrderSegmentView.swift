//
//  OrderSegmentView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//


import UIKit
import SnapKit
class OrderSegmentView: UIView {
	
	var tableview:UITableView = UITableView()
	var index:Int = 0
	var tableviewTag:Int = 0
	var pg:Int = 1
	var isFetching:Bool = false
	var tabview:UITableView = UITableView()
 	var allData:NSArray = []
	var stateData:NSMutableArray = [false,false,false]
	var openCloseState:Bool = false
	
	let badageCircle:(String) -> UILabel = {(text:String) -> UILabel in
		
		let badage:UILabel = UILabel()
		badage.textAlignment = .center
		badage.textColor = UIColor.white
		badage.layer.cornerRadius = 7
		badage.layer.masksToBounds = true
		badage.text = text
		badage.font = UIFont.systemFont(ofSize: 12)
		badage.backgroundColor = UIColor(red: 222, green: 0, blue: 0)
		return badage
	}
	
	let tableViewMap:(UIView,Int)->UITableView = {(dele:UIView,tableviewTag:Int)->UITableView in
		
		let tableview:UITableView = UITableView()
		tableview.frame = CGRect(x: (CGFloat(tableviewTag)*(screenWidth)), y: 0, width: screenWidth, height: screenHeight - 80)
		tableview.tag = tableviewTag
		tableview.separatorColor = UIColor(red: 242, green: 244, blue: 246)
		tableview.dataSource = dele as? UITableViewDataSource
		tableview.delegate = (dele as! UITableViewDelegate)
		tableview.estimatedRowHeight = 0
		tableview.tableFooterView = UIView()
		tableview.estimatedSectionFooterHeight = 0
		tableview.estimatedSectionHeaderHeight = 0
		

		
		return tableview
	}
	
	
	let addSegmentView:() -> UIView = { () -> UIView in
		let bgs:UIView = UIView()
		bgs.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		bgs.layer.borderWidth = 1
		return bgs
	}
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)

	}
	
	@objc public func getTag(tag:Int){
		self.tableviewTag = tag
		ceateTableView()

		KLHttpTool.requestNewOrderListwithUri("/api/AppSM/requestNewOrderList", withDivcode: "2", withpg: "1", withPagesize: "3", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:String = (res.object(forKey: "status") as! String)
			if status == "1" {
				self.allData = res.object(forKey: "data") as! NSArray
				self.tabview.reloadData()
			}
			
		}) { (error) in
			
		}

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
extension OrderSegmentView:UITableViewDelegate,UITableViewDataSource{
	private func ceateTableView(){
		
		self.tabview  = UITableView()
		self.tabview .separatorColor = UIColor(red: 232, green: 234, blue: 236)
		self.tabview .dataSource = self
		self.tabview .delegate = self
		self.tabview .estimatedRowHeight = 0
		self.tabview .tableFooterView = UIView()
		self.tabview .estimatedSectionFooterHeight = 0
		self.tabview .estimatedSectionHeaderHeight = 0
		self.tabview.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//			self.resquestData(refreshtype: RefreshType.topfresh,categoryId:self.categoryid, complete: {
//				self.tableview.mj_header.endRefreshing()
//				self.tableview.mj_footer.resetNoMoreData()
//
//			})
		})
		self.tabview.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
//			self.resquestData(refreshtype: RefreshType.loadmore,categoryId:self.categoryid, complete: {
//				self.tableview.mj_footer.endRefreshing()
//			})
		})
		self.addSubview(self.tabview)
		self.tabview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
	

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 		return self.allData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = UITableViewCell()
		cell.contentView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		
		let orderView:OrderCellTableView = OrderCellTableView()
 		orderView.clickStateMap = { (openState:Bool) in
			self.openCloseState = openState
			self.stateData.replaceObject(at: indexPath.row, with: openState)
			tableView.reloadRows(at: [indexPath], with: .none)
 		}
		orderView.getData(dic:(self.allData.object(at: indexPath.row) as! NSDictionary))
		orderView.getState(state:self.openCloseState)
 		cell.contentView.addSubview(orderView)
		orderView.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview().offset(10)
			make.right.equalToSuperview().offset(-10)
			make.bottom.equalToSuperview()

		}
		
		if indexPath.row == 2 {
			
			let yinImg:UIImageView = UIImageView(image: UIImage(named: "img_cancle_order"))
			orderView.addSubview(yinImg)
			yinImg.snp.makeConstraints { (make) in
				make.right.equalToSuperview().offset(-10)
				make.top.equalToSuperview().offset(5)
				make.width.height.equalTo(90)
			}
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let orderdic:NSDictionary = self.allData.object(at: indexPath.row) as! NSDictionary
		let orderData:NSArray = orderdic.object(forKey: "dataitem") as! NSArray
		let count:Int = orderData.count
		let state:Bool = (self.stateData.object(at: indexPath.row) as! Bool)
		if state {
			return (CGFloat(290 + count*40))
		}else{
			
			return 290
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
	}
	
	
}

