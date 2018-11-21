//
//  BMainGridTableCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/10/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BMainGridTableCell: UITableViewCell {

	var data:NSArray!
	var collectView:UICollectionView!
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.data = []
		addSubViews()
 		loadResponse()
	}
	
	required init?(coder aDecoder: NSCoder) {
 		fatalError("init(coder:) has not been implemented")
 	}
	
	private func loadResponse(){
		let account:YCAccountModel = YCAccountModel.getAccount() ?? YCAccountModel()
		let params:Dictionary = ["custom_code":account.customCode,"token":account.combineToken,"lang_type":"chn"]
		DispatchQueue.global().async {
			Alamofire.request(Constant.swiftMallBaseUrl + "StoreCate/requestStoreCate1FavList", method:.post, parameters: params as Parameters).responseJSON { (response) in
				
				switch response.result {
				case .success:
					let value = response.result.value as? [String:AnyObject]
					self.data = value?["data"] as? NSArray
					DispatchQueue.main.async {
						self.collectView.reloadData()
					}
					break
				case .failure:
					break
					
				}
			}
		}
	}
	
	private func addSubViews(){
			
		
		let flowlayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		flowlayout.itemSize = CGSize(width: (Constant.screenWidth - 4)/3.0 , height: (screenWidth / 3.0 + 30.0) )
		flowlayout.minimumLineSpacing = 1
		flowlayout.minimumInteritemSpacing = 1
		
		collectView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
		collectView.backgroundColor = UIColor(red: 232, green: 232, blue: 232)
 		collectView.showsVerticalScrollIndicator = false
		collectView.isScrollEnabled = false
		collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reused")
		collectView.dataSource = self
		collectView.delegate = self
		collectView.showsHorizontalScrollIndicator = false
		self.contentView.addSubview(collectView)
		collectView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
}

extension BMainGridTableCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return self.data.count
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "reused", for: indexPath)
		cell.backgroundColor = UIColor.white
		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		let avator:UIImageView = UIImageView()
		avator.layer.cornerRadius = ((Constant.screenWidth - 4) / 10.0)
		avator.layer.masksToBounds = true
		cell.contentView.addSubview(avator)
		avator.snp.updateConstraints { (make) in
			make.top.equalTo((Constant.screenWidth - 4)/15.0 )
			make.centerX.equalToSuperview()
			make.height.width.equalTo((Constant.screenWidth - 4) / 5.0)
 
		}
		avator.kf.setImage(with:URL(string:dic.object(forKey: "image_url") as! String))

		let name:UILabel = UILabel()
		name.font = .systemFont(ofSize: 15)
		name.text = dic.object(forKey: "level_name") as? String
		cell.contentView.addSubview(name)
		name.snp.makeConstraints { (make) in
			
			make.centerX.equalToSuperview()
			make.top.equalTo(avator.snp.bottom).offset(6)

		}

		if indexPath.row < 3 {
			
			let star:UIImageView = UIImageView(image: UIImage(named: "icon_fullstar")?.withRenderingMode(.alwaysOriginal))
 			cell.contentView.addSubview(star)
			star.snp.updateConstraints { (make) in

				make.top.equalTo((Constant.screenWidth - 4)/15.0 )
				make.right.equalTo(-(Constant.screenWidth - 4)/15.0 )
 				make.height.width.equalTo(15)
				
			}

		}
 
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let model:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		let parcel:BMainParcelController = BMainParcelController()
		parcel.hidesBottomBarWhenPushed = true
		parcel.withMallModel(model:model)
		self.viewController()?.navigationController?.pushViewController(parcel, animated: true)
	}
	
}


