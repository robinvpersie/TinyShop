//
//  ShopNameChangeViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/7/5.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopNameChangeController: MyStoreBaseViewController {
	var tableview:UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
 		self.view.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		addTableView()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
	private func addTableView(){
		
 		self.tableview.dataSource = self
		self.tableview.delegate = self
		self.tableview.estimatedRowHeight = 0
		self.tableview.tableFooterView = UIView()
		self.tableview.estimatedSectionFooterHeight = 0
		self.tableview.estimatedSectionHeaderHeight = 0
		self.tableview.separatorColor = UIColor.white
		self.tableview.backgroundColor =  UIColor(red: 242, green: 244, blue: 246)
 		self.view.addSubview(self.tableview)
		
		self.tableview.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
}

extension ShopNameChangeController:UITableViewDelegate,UITableViewDataSource{
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 5
	}
	
}
