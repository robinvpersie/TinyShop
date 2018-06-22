//
//  GMEditSizeCollectView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditSizeCollectView: UIView {
	var sizeCollectView:UICollectionView?
	var data:NSArray = NSArray(array: [])
	let mapCollectionview = { (selfDelegate:UIView,width:CGFloat,height:CGFloat) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .vertical
		let collectionview = UICollectionView(frame:CGRect(x:0,y:0,width: width ,height:height), collectionViewLayout: layout)
		collectionview.layer.backgroundColor = UIColor.white.cgColor
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		collectionview.delegate = selfDelegate as? UICollectionViewDelegate
		collectionview.dataSource = selfDelegate as? UICollectionViewDataSource
		return collectionview
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.sizeCollectView = self.mapCollectionview(self,frame.size.width,frame.size.height)
		self.addSubview(self.sizeCollectView!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getData(array:NSArray){
		self.data = array
		self.sizeCollectView?.reloadData()
	}
	
	@objc private func addTap(){
		
	}
	
}
extension GMEditSizeCollectView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let dic:NSDictionary = data.object(at: indexPath.row) as! NSDictionary
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)
		
		let bgView:UIView = UIView()
		bgView.layer.cornerRadius = 3
		bgView.layer.masksToBounds = true
		bgView.layer.borderColor = UIColor(red: 201, green: 201, blue: 201).cgColor
		bgView.layer.borderWidth = 1
		cell.contentView.addSubview(bgView)
		bgView.snp.makeConstraints { (make) in
			make.top.left.equalTo(2)
			make.bottom.right.equalTo(-2)
		}

		if indexPath.row != (self.data.count-1) {

			let size:UILabel = UILabel()
			size.text = "大份"
			size.textAlignment = .center
			bgView.addSubview(size)
			size.snp.makeConstraints { (make) in
				make.top.equalTo(5)
				make.left.right.equalToSuperview()
				make.bottom.equalTo(bgView.snp.centerY)
			}
			
			let price:UILabel = UILabel()
			price.text = "$125"
			price.textAlignment = .center
			bgView.addSubview(price)
			price.snp.makeConstraints { (make) in
				make.bottom.equalTo(-5)
				make.left.right.equalToSuperview()
				make.top.equalTo(bgView.snp.centerY)
			}

		}else{
			let img:UIImageView = UIImageView(image: UIImage(named: "icon_add_specifications"))
			img.contentMode = .scaleAspectFit
			img.isUserInteractionEnabled = true
			let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addTap))
			img.addGestureRecognizer(tap)
			bgView.addSubview(img)
			img.snp.makeConstraints { (make) in
				make.top.left.equalTo(10)
				make.bottom.right.equalTo(-10)

			}
		}

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width:CGFloat = floor((self.frame.width)/4.0)
		return CGSize(width: width, height: 50.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
}

