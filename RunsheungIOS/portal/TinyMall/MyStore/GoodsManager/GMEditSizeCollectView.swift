//
//  GMEditSizeCollectView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditSizeCollectView: UIView {
	var popEditView:GMEditPopView?
	var sizeCollectView:UICollectionView?
	var data:NSMutableArray = NSMutableArray(array: [])
	var dataIndex:Int?


	@objc public var sumbitMap:(String,String)->Void = {(name:String,price:String)->Void in }
	@objc public var sumbitMap1:(String)->Void = {(name:String)->Void in }

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
	
	@objc public func getData(array:NSMutableArray,tag:Int){
		self.data = array
		self.tag = tag
		self.sizeCollectView?.reloadData()
	}
	
	@objc private func longPressDele(longpressGuesture:UILongPressGestureRecognizer){
		let alerController:UIAlertController = UIAlertController(title: "", message: "确定删除？".localized, preferredStyle: .alert)
		let cancel:UIAlertAction = UIAlertAction(title: "取消".localized, style: .cancel) { (alert) in }
		let ok:UIAlertAction = UIAlertAction(title: "确定".localized, style: .default) { [weak self](alert) in
			
			let dic:NSDictionary = self?.data.object(at: Int(longpressGuesture.allowableMovement)) as! NSDictionary
 			var delefunc:String?
			var selftag:Int32?
			var str:String?
			if self?.tag == 101 {
				delefunc = "product/DelSpce"
				selftag = 101
				str = dic.object(forKey: "item_code") as? String

			}else{
				delefunc = "product/DelFlavor"
				selftag = 102
				str = dic.object(forKey: "flavorName") as? String

			}
			
			KLHttpTool.deleGoodManagerDelSpcePricewithUri(delefunc, withgroupid: dic.object(forKey: "groupid") as! String, withdeleTag:selftag!, withspecNamePrice: str , success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let msg:String = res.object(forKey: "message") as! String
				
				if msg == "success" {
					self?.data.removeObject(at: Int(longpressGuesture.allowableMovement))
					self?.sizeCollectView?.reloadData()
				}
				
			}, failure: { (err) in
				
			})

		}
		alerController.addAction(cancel)
		alerController.addAction(ok)
		self.viewController().present(alerController, animated: true, completion: nil)
		

	}

	
}
extension GMEditSizeCollectView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (data.count + 1)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)
		for suv in cell.contentView.subviews {
			suv.removeFromSuperview()
		}
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

		if indexPath.row != (self.data.count) {
			
			let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressDele))
			longPress.allowableMovement = CGFloat(indexPath.row)
			bgView.addGestureRecognizer(longPress)
			
			let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
 			if self.tag == 101 {
				
				let specname:String = (dic.object(forKey: "specName") as! String)
				let specPrice:String = (dic.object(forKey: "specPrice") as! String)
 				let size:UILabel = UILabel()
				size.text = specname + "份".localized
				size.font = UIFont.systemFont(ofSize: 13)
				size.textAlignment = .center
				bgView.addSubview(size)
				size.snp.makeConstraints { (make) in
					make.top.equalTo(5)
					make.left.right.equalToSuperview()
					make.bottom.equalTo(bgView.snp.centerY)
				}
				
				let price:UILabel = UILabel()
				price.text = "￥" + specPrice
				price.font = UIFont.systemFont(ofSize: 13)
 				price.textAlignment = .center
				bgView.addSubview(price)
				price.snp.makeConstraints { (make) in
					make.bottom.equalTo(-5)
					make.left.right.equalToSuperview()
					make.top.equalTo(bgView.snp.centerY)
				}

			}else{
				let specname:String = (dic.object(forKey: "flavorName") as! String)
 				let size:UILabel = UILabel()
				size.text = specname
				size.textAlignment = .center
				bgView.addSubview(size)
				size.snp.makeConstraints { (make) in

					make.edges.equalToSuperview()
					
				}

			}

		}else{
			let img:UIImageView = UIImageView(image: UIImage(named: "icon_add_specifications"))
			img.contentMode = .scaleAspectFit
			img.isUserInteractionEnabled = true
			bgView.addSubview(img)
			img.snp.makeConstraints { (make) in
				make.top.left.equalTo(10)
				make.bottom.right.equalTo(-10)

			}
		}

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if indexPath.row == (self.data.count){
			self.popEditView = GMEditPopView()
			self.popEditView?.getTag(tag:self.tag)
			if self.tag == 101 {
				
				self.popEditView?.finishCompleteMap = {(name:String,price:String)->Void in
					self.sumbitMap(name,price)
					var rect:CGRect = (self.sizeCollectView?.frame)!
					let sections:Int = Int(ceil(CGFloat(self.data.count + 1)/4.0))
					rect.size.height = CGFloat(sections) * 50.0
					self.sizeCollectView?.frame = rect
					self.sizeCollectView?.reloadData()
				}

			}else{
				
            self.popEditView?.finishCompleteMap1 = {(name:String)->Void in
					self.sumbitMap1(name)
					var rect:CGRect = (self.sizeCollectView?.frame)!
					let sections:Int = Int(ceil(CGFloat(self.data.count + 1)/4.0))
					rect.size.height = CGFloat(sections) * 50.0
					self.sizeCollectView?.frame = rect
					self.sizeCollectView?.reloadData()
				}
			}
			UIApplication.shared.delegate?.window??.addSubview(self.popEditView!)
			self.popEditView?.snp.makeConstraints({ (make) in
				make.centerX.equalToSuperview()
				make.centerY.equalToSuperview().offset(-40)
 				make.width.equalTo(screenWidth - 60)
				make.height.equalTo(screenHeight/3)
			})

		}
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

