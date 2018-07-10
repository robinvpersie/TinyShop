//
//  ShopMTableViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopMTableViewController: UITableViewController {
	var data:NSArray = ["店铺头像".localized,"店铺名称".localized,"客服电话".localized,"店铺地址".localized]
	var contents:NSMutableArray = [""," "," "," "]
	var infoDic:NSDictionary?
	let avator:UIImageView = UIImageView()
	var changeHeadAvatorMap:(String)->Void = {(imageurl:String)->Void in}

	var mallAvator:String?
	var mallName:String?
	var mallPhone:String?
	var mallAddress:String?

    override func viewDidLoad() {
        super.viewDidLoad()
 		requestData()
 		setNavi()
    }
	
	private func requestData(){
		KLHttpTool.requestSaleOrderAmountwithUri("/api/AppSM/requestSaleOrderAmount", success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:String = res.object(forKey: "status") as! String
			if status == "1" {
				
				self.mallAvator = res.object(forKey: "shop_thumnail_image") as? String
				self.mallName = res.object(forKey: "custom_name") as? String
				self.mallPhone = res.object(forKey: "telephon") as? String
				self.mallAddress = res.object(forKey: "address") as? String
				self.contents = [self.mallAvator ,self.mallName ,self.mallPhone ,self.mallAddress]
				self.tableView.reloadData()
			}
		}) { (error) in
			
		}
	}

	public func setNavi(){
		
		self.tableView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.tableView.contentInset = UIEdgeInsetsMake(10, 0, -10, 0)
		self.tableView.tableFooterView = UIView()
		self.title = "店铺信息".localized
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

extension ShopMTableViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
	
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
				
 				avator.layer.cornerRadius = 5
				avator.layer.masksToBounds = true
				avator.setImageWith(NSURL(string: self.contents.firstObject as! String)! as URL)
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
				content.font = UIFont.systemFont(ofSize: 14.0)
 				content.text = self.contents.object(at: indexPath.row) as? String
				cell.contentView.addSubview(content)
				content.snp.makeConstraints { (make) in
					make.bottom.top.equalToSuperview()
					make.right.equalToSuperview().offset(-5)
					make.left.equalToSuperview().offset(100)
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
		if indexPath.row == 0 {
			let alert:UIAlertController = UIAlertController(title: "", message: "选择图片来源".localized, preferredStyle: .actionSheet)
			let action = UIAlertAction(title:"相册".localized, style: .default) {[weak self](action)in
				if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
					
					let picker = UIImagePickerController()
					picker.delegate = self
					picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
					picker.allowsEditing = true
					self?.present(picker, animated:true, completion: {() -> Void in })
					
				}
			}
			let action1 = UIAlertAction(title:"照相".localized, style: .default) { [weak self](action)in
				if UIImagePickerController.isSourceTypeAvailable(.camera){
					
					let picker = UIImagePickerController()
					picker.delegate = self
					picker.sourceType = UIImagePickerControllerSourceType.camera
					picker.allowsEditing = true
					self?.present(picker, animated:true, completion: { () -> Void in })
					
				}
			}
			let action2 = UIAlertAction(title:"取消".localized, style: .cancel, handler:nil)
			alert.addAction(action)
			alert.addAction(action1)
			alert.addAction(action2)
			self.present(alert, animated:true, completion: nil)
		}else{
			if indexPath.row == 1 {
				clickInputBtn(type: "修改名字".localized,flag:indexPath.row)
 			}else if indexPath.row == 2 {
				clickInputBtn(type: "修改联系方式".localized,flag:indexPath.row)
			}else{
				let vc:ShopNameChangeController = ShopNameChangeController()
				vc.title = self.data.object(at: indexPath.row) as? String
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	//弹出带有输入框的提示框
	private func clickInputBtn(type:String,flag:Int) {
 		var inputText:UITextField = UITextField();
		let msgAlertCtr = UIAlertController.init(title:nil, message: type, preferredStyle: .alert)
		let ok = UIAlertAction.init(title: "确定".localized, style:.default) { (action:UIAlertAction) ->() in
			for textFields in msgAlertCtr.textFields! {
				if flag == 1{
 					self.mallName = textFields.text
					self.contents.replaceObject(at: 1, with:self.mallName ?? " ")
  				}else {
 					self.mallPhone = textFields.text
					self.contents.replaceObject(at: 2, with:self.mallPhone ?? " ")
  				}
				self.tableView.reloadData()
  			}
		
 			KLHttpTool.requestStoreImageUpdatewithUri("/api/AppSM/requestStoreImageUpdate", withStoreImageurl: self.mallAvator, withCustomName: self.mallName, withTelephon: self.mallPhone, withZipcode: "12344", withKoraddr: self.mallAddress, withkoraddrDetail: self.mallAddress, success: { (response) in
					let res:NSDictionary = (response as? NSDictionary)!
					let status:String = (res.object(forKey: "status") as! String)
					if status == "1" {
						self.changeHeadAvatorMap(self.mallAvator!)
					}
 				}, failure: { (error) in
 				})
		}
		
		let cancel = UIAlertAction.init(title: "取消".localized, style:.cancel) { (action:UIAlertAction) -> ()in
			print("取消输入")
		}
		
		msgAlertCtr.addAction(ok)
		msgAlertCtr.addAction(cancel)
 		msgAlertCtr.addTextField { (textField) in
 			inputText = textField
			if flag == 1{
 				inputText.placeholder = "输入商铺名称"
				
 			}else {
 				inputText.placeholder = "输入商铺电话"
			}
		}
 		self.present(msgAlertCtr, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = info[UIImagePickerControllerEditedImage] as! UIImage
		picker.dismiss(animated: true, completion: { () -> Void in
			self.avator.image = image
			KLHttpTool.sendGoodLogoPicture(withUrl: "fileUp/postFile", with: image, success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let status:Int = (res.object(forKey: "status") as! Int)
				if status == 1 {
					let imageurls:NSArray = res.object(forKey: "data") as! NSArray
					self.mallAvator = "http://gigaMerchantManager.gigawon.co.kr:8825/" + (imageurls.firstObject as! String)
					KLHttpTool.requestStoreImageUpdatewithUri("/api/AppSM/requestStoreImageUpdate", withStoreImageurl: self.mallAvator, withCustomName: self.mallName, withTelephon: self.mallPhone, withZipcode: "12344", withKoraddr: self.mallAddress, withkoraddrDetail: self.mallAddress, success: { (response) in
						let res:NSDictionary = (response as? NSDictionary)!
						let status:String = (res.object(forKey: "status") as! String)
						if status == "1" {
							self.changeHeadAvatorMap(self.mallAvator!)
						}

					}, failure: { (error) in
						
					})
					
//					KLHttpTool.requestStoreImageUpdatewithUri("/api/AppSM/requestStoreImageUpdate", withStoreImageurl: imagestr, success: { (response) in
//						let res:NSDictionary = (response as? NSDictionary)!
//						let status:String = (res.object(forKey: "status") as! String)
//						if status == "1" {
//							self.changeHeadAvatorMap(imagestr)
// 						}
//					}, failure: { (error) in
					
//					})
				}
				
			}, failure: { (error) in
				
			})
			
			
		})
		
	}
 }
