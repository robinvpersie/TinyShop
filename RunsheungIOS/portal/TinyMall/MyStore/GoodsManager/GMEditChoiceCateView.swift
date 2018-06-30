//
//  GMEditChoiceCateView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditChoiceCateView: UIView {
	
	@objc public var choicebtn:BusinessStateView = BusinessStateView()
	var datas:NSMutableArray? = NSMutableArray()

	override init(frame: CGRect) {
		super.init(frame: frame)
		createSUVS()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}



extension GMEditChoiceCateView{
	
	@objc public func getData(data:NSArray){
		KLHttpTool.getGoodManagerQuerycategorywithUri("category/querycategory", withCatergoryID: "4", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
				let tempdic:NSArray = res.object(forKey: "data") as! NSArray
				for dic in tempdic {
					let dit:NSDictionary = dic as! NSDictionary
					let levelname:String = (dit.object(forKey: "level_name") as! String)
					
					let currentDic:NSDictionary = ((data.firstObject) as! NSDictionary)
					let current:String = currentDic.object(forKey: "level_name") as! String

					if levelname == current {
 						self.datas?.insert(dit, at: 0)
					}else{
 						self.datas?.add(dit)
					}
					self.choicebtn.getTitlesArray(titles: self.datas!)
				}
			}
			
		}) { (error) in
			
		}
		
 		self.addSubview(self.choicebtn)
		self.choicebtn.snp.makeConstraints { (make) in
			make.right.equalTo(-5)
			make.top.equalTo(10)
			make.bottom.equalTo(-10)
			make.width.equalTo(140)
		}
	}
	private func createSUVS(){
		self.layer.cornerRadius = 3
		self.layer.masksToBounds = true
		self.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		self.layer.borderWidth = 1
		
		let title:UILabel = UILabel()
		title.text = "商品分类:".localized
		self.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.top.equalTo(10)
			make.left.equalTo(5)
			make.width.equalTo(100)
			make.height.equalTo(30)
		}
		
		
		
		
	}
}
