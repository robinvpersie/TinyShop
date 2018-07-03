//
//  CommetnTableCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentRetTableCell: UITableViewCell {
    var merReturn:CommentMerReturnView?
	var starView:CommentStarView = CommentStarView()
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
 		self.returnBtn.setTitle("修改".localized, for: .normal)
		self.returnBtn.setTitle("完成".localized, for: .selected)
 
 	}
	
	@objc public func getdic(dic:NSDictionary){
		self.dic = dic
		let content:String = (dic.object(forKey: "rep_content") as? String)!
		let ws:CGFloat = screenWidth - 30.0
		let textMaxSize = CGSize(width:ws , height: CGFloat(MAXFLOAT))
		let size:CGSize = self.textSize(text: content, font: UIFont.systemFont(ofSize: 14), maxSize: textMaxSize)
		
		let salecontent:String = (dic.object(forKey: "sale_content") as? String)!
   		let salews:CGFloat = screenWidth - 50.0
		let saletextMaxSize = CGSize(width:salews , height: CGFloat(MAXFLOAT))
		let salesize:CGSize = self.textSize(text: salecontent, font: UIFont.systemFont(ofSize: 14), maxSize: saletextMaxSize)
		
 		self.merReturn = CommentMerReturnView(frame: CGRect(x: 15, y: 90 + size.height, width: screenWidth - 30, height: 80.0 + salesize.height))
		self.merReturn?.returnFinishChnageMap = {(changeContent:String)->Void in
			KLHttpTool.requestSaleAssessUpdInswithUri("/api/AppSM/requestSaleAssessUpdIns", withsale_content: changeContent, withassess_id: self.dic?.object(forKey: "id") as! String, success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let status:String = (res.object(forKey: "status") as! String)
				if status == "1" {
					self.returnSaleSuccessMap()
				}
			}) { (error) in
				
			}

		}
		
		let regdate:String = self.dic?.object(forKey: "sale_reg_date") as! String
		self.merReturn?.getContent(s: salecontent,date:regdate)
		self.contentView.addSubview(self.merReturn!)
		
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
		self.content.text = content
	}

	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

	}
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	}

	@IBAction func returnAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		self.merReturn?.clickChangeMap(sender.isSelected)
		
	}
 }
