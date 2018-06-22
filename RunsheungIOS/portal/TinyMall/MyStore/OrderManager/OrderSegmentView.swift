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
	
	var segment:UIView?
	var bottomline:UILabel?
	var firstBtn:UIButton = UIButton()
	var secBtn:UIButton = UIButton()
	var tableview:UITableView = UITableView()
	var scrollview:UIScrollView?
	var index:Int = 0
	var tabview1:UITableView = UITableView()
	var tabview2:UITableView = UITableView()
	var newBadage:UILabel?
	var alreadyBadage:UILabel?
	var allData:NSArray = [[1,2],[1,],[1,2,3]]
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
		createSuv()
		createScrollerView()
		ceateTableView()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
extension OrderSegmentView:UITableViewDelegate,UITableViewDataSource{
	private func ceateTableView(){
		
		self.tabview1 = self.tableViewMap(self, 0)
		self.scrollview?.addSubview(self.tabview1)
		self.tabview2 = self.tableViewMap(self, 1)
		self.scrollview?.addSubview(self.tabview2)
		
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
//			orderView.getData(array: (self.allData.object(at: indexPath.row) as! NSArray))
		}
		
		orderView.getState(state:self.openCloseState)
		orderView.getData(array:(self.allData.object(at: indexPath.row) as! NSArray))
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
		let orderData:NSArray = self.allData.object(at: indexPath.row) as! NSArray
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

extension OrderSegmentView:UIScrollViewDelegate{
	private func createScrollerView(){
		self.scrollview = UIScrollView()
		self.scrollview?.isScrollEnabled = false
		self.scrollview?.delegate = self
		
		self.addSubview(self.scrollview!)
		self.scrollview?.snp.makeConstraints({ (make) in
			make.bottom.left.right.equalToSuperview()
			make.top.equalTo((self.segment?.snp.bottom)!)
		})
		self.scrollview?.contentSize = CGSize(width: 2*screenWidth, height: (self.scrollview?.frame.height)!)
	}
	
	
}

extension OrderSegmentView{
	
	private func createSuv(){
		self.segment = addSegmentView()
		
		self.addSubview(self.segment!)
		self.segment?.snp.makeConstraints({ (make) in
			make.top.left.right.equalToSuperview()
			make.height.equalTo(40)
		})
		
		self.firstBtn.tag = 0
		self.firstBtn.setTitle("新订单", for: .normal)
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
		self.secBtn.setTitle("已完成", for: .normal)
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
		
		
		self.newBadage = self.badageCircle("2")
		firstBtn.addSubview(self.newBadage! )
		self.newBadage?.snp.makeConstraints { (make) in
			make.width.height.equalTo(14)
			make.top.equalToSuperview().offset(2)
			make.left.equalTo(self.firstBtn.snp.centerX).offset(20)
		}
		
//		self.alreadyBadage = self.badageCircle("3")
//		secBtn.addSubview(self.alreadyBadage! )
//		self.alreadyBadage?.snp.makeConstraints { (make) in
//			make.width.height.equalTo(14)
//			make.top.equalToSuperview().offset(2)
//			make.left.equalTo(self.secBtn.snp.centerX).offset(20)
//		}

		
		
	}
	
	@objc private func segementIndex(sender:UIButton){
		
		self.firstBtn.isSelected = false
		self.secBtn.isSelected = false
		sender.isSelected = !sender.isSelected
		if (self.bottomline?.minx)! < screenWidth/2 {
			self.alreadyBadage?.isHidden = true
			UIView.animate(withDuration: 0.5) {
				self.bottomline?.transform = CGAffineTransform(translationX: screenWidth/2, y: 0)
				
			}
		}else{
			self.newBadage?.isHidden = true

			UIView.animate(withDuration: 0.5) {
				self.bottomline?.transform = CGAffineTransform(translationX: 0, y: 0)
			}
			
		}
		
		self.index = sender.tag
		
		scrollview?.contentOffset = CGPoint(x: self.index*Int(screenWidth), y: 0)
		
	}
	
	
}
