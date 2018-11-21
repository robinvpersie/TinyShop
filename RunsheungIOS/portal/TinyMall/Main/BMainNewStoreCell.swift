//
//  BMainNewStoreCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/10/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BMainNewStoreCell: UITableViewCell {
	var collectView:UICollectionView!
	let title:UILabel = UILabel()
	var data:NSArray = []
	var level1:String = ""

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
 		addSubviews()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	 func loadNewsData(url:String,level:String?){
		self.level1 = level ?? ""
		let params:NSMutableDictionary = ["lang_type":"chn"]
		if level?.count != 0 {
			title.text = "新品尝鲜"
			params.setObject(level ?? "", forKey: "level1" as NSCopying)
		}
 		DispatchQueue.global().async {
			Alamofire.request( Constant.swiftMallBaseUrl + url, method:.post, parameters: params as? Parameters).responseJSON { (response) in
				
				switch response.result {
				case .success:
					let value = response.result.value as? [String:AnyObject]
					if level?.count != 0 {
						self.data = (value?["data"]?["PopularBanner"] as? NSArray)!
					}else{
						self.data = (value?["data"]?["NewStore"] as? NSArray)!

					}

					DispatchQueue.main.async {
						self.collectView?.reloadData()
					}
					break
				case .failure:
					break
					
				}
			}
		}
	}
	private func addSubviews(){
		
		title.text = "新店入驻"
		title.font = .systemFont(ofSize: 15)
		self.contentView.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(10)
			make.top.equalToSuperview().offset(10)
		}
		
		let logo:UIImageView = UIImageView()
		logo.image = UIImage(named: "icon_new_shop")?.withRenderingMode(.alwaysOriginal)
		self.contentView.addSubview(logo)
		logo.snp.makeConstraints { (make) in
			make.left.equalTo(title.snp.right).offset(6)
			make.centerY.equalTo(title.snp.centerY)
			make.height.equalTo(13)
		}

 
		let flowlayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		flowlayout.itemSize = CGSize(width: 2.0 * Constant.screenWidth / 5.0, height: screenWidth / 2.0)
		flowlayout.minimumLineSpacing = 2
		flowlayout.minimumInteritemSpacing = 2
		flowlayout.scrollDirection = .horizontal
		
		collectView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
		collectView.backgroundColor =  UIColor.white
		collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reused")
		collectView.dataSource = self
		collectView.delegate = self
		collectView.showsHorizontalScrollIndicator = false
		self.contentView.addSubview(collectView)
		collectView.snp.makeConstraints({ (make) in
			make.left.equalTo(10)
 			make.right.bottom.equalToSuperview()
 			make.height.equalTo(screenWidth / 2.0)
		})
		
		
	}
	
}

extension BMainNewStoreCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reused", for: indexPath)
		for view in cell.contentView.subviews {
			view.removeFromSuperview()
		}
 		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		let logo:UIImageView = UIImageView()
		cell.contentView.addSubview(logo)
		logo.snp.makeConstraints { (make) in
			make.top.left.equalTo(8)
			make.right.equalTo(-2)
			make.height.equalTo(screenWidth / 2.0 - 90.0)
 		}
		
		if self.level1.count == 0 {
			logo.kf.setImage(with:URL(string:dic.object(forKey: "SHOP_THUMNAIL_IMAGE") as! String)!)
		}else{
			logo.kf.setImage(with:URL(string:dic.object(forKey: "ad_image") as! String)!)
 		}

 		let title:UILabel = UILabel()
		title.text = dic.object(forKey: "CUSTOM_NAME") as? String
		title.font = UIFont.systemFont(ofSize: 15)
		cell.contentView.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.left.equalTo(logo.snp.left)
			make.top.equalTo(logo.snp.bottom).offset(15)
			make.right.equalTo(logo.snp.right)
			make.height.equalTo(15)
 
		}
		
		let address:UILabel = UILabel()
		address.numberOfLines = 0
		address.text = dic.object(forKey: "SHOP_INFO") as? String
		address.font = UIFont.systemFont(ofSize: 12)
		address.textColor = UIColor(red: 222, green: 222, blue: 222)
		cell.contentView.addSubview(address)
		address.snp.makeConstraints { (make) in
			make.left.equalTo(logo.snp.left)
			make.top.equalTo(title.snp.bottom)
			make.right.equalTo(logo.snp.right)
			make.height.equalTo(30)
 		}
		
		return cell
	}
	
	
	
}
