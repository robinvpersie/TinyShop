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
	var dic:NSDictionary?
	var openState:Bool = false
	var acceptPopView:OrderAcceptPopView = OrderAcceptPopView()
	var index:Int = 0
 	@objc public var clickStateMap:(Bool)->Void = { (openState:Bool) in }
	var enterNextPageMap:(Int)->Void = {(page:Int)->Void in }
	
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
	@objc public func getData(dic:NSDictionary,index:Int){
		self.dic = dic
		self.index = index
		self.data = dic.object(forKey: "dataitem") as! NSArray
		self.tabview.reloadData()
	}
	@objc private func acceptAction(sender:UIButton){
		let num:String = self.dic?.object(forKey: "order_num") as! String
		let customer:String  = self.dic?.object(forKey: "custom_code") as! String
		
		if sender.tag == 101 {
		
			KLHttpTool.requestOrderCancelwithUri("/api/AppSM/requestOrderCancel", withOrderNum:num, withCustomerCode:customer, success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let status:String = (res.object(forKey: "status") as! String)
				if status == "1" {
					self.enterNextPageMap(1)
//					self.tabview.reloadData()

 				}
			}) { (error) in
				
			}
		}else if sender.tag == 102 {
			let alerController:UIAlertController = UIAlertController(title: "确定取消此订单发货？", message: "取消订单发货后订单将作为退款订单处理".localized, preferredStyle: .alert)
			let cancel:UIAlertAction = UIAlertAction(title: "取消".localized, style: .cancel) { (alert) in }
			let ok:UIAlertAction = UIAlertAction(title: "确定".localized, style: .default) { (alert) in
				
				KLHttpTool.requestOrderCancelwithUri("/api/AppSM/requestOrderCancel", withOrderNum:num, withCustomerCode:customer, success: { (response) in
					let res:NSDictionary = (response as? NSDictionary)!
					let status:String = (res.object(forKey: "status") as! String)
					if status == "1" {
						self.enterNextPageMap(1)
//						self.tabview.reloadData()

 					}
				}) { (error) in
					
				}

			}
			alerController.addAction(cancel)
			alerController.addAction(ok)
			self.viewController().present(alerController, animated: true, completion: nil)
		} else {
			
			var status:String = "0"
			switch sender.tag {
			case 0:
				status = "3"
				break
			case 1:
				status = "31"
				break
			default:
				break
			}
			
			KLHttpTool.requestOrderTakewithUri("/api/AppSM/requestOrderTake", withorder_num: self.dic?.object(forKey: "order_num") as! String, withstatus:status, success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let status:String = (res.object(forKey: "status") as! String)
				if status == "1" {
//					self.tabview.reloadData()
 					self.acceptPopView.getTag(tag: sender.tag)
					UIApplication.shared.delegate?.window??.addSubview(self.acceptPopView)
					self.acceptPopView.snp.makeConstraints({ (make) in
						make.center.equalToSuperview()
						make.width.equalTo(screenWidth - 60)
						make.height.equalTo(screenHeight/4)
					})
				}
				
			}) { (error) in
				
			}
		}
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
				let namelabel:UILabel = self.label(16.0,UIColor.black,self.dic?.object(forKey: "delivery_name") as! String)
				cell.contentView.addSubview(namelabel)
				namelabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(15)
					make.height.equalTo(20)
					make.width.equalTo(60)

				}
				
				let phonelabel:UILabel = self.label(15.0,UIColor(red: 33, green: 192, blue: 67),self.dic?.object(forKey: "mobilepho") as! String)
				cell.contentView.addSubview(phonelabel)
				phonelabel.snp.makeConstraints { (make) in
					make.left.equalTo(namelabel.snp.right).offset(5)
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}

				let orderlabel:UILabel = self.label(22.0,UIColor(red: 33, green: 192, blue: 67),self.dic?.object(forKey: "order_seq") as! String)
				orderlabel.textAlignment = .right
				cell.contentView.addSubview(orderlabel)
				orderlabel.snp.makeConstraints { (make) in
					make.right.equalTo(-10)
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}

				let addresslabel:UILabel = self.label(15.0,UIColor.black,self.dic?.object(forKey: "to_address") as! String)
				addresslabel.numberOfLines = 0
				cell.contentView.addSubview(addresslabel)
				addresslabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalTo(namelabel.snp.bottom).offset(5)
					make.bottom.equalToSuperview()
					make.right.equalToSuperview().offset(-10)

				}
 			}
			break
		case 1:
			do {
				let rowdic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
				let namelabel:UILabel = self.label(15.0,UIColor(red: 160, green: 160, blue: 160),rowdic.object(forKey: "item_name") as! String)
				cell.contentView.addSubview(namelabel)
				namelabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(10)
					make.height.equalTo(20)
					
				}
				let account:String = rowdic.object(forKey: "order_q") as! String
				let orderCount:UILabel = self.label(15.0,UIColor(red: 160, green: 160, blue: 160),"x"+account)
				cell.contentView.addSubview(orderCount)
				orderCount.snp.makeConstraints { (make) in
					make.centerX.equalToSuperview()
					make.top.equalTo(namelabel.snp.top)
					make.height.equalTo(20)
					
				}
				let price:String = rowdic.object(forKey: "order_o") as! String
 				let pricelabel:UILabel = self.label(16.0,UIColor(red: 160, green: 160, blue: 160),"￥"+price)
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
				let totallabel:UILabel = self.label(15.0,UIColor.black,"总计".localized)
				cell.contentView.addSubview(totallabel)
				totallabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(10)
					make.height.equalTo(20)
					make.width.equalTo(40)
					
				}
				let delivery:String = self.dic?.object(forKey: "delivery_o") as! String
				let titlePlabel:UILabel = self.label(15.0,UIColor(red: 160, green: 160, blue: 160),"(含配送费 ￥".localized + delivery + ")")
				cell.contentView.addSubview(titlePlabel)
				titlePlabel.snp.makeConstraints { (make) in
					make.left.equalTo(totallabel.snp.right)
					make.top.equalTo(totallabel.snp.top)
					make.height.equalTo(20)
					
				}
				let totalmoney:String = self.dic?.object(forKey: "tot_amt") as! String
 				let pricelabel:UILabel = self.label(16.0,UIColor(red: 33, green: 192, blue: 67),"￥ " + totalmoney)
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
				let orderNo:String = self.dic?.object(forKey: "order_num") as! String
 				let orderNolabel:UILabel = self.label(12.0,UIColor(red: 160, green: 160, blue: 160),"订单号：".localized + orderNo)
				cell.contentView.addSubview(orderNolabel)
				orderNolabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalToSuperview().offset(10)
					make.height.equalTo(15)
				}
				
				let orderTime:String = self.dic?.object(forKey: "create_date") as! String
 				let orderTimelabel:UILabel = self.label(12.0,UIColor(red: 160, green: 160, blue: 160),"订单时间: ".localized + orderTime)
				cell.contentView.addSubview(orderTimelabel)
				orderTimelabel.snp.makeConstraints { (make) in
					make.left.equalToSuperview().offset(10)
					make.top.equalTo(orderNolabel.snp.bottom).offset(5)
					make.height.equalTo(15)
					
				}
				
				if (self.index == 0 || self.index == 1) {
					
					let cancelBtn:UIButton = self.button(15.0,UIColor(red: 160, green: 160, blue: 160),"取消订单".localized,UIColor(red: 242, green: 242, blue: 242))
					cancelBtn.tag = 101
 					cancelBtn.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
 					cell.contentView.addSubview(cancelBtn)
					cancelBtn.snp.makeConstraints { (make) in
						make.left.equalTo(15)
						make.top.equalTo(orderTimelabel.snp.bottom).offset(10)
						make.height.equalTo(50)
						make.right.equalTo(cell.contentView.snp.centerX).offset(-5)
					}
					
					let alreadyBtn:UIButton = self.button(15.0,UIColor.white,"接单".localized,UIColor(red: 33, green: 192, blue: 67))
					alreadyBtn.setTitle("已接单".localized, for: .selected)
					alreadyBtn.tag = self.index
 					alreadyBtn.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
					cell.contentView.addSubview(alreadyBtn)
					alreadyBtn.snp.makeConstraints { (make) in
						make.right.equalTo(-15)
						make.top.equalTo(cancelBtn.snp.top)
						make.height.equalTo(50)
						make.left.equalTo(cell.contentView.snp.centerX).offset(5)
					}
					switch self.index {
					case 1:
						cancelBtn.setTitle("取消发货".localized, for: .normal)
						cancelBtn.tag = 102
						alreadyBtn.setTitle("确认发货".localized, for: .normal)

						break
					default:
						break
					}
				
				}
