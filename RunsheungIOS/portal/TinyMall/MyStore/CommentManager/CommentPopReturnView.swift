//
//  CommentPopReturnView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentPopReturnView: UIView {
	var maskview:UIImageView = UIImageView()
	var choiceView:UIView = UIView()
	var inputText: UITextView?
	@objc public var finishCompleteMap:(String)->Void = {(returnContent:String)->Void in }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createSuv()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func createSuv(){
		
		self.backgroundColor = UIColor.white
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
		
		self.maskview.backgroundColor = UIColor.black
		self.maskview.alpha = 0.3
		self.maskview.isUserInteractionEnabled = true
		let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
		self.maskview.addGestureRecognizer(tap)
		UIApplication.shared.delegate?.window??.addSubview(self.maskview)
		self.maskview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		let cancel:UIButton = UIButton()
		cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
		cancel.setImage(UIImage(named: "icon_close_date"), for: .normal)
		self.addSubview(cancel)
		cancel.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-15)
			make.top.equalToSuperview().offset(15)
			make.width.height.equalTo(25)
		}
		
		let title:UILabel = UILabel()
		title.text = "回复评论"
		title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.4))
		self.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(30)
		}

		let okbtn:UIButton = UIButton()
		okbtn.setTitle("确定", for: .normal)
		okbtn.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		okbtn.setTitleColor(UIColor.white, for: .normal)
		okbtn.layer.cornerRadius = 5
		okbtn.layer.masksToBounds = true
		okbtn.addTarget(self, action: #selector(sumbit), for: .touchUpInside)
		self.addSubview(okbtn)
		okbtn.snp.makeConstraints({ (make) in
			make.bottom.equalToSuperview().offset(-20)
			make.left.equalToSuperview().offset(50)
			make.right.equalToSuperview().offset(-50)
			make.height.equalTo(40)
		})
		
		
		self.inputText = UITextView()
		self.inputText?.layer.cornerRadius = 5
		self.inputText?.layer.masksToBounds = true
		self.inputText?.textColor = UIColor(red: 160, green: 160, blue: 160)
		self.inputText?.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.inputText?.tintColor = UIColor(red: 160, green: 160, blue: 160)
		self.inputText?.text = "回复"
		
		self.addSubview(self.inputText!)
		self.inputText?.snp.makeConstraints({ (make) in
			make.left.equalToSuperview().offset(30)
			make.right.equalToSuperview().offset(-30)
			make.top.equalTo(title.snp.bottom).offset(20)
			make.bottom.equalTo(okbtn.snp.top).offset(-20)
			
		})
	}
	
}

extension CommentPopReturnView{
	@objc private func sumbit(){
		self.hidden()
		if let comment = self.inputText?.text {
			self.finishCompleteMap(comment)
		}
 	}
	
	@objc private func cancelAction(){
		self.hidden()
		
	}
	
	private func hidden(){
		self.maskview.removeFromSuperview()
		self.removeFromSuperview()
	}
	
}
