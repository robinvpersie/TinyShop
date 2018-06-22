//
//  CommetnTableCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommetnTableCell: UITableViewCell {
    var merReturn:CommentMerReturnView?
	var starView:CommentStarView = CommentStarView()
	@IBOutlet weak var avator: UIImageView!
	@IBOutlet weak var nickname: UILabel!
	@IBOutlet weak var time: NSLayoutConstraint!
	@IBOutlet weak var content: UILabel!
	@IBOutlet weak var bgStarView: UILabel!
	@IBOutlet weak var returnBtn: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.avator.layer.cornerRadius = 20
		self.avator.layer.masksToBounds = true
		self.returnBtn.layer.cornerRadius = 3
		self.returnBtn.layer.masksToBounds = true
		
		self.bgStarView.addSubview(self.starView)
		self.starView.getStarValue(value: 4.2, h: 12)
		self.starView.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.equalToSuperview()
			make.height.equalTo(12)
			make.width.equalTo(80)
		}
		
	}
	
	@objc public func getMark(mark:Int){
		if mark == 0 {
			self.merReturn = CommentMerReturnView(frame: CGRect(x: 15, y: 110, width: screenWidth - 30, height: 100))
			self.contentView.addSubview(self.merReturn!)
			self.returnBtn.setTitle("修改", for: .normal)
			self.returnBtn.setTitle("完成", for: .selected)
			
		}
		self.returnBtn.setBackgroundImage(UIImage(named: "green"), for: .selected)

	}


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

	}
	
	@IBAction func returnAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		self.merReturn?.clickChangeMap(sender.isSelected)
	}
	
}
