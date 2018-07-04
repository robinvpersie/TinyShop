//
//  DataStatisticsCellTableView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataStatisticsCellTableView: UIView {
	enum RefreshType: Int {
		case topfresh
		case loadmore
	}
	var pg:Int = 1
	var isFetching:Bool = false
 	var tableview:UITableView = UITableView()
	var data:NSArray = ["今日".localized,"本周".localized,"本月".localized,"期间".localized]
	var requesData:NSMutableArray = NSMutableArray()
	var tableHeadView:DataStatisticCellHeadView?
	var forthCellTableViewMap:(NSString,NSString)->Void = {(fromday:NSString,endday:NSString) in }
	override init(frame: CGRect) {
		super.init(frame: frame)
		createSuv()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func createSuv(){
		createTableView()
		self.forthCellTableViewMap = {(fromday:NSString,endday:NSString) in
			self.tableview.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
				self.resquestData(refreshtype: RefreshType.topfresh,type:4,startDay:fromday,endDay:endday , complete: {
					self.tableview.mj_header.endRefreshing()
					self.tableview.mj_footer.resetNoMoreData()
					
				})
			})
			self.tableview.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
				self.resquestData(refreshtype: RefreshType.loadmore,type:4,startDay:fromday,endDay:endday , complete: {
					self.tableview.mj_footer.endRefreshing()
				})
			})
			self.tableview.mj_header.beginRefreshing()

  		}
 	}
	
	@objc public func getData(type:Int){
 		if type < 3 {
 
			self.tableview.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
				self.resquestData(refreshtype: RefreshType.topfresh,type:type + 1,startDay:"",endDay:"" , complete: {
					self.tableview.mj_header.endRefreshing()
					self.tableview.mj_footer.resetNoMoreData()
					
				})
			})
			self.tableview.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
				self.resquestData(refreshtype: RefreshType.loadmore,type:type + 1,startDay:"",endDay:"" , complete: {
					self.tableview.mj_footer.endRefreshing()
				})
			})
			self.tableview.mj_header.beginRefreshing()

  		}
	
 
	}
	
	
 	private func resquestData(refreshtype:RefreshType,type:Int,startDay:NSString,endDay:NSString,complete:@escaping ()->Void){
 
		if (self.isFetching) {
			complete()
			return
		}
 
		if refreshtype == RefreshType.topfresh {
			self.pg = 1
			
		}else{
			self.pg += 1
			
		}
		
		KLHttpTool.requestOrderSalesReportwithUri("/api/AppSM/requestOrderSalesReport", withpg: "1", withPeriodclassify: String(type), witheFromday: startDay as String?, withToday: endDay as String?, withPagesize: "5", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
 			let status:String = (res.object(forKey: "status") as! String)
			self.isFetching = false
 			if status == "1" {
				self.tableHeadView?.showData(dic: res)
				let tempdata:NSArray = res.object(forKey: "data") as! NSArray
				if refreshtype == RefreshType.topfresh{
					
					self.requesData = NSMutableArray(array:tempdata)
				}else{
					
					self.requesData.addObjects(from: tempdata as! [Any])
				}
 				self.tableview.reloadData()
				
			}
			complete()
			
			
		}) { (err) in
			complete()
			
		}
		
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
		return self.requesData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let dic:NSDictionary = self.requesData.object(at: indexPath.row) as! NSDictionary
		let cell:DataSingleOrderCell = tableview.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! DataSingleOrderCell
		cell.getDic(dic: dic)
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
		label.text = content + "订单".localized
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
