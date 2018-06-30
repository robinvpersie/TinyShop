//
//  DataStatisticCellHeadView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataStatisticCellHeadView: UIView {
	var collectView:UICollectionView?
	var iconArray:NSArray = ["icon_turnover_data","icon_order_data","icon_refund_data","icon_refund_order_data"]
	var titleArray:NSArray = ["营业额(元)".localized,"总订单(单)".localized,"退款额(元)".localized,"退款订单(单)".localized]
	var data:NSArray = ["今日".localized,"本周".localized,"本月".localized,"自定义".localized]

	let mapCollectionview = { (selfDelegate:UIView) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .horizontal
		let collectionview = UICollectionView(frame:CGRect(x:0,y:50,width: screenWidth,height:screenWidth/4), collectionViewLayout: layout)
		collectionview.layer.backgroundColor = UIColor.white.cgColor
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		collectionview.delegate = selfDelegate as? UICollectionViewDelegate
		collectionview.dataSource = selfDelegate as? UICollectionViewDataSource
		return collectionview
	}
	
	var label:(CGFloat,UIColor,String)->UILabel = {(fontSize:CGFloat,textColor:UIColor,textContent:String)->UILabel in
		let labels:UILabel = UILabel()
		labels.font = UIFont.systemFont(ofSize: fontSize)
		labels.text = textContent
		labels.textColor = textColor
		return labels

	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getTitle(text:String){
		createSuv(text: text)
	}
	
	private func createSuv(text:String){
		
		let bgview:UIView = UIView()
		bgview.backgroundColor = UIColor.white
		self.addSubview(bgview)
		bgview.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(10)
			make.bottom.equalTo(-10)
		}

		let title:UILabel = UILabel()
		title.text = text + "数据".localized
		title.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight(rawValue: 0.4))
		bgview.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.left.top.equalToSuperview().offset(15)
			make.height.equalTo(20)
		}
		
		self.collectView = self.mapCollectionview(self)
		bgview.addSubview(self.collectView!)
		self.collectView?.snp.makeConstraints({ (make) in
			make.left.bottom.right.equalToSuperview()
			make.top.equalTo(title.snp.bottom)
		})
	}
	
}

extension DataStatisticCellHeadView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)
		
		let icon:UIImageView = UIImageView(image: UIImage(named: self.iconArray.object(at: indexPath.row) as! String))
		cell.contentView.addSubview(icon)
		icon.snp.makeConstraints { (make) in
			make.width.height.equalTo(30)
			make.top.equalTo(10)
			make.centerX.equalToSuperview()
		}
		
		let money:UILabel = self.label(18.0,UIColor.black,"34")
		money.textAlignment = .center
		cell.contentView.addSubview(money)
		money.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(cell.contentView.snp.centerY).offset(5)
			make.height.equalTo(20)
		}
		
		let mark:UILabel = self.label(12.0,UIColor(red: 160, green: 160, blue: 160),self.titleArray.object(at: indexPath.row ) as! String)
		mark.textAlignment = .center
		cell.contentView.addSubview(mark)
		mark.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(-5)
			make.height.equalTo(15)
		}

		
		return cell
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width:CGFloat = screenWidth/4.0
		let height:CGFloat = screenWidth/4.0
		
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
}

