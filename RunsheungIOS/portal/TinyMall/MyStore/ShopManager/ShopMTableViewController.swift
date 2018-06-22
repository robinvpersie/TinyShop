//
//  ShopMTableViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopMTableViewController: UITableViewController {
	var data:NSArray = ["店铺头像","店铺名称","客服电话","店铺地址"]
	var contents:NSArray = ["","KFC(九龙城店)","66666-99999","威海市经济开发区大庆路"]

    override func viewDidLoad() {
        super.viewDidLoad()
		setNavi()
    }
	
	public func setNavi(){
		
		self.tableView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.tableView.contentInset = UIEdgeInsetsMake(10, 0, -10, 0)
		self.tableView.tableFooterView = UIView()
		self.title = "店铺管理"
		let backItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .plain, target: self, action: #selector(back))
		self.navigationItem.leftBarButtonItem = backItem
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationController?.navigationBar.tintColor = UIColor.black
		
		
	}
	
	@objc private func back(){
		self.navigationController?.popViewController(animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
 }

extension ShopMTableViewController{
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = self.data.object(at: indexPath.row) as? String
		cell.accessoryType = .disclosureIndicator
		cell.selectionStyle = .none
		
		switch indexPath.row {
		case 0:
			do {
				
				let avator:UIImageView = UIImageView(image: UIImage(named: "img_product_circle01"))
				cell.contentView.addSubview(avator)
				avator.snp.makeConstraints { (make) in
					make.width.height.equalTo(80)
					make.right.equalToSuperview().offset(-5)
					make.top.equalToSuperview().offset(10)
				}
			}
			
		default:
			do {
				let content:UILabel = UILabel()
				content.textAlignment = .right
				content.text = self.contents.object(at: indexPath.row) as? String
				cell.contentView.addSubview(content)
				content.snp.makeConstraints { (make) in
					make.bottom.top.equalToSuperview()
					make.right.equalToSuperview().offset(-5)
					make.left.equalToSuperview().offset(80)
				}
			}
		}

		return cell
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return 100.0
		default:
			return 44.0
		}
	}
	
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}

}
