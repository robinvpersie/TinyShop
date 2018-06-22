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

	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		initUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
		showStarValue.text = "4.5"
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
		commentCount.text = "共384条"
		self.leftView.addSubview(commentCount)
		commentCount.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(centerline.snp.bottom).offset(10)
			make.height.equalTo(20)
		}
		
		let starView:CommentStarView = CommentStarView()
		starView.getStarValue(value: 3.6, h: 14)
		self.leftView.addSubview(starView)
		starView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.width.equalTo(90)
			make.top.equalTo(commentCount.snp.bottom).offset(4)
			make.height.equalTo(25)
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
		for i in (0...4) {
			
			let count:Int = Int((arc4random() % 1000) + 1)
			let star:CGFloat = CGFloat(count)/1000.0
			self.createBarView(Value: star, star: String(5-i), count: String(count), orderBy: CGFloat(i), superview: rightView)
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
		starValue.text =  star + "星"
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
