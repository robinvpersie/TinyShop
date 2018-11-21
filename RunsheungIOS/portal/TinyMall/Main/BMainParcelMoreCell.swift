//
//  BMainParcelMoreCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/11/1.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BMainParcelMoreCell: UITableViewCell {
	private var collectView:UICollectionView!
	private let title:UILabel = UILabel()
	private var data:NSArray = []
	var level1:String = ""
	var finishReloadData:((Int) -> Void)!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviews()
		loadResponse()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func loadResponse(){
		let params:Dictionary = ["level1":"1", "latitude": "37.434668","longitude": "122.160742","lang_type":"kor"]
		DispatchQueue.global().async {
			Alamofire.request(Constant.swiftMallBaseUrl + "StoreCate/requestCateNewStoreList", method:.post, parameters: params as Parameters).responseJSON { (response) in
				
				switch response.result {
				case .success:
					let value = response.result.value as? [String:AnyObject]
					self.data = (value?["data"]?["NewStore"] as? NSArray)!
					DispatchQueue.main.async {
						guard self.finishReloadData != nil else {
							return;
						}
						self.finishReloadData(self.data.count)
						
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

		let flowlayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		flowlayout.itemSize = CGSize(width: Constant.screenWidth , height: screenWidth / 2.0)
		flowlayout.minimumLineSpacing = 0
		flowlayout.minimumInteritemSpacing = 0
		flowlayout.scrollDirection = .vertical
 
		collectView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
  		collectView.register(BMainParcelMoreColCell.self, forCellWithReuseIdentifier: "reused")
		collectView.dataSource = self
		collectView.delegate = self
		collectView.backgroundColor = UIColor.white
		collectView.showsHorizontalScrollIndicator = false
		collectView.isScrollEnabled = false
		self.contentView.addSubview(collectView)
		collectView.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
		})
		
		
	}
	
}

extension BMainParcelMoreCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:BMainParcelMoreColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "reused", for: indexPath) as! BMainParcelMoreColCell
		cell.withData(dic: self.data.object(at: indexPath.row) as! NSDictionary)
		return cell
	}
	
	
	
}
