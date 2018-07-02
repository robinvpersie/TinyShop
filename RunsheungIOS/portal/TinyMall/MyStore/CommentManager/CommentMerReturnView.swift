//
//  CommentMerchantReturnView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentMerReturnView: UIView {
	var clickChangeMap:(Bool)->Void = {(state:Bool)->Void in}
	var returnFinishChnageMap:(String)->Void = {(changeContent:String)->Void in}

	@objc public var comment:UITextView = UITextView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createSUV()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getContent(s:String){
		self.comment.text = s
	}

}

extension CommentMerReturnView{
	private func createSUV(){
		self.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
		
		let titlelabel:UILabel = UILabel()
		titlelabel.textColor = UIColor(red: 33, green: 192, blue: 67)
		titlelabel.text = "商家回复："
		self.addSubview(titlelabel)
		titlelabel.snp.makeConstraints { (make) in
			make.left.top.equalTo(10)
			make.height.equalTo(30)
		}
		
		let time:UILabel = UILabel()
		time.textColor = UIColor(red: 160, green: 160, blue: 160)
		time.text = "2018-06-10 10:34"
		time.font = UIFont.systemFont(ofSize: 14)
		self.addSubview(time)
		time.snp.makeConstraints { (make) in
			make.top.equalTo(10)
			make.right.equalToSuperview().offset(-10)
			make.height.equalTo(30)
		}
		
		let line:UILabel = UILabel()
		line.backgroundColor = UIColor(red: 224, green: 224, blue: 224)
		line.font = UIFont.systemFont(ofSize: 14)
		self.addSubview(line)
		line.snp.makeConstraints { (make) in
			make.top.equalTo(titlelabel.snp.bottom).offset(10)
			make.right.left.equalToSuperview()
			make.height.equalTo(1)
		}

		
		self.comment.textColor = UIColor(red: 160, green: 160, blue: 160)
		self.comment.isUserInteractionEnabled = false
		self.comment.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.comment.tintColor = UIColor(red: 160, green: 160, blue: 160)
		self.comment.text = "感谢您的支持与喜欢！我们会努力做到更好！".localized
		self.comment.font = UIFont.systemFont(ofSize: 14)
		self.addSubview(self.comment)
		self.comment.snp.makeConstraints { (make) in
			make.top.equalTo(line.snp.bottom).offset(8)
			make.bottom.equalToSuperview().offset(-8)
			make.left.equalTo(10)
			make.right.equalTo(-10)

		}
		
		self.clickChangeMap = {(state:Bool)->Void in
			if state {
				self.comment.becomeFirstResponder()

			}else{
				self.comment.resignFirstResponder()
				self.returnFinishChnageMap(self.comment.text)
			}
			
			self.comment.isUserInteractionEnabled = state

		}

	}
}
