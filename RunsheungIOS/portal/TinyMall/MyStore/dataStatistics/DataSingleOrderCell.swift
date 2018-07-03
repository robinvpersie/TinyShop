//
//  DataSingleOrderCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataSingleOrderCell: UITableViewCell {

	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var orderNO: UILabel!
	@IBOutlet weak var orderNOmark: UILabel!
	
	@IBOutlet weak var orderPhone: UILabel!
	@IBOutlet weak var orderMoney: UILabel!
	@IBOutlet weak var orderState: UILabel!
	@IBOutlet weak var orderTime: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
		self.bgView.layer.borderWidth = 1.0
		self.bgView.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		self.bgView.layer.cornerRadius = 5
		self.bgView.layer.masksToBounds = true
		self.bgView.layer.shadowColor = UIColor(red: 242, green: 244, blue: 246).cgColor

	}

	@objc public func getDic(dic:NSDictionary){
		
		let num:String = dic.object(forKey: "list_num") as! String
		let itemP:String = dic.object(forKey: "tot_amt") as! String
		let time:String = dic.object(forKey: "create_date") as! String
		let ordernum:String = dic.object(forKey: "order_num") as! String
		let mobilep:String = dic.object(forKey: "mobilepho") as! String
		let orderstatus:String = dic.object(forKey: "order_status") as! String

		self.orderMoney.text = "订单金额：￥" + itemP
		self.orderNOmark.text = "#" + num
		self.orderTime.text = "下单时间：" + time
		self.orderNO.text = "订单号：" + ordernum
		self.orderPhone.text = "手机号码：" + mobilep
		self.orderState.text = "订单状态：" + orderstatus

		

	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
