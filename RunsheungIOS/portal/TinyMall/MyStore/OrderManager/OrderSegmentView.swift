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
	enum RefreshType: Int {
		case topfresh
		case loadmore
	}

	var tableview:UITableView = UITableView()
	var index:Int = 0
	var tableviewTag:Int = 0
	var pg:Int = 1
	var isFetching:Bool = false
	var tabview:UITableView = UITableView()
 	var allData:NSMutableArray = []
	var stateData:NSMutableArray = []
	var openCloseState:Bool = false
	var submitAcceptSuccessMap1:(Int)->Void = {(index:Int)->Void in}

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
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc public func getTag(tag:Int){
		self.tableviewTag = tag
		ceateTableView()
		self.tabview.mj_header.beginRefreshing()
 	}
	

	private func resquestData(refreshtype:RefreshType,complete:@escaping ()->Void){
		self.openCloseState = false
		if (self.isFetching) {
			complete()
			return
		}

		if refreshtype == RefreshType.topfresh {
			self.pg = 1

		}else{
			self.pg += 1

		}

		KLHttpTool.requestNewOrderListwithUri("/api/AppSM/requestNewOrderList", withOrderclassify:String(self.tableviewTag + 1),withDivcode: "2", withpg:String(self.pg), withPagesize: "3", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			
			let status:String = (res.object(forKey: "status") as! String)
			self.isFetching = false

			if status == "1" {
				let tempdata:NSArray = res.object(forKey: "data") as! NSArray
				if refreshtype == RefreshType.topfresh{

					self.allData = NSMutableArray(array:tempdata)
				}else{
					
 					self.allData.addObjects(from: tempdata as! [Any])
				}
				for _ in self.allData {
					self.stateData.add(false)
				}
				self.tabview.reloadData()

			}
			complete()


		}) { (err) in
			complete()

		}

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
			self.resquestData(refreshtype: RefreshType.topfresh , complete: {
				self.tabview.mj_header.endRefreshing()
				self.tabview.mj_footer.resetNoMoreData()

			})
		})
		self.tabview.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
			self.resquestData(refreshtype: RefreshType.loadmore, complete: {
				self.tabview.mj_footer.endRefreshing()
			})
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
		orderView.acceptPopView.submitAcceptSuccessMap = {[weak self](index:Int)->Void in
//			self?.resquestData(refreshtype: RefreshType.topfresh, complete: {
//				self?.tabview.mj_header.endRefreshing()
//				self?.tabview.mj_footer.resetNoMoreData()
//
//			})
			self?.submitAcceptSuccessMap1(index)
			
		}
		orderView.getData(dic:(self.allData.object(at: indexPath.row) as! NSDictionary) ,index:self.tableviewTag)
		orderView.getState(state:self.openCloseState)
 		cell.contentView.addSubview(orderView)
		orderView.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview().offset(10)
			make.right.equalToSuperview().offset(-10)
			make.bottom.equalToSuperview()

		}
 
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let orderdic:NSDictionary = self.allData.object(at: indexPath.row) as! NSDictionary
		let orderData:NSArray = orderdic.object(forKey: "dataitem") as! NSArray
		let count:Int = orderData.count
		let state:Bool = (self.stateData.object(at: indexPath.row) as! Bool)
		if state {
			return (CGFloat(((self.tableviewTag == 2) ? 230 : 290) + count*40))
		}else{
			
			return (self.tableviewTag == 2) ? 230 : 290
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
	}
	
	
}

