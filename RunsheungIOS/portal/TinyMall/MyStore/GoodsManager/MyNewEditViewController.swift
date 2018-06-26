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
	var groupid:String?
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	
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
		let alerController:UIAlertController = UIAlertController(title: "", message: "取消编辑并退出？", preferredStyle: .alert)
		let cancel:UIAlertAction = UIAlertAction(title: "继续编辑", style: .cancel) { (alert) in }
		let ok:UIAlertAction = UIAlertAction(title: "确定", style: .default) { (alert) in
			self.navigationController?.popViewController(animated: true)
		}
		alerController.addAction(cancel)
		alerController.addAction(ok)
		self.present(alerController, animated: true, completion: nil)

	}
	
	@objc public func getData(groupid:String,categorName:String){
		KLHttpTool.getGoodManagerNewEditwithUri("product/queryproductbyGroudId", withgroupid: groupid, success: { (response) in
			let res:NSDictionary = (response as? NSDictionary)!
			let status:Int = (res.object(forKey: "status") as! Int)
			if status == 1 {
				
				let dataDit:NSDictionary = res.object(forKey: "data") as! NSDictionary
				let dic:NSDictionary = dataDit.object(forKey: "item") as! NSDictionary
				self.baseInfoView.getBaseData(dic: dic, categorName:categorName)
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

		let submit:UIButton = UIButton()
		submit.setTitle("保存上架", for: .normal)
		submit.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		submit.setTitleColor(UIColor.white, for: .normal)
		submit.addTarget(self, action: #selector(submitaction), for: .touchUpInside)
		self.view.addSubview(submit)
		submit.snp.makeConstraints { (make) in
			make.bottom.left.right.equalToSuperview()
			make.height.equalTo(50)
		}
		
	}
	
	@objc private func submitaction(){
		
	}

}
