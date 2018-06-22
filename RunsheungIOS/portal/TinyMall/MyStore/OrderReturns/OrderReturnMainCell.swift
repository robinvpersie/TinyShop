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

	@IBAction func checkDetail(_ sender: UIButton) {
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


	}
    
}
