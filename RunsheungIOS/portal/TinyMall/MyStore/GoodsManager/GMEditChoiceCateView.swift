//
//  GMEditChoiceCateView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditChoiceCateView: UIView {
	var choicebtn:BusinessStateView = BusinessStateView()
	

	override init(frame: CGRect) {
		super.init(frame: frame)
		createSUVS()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension GMEditChoiceCateView{
	private func createSUVS(){
		self.layer.cornerRadius = 3
		self.layer.masksToBounds = true
		self.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		self.layer.borderWidth = 1
		
		let title:UILabel = UILabel()
		title.text = "商品分类:"
		self.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.top.equalTo(10)
			make.left.equalTo(5)
			make.width.equalTo(100)
			make.height.equalTo(30)
		}
		self.choicebtn.getTitlesArray(titles: ["Chizza","KFC","人气明星套餐","鸡翅/鸡排","小食/配餐"])
		self.addSubview(self.choicebtn)
		
		self.choicebtn.snp.makeConstraints { (make) in
			make.right.equalTo(-5)
			make.top.equalTo(10)
			make.bottom.equalTo(-10)
			make.width.equalTo(140)
		}
		
		
		
		
	}
}
