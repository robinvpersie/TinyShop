//
//  GoodsManagerView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
class GoodsManagerView: UIView {
	
	var segment:UIView?
	var bottomline:UILabel?
	var firstBtn:UIButton = UIButton()
	var secBtn:UIButton = UIButton()
	var tableview:UITableView = UITableView()
	var scrollview:UIScrollView?
	var index:Int = 0
	var tabview1:UITableView = UITableView()
	var tabview2:UITableView = UITableView()
	
	
	let tableViewMap:(UIView,Int)->UITableView = {(dele:UIView,tableviewTag:Int)->UITableView in
		let tableview:UITableView = UITableView()
		tableview.register(UINib(nibName: "GoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CELL_ID")
		tableview.frame = CGRect(x: (CGFloat(tableviewTag)*(screenWidth)), y: 0, width: screenWidth, height: screenHeight - 40)
		tableview.tag = tableviewTag
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
		createSuv()
		createScrollerView()
		ceateTableView()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
extension GoodsManagerView:UITableViewDelegate,UITableViewDataSource{
	private func ceateTableView(){
		
		self.tabview1 = self.tableViewMap(self, 0)
		self.scrollview?.addSubview(self.tabview1)

		self.tabview2 = self.tableViewMap(self, 1)
		self.scrollview?.addSubview(self.tabview2)

		
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch tableView.tag {
		case 0:
			return 4
		default:
			return 2
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:GoodsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELL_ID") as! GoodsTableViewCell
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
	}
	
	
}

extension GoodsManagerView:UIScrollViewDelegate{
	private func createScrollerView(){
		self.scrollview = UIScrollView()
		self.scrollview?.delegate = self
		self.scrollview?.isScrollEnabled = false
		self.addSubview(self.scrollview!)
		self.scrollview?.snp.makeConstraints({ (make) in
			make.bottom.left.right.equalToSuperview()
			make.top.equalTo((self.segment?.snp.bottom)!)
		})
		self.scrollview?.contentSize = CGSize(width: 2*screenWidth, height: (self.scrollview?.frame.height)!)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let offx:Int = Int(scrollView.contentOffset.x)
		var indexs:Int = Int(offx / Int(screenWidth))
		if (offx-Int(screenWidth) * indexs) > Int(screenWidth/2) {
			indexs += 1
			
		}
		scrollView.contentOffset = CGPoint(x:(indexs * Int(screenWidth)),y:0)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {

	}

}

extension GoodsManagerView{
	
	private func createSuv(){
		self.segment = addSegmentView()
		
		self.addSubview(self.segment!)
		self.segment?.snp.makeConstraints({ (make) in
			make.top.left.right.equalToSuperview()
			make.height.equalTo(40)
		})

		self.firstBtn.tag = 0
		self.firstBtn.setTitle("销售中", for: .normal)
		self.firstBtn.setTitleColor(UIColor(red: 33, green: 192, blue: 67), for: .selected)
		self.firstBtn.addTarget(self, action: #selector(segementIndex), for: .touchUpInside)
		self.firstBtn.setTitleColor(UIColor.black, for: .normal)
		self.firstBtn.isSelected = true
		self.segment?.addSubview(self.firstBtn)
		self.firstBtn.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview()
			make.bottom.equalToSuperview().offset(-2)
			make.right.equalTo((self.segment?.snp.centerX)!)
			
		}
		
		self.secBtn.tag = 1
		self.secBtn.setTitle("已下架", for: .normal)
		self.secBtn.setTitleColor(UIColor(red: 33, green: 192, blue: 67), for: .selected)
		self.secBtn.addTarget(self, action: #selector(segementIndex), for: .touchUpInside)
		self.secBtn.setTitleColor(UIColor.black, for: .normal)
		self.segment?.addSubview(self.secBtn)
		self.secBtn.snp.makeConstraints { (make) in
			make.right.top.equalToSuperview()
			make.bottom.equalToSuperview().offset(-2)
			make.left.equalTo((self.segment?.snp.centerX)!)
		}

		self.bottomline = UILabel()
		self.bottomline?.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		self.segment?.addSubview(self.bottomline!)
		self.bottomline?.snp.makeConstraints({ (make) in
			make.height.equalTo(2)
			make.width.equalTo(60)
			make.centerX.equalTo(firstBtn.snp.centerX)
			make.bottom.equalToSuperview()
		})
		
		
	}
	
	@objc private func segementIndex(sender:UIButton){
		
		self.firstBtn.isSelected = false
		self.secBtn.isSelected = false
		sender.isSelected = !sender.isSelected
		if (self.bottomline?.minx)! < screenWidth/2 {
			UIView.animate(withDuration: 0.5) {
				self.bottomline?.transform = CGAffineTransform(translationX: screenWidth/2, y: 0)
				
			}
		}else{
			UIView.animate(withDuration: 0.5) {
				self.bottomline?.transform = CGAffineTransform(translationX: 0, y: 0)
			}

		}
		
		self.index = sender.tag

		scrollview?.contentOffset = CGPoint(x: self.index*Int(screenWidth), y: 0)
		
	}
	
	
}
