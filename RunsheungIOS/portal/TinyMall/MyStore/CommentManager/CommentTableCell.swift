//
//  DataReturnOrderViewCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentTableCell: UITableViewCell {
	var starView:CommentStarView = CommentStarView()
	var popReturnView:CommentPopReturnView?

	@IBOutlet weak var avator: UIImageView!
	@IBOutlet weak var nickname: UILabel!
	@IBOutlet weak var time: NSLayoutConstraint!
	@IBOutlet weak var content: UILabel!
	@IBOutlet weak var bgStarView: UILabel!
	@IBOutlet weak var returnBtn: UIButton!
//	@objc public var refreshCellHeightMap:(CGFloat,Int)->Void = {(cellHeight:CGFloat,indexSection:Int)->Void in }

	
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
		}    }

	@IBAction func returnBtnAction(_ sender: UIButton) {
//		if self.merReturn == nil {
		
			self.popReturnView = CommentPopReturnView()
			UIApplication.shared.delegate?.window??.addSubview(self.popReturnView!)
			self.popReturnView?.snp.makeConstraints({ (make) in
				make.center.equalToSuperview()
				make.width.equalTo(screenWidth - 60)
				make.height.equalTo(screenHeight/3)
			})
			
			self.popReturnView?.finishCompleteMap = {(returnContent:String)->Void in
				
				let ws:CGFloat = screenWidth - 50.0
				let textMaxSize = CGSize(width:ws , height: CGFloat(MAXFLOAT))
				let size:CGSize = self.textSize(text: returnContent, font: UIFont.systemFont(ofSize: 14), maxSize: textMaxSize)
//				self.refreshCellHeightMap(size.height,self.IndexPathSection)
			}
			
//		}

	}
	
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     }
    
}
