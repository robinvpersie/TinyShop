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
	var popWidth:CGFloat = 0
	var popTableView:UIImageView?
	var choiceMap:(NSDictionary,Int,Int) ->Void = {(_:NSDictionary,_:Int,_:Int) in }
	var level_id:String = "1"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
 
		self.addTarget(self, action: #selector(popChoiceView), for: .touchUpInside)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func getTitlesArray(titles:NSArray){
		self.values = titles
		let dic:NSDictionary = self.values?.firstObject as! NSDictionary
		self.level_id = (dic.object(forKey: "id") as? String)!
 		self.getWidth(array: self.values!)
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

		cell.textLabel?.textAlignment = .left

		let check:UIImageView = UIImageView()
		check.image = #imageLiteral(resourceName: "icon_state_02")
		check.isHidden = true
		cell.contentView.addSubview(check)
		check.snp.makeConstraints { (make) in
			make.width.top.equalTo(17)
			make.height.equalTo(12)
			make.right.equalToSuperview().offset(-15)
		}
		
		let dic1:NSDictionary  = self.values?.object(at: indexPath.row) as! NSDictionary
		let s1:String = dic1.object(forKey: "level_name") as! String
 		cell.textLabel?.text = s1
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
		guard let _:((NSDictionary,Int,Int) -> Void) = self.choiceMap else {
			return
		}
		let dic:NSDictionary = self.values?[indexPath.row] as! NSDictionary
		self.value?.text = dic.object(forKey: "level_name") as? String
		self.level_id = (dic.object(forKey: "id") as? String)!
  		self.choiceMap(dic,Int(self.tag),Int(indexPath.row))
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
		let dic:NSDictionary = self.values?.firstObject as! NSDictionary
		self.value?.text = dic.object(forKey: "level_name") as? String
		self.addSubview(self.value!)
		self.value?.snp.makeConstraints({ (make) in
			make.left.top.equalTo(5)
			make.right.equalTo(arrow.snp.left).offset(-5)
			make.bottom.equalToSuperview().offset(-5)
		})
		
		
		
	}
	private func getWidth(array:NSArray) {
		for dic in array {
			let dic1:NSDictionary  = dic as! NSDictionary
			let st:String = dic1.object(forKey: "level_name") as! String
 			let textMaxSize = CGSize(width:CGFloat(MAXFLOAT) , height: 25.0)
			let size:CGSize = self.textSize(text: st , font: UIFont.systemFont(ofSize: 15.0), maxSize: textMaxSize)
			if size.width > self.popWidth {
				self.popWidth = size.width
			}
		}
		
	}
	private func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
		return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [kCTFontAttributeName as NSAttributedStringKey : font], context: nil).size
	}
	@objc private func popChoiceView(){
		
		if self.popTableView == nil {

			let newFrame:CGRect = self.convert(self.bounds, to: (UIApplication.shared.delegate?.window)!)
			self.popTableView = UIImageView(frame: CGRect(x:Int( newFrame.origin.x+newFrame.size.width/2) - Int(22 + self.popWidth/2), y:Int(newFrame.maxY+5) , width: Int(55 + self.popWidth) , height: ((self.values?.count)!*44) + 10))
			self.popTableView?.image = #imageLiteral(resourceName: "img_bg_01")
			self.popTableView?.isUserInteractionEnabled = true
			let tableview:UITableView = UITableView(frame: CGRect(x:0, y:0 , width: 0, height: 0), style: .plain)
			tableview.separatorColor = UIColor.white
			tableview.layer.cornerRadius = 5
			tableview.layer.masksToBounds = true
			tableview.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
			tableview.layer.borderWidth = 1
			tableview.delegate = self
			tableview.dataSource = self
			self.popTableView?.addSubview(tableview)
			tableview.snp.makeConstraints { (make) in
				make.left.bottom.right.equalToSuperview()
				make.top.equalToSuperview().offset(10)
			}
			
			UIApplication.shared.delegate?.window??.addSubview(self.popTableView!)
			
		}
		
	}
	
}
