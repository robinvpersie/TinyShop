//
//  OrderManagerViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class OrderManagerViewController: MyStoreBaseViewController {
	var mainView:OrderSegmentView?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "订单管理"
		self.mainView = OrderSegmentView()
		self.view.addSubview(self.mainView!)
		self.mainView?.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
			
		})

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	private func createTableView(){
	}


}

