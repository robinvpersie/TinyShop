//
//  BusinessStateView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessStateView: UIButton {
	var values:NSArray?
	var data:NSArray?
	var value:UILabel?

	var popTableView:UITableView?
	var choiceMap:(String,Int,Int) ->Void = {(_:String,_:Int,_:Int) in }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
 
		self.addTarget(self, action: #selector(popChoiceView), for: .touchUpInside)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getTitlesArray(titles:NSArray){
		self.values = titles
		createSuvs()
	}
}
extension BusinessStateView:UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.values!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell:UITableViewCell = UITableViewCell()
		cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
		cell.textLabel?.text = self.values?[indexPath.row] as? String
		cell.textLabel?.textAlignment = .left

		let check:UIImageView = UIImageView(frame: CGRect(x: 70, y: 15, width: 20, height: 14))
		check.image = #imageLiteral(resourceName: "icon_state_02")
		check.isHidden = true
		cell.contentView.addSubview(check)

		let s1:String = self.values?.object(at: indexPath.row) as! String
		if s1 == self.value?.text {
			check.isHidden = false
		}
		
		let seperatorline:UILabel = UILabel()
		seperatorline.backgroundColor = UIColor(red: 232, green: 232, blue: 232)
		cell.contentView.addSubview(seperatorline)
		seperatorline.snp.makeConstraints { (make) in
			make.left.equalTo(3)
			make.right.equalTo(-3)
			make.height.equalTo(1)
			make.bottom.equalToSuperview()
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let _:((String,Int,Int) -> Void) = self.choiceMap else {
			return
		}
		self.choiceMap((self.value?.text)!,Int(self.tag),Int(indexPath.row))
		self.value?.text = self.values?[indexPath.row] as? String

		self.hiddenPopView()
		
	}
	
}

extension BusinessStateView{
	
	@objc public func hiddenPopView(){
	
		self.popTableView?.removeFromSuperview()
		self.popTableView = nil
	}
	private func createSuvs(){
		
		let arrow:UIImageView = UIImageView(image: #imageLiteral(resourceName: "icon_state_01"))
		self.addSubview(arrow)
		arrow.snp.makeConstraints { (make) in
			make.width.equalTo(12)
			make.bottom.equalTo(-10)
			make.right.equalTo(-8)
			make.top.equalTo(10)
		}

		self.value = UILabel()
		self.value?.backgroundColor = UIColor.white
		self.value?.textAlignment = .right
		self.value?.textColor = UIColor(red: 71, green: 71, blue: 71)
		self.value?.font = UIFont.systemFont(ofSize: 14)
		self.value?.text = self.values?.firstObject as? String
		self.addSubview(self.value!)
		self.value?.snp.makeConstraints({ (make) in
			make.left.top.equalTo(5)
			make.right.equalTo(arrow.snp.left).offset(-5)
			make.bottom.equalToSuperview().offset(-5)
		})
		
		
		
	}
	
	@objc private func popChoiceView(){
		
		if self.popTableView == nil {

			let newFrame:CGRect = self.convert(self.bounds, to: (UIApplication.shared.delegate?.window)!)
			self.popTableView = UITableView(frame: CGRect(x:Int( newFrame.origin.x+newFrame.size.width/2 - 50), y:Int(newFrame.maxY+10) , width: 100, height: ((self.values?.count)!*44)), style: .plain)
			self.popTableView?.separatorColor = UIColor.white
			self.popTableView?.layer.cornerRadius = 5
			self.popTableView?.layer.masksToBounds = true
			self.popTableView?.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
			self.popTableView?.layer.borderWidth = 1
			self.popTableView?.delegate = self
			self.popTableView?.dataSource = self
			UIApplication.shared.delegate?.window??.addSubview(self.popTableView!)
			
		}
		
	}
	
}
