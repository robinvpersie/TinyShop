//
//  GMEditPopView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditPopView: UIView {
	var maskview:UIImageView = UIImageView()
	var choiceView:UIView = UIView()
	var inputfieldName: UITextField = UITextField()
	var inputfieldPrice: UITextField = UITextField()

	@objc public var finishCompleteMap:(String,String)->Void = {(name:String,price:String)->Void in }
	
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
		title.text = "新增规格"
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
		

		self.addSubview(self.inputfieldName)
		self.inputfieldName.placeholder = "规格名称"
		self.inputfieldName.layer.cornerRadius = 5
		self.inputfieldName.layer.masksToBounds = true
		self.inputfieldName.textColor = UIColor(red: 160, green: 160, blue: 160)
		self.inputfieldName.tintColor = UIColor(red: 160, green: 160, blue: 160)
		self.inputfieldName.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.inputfieldName.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.snp.centerY).offset(-5)
			make.left.equalTo(30)
			make.right.equalTo(-30)
			make.height.equalTo(40)
		}
		
		self.addSubview(self.inputfieldPrice)
		self.inputfieldPrice.placeholder = "规格价格"
		self.inputfieldPrice.layer.cornerRadius = 5
		self.inputfieldPrice.layer.masksToBounds = true
		self.inputfieldPrice.textColor = UIColor(red: 160, green: 160, blue: 160)
		self.inputfieldPrice.tintColor = UIColor(red: 160, green: 160, blue: 160)
		self.inputfieldPrice.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.inputfieldPrice.snp.makeConstraints { (make) in
			make.top.equalTo(self.snp.centerY).offset(5)
			make.left.equalTo(30)
			make.right.equalTo(-30)
			make.height.equalTo(40)
		}

	}
	
}

extension GMEditPopView{
	@objc private func sumbit(){
		self.hidden()
		if let name = self.inputfieldName.text, let price = self.inputfieldPrice.text {
			self.finishCompleteMap(name,price)

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
