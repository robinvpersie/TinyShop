//
//  OrderReturnMainCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class OrderReturnMainCell: UITableViewCell {

	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var orderNO: UILabel!
	@IBOutlet weak var orderPhone: UILabel!
	@IBOutlet weak var orderPrice: UILabel!
	@IBOutlet weak var orderState: UILabel!
	@IBOutlet weak var greyOrderState: UILabel!
	@IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var timelb: UILabel!
    
    
	override func awakeFromNib() {
        super.awakeFromNib()
		self.bgView.layer.borderWidth = 1.0
		self.bgView.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		self.bgView.layer.cornerRadius = 5
		self.bgView.layer.masksToBounds = true
		self.bgView.layer.shadowColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		
		self.checkBtn.layer.borderWidth = 1.0
		self.checkBtn.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		self.checkBtn.layer.cornerRadius = 3
		self.checkBtn.layer.masksToBounds = true
		

    }
    
    func configureWithModel(_ model: OrderReturnModel) {
        orderPhone.text = "전화번호: " + model.mobilepho
        orderPrice.text =  "￥" + model.tot_amt
        greyOrderState.text = "환불상태: " + model.online_order_status
        timelb.text = "신청시간: " + model.cancel_date
        orderNO.text = "주문번호:" + model.order_num
        orderState.text = model.status_classify
    }

	@IBAction func checkDetail(_ sender: UIButton) {
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


	}
    
}
