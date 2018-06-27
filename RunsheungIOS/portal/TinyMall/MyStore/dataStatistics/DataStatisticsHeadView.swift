//
//  DataStatisticsHeadView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataStatisticsHeadView: UIView {
	
	var bottomline:UILabel?
	var collectView:UICollectionView?
	var data:NSArray = []
	var pressBtnArray:NSMutableArray = NSMutableArray()
  	var clickHeadIndexMap:(Int)->Void = {(index:Int)->Void in }
	var newBadgeCircle:UILabel?
	
	let badageCircle:(String) -> UILabel = {(text:String) -> UILabel in
		
		let badage:UILabel = UILabel()
		badage.textAlignment = .center
		badage.textColor = UIColor.white
		badage.layer.cornerRadius = 7
		badage.layer.masksToBounds = true
		badage.text = text
		badage.font = UIFont.systemFont(ofSize: 12)
		badage.backgroundColor = UIColor(red: 222, green: 0, blue: 0)
		return badage
	}
	
	var button:(CGFloat,UIColor,String,UIColor)->UIButton = {(fontSize:CGFloat,textColor:UIColor,textContent:String,bgColor:UIColor)->UIButton in
		let btn:UIButton = UIButton()
		btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
		btn.backgroundColor = bgColor
		btn.setTitle(textContent, for: .normal)
		btn.setTitleColor(textColor, for: .normal)
		btn.layer.cornerRadius = 3
		btn.layer.masksToBounds = true
		
		return btn
	}
	
	
	let mapCollectionview = { (selfDelegate:UIView) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .vertical
		let collectionview = UICollectionView(frame:CGRect(x:0,y:0,width: screenWidth,height:48), collectionViewLayout: layout)
		collectionview.layer.backgroundColor = UIColor.white.cgColor
		collectionview.isScrollEnabled = false
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		collectionview.delegate = selfDelegate as? UICollectionViewDelegate
		collectionview.dataSource = selfDelegate as? UICollectionViewDataSource
		return collectionview
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		self.layer.borderWidth = 1.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getTitles(array:NSArray){
		self.data = array
		createSuvs()

	}
	
	private func createSuvs(){
		self.collectView = self.mapCollectionview(self)
		self.addSubview(self.collectView!)
		
		self.bottomline = UILabel()
		self.bottomline?.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		self.addSubview(self.bottomline!)
		let singleWidth:Int = Int(screenWidth) / self.data.count
		self.bottomline?.snp.makeConstraints({ (make) in
			make.height.equalTo(2)
			make.width.equalTo(60)
			make.left.equalTo((singleWidth-60)/2)
			make.bottom.equalToSuperview()
		})
		
	}

}

extension DataStatisticsHeadView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)

		let text:String = (self.data.object(at: indexPath.row) as? String)!
		let pressbtn:UIButton = self.button(15.0, UIColor(red: 33, green: 192, blue: 67),text,UIColor.white)
		pressbtn.addTarget(self, action: #selector(pressbtnIndex), for: .touchUpInside)
		pressbtn.setTitleColor(UIColor(red: 33, green: 192, blue: 67), for: .selected)
		pressbtn.setTitleColor(UIColor(red: 45, green: 45, blue: 45), for: .normal)
		pressbtn.tag = indexPath.row
		cell.contentView.addSubview(pressbtn)
		pressbtn.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		if indexPath.row == 0 {
			pressbtn.isSelected = true
		}
		
		self.pressBtnArray.add(pressbtn)
		if indexPath.row == 0 {
			
			let titlestr:NSString = self.data[indexPath.row] as! NSString
			let textMaxSize = CGSize(width:CGFloat(MAXFLOAT) , height: 25.0)
			let size:CGSize = self.textSize(text: titlestr as String, font: UIFont.systemFont(ofSize: 15.0), maxSize: textMaxSize)
 			self.newBadgeCircle = self.badageCircle("2")
			self.newBadgeCircle?.isHidden = false
			pressbtn.addSubview(self.newBadgeCircle!)
			self.newBadgeCircle?.snp.makeConstraints({ (make) in
				make.top.equalToSuperview().offset(8)
				make.width.height.equalTo(14)
				make.left.equalTo(pressbtn.snp.centerX).offset((size.width / 2.0) - 5.0)
			})
 		}

		return cell
	}
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	}
	@objc public func transferIndex(index:Int){
		for btn in self.pressBtnArray {
			let button:UIButton = (btn as? UIButton)!
			button.isSelected = false
		}
		let sender:UIButton = self.pressBtnArray.object(at: index) as! UIButton
		sender.isSelected = true
		let singleWidth:Int = (Int(screenWidth) / self.data.count)*Int(sender.tag)
		
		UIView.animate(withDuration: 0.3) {
			self.bottomline?.transform = CGAffineTransform(translationX:CGFloat(singleWidth), y: 0)
			
		}
//		self.clickHeadIndexMap(sender.tag)
		
	}

	
	@objc private func pressbtnIndex(sender:UIButton){
		for btn in self.pressBtnArray {
			let button:UIButton = (btn as? UIButton)!
			button.isSelected = false
		}
		self.newBadgeCircle?.isHidden = true
		sender.isSelected = true
		let singleWidth:Int = (Int(screenWidth) / self.data.count)*Int(sender.tag)

		UIView.animate(withDuration: 0.3) {
			self.bottomline?.transform = CGAffineTransform(translationX:CGFloat(singleWidth), y: 0)
			
		}
		self.clickHeadIndexMap(sender.tag)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width:CGFloat = floor((screenWidth)/CGFloat(self.data.count))
		return CGSize(width: width, height: 50.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
}
