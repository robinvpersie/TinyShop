//
//  GMEditByInfoView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditByInfoView: UIView {
	var sizeCollectview:GMEditSizeCollectView?
	var kwCollectview:GMEditSizeCollectView?
	let titleLabel:(String,CGFloat)->UILabel = {(titles:String,fontweight:CGFloat)->UILabel in
		
		let label:UILabel = UILabel()
		label.text = titles
		return label
	}

	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getData(array1:NSMutableArray,array2:NSMutableArray){
		createSuvs(array1:array1,array2:array2)

	}
}
extension GMEditByInfoView{
	private func createSuvs(array1:NSMutableArray,array2:NSMutableArray){
		self.backgroundColor = UIColor.white
		let basetitle:UILabel = self.titleLabel("附加信息",1.0)
		self.addSubview(basetitle)
		basetitle.snp.makeConstraints { (make) in
			make.left.top.equalTo(20)
			make.height.equalTo(30)
		}
		
		let sizelabel:UILabel = self.titleLabel("规格：",0.6)
		sizelabel.font = UIFont.systemFont(ofSize: 15)
		self.addSubview(sizelabel)
		sizelabel.snp.makeConstraints { (make) in
			make.left.equalTo(20)
			make.top.equalTo(basetitle.snp.bottom).offset(10)
			make.height.equalTo(30)
		}
		
 		self.sizeCollectview = GMEditSizeCollectView(frame: CGRect(x: 20.0, y: 90, width: screenWidth - 40, height: (ceil(CGFloat(array1.count + 1)/4.0) * 50)))
		self.sizeCollectview?.getData(array: array1,tag:101)
		self.addSubview(self.sizeCollectview!)
		self.sizeCollectview?.sumbitMap = {(name:String,price:String)->Void in
			
			array1.add(["specName":name,"specPrice":price])
 			let sections:Int = Int(ceil(CGFloat(array1.count + 1)/4.0))
			var rect:CGRect = (self.sizeCollectview?.frame)!
			rect.size.height = CGFloat(sections) * 50.0
			self.sizeCollectview?.frame = rect
			
		}
		
		
		let kwlabel:UILabel = self.titleLabel("口味：",0.6)
		kwlabel.font = UIFont.systemFont(ofSize: 15)
		self.addSubview(kwlabel)
		kwlabel.snp.makeConstraints { (make) in
			make.left.equalTo(20)
			make.top.equalTo((self.sizeCollectview?.snp.bottom)!).offset(10)
			make.height.equalTo(30)
		}
		
 		self.kwCollectview = GMEditSizeCollectView(frame: CGRect(x: 20.0, y: 0, width: screenWidth - 40, height: (ceil(CGFloat(array2.count + 1)/4.0) * 50)))
		self.kwCollectview?.getData(array: array2,tag:102)
		self.addSubview(self.kwCollectview!)
		self.kwCollectview?.sumbitMap1 = {(name:String)->Void in
			array2.add(["flavorName":name])
			let sections:Int = Int(ceil(CGFloat(array2.count + 1)/4.0))
			var rect:CGRect = (self.kwCollectview?.frame)!
			rect.size.height = CGFloat(sections) * 50.0
			self.kwCollectview?.frame = rect
		}

		self.kwCollectview?.snp.makeConstraints({ (make) in
			make.top.equalTo(kwlabel.snp.bottom)
			make.left.equalTo(20)
			make.width.equalTo(screenWidth - 40)
			make.height.equalTo(ceil(CGFloat(array2.count + 1)/4.0) * 50)
		})

		

	}
}
