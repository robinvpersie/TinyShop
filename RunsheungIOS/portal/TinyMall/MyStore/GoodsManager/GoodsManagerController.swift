//
//  GoodsManagerController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GoodsManagerController: MyStoreBaseViewController {
	
	public var segmentGood:GoodsManagerView?
	var rightbtn:GMcatagoryButton?
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.rightbtn?.hidePopTableView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		createSegmentGood()
		self.setNavi()
		
	}
	override func setNavi() {
		super.setNavi()
		self.navigationItem.title = "商品管理"
		
		
		rightbtn = GMcatagoryButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
		let status:CGRect = UIApplication.shared.statusBarFrame
		let navi:CGRect = (self.navigationController?.navigationBar.frame)!
		rightbtn?.getPopViewOrgY(y: status.height + navi.height)
		let rightItem:UIBarButtonItem = UIBarButtonItem(customView: rightbtn!)
		self.navigationItem.rightBarButtonItem = rightItem
	}
	
	
	
	
}

extension GoodsManagerController{
	
	private func createSegmentGood(){
		
		self.segmentGood = GoodsManagerView()

		self.view.addSubview(self.segmentGood!)
		self.segmentGood?.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
		})
		
	}

	@objc private func rightAction(){
		
	
	}
}
