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
	var veiw_bgn:Int = 1
	var refreshIndexPath:IndexPath?
	var data:NSMutableArray = [true,false]
	var requestFinishMap:(NSDictionary) -> Void = {(dic:NSDictionary) in}
 	var requestData:NSArray = NSArray()

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
		self.tableview.register(UINib(nibName: "CommentRetTableCell", bundle: nil), forCellReuseIdentifier: "CommentRetTableCell_ID")
		self.tableview.register(UINib(nibName: "CommentTableCell", bundle: nil), forCellReuseIdentifier: "CommentTableCell_ID")
 		self.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
	
	@objc public func getSection(section:Int){
		self.veiw_bgn = section + 1
		self.resquestAssessList(view_gbn: self.veiw_bgn)
	}
	
	private func resquestAssessList(view_gbn:Int){
		KLHttpTool.requestAssessListwithUri("/api/AppSM/requestAssessList", withDivcode:"2", withview_gbn: String(view_gbn), withpg: "1", withPagesize: "5", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:String = (res.object(forKey: "status") as! String)
			if status == "1" {
				self.requestData = res.object(forKey: "ShopAssessData") as! NSArray
				self.requestFinishMap(res)
				self.tableview.reloadData()
			}
		}) { (error) in
			
		}

	}
}

extension CommentCellTableView:UITableViewDelegate,UITableViewDataSource{
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.requestData.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
		let dic:NSDictionary = self.requestData.object(at: indexPath.section) as! NSDictionary
		let returnContent:String = dic.object(forKey: "sale_content") as! String
		let isHave:Bool = (returnContent.count == 0) ? false : true
 
		if isHave {
			let cell:CommentRetTableCell = tableview.dequeueReusableCell(withIdentifier: "CommentRetTableCell_ID", for: indexPath) as! CommentRetTableCell
			cell.getdic(dic: dic)
			cell.returnSaleSuccessMap = { ()->Void in
				self.resquestAssessList(view_gbn: self.veiw_bgn)
 			}
 			return cell

		}else{
			let cell:CommentTableCell = tableview.dequeueReusableCell(withIdentifier: "CommentTableCell_ID", for: indexPath) as! CommentTableCell
			cell.getdic(dic: dic)
 			cell.returnSaleSuccessMap = { ()->Void in
				self.resquestAssessList(view_gbn: self.veiw_bgn)
 			}
 			return cell

		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let dic:NSDictionary = self.requestData.object(at: indexPath.section) as! NSDictionary
		let returnContent:String = dic.object(forKey: "sale_content") as! String
		let salews:CGFloat = screenWidth - 50.0
		let saletextMaxSize = CGSize(width:salews , height: CGFloat(MAXFLOAT))
		let salesize:CGSize = self.textSize(text: returnContent, font: UIFont.systemFont(ofSize: 14), maxSize: saletextMaxSize)
   		let isHave:Bool = (returnContent.count == 0) ? false : true
		
		let content:String = (dic.object(forKey: "rep_content") as? String)!
  		let ws:CGFloat = screenWidth - 30.0
		let textMaxSize = CGSize(width:ws , height: CGFloat(MAXFLOAT))
		let size:CGSize = self.textSize(text: content, font: UIFont.systemFont(ofSize: 14), maxSize: textMaxSize)

 		if isHave {
 			return 210.0 + size.height + salesize.height
		}else{
		
			return 130.0 + size.height

		}
 	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
		view.backgroundColor =  UIColor(red: 242, green: 244, blue: 246)
		return view
	}

	func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return 10.0
	}

	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	}
 
}
