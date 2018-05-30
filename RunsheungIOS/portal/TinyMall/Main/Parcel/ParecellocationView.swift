//
//  ParecellocationView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/5/29.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ParecellocationView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 254, green: 222, blue: 209)
		createSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func createSubviews(){
		let suv:UIView = UIView()
		suv.backgroundColor = UIColor.white
		self.addSubview(suv)
		suv.snp.makeConstraints { (make) in
			make.leading.equalTo(20)
			make.bottom.equalTo(-5)
			make.top.equalTo(5)
			make.trailing.equalTo(-20)
		}
		
		let ltn:UIButton = UIButton()
		ltn.setImage(UIImage(named: "icon_location-1"), for: .normal)
		suv.addSubview(ltn)
		ltn.addTarget(self, action: #selector(btnaction), for: .touchUpInside)
		
		ltn.snp.makeConstraints { (make) in
			make.width.height.equalTo(24)
			make.leading.top.equalTo(3)
		}
		let sqr:UIButton = UIButton()
		sqr.setImage(UIImage(named: "icon_scan_qr"), for: .normal)
		sqr.addTarget(self, action: #selector(btnaction), for: .touchUpInside)

		suv.addSubview(sqr)
		sqr.snp.makeConstraints { (make) in
			make.width.height.equalTo(24)
			make.trailing.bottom.equalTo(-3)
		}
		
		let lbl:UILabel = UILabel()
		lbl.text = UserDefaults().object(forKey: "Address") as? String
		
		suv.addSubview(lbl)
		lbl.snp.makeConstraints { (make) in
			make.leading.equalTo(ltn.snp_trailing).offset(15)
			make.trailing.equalTo(sqr.snp_leading)
			make.top.equalTo(3)
			make.bottom.equalTo(-3)
		}
		
	}
	
	@objc private func btnaction(sender:UIButton){
		
	}
	
}
