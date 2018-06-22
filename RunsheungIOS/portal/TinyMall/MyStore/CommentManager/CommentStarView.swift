//
//  commentStarView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentStarView: UIView {
	var starValue:CGFloat = 0.0

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	@objc public func getStarValue(value:CGFloat,h:CGFloat){
		self.starValue = value
		createSuv(h:h)
	}
	private func createSuv(h:CGFloat){
		let defaultStarBG:UIView = UIView()

		for i in (0...4) {
			self.addSubview(defaultStarBG)
			defaultStarBG.snp.makeConstraints { (make) in
				make.edges.equalToSuperview()
			}
			
			let starImg:UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_star_default_8"))
			starImg.contentMode = .scaleAspectFit
			defaultStarBG.addSubview(starImg)
			starImg.snp.makeConstraints { (make) in
				make.top.equalTo(5)
				make.left.equalTo(i*Int(h + 5.0))
				make.width.height.equalTo(h)
			}

		}
		
		let IntS:CGFloat = CGFloat(floorf(Float(self.starValue)))
		let floatS:CGFloat = self.starValue - IntS
		for i in (0...4){
			
			let yellowStarBG:UIView = UIView()
			yellowStarBG.clipsToBounds = true
			self.addSubview(yellowStarBG)
			yellowStarBG.snp.makeConstraints { (make) in
				make.left.bottom.top.equalToSuperview()
				make.width.equalTo(floatS * h + IntS * CGFloat(i*Int(h + 5.0)))
			}
			
			let starImgY:UIImageView = UIImageView(image: UIImage(named: "icon_star_yellow_8"))
			starImgY.contentMode = .scaleAspectFit
			yellowStarBG.addSubview(starImgY)
			starImgY.snp.makeConstraints { (make) in
				make.top.equalTo(5)
				make.left.equalTo(i*Int(h + 5.0))
				make.width.height.equalTo(h)
			}

		}
	}

}
