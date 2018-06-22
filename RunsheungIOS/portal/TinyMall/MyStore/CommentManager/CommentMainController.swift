//
//  CommentMainController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentMainController: MyStoreBaseViewController {
	var tableview:UITableView = UITableView()
	var commentTop:CommentTopView = CommentTopView()
	var segment:DataStatisticsHeadView?
	var refreshHeight:CGFloat = 0.0
	var refreshIndexPath:IndexPath?
	var data:NSMutableArray = [true,false]

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UserDefaults.standard.set("", forKey: "changeComment")
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "评价管理"
		createSuvs()

	}
	private func createSuvs(){
		self.view.addSubview(self.commentTop)
		self.commentTop.snp.makeConstraints { (make) in
			make.top.left.right.equalToSuperview()
			make.height.equalTo( screenWidth / 2)
		}
		self.createTableView()

		
	}

}


extension CommentMainController:UITableViewDelegate,UITableViewDataSource {
	
	@objc private func clickChange(sender:UIButton){
		
	}
	
	private func createTableView(){
		
		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.estimatedRowHeight = 0
		self.tableview.tableFooterView = UIView()
		self.tableview.separatorColor = UIColor.white
		
		self.tableview.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.tableview.register(UINib(nibName: "CommetnTableCell", bundle: nil), forCellReuseIdentifier: "cell_id")
		self.view.addSubview(self.tableview)
		self.tableview.snp.makeConstraints { (make) in
			make.top.equalTo(self.commentTop.snp.bottom)
			make.left.right.bottom.equalToSuperview()
		}
		
		self.segment = DataStatisticsHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
		self.segment?.getTitles(array: ["全部(234)","差评(13)","未读(23)"])
		self.tableview.tableHeaderView = self.segment
		
		
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return self.data.count
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

