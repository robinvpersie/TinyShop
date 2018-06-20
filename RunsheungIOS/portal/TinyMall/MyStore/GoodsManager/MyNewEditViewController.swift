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

    override func viewDidLoad() {
        super.viewDidLoad()
		createBaseInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func setNavi() {
		super.setNavi()
		self.view.backgroundColor = UIColor(red: 242, green: 242, blue: 242)

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
		submit.setTitleColor(UIColor(red: 33, green: 192, blue: 67), for: .normal)
		submit.addTarget(self, action: #selector(submitaction), for: .touchUpInside)
		self.view.addSubview(submit)
//		UIApplication.shared.delegate?.window??.addSubview(submit)
		submit.snp.makeConstraints { (make) in
			make.bottom.left.right.equalToSuperview()
			make.height.equalTo(50)
		}
		
	}
	
	@objc private func submitaction(){
		
	}

}
