//
//  OrderAcceptPopView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/29.
//  Copyright © 2018年 linpeng. All rights reserved.
//


import UIKit

class OrderAcceptPopView: UIView {
	var maskview:UIImageView = UIImageView()
	var index:Int = 0
	
	var submitAcceptSuccessMap:(Int)->Void = {(index:Int)->Void in}
	
	override init(frame: CGRect) {
		super.init(frame: frame)

	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getTag(tag:Int){
		self.index = tag
		createSuv()

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
		
		let showState:UIView = UIView()
 		self.addSubview(showState)
		showState.snp.makeConstraints { (make) in
			make.left.top.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(-40)
		}

		let icon:UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_succeeds_order"))
		showState.addSubview(icon)
		icon.snp.makeConstraints { (make) in
 			make.center.equalToSuperview()
			make.width.height.equalTo(60)
		}
		
		let titlsState:UILabel = UILabel()
		showState.addSubview(titlsState)
		titlsState.snp.makeConstraints { (make) in
			make.top.equalTo(icon.snp.bottom)
			make.height.equalTo(30)
			make.centerX.equalTo(showState.snp.centerX)
		}
		
		switch self.index {
		case 0:
			do{
				titlsState.text = "接单成功!".localized
				icon.image = #imageLiteral(resourceName: "icon_succeeds_order")

			}
			break
		case 1:
			do{
				titlsState.text = "商品已全部打包开始派送！".localized
 				icon.image = #imageLiteral(resourceName: "img_delivery_success")
			}
			break

		default:
			break
		}
		
		let okbtn:UIButton = UIButton()
		okbtn.setTitle("确定".localized, for: .normal)
		okbtn.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		okbtn.setTitleColor(UIColor.white, for: .normal)
		okbtn.addTarget(self, action: #selector(sumbit), for: .touchUpInside)
		self.addSubview(okbtn)
		okbtn.snp.makeConstraints({ (make) in
			make.bottom.right.left.equalToSuperview()
 			make.height.equalTo(40)
		})

	}
	
}

extension OrderAcceptPopView{
	
 	@objc private func sumbit(tag:Int){
		self.submitAcceptSuccessMap(self.index)
		self.hidden()

	}
	@objc private func cancelAction(){
		self.hidden()
	}
	private func hidden(){
		self.maskview.removeFromSuperview()
		self.removeFromSuperview()
	}
	
}
