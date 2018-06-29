//
//  MyNewEditViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class MyNewEditViewController: MyStoreBaseViewController {
	var baseInfoView:GMEditBaseInfoView = GMEditBaseInfoView()
	var byInfoView:GMEditByInfoView = GMEditByInfoView()
	var dic:NSDictionary?
	var imageURL:String?
	var levelname:String?
	var classname:String?
	var groupid:String?
	var editfinshRefreshMap:( )->Void = {( )->Void in }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.baseInfoView.choiceView?.choicebtn.hiddenPopView()
	
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		createBaseInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    

	override func setNavi() {
		super.setNavi()
		self.view.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
		self.navigationItem.title = "重新编辑"
		let cancel:UIBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelEdit))
		self.navigationItem.rightBarButtonItem = cancel
		
	}
	

	@objc private func cancelEdit(){
		self.baseInfoView.choiceView?.choicebtn.hiddenPopView()
 		let alerController:UIAlertController = UIAlertController(title: "", message: "取消编辑并退出？", preferredStyle: .alert)
		let cancel:UIAlertAction = UIAlertAction(title: "继续编辑", style: .cancel) { (alert) in }
		let ok:UIAlertAction = UIAlertAction(title: "确定", style: .default) { (alert) in
			self.navigationController?.popViewController(animated: true)
		}
		alerController.addAction(cancel)
		alerController.addAction(ok)
		self.present(alerController, animated: true, completion: nil)

	}
	
	@objc public func getData(dic:NSDictionary){
		self.dic = dic
		self.imageURL = self.dic!.object(forKey: "image_url") as? String
		self.levelname = self.dic!.object(forKey: "level_name") as? String
		self.classname = self.dic!.object(forKey: "item_name") as? String
		self.groupid =  self.dic!.object(forKey: "GroupId") as? String
		
   		KLHttpTool.getGoodManagerNewEditwithUri("product/queryproductbyGroudId", withgroupid: self.groupid, success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
				
				let dataDit:NSDictionary = res.object(forKey: "data") as! NSDictionary
				let dic:NSDictionary = dataDit.object(forKey: "item") as! NSDictionary
				self.baseInfoView.getBaseData(dic: dic, currentLevelDic:NSArray(array: [self.dic ?? " "] ))
				let spec:NSMutableArray = NSMutableArray(array: dataDit.object(forKey: "spec") as! NSArray )
				let Flavor:NSMutableArray = NSMutableArray(array: dataDit.object(forKey: "Flavor") as! NSArray )
 				self.byInfoView.getData(array1: spec,array2: Flavor)
				
			}
		}) { (error) in
			
		}
	}
}

extension MyNewEditViewController{
	private func createBaseInfo(){
		self.view.addSubview(self.baseInfoView)
		self.baseInfoView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(10)
			make.height.equalTo(210)
		}
		
		self.view.addSubview(self.byInfoView)
		self.byInfoView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(self.baseInfoView.snp.bottom).offset(20)
			make.height.equalTo(screenHeight - self.baseInfoView.maxy - 20)
		}

		self.byInfoView.finishData = {(da1:NSMutableArray,da2:NSMutableArray)->Void in
 
			KLHttpTool.getGoodManagerAppendproductwithUri("product/updateproduct", withGroupid:self.groupid, withimageURL:self.imageURL, withcustom_item_code: self.dic?.object(forKey: "item_code") as! String, withcustom_item_name: self.classname , withcustom_item_spec: "1", withdom: "1", withitem_name: self.classname, withitem_level1: self.levelname, withprice:self.dic?.object(forKey: "item_p") as! String, withspec: da1 as! [Any], withFlavor: da2 as! [Any], success: { (response) in
				
				let res:NSDictionary = (response as? NSDictionary)!
				let status:Int = (res.object(forKey: "status") as! Int)
				if status == 1 {
					self.editfinshRefreshMap()
 					self.navigationController?.popViewController(animated: true)
				}
			}, failure: { (error) in
				
			})
		}
		self.baseInfoView.finishBaseData = {(imageurl:String,name:String,categoryname:String) in
			
			self.imageURL = imageurl
			self.levelname = categoryname
			self.classname = name
		
		}
		
	}

	
 }
