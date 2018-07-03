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
	var contents:NSArray = [""," "," "," "]
	var infoDic:NSDictionary?
	let avator:UIImageView = UIImageView()


    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.infoDic = UserDefaults.standard.object(forKey: "mystoreinfo") as? NSDictionary
		let avatarurl:String = self.infoDic?.object(forKey: "shop_thumnail_image") as! String
		let name:String = self.infoDic?.object(forKey: "custom_name") as! String
 		let phone:String = self.infoDic?.object(forKey: "telephon") as! String
		let address:String = self.infoDic?.object(forKey: "address") as! String
 		self.contents = [avatarurl,name,phone,address]
		self.tableView.reloadData()
 		setNavi()
    }
	
	public func setNavi(){
		
		self.tableView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.tableView.contentInset = UIEdgeInsetsMake(10, 0, -10, 0)
		self.tableView.tableFooterView = UIView()
		self.title = "店铺管理".localized
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
		if indexPath.row == 0 {
			let alert:UIAlertController = UIAlertController(title: "", message: "选择图片来源".localized, preferredStyle: .actionSheet)
			let action = UIAlertAction(title:"相册".localized, style: .default) {[weak self](action)in
				self?.openAlbumCamera()
			}
			let action1 = UIAlertAction(title:"照相".localized, style: .default) { [weak self](action)in
				self?.openAlbumCamera()
			}
			let action2 = UIAlertAction(title:"取消".localized, style: .cancel, handler:nil)
			alert.addAction(action)
			alert.addAction(action1)
			alert.addAction(action2)
			self.present(alert, animated:true, completion: nil)
		}
	}
	
	private func openAlbumCamera(){
		
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
			
			let picker = UIImagePickerController()
			picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
			picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
			picker.allowsEditing = true
			
			self.present(picker, animated:true, completion: {() -> Void in
				
			})
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			
			let picker = UIImagePickerController()
			picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
			picker.sourceType = UIImagePickerControllerSourceType.camera
			picker.allowsEditing = true
			self.present(picker, animated:true, completion: { () -> Void in })
			
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = info[UIImagePickerControllerEditedImage] as! UIImage
		picker.dismiss(animated: true, completion: { () -> Void in
			self.avator.image = image
			KLHttpTool.sendGoodLogoPicture(withUrl: "fileUp/postFile", with: image, success: { (response) in
				let res:NSDictionary = (response as? NSDictionary)!
				let status:Int = (res.object(forKey: "status") as! Int)
				if status == 1 {
//					let imageurls:NSArray = res.object(forKey: "data") as! NSArray
//					self.imageurl = "http://gigaMerchantManager.gigawon.co.kr:8825/" + (imageurls.firstObject as! String)
//					self.finishBaseData(self.imageurl!,(self.inputNameField?.text)!,(self.choiceView?.choicebtn.level_id)!)
					
				}
				
			}, failure: { (error) in
				
			})
			
			
		})
		
	}

}
