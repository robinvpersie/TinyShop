//
//  GoodsTableViewCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {

	@IBOutlet weak var headavator: UIImageView!
	@IBOutlet weak var productName: UILabel!
	@IBOutlet weak var saleCount: UILabel!
	@IBOutlet weak var price: UILabel!
	
	@IBOutlet weak var reEidt: UIButton!
	@IBOutlet weak var downProduct: UIButton!
	var dic:NSDictionary?
	@objc public func getDic(dic:NSDictionary){
		self.dic = dic
		self.headavator.setImageWith(NSURL.init(string: self.dic?.object(forKey: "image_url") as! String)! as URL)
		self.productName.text = self.dic?.object(forKey: "item_name") as? String
		let salecount:String = (self.dic?.object(forKey: "MonthSaleCount") as? String)!
		self.saleCount.text = "月售 " + salecount
		self.price.text = self.dic?.object(forKey: "item_p") as? String
	
	}
	override func awakeFromNib() {
        super.awakeFromNib()
		self.reEidt.layer.cornerRadius = 3
		self.reEidt.layer.masksToBounds = true
		self.reEidt.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		self.reEidt.layer.borderWidth = 1
		
		self.downProduct.layer.cornerRadius = 3
		self.downProduct.layer.masksToBounds = true
		self.downProduct.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		self.downProduct.layer.borderWidth = 1
		
		self.headavator.layer.cornerRadius = 5
		self.headavator.layer.masksToBounds = true

    }
	@IBAction func downProductFunc(_ sender: UIButton) {
		
		let alerController:UIAlertController = UIAlertController(title: "", message: "确定下架此商品？", preferredStyle: .alert)
		let cancel:UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { (alert) in }
		let ok:UIAlertAction = UIAlertAction(title: "确定", style: .default) { (alert) in }
		alerController.addAction(cancel)
		alerController.addAction(ok)
		self.viewController().present(alerController, animated: true, completion: nil)
		
	}
	
	@IBAction func reEditionFunc(_ sender: UIButton) {
	
		let newEdit:MyNewEditViewController = MyNewEditViewController()
		newEdit.title = "重新编辑"
		self.viewController().navigationController?.pushViewController(newEdit, animated: true)
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
