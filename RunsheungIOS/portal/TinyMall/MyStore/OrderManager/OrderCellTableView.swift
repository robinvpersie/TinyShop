//
//  OrderCellTableView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//


import UIKit
import SnapKit
class OrderCellTableView: UIView {
	var tabview:UITableView = UITableView()
	var data:NSArray = NSArray()
	var openState:Bool = false
	

	@objc public var clickStateMap:(Bool)->Void = { (openState:Bool) in }
	
	var label:(CGFloat,UIColor,String)->UILabel = {(fontSize:CGFloat,textColor:UIColor,textContent:String)->UILabel in
		let labels:UILabel = UILabel()
		labels.font = UIFont.systemFont(ofSize: fontSize)
		labels.text = textContent
		labels.textColor = textColor
		return labels
		
	}
	
	
	var button:(CGFloat,UIColor,String,UIColor)->UIButton = {(fontSize:CGFloat,textColor:UIColor,textContent:String,bgColor:UIColor)->UIButton in
		let btn:UIButton = UIButton()
		btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
		btn.backgroundColor = bgColor
		btn.setTitle(textContent, for: .normal)
		btn.setTitleColor(textColor, for: .normal)
		btn.layer.cornerRadius = 3
		btn.layer.masksToBounds = true
		
		return btn
		
	}


	let tableViewMap:(UIView,Int)->UITableView = {(dele:UIView,tableviewTag:Int)->UITableView in
		let tableview:UITableView = UITableView()
		tableview.frame = CGRect(x: (CGFloat(tableviewTag)*(screenWidth)), y: 0, width: screenWidth-20, height: screenHeight - 40)
		tableview.tag = tableviewTag
		tableview.dataSource = dele as? UITableViewDataSource
		tableview.delegate = (dele as! UITableViewDelegate)
		tableview.estimatedRowHeight = 0
		tableview.tableFooterView = UIView()
		tableview.estimatedSectionFooterHeight = 0
		tableview.estimatedSectionHeaderHeight = 0
		return tableview
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
		self.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		self.layer.borderWidth = 1.0
		ceateTableView()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func openOrCloseAction(sender:UIButton){
		self.openState = !self.openState
		let indexset:NSIndexSet = NSIndexSet(index: 1)
		self.tabview.reloadSections(indexset as IndexSet, with: .none)
		self.clickStateMap(self.openState)
		
	}
	
	@objc public func getState(state:Bool){
		self.openState = state
		let indexset:NSIndexSet = NSIndexSet(index: 1)
		self.tabview.reloadSections(indexset as IndexSet, with: .none)
		
	}
	@objc public func getData(array:NSArray){
		self.data = array
		self.tabview.reloadData()
	}
	
}
extension OrderCellTableView:UITableViewDelegate,UITableViewDataSource{
	private func ceateTableView(){
		
		self.tabview = self.tableViewMap(self, 0)
		self.addSubview(self.tabview)
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 1 {
			if self.openState {
				return (self.data.count)
			}else{
				
				return 0
			}

		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = UITableViewCell()
		switch indexPath.section {
		case 0:
			do {
				let namelabel:UILabel = self.label(16.0,UIColor.black,"冷先生")
				cell.contentView.addSubview(namelabel)
				namelabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(15)
					make.height.equalTo(20)
					make.width.equalTo(60)

				}
				
				let phonelabel:UILabel = self.label(15.0,UIColor(red: 33, green: 192, blue: 67),"13142276655")
				cell.contentView.addSubview(phonelabel)
				phonelabel.snp.makeConstraints { (make) in
					make.left.equalTo(namelabel.snp.right).offset(5)
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}

				let orderlabel:UILabel = self.label(22.0,UIColor(red: 33, green: 192, blue: 67),"#88")
				orderlabel.textAlignment = .right
				cell.contentView.addSubview(orderlabel)
				orderlabel.snp.makeConstraints { (make) in
					make.right.equalTo(-10)
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}

				let addresslabel:UILabel = self.label(16.0,UIColor.black,"龙跃国际2栋1903")
				cell.contentView.addSubview(addresslabel)
				addresslabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalTo(namelabel.snp.bottom).offset(10)
					make.height.equalTo(20)
					
				}

				
			}
			break
		case 1:
			do {
				let namelabel:UILabel = self.label(15.0,UIColor(red: 160, green: 160, blue: 160),"Chizza考烧鸡")
				cell.contentView.addSubview(namelabel)
				namelabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(10)
					make.height.equalTo(20)
					
				}
				
				let orderCount:UILabel = self.label(15.0,UIColor(red: 160, green: 160, blue: 160),"x1")
				cell.contentView.addSubview(orderCount)
				orderCount.snp.makeConstraints { (make) in
					make.centerX.equalToSuperview()
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}
				
				let pricelabel:UILabel = self.label(16.0,UIColor(red: 160, green: 160, blue: 160),"￥ 10")
				pricelabel.textAlignment = .right
				cell.contentView.addSubview(pricelabel)
				pricelabel.snp.makeConstraints { (make) in
					make.right.equalTo(-10)
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}
			}
			break

