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
	var selftag:Int = 0
	var downProductMap:(Int)->Void = {(index:Int)->Void in }
	var editCellfinshRefreshMap:( )->Void = {( )->Void in }

	var dic:NSDictionary?
	@objc public func getDic(dic:NSDictionary,tag:Int){
		self.dic = dic
		self.selftag = tag
		if selftag == 0 {
			self.downProduct.setTitle("产品上架".localized, for: .normal)
			selftag = 1
		}else{
			selftag = 0
		}
	
		self.headavator.setImageWith(NSURL.init(string: self.dic?.object(forKey: "image_url") as! String)! as URL)
		self.productName.text = self.dic?.object(forKey: "item_name") as? String
		let salecount:String = (self.dic?.object(forKey: "MonthSaleCount") as? String)!
		let itemprice:String = (self.dic?.object(forKey: "item_p") as? String)!
 		self.saleCount.text = "月售 ".localized + salecount
		self.price.text = "￥" + itemprice
		self.reEidt.setTitle("重新编辑".localized, for: .normal)
		self.downProduct.setTitle("下架商品".localized, for: .normal)

	
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
        self.headavator.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		self.headavator.layer.borderWidth = 1.0
    }
	@IBAction func downProductFunc(_ sender: UIButton) {
		
		let alerController:UIAlertController = UIAlertController(title: "", message:(selftag == 0 ? "确定下架此商品？".localized:"确定上架此商品？".localized), preferredStyle: .alert)
		let cancel:UIAlertAction = UIAlertAction(title: "取消".localized, style: .cancel) { (alert) in }
		
		let ok:UIAlertAction = UIAlertAction(title: "确定".localized, style: .default) { (alert) in
			let groupid:String = self.dic?.object(forKey: "GroupId") as! String
			
			KLHttpTool.setGoodManagerDelFlavorwithUri("product/setProductsellstate", withselling: String(self.selftag ), withgroupid: groupid, success: { (response) in
			
				let res:NSDictionary = (response as? NSDictionary)!
				let anum:String = self.dic!.object(forKey: "ANum") as! String
				let status:Int = (res.object(forKey: "status") as! Int)
				if status == 1 {
					self.downProductMap(Int(anum)!)
				}
				
			}, failure: { (error) in
				
			})
		}
		alerController.addAction(cancel)
		alerController.addAction(ok)
		self.viewController().present(alerController, animated: true, completion: nil)
		
	}
	
	@IBAction func reEditionFunc(_ sender: UIButton) {
	
		let newEdit:MyNewEditViewController = MyNewEditViewController()
		newEdit.getData(dic:self.dic!)
		newEdit.editfinshRefreshMap = {()->Void in
			self.editCellfinshRefreshMap()
		}
 		self.viewController().navigationController?.pushViewController(newEdit, animated: true)
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
