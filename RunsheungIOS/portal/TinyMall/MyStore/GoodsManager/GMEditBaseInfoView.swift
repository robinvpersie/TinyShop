//
//  GMEditBaseInfoView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GMEditBaseInfoView: UIView {
	let avator:UIImageView = UIImageView(image: UIImage(named: "256252.jpg") )
	var inputNameField:UITextField?
	var choiceView:GMEditChoiceCateView?
	
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
//		input.layer.backgroundColor = UIColor(red: 211, green: 211, blue: 211).cgColor
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

extension GMEditBaseInfoView:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
	
	
	@objc private func changAvatorFunc(){
		let alert:UIAlertController = UIAlertController(title: "", message: "修改头像图片", preferredStyle: .actionSheet)
		let action = UIAlertAction(title:"打开相册".localized, style: .default) {[weak self](action)in
			self?.openAlbum()
		}
		let action1 = UIAlertAction(title:"调用相机".localized, style: .default) { [weak self](action)in
			self?.openCamera()
		}
		let action2 = UIAlertAction(title:"取消".localized, style: .cancel, handler:nil)
		alert.addAction(action)
		alert.addAction(action1)
		alert.addAction(action2)
		self.viewController().present(alert, animated:true, completion: nil)
	}
	
	@objc public func getBaseData(dic:NSDictionary,categorName:String){
		self.avator.setImageWith(NSURL(string: dic.object(forKey: "Image_url") as! String)! as URL)
		self.inputNameField?.text = dic.object(forKey: "ITEM_NAME") as? String
		self.choiceView?.getData(data:[categorName])
	}

	private func createSuvs(){
		self.backgroundColor = UIColor.white
		let basetitle:UILabel = self.titleLabel("基本信息")
		self.addSubview(basetitle)
		basetitle.snp.makeConstraints { (make) in
			make.left.top.equalTo(20)
			make.height.equalTo(30)
		}
		

		self.addSubview(self.avator)
		self.avator.isUserInteractionEnabled = true
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
		correct.text = "更换图片"
		correct.textAlignment = .center
		correct.font = UIFont.systemFont(ofSize: 13)
		self.avator.addSubview(correct)
		correct.snp.makeConstraints { (make) in
			make.bottom.left.right.equalToSuperview()
			make.height.equalTo(25)
		}
		
		self.inputNameField = self.inputName("Chizza烤薯条餐S")
		self.addSubview(self.inputNameField!)
		self.inputNameField?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.avator.snp.top)
			make.height.equalTo(50)
			make.left.equalTo(self.avator.snp.right).offset(15)
			make.right.equalTo(-20)
		})
		
		self.choiceView = GMEditChoiceCateView()
		self.addSubview(self.choiceView!)
		self.choiceView?.snp.makeConstraints({ (make) in
			make.height.equalTo(50)
			make.left.equalTo((self.inputNameField?.snp.left)!)
			make.right.equalTo((self.inputNameField?.snp.right)!)
			make.top.equalTo((self.inputNameField?.snp.bottom)!).offset(15)
		})
		
		
	}
	//打开相册
	func openAlbum(){
		
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
			
			let picker = UIImagePickerController()
			picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
			picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
			
			self.viewController().present(picker, animated:true, completion: {() -> Void in
				
			})
			
		}else{
			
			print("读取相册错误")
			
		}
		
	}
	
	
	
	func openCamera(){

		if UIImagePickerController.isSourceTypeAvailable(.camera){

			let picker = UIImagePickerController()
			picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
			picker.sourceType = UIImagePickerControllerSourceType.camera
			picker.allowsEditing = true
			self.viewController().present(picker, animated:true, completion: { () -> Void in



			})

		}

	}


	

	private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :AnyObject]) {

		print(info)

		let image = info[UIImagePickerControllerOriginalImage]as! UIImage

		picker.dismiss(animated: true, completion: { () -> Void in

		})

	}


}


