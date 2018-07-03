//
//  CommentTopView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentTopView: UIView {
	var leftView:UIView = UIView()
	var rightView:UIView = UIView()
	var dic:NSDictionary?
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getDic(dic:NSDictionary){
		self.dic = dic
		initUI()

	}

}

extension CommentTopView {
	private func initUI() {
		self.createLeft()
		self.createright()
	}
	
	private func createLeft(){
		
		self.leftView.backgroundColor = UIColor.white
		self.leftView.layer.cornerRadius = 5
		self.leftView.layer.masksToBounds = true
		self.addSubview(self.leftView)
		self.leftView.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview().offset(15)
			make.bottom.equalToSuperview().offset(-15)
			make.width.equalTo(screenWidth/3)
		}
		
		
		let showStarValue:UILabel = UILabel()
 		let stars:String = self.dic?.object(forKey:"assess_avg") as! String
		showStarValue.text = stars
		showStarValue.textColor = UIColor(red: 255, green: 190, blue: 14)
		showStarValue.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight(rawValue: 0.4))
		self.leftView.addSubview(showStarValue)
		showStarValue.snp.makeConstraints { (make) in
			make.top.equalToSuperview()
			make.bottom.equalTo(self.leftView.snp.centerY)
			make.centerX.equalToSuperview()
		}
		
		let centerline:UILabel = UILabel()
		centerline.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.leftView.addSubview(centerline)
		centerline.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.left.equalToSuperview().offset(15)
			make.right.equalToSuperview().offset(-15)
			make.height.equalTo(1)
		}
		
		let commentCount:UILabel = UILabel()
		commentCount.textColor = UIColor(red: 160, green: 160, blue: 160)
		commentCount.font = UIFont.systemFont(ofSize: 15.0)
		let num1:String = self.dic?.object(forKey: "assess_cnt") as! String
		commentCount.text = "共".localized+num1+"条".localized
		self.leftView.addSubview(commentCount)
		commentCount.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(centerline.snp.bottom).offset(10)
			make.height.equalTo(20)
		}
		
		
   		let starView:CommentStarView = CommentStarView()
		let starDouble:Double = Double(stars)!
		starView.getStarValue(value:CGFloat(starDouble), h: 14.0)
   		self.leftView.addSubview(starView)
		starView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.width.equalTo(90)
			make.top.equalTo(commentCount.snp.bottom).offset(10)
			make.height.equalTo(14)
		}
	
	}
	
	private func createright(){
		self.addSubview(self.rightView)
		self.rightView.snp.makeConstraints { (make) in
			make.left.equalTo(self.leftView.snp.right).offset(5)
			make.top.equalToSuperview().offset(20)
			make.bottom.equalToSuperview().offset(-15)
			make.right.equalToSuperview()
		}
		let allcount:String = self.dic?.object(forKey: "assess_cnt") as! String
		let allcountInt:Int = Int(allcount)!

		let starStr1:String = self.dic?.object(forKey: "rating1") as! String
		let starInt1:Int = Int(starStr1)!
		let starvalue1:CGFloat = CGFloat(starInt1)/CGFloat(allcountInt)
		
		let starStr2:String = self.dic?.object(forKey: "rating2") as! String
		let starInt2:Int = Int(starStr2)!
		let starvalue2:CGFloat = CGFloat(starInt2)/CGFloat(allcountInt)
		
		let starStr3:String = self.dic?.object(forKey: "rating3") as! String
		let starInt3:Int = Int(starStr3)!
		let starvalue3:CGFloat = CGFloat(starInt3)/CGFloat(allcountInt)
		
		let starStr4:String = self.dic?.object(forKey: "rating4") as! String
		let starInt4:Int = Int(starStr4)!
		let starvalue4:CGFloat = CGFloat(starInt4)/CGFloat(allcountInt)
		
		let starStr5:String = self.dic?.object(forKey: "rating5") as! String
		let starInt5:Int = Int(starStr5)!
		let starvalue5:CGFloat = CGFloat(starInt5)/CGFloat(allcountInt)
		let stararray:NSArray = [starvalue1,starvalue2,starvalue3,starvalue4,starvalue5]
		let starstrarray:NSArray = [starStr1,starStr2,starStr3,starStr4,starStr5]

 
		for i in (0...4) {
			
			self.createBarView(Value: stararray[4-i] as! CGFloat, star: String(5-i), count: starstrarray[4-i] as! String, orderBy: CGFloat(i), superview: rightView)
		}
	}
	
	private func createBarView(Value:CGFloat,star:String,count:String,orderBy:CGFloat,superview:UIView){
		
		let bar:UIView = UIView()
		superview.addSubview(bar)
		
		bar.snp.makeConstraints({ (make) in
			make.top.equalToSuperview().offset(((screenWidth/2 - 30)/5)*orderBy)
			make.left.equalToSuperview().offset(10)
			make.right.equalToSuperview().offset(-5)
			make.height.equalTo((screenWidth/2 - 30)/5)
		})
		
		let starValue:UILabel = UILabel()
		starValue.text =  star + "星".localized
		starValue.textColor = UIColor(red: 160, green: 160, blue: 160)
		starValue.font = UIFont.systemFont(ofSize: 15.0)
		bar.addSubview(starValue)
		starValue.snp.makeConstraints({ (make) in
			make.left.top.equalToSuperview()
			make.bottom.equalToSuperview().offset(-10)
			make.width.equalTo(30)
		})
	
	
		let endlabel:UILabel = UILabel()
		endlabel.text = count
		endlabel.textColor = UIColor(red: 160, green: 160, blue: 160)
		endlabel.font = UIFont.systemFont(ofSize: 15.0)
		bar.addSubview(endlabel)
		endlabel.snp.makeConstraints({ (make) in
			make.right.top.equalToSuperview()
			make.bottom.equalToSuperview().offset(-10)
			make.width.equalTo(50)
		})

		let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
		progressView.progress = 0.1
		progressView.layer.cornerRadius = 3
		progressView.layer.masksToBounds = true
		progressView.setProgress(Float(Value), animated: true)
		progressView.progressTintColor = UIColor(red: 255, green: 190, blue: 14)
		progressView.trackTintColor = UIColor(red: 210, green: 210, blue: 210)
		bar.addSubview(progressView)
		progressView.snp.makeConstraints { (make) in

			make.left.equalTo(starValue.snp.right).offset(5)
			make.right.equalTo(endlabel.snp.left).offset(-5)
			make.centerY.equalTo(starValue.snp.centerY)
			make.height.equalTo(16)
		}

		
	}

}