//				else if self.index == 1 {
//					let okBtn:UIButton = self.button(15.0,UIColor.white,"确定发货".localized,UIColor(red: 33, green: 192, blue: 67))
//					okBtn.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
// 					okBtn.tag = self.index
//					cell.contentView.addSubview(okBtn)
//					okBtn.snp.makeConstraints { (make) in
//						make.left.equalTo(15)
//						make.top.equalTo(orderTimelabel.snp.bottom).offset(10)
//						make.height.equalTo(50)
//						make.right.equalToSuperview().offset(-15)
//					}
//
//				}
				else if self.index == 2 {
				
					let orderStatus:String = self.dic?.object(forKey: "online_order_status") as! String
 					let statusBtn:UILabel?
					if orderStatus == "4"{
						statusBtn = self.label(12.0,UIColor(red: 190, green: 190, blue: 190),"已拒单".localized)
					}else{
						statusBtn = self.label(12.0,UIColor(red: 190, green: 190, blue: 190),"已发货".localized)
 					}
					statusBtn?.textAlignment = .center
					statusBtn?.layer.cornerRadius = 3
					statusBtn?.layer.masksToBounds = true
					statusBtn?.layer.borderColor = UIColor(red: 190, green: 190, blue: 190).cgColor
					statusBtn?.layer.borderWidth = 1
					cell.contentView.addSubview(statusBtn!)
					statusBtn?.snp.makeConstraints { (make) in
						make.right.equalToSuperview().offset(-10)
						make.centerY.equalTo(orderTimelabel.snp.centerY)
 						make.height.equalTo(20)
						make.width.equalTo(50)
					}
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
			return ((self.index == 2) ? 60 : 120)
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
			
			let title:UILabel = self.label(14.0,UIColor(red: 160, green: 160, blue: 160),"订单商品".localized)
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
			arrowtitle.setTitle("打开".localized,for: .normal)
			arrowtitle.setTitle("收起".localized,for: .selected)
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


