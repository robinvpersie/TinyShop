//
//  MyStoreBaseViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class MyStoreBaseViewController: UIViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setNavi()

	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.white

		
	}

	public func setNavi(){
		
		let backItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .plain, target: self, action: #selector(back))
		self.navigationItem.leftBarButtonItem = backItem
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationController?.navigationBar.tintColor = UIColor.black
		
		
	}
	
	@objc private func back(){
		self.navigationController?.popViewController(animated: true)
	}
}
