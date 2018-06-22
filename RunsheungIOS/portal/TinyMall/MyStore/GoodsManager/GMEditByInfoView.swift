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
		createSuvs()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
extension GMEditByInfoView{
	private func createSuvs(){
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
		
		var array:NSMutableArray = ["1","2","3","4"]

		self.sizeCollectview = GMEditSizeCollectView(frame: CGRect(x: 20.0, y: 90, width: screenWidth - 40, height: (ceil(CGFloat(array.count)/4.0) * 50)))
		self.sizeCollectview?.getData(array: array)
		self.addSubview(self.sizeCollectview!)
		
		let kwlabel:UILabel = self.titleLabel("口味：",0.6)
		kwlabel.font = UIFont.systemFont(ofSize: 15)
		self.addSubview(kwlabel)
		kwlabel.snp.makeConstraints { (make) in
			make.left.equalTo(20)
			make.top.equalTo((self.sizeCollectview?.snp.bottom)!).offset(10)
			make.height.equalTo(30)
		}
		
		var array1:NSMutableArray = ["1"]
		self.kwCollectview = GMEditSizeCollectView(frame: CGRect(x: 20.0, y: 0, width: screenWidth - 40, height: (ceil(CGFloat(array1.count)/4.0) * 50)))
		self.kwCollectview?.getData(array: array1)
		self.addSubview(self.kwCollectview!)
		self.kwCollectview?.snp.makeConstraints({ (make) in
			make.top.equalTo(kwlabel.snp.bottom)
			make.left.equalTo(20)
			make.width.equalTo(screenWidth - 40)
			make.height.equalTo(ceil(CGFloat(array1.count)/4.0) * 50)
		})

		

	}
}
