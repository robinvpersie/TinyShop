//
//  BMainHeadPicView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/10/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import FSPagerView
import Alamofire
import SwiftyJSON

class BMainHeadPicView: UIView {

	var pagerView:FSPagerView!
	var images:NSArray = []
	override init(frame: CGRect) {
		super.init(frame: frame)
		images = NSArray()
		addSubViews()
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func addSubViews() {
		guard pagerView == nil else {
			return
		}
		pagerView = FSPagerView(frame: .zero)
		pagerView.dataSource = self
		pagerView.delegate = self
		pagerView.automaticSlidingInterval = 4
		pagerView.isInfinite = true
		pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "fscell")
		self.addSubview(pagerView)
		pagerView.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
		})
  	}
}

extension BMainHeadPicView:FSPagerViewDelegate,FSPagerViewDataSource {
	
	func reloadBannerData(url:String,level:String?){
		
		let params:NSMutableDictionary = ["lang_type":"语言".localized]
		if level?.count != 0 {
			params.setObject(level ?? "", forKey: "level1" as NSCopying)
 		}
 
		DispatchQueue.global().async {
			Alamofire.request( Constant.swiftMallBaseUrl + url, method:.post, parameters: params as? Parameters).responseJSON { (response) in
				
				switch response.result {
				case .success:
					let value = response.result.value as? [String:AnyObject]
					self.images = (value?["data"]?["TopBanner"] as? NSArray)!
					DispatchQueue.main.async {
						self.pagerView.reloadData()
					}
					break
				case .failure:
					break
					
				}
			}
		}

		pagerView.reloadData()
	}
	
	func numberOfItems(in pagerView: FSPagerView) -> Int {
		return images.count
	}
	
	func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
		let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "fscell", at: index)
		let dic:NSDictionary = images[index] as! NSDictionary
		cell.imageView?.kf.setImage(with: URL(string: dic.object(forKey: "ad_image") as! String))
		cell.textLabel?.text = String(index + 1) + "/" + String(images.count )
		return cell
	}


}
