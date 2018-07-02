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
	var dic:NSDictionary?
	var showtime:UILabel?
	
	var returnSaleSuccessMap:()->Void = { ()->Void in }
	
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
		
		self.showtime = UILabel(frame: CGRect(x: screenWidth - 195, y: nickname.y, width: 180, height: nickname.height))
 		self.showtime?.textColor = UIColor(red: 160, green: 160, blue: 160)
		showtime?.font = UIFont.systemFont(ofSize: 15)
		showtime?.textAlignment = .right
		self.contentView.addSubview(self.showtime!)
		
		
		
	}

	@IBAction func returnBtnAction(_ sender: UIButton) {
 
			self.popReturnView = CommentPopReturnView()
			UIApplication.shared.delegate?.window??.addSubview(self.popReturnView!)
			self.popReturnView?.snp.makeConstraints({ (make) in
				make.center.equalToSuperview()
				make.width.equalTo(screenWidth - 60)
				make.height.equalTo(screenHeight/3)
			})
			self.popReturnView?.finishCompleteMap = {(returnContent:String)->Void in
				
				KLHttpTool.requestSaleAssessUpdInswithUri("/api/AppSM/requestSaleAssessUpdIns", withsale_content: returnContent, withassess_id: self.dic?.object(forKey: "id") as! String, success: { (response) in
					let res:NSDictionary = (response as? NSDictionary)!
					let status:String = (res.object(forKey: "status") as! String)
					if status == "1" {
						self.returnSaleSuccessMap()
					}
				}) { (error) in
 
				}
   			}
 	}
	
	@objc public func getdic(dic:NSDictionary){
		self.dic = dic
		let imageurl:String = self.dic?.object(forKey: "img_path") as! String
		self.avator.setImageWith(NSURL.init(string:imageurl)! as URL)
 		self.nickname.text = self.dic?.object(forKey: "custom_name") as? String
		let starStr:String = self.dic?.object(forKey: "score") as! String
		let starValue:Int = Int(starStr)!
		self.bgStarView.addSubview(self.starView)
		self.starView.getStarValue(value: CGFloat(starValue), h: 12)
		self.starView.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.equalToSuperview()
			make.height.equalTo(12)
			make.width.equalTo(80)
		}
		
		let timeStr:String = self.dic?.object(forKey: "reg_date") as! String
 		self.showtime?.text = String(timeStr.prefix(16))
 		self.content.text = self.dic?.object(forKey: "rep_content") as? String

	}
	
	
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     }
    
}
