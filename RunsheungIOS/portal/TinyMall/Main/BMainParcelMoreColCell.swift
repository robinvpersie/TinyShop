//
//  BMainParcelMoreColCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/11/1.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BMainParcelMoreColCell: UICollectionViewCell {
	var imageView:UIImageView!
	var shopName:UILabel!
	var score:UILabel!
	var address:UILabel!
	var distance:UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.contentView.backgroundColor = UIColor(hex: 0xf2f4f6)
 		addSubViews()
		
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func withData(dic:NSDictionary){
		
		imageView.kf.setImage(with:URL(string:dic.object(forKey: "SHOP_THUMNAIL_IMAGE") as! String))
		distance.text = (dic.object(forKey: "distance") as? String)! + "km"
		shopName.text = dic.object(forKey: "CUSTOM_NAME") as? String
		score.text = (dic.object(forKey: "SCORE") as? String)! + "分"
 		address.text = dic.object(forKey: "SHOP_INFO") as? String

	}
	
	private func addSubViews(){
		
		let bgView:UIView = UIView()
		bgView.backgroundColor = UIColor.white
		self.contentView.addSubview(bgView)
		bgView.snp.makeConstraints { (make) in
			make.left.top.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(-10)
		}
		
		imageView = UIImageView()
		bgView.addSubview(imageView)
		imageView.snp.makeConstraints({ (make) in
			make.left.right.top.equalToSuperview()
			make.bottom.equalTo( -self.frame.height / 3.0)
		})

		shopName = UILabel()
		bgView.addSubview(shopName)
		shopName.snp.makeConstraints({ (make) in
			make.top.equalTo((imageView.snp.bottom)).offset(5)
			make.left.equalToSuperview().offset(10)
 		})

		score = UILabel()
		score.textColor = UIColor(hex: 0xfeca55)
		bgView.addSubview(score)
		score.snp.makeConstraints({ (make) in
			make.left.equalTo(shopName.snp.right).offset(6)
			make.centerY.equalTo(shopName.snp.centerY)
		})
		
		address = UILabel()
		address.textColor = UIColor(hex: 0x999999)
		address.backgroundColor = UIColor.brown
		address.text = "di zhi wei zhi"
		bgView.addSubview(address)
		address.snp.makeConstraints({ (make) in
			make.top.equalTo(shopName.snp.bottom)
			make.left.equalTo(10)
  		})

		distance = UILabel()
		distance.font = .systemFont(ofSize: 13)
 		distance.textColor = UIColor(hex: 0x999999)
		bgView.addSubview(distance)
		distance.snp.makeConstraints({ (make) in
			make.right.equalToSuperview().offset(-5)
			make.centerY.equalTo(address.snp.centerY)
		})

		let locationIcon:UIImageView = UIImageView(image: UIImage(named: "icon_topbar_location")?.withRenderingMode(.alwaysOriginal))
		bgView.addSubview(locationIcon)
		locationIcon.snp.makeConstraints { (make) in
			make.right.equalTo(distance.snp.left).offset(-2)
			make.width.height.equalTo(15)
			make.centerY.equalTo(distance.snp.centerY)
		}
 
	
	}
}