		case 2:
			do {
				let totallabel:UILabel = self.label(15.0,UIColor.black,"总计")
				cell.contentView.addSubview(totallabel)
				totallabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(10)
					make.height.equalTo(20)
					make.width.equalTo(40)
					
				}
				
				let titlePlabel:UILabel = self.label(15.0,UIColor(red: 160, green: 160, blue: 160),"(含配送费 ￥2.00)")
				cell.contentView.addSubview(titlePlabel)
				titlePlabel.snp.makeConstraints { (make) in
					make.left.equalTo(totallabel.snp.right).offset(5)
					make.top.equalTo(totallabel.snp.top)
					make.height.equalTo(20)
					
				}
				
				let pricelabel:UILabel = self.label(16.0,UIColor(red: 33, green: 192, blue: 67),"￥ 107")
				pricelabel.textAlignment = .right
				cell.contentView.addSubview(pricelabel)
				pricelabel.snp.makeConstraints { (make) in
					make.right.equalTo(-10)
					make.top.equalTo(totallabel.snp.top)
					make.height.equalTo(20)
					
				}
				
			}
			break
		case 3:
			do {
				let orderNolabel:UILabel = self.label(12.0,UIColor(red: 160, green: 160, blue: 160),"订单号：032445563243445")
				cell.contentView.addSubview(orderNolabel)
				orderNolabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(10)
					make.height.equalTo(15)
				}
				
				let orderTimelabel:UILabel = self.label(12.0,UIColor(red: 160, green: 160, blue: 160),"订单时间：06-16 10:30:34")
				cell.contentView.addSubview(orderTimelabel)
				orderTimelabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalTo(orderNolabel.snp.bottom).offset(5)
					make.height.equalTo(15)
					
				}
				
				let cancelBtn:UIButton = self.button(15.0,UIColor(red: 160, green: 160, blue: 160),"取消订单",UIColor(red: 242, green: 242, blue: 242))
				cell.contentView.addSubview(cancelBtn)
				cancelBtn.snp.makeConstraints { (make) in
					make.left.equalTo(15)
					make.top.equalTo(orderTimelabel.snp.bottom).offset(10)
					make.height.equalTo(50)
					make.right.equalTo(cell.contentView.snp.centerX).offset(-5)
				}

				let alreadyBtn:UIButton = self.button(15.0,UIColor.white,"已接单",UIColor(red: 33, green: 192, blue: 67))
				cell.contentView.addSubview(alreadyBtn)
				alreadyBtn.snp.makeConstraints { (make) in
					make.right.equalTo(-15)
					make.top.equalTo(cancelBtn.snp.top)
					make.height.equalTo(50)
					make.left.equalTo(cell.contentView.snp.centerX).offset(5)
				}

				
			}
			break

		default:
			break
		}
	   
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 80
		case 3:
			return 120

		default:
			return 40
		}
	}
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headView:UIView = UIView()
		headView.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		headView.layer.borderWidth = 1.0
		headView.backgroundColor = UIColor.white
		if section == 1 {
			let icon:UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_order_goods"))
			headView.addSubview(icon)
			icon.snp.makeConstraints { (make) in
				make.left.equalToSuperview().offset(15)
				make.centerY.equalTo(headView.snp.centerY)
				make.width.height.equalTo(15)
			}
			
			let title:UILabel = self.label(14.0,UIColor(red: 160, green: 160, blue: 160),"订单商品")
			headView.addSubview(title)
			title.snp.makeConstraints { (make) in
				make.left.equalTo(icon.snp.right).offset(5)
				make.top.equalTo(icon.snp.top)
				make.height.equalTo(15)
				
			}
			
			let arrowBtn:UIButton = UIButton()
			arrowBtn.addTarget(self, action: #selector(openOrCloseAction), for: .touchUpInside)
			headView.addSubview(arrowBtn)
			arrowBtn.snp.makeConstraints { (make) in
				make.right.bottom.top.equalToSuperview()
				make.width.equalTo(60)
			}
			
			let arrow:UIButton = UIButton()
			arrow.tag = 101
			arrow.isUserInteractionEnabled = false
			arrow.setImage(UIImage(named: "icon_open_goods"), for: .normal)
			arrow.setImage(UIImage(named: "icon_close_goods"), for: .selected)
						arrowBtn.addSubview(arrow)
			arrow.snp.makeConstraints { (make) in
				make.right.equalToSuperview().offset(-10)
				make.centerY.equalToSuperview()
				make.width.height.equalTo(15)
			}
			
			
			let arrowtitle:UIButton = UIButton()
			arrowtitle.tag = 102
			arrowtitle.isUserInteractionEnabled = false
			arrowtitle.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
			arrowtitle.setTitleColor(UIColor(red: 33, green: 192, blue: 67), for: .normal)
			arrowtitle.setTitle("打开",for: .normal)
			arrowtitle.setTitle("收起",for: .selected)
			arrowBtn.addSubview(arrowtitle)
			arrowtitle.snp.makeConstraints { (make) in
				make.right.equalTo(arrow.snp.left).offset(5)
				make.centerY.equalToSuperview()
				make.height.equalTo(30)
				make.width.equalTo(40)
			}

			
			arrow.isSelected = openState
			arrowtitle.isSelected = openState
			
			
			return headView
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return 40.0
		}
		return 0.0
	}

	
	
}


