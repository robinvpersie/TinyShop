//
//  GMEditBaseInfoView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditBaseInfoView: UIView {
	let avator:UIImageView = UIImageView()
	var inputNameField:UITextField?
	var choiceView:GMEditChoiceCateView?
	var imageurl:String?
 	var finishBaseData:(String,String,String) -> Void = {(imageurl:String,name:String,categoryname:String) in }
 	let titleLabel:(String)->UILabel = {(titles:String)->UILabel in
		
		let label:UILabel = UILabel()
		label.text = titles
		label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 1.0))
		return label
	}

	let inputName:(String) -> UITextField = {(text:String) -> UITextField in
		let input:UITextField = UITextField()
		input.text = text
		input.textColor = UIColor(red: 141, green: 141, blue: 141)
		input.borderStyle = .roundedRect
		return input
		
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		createSuvs()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension GMEditBaseInfoView:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		self.finishBaseData(self.imageurl!,(self.inputNameField?.text)!,(self.choiceView?.choicebtn.level_id)!)
		return true
	}
	
	@objc private func changAvatorFunc(){
		let alert:UIAlertController = UIAlertController(title: "", message: "修改头像图片".localized, preferredStyle: .actionSheet)
		let action = UIAlertAction(title:"相册".localized, style: .default) {[weak self](action)in
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
				
				let picker = UIImagePickerController()
				picker.delegate = self
				picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
				picker.allowsEditing = true
				self?.viewController().present(picker, animated:true, completion: {() -> Void in })
			}
		}
		let action1 = UIAlertAction(title:"照相".localized, style: .default) { [weak self](action)in
			if UIImagePickerController.isSourceTypeAvailable(.camera){
				
				let picker = UIImagePickerController()
				picker.delegate = self
				picker.sourceType = UIImagePickerControllerSourceType.camera
				picker.allowsEditing = true
				self?.viewController().present(picker, animated:true, completion: { () -> Void in })
				
			}
		}
		let action2 = UIAlertAction(title:"取消".localized, style: .cancel, handler:nil)
		alert.addAction(action)
		alert.addAction(action1)
		alert.addAction(action2)
		self.viewController().present(alert, animated:true, completion: nil)
	}
	
	@objc public func getBaseData(dic:NSDictionary,currentLevelDic:NSArray){
		self.imageurl =  dic.object(forKey: "Image_url") as? String
  		self.avator.setImageWith(NSURL(string: dic.object(forKey: "Image_url") as! String)! as URL)
		self.inputNameField?.text = dic.object(forKey: "ITEM_NAME") as? String
 		self.choiceView?.getData(data:currentLevelDic)
	}

	private func createSuvs(){
		self.backgroundColor = UIColor.white
		let basetitle:UILabel = self.titleLabel("基本信息".localized)
		self.addSubview(basetitle)
		basetitle.snp.makeConstraints { (make) in
			make.left.top.equalTo(20)
			make.height.equalTo(30)
		}
		

		self.addSubview(self.avator)
		self.avator.isUserInteractionEnabled = true
		self.avator.layer.cornerRadius = 5
		self.avator.layer.masksToBounds = true
		self.avator.layer.borderWidth = 1
		self.avator.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
		let changAvator:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changAvatorFunc))
		self.avator.addGestureRecognizer(changAvator)
		self.avator.snp.makeConstraints { (make) in
			make.width.height.equalTo(90)
			make.left.equalTo(20)
			make.top.equalTo(basetitle.snp.bottom).offset(20)
		}
		
		let correct:UILabel = UILabel()
		correct.backgroundColor = UIColor.black
		correct.alpha = 0.3
		correct.textColor = UIColor.white
		correct.text = "更换图片".localized
		correct.textAlignment = .center
		correct.font = UIFont.systemFont(ofSize: 13)
		self.avator.addSubview(correct)
		correct.snp.makeConstraints { (make) in
			make.bottom.left.right.equalToSuperview()
			make.height.equalTo(25)
		}
		
		self.inputNameField = self.inputName("Chizza烤薯条餐S")
		self.inputNameField?.delegate = self as UITextFieldDelegate
		self.addSubview(self.inputNameField!)
		self.inputNameField?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.avator.snp.top)
			make.height.equalTo(50)
			make.left.equalTo(self.avator.snp.right).offset(15)
			make.right.equalTo(-20)
		})
		
		self.choiceView = GMEditChoiceCateView()
		self.choiceView?.choicebtn.choiceMap = {(_:NSDictionary,_:Int,_:Int) in
			self.finishBaseData(self.imageurl!,(self.inputNameField?.text)!,(self.choiceView?.choicebtn.level_id)!)

		}
		self.addSubview(self.choiceView!)
		self.choiceView?.snp.makeConstraints({ (make) in
			make.height.equalTo(50)
			make.left.equalTo((self.inputNameField?.snp.left)!)
			make.right.equalTo((self.inputNameField?.snp.right)!)
			make.top.equalTo((self.inputNameField?.snp.bottom)!).offset(15)
		})
		
		
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
					self.imageurl = "http://gigaMerchantManager.gigawon.co.kr:8825/" + (imageurls.firstObject as! String)
					self.finishBaseData(self.imageurl!,(self.inputNameField?.text)!,(self.choiceView?.choicebtn.level_id)!)

				}

			}, failure: { (error) in
				
			})
			

		})
		
	}
	
}


