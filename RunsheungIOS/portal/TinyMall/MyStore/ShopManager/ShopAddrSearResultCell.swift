//
//  ShopAddrSearResultCell.swift
//  Portal
//
//  Created by dlwpdlr on 2018/7/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopAddrSearResultCell: UITableViewCell {
	var address:UILabel = UILabel()
	var pstcode:UILabel = UILabel()
	var dic:NSDictionary?
	var choiceMap:(NSDictionary)->Void = {(dict:NSDictionary)->Void in}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
		
		let bg:UIView = UIView()
		bg.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		bg.layer.cornerRadius = 3
		bg.layer.masksToBounds = true
		self.contentView.addSubview(bg)
		bg.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(7)
			make.bottom.equalToSuperview().offset(-7)
 			make.left.equalToSuperview().offset(15)
 			make.right.equalToSuperview().offset(-15)

		}
		
		let choiceBtn:UIButton = UIButton()
		choiceBtn.backgroundColor = UIColor(red: 176, green: 204, blue: 230)
		choiceBtn.setTitleColor(UIColor.white, for: .normal)
		choiceBtn.setTitle("选择", for: .normal)
		choiceBtn.layer.cornerRadius = 15
		choiceBtn.layer.masksToBounds = true
 		choiceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		choiceBtn.addTarget(self, action: #selector(choiceAction), for: .touchUpInside)
		bg.addSubview(choiceBtn)
		choiceBtn.snp.makeConstraints { (make) in
			make.width.equalTo(60)
			make.height.equalTo(30)
			make.right.equalTo(-15)
			make.top.equalToSuperview().offset(10)
		}
		
		bg.addSubview(self.pstcode)
		pstcode.textColor = UIColor(red: 180, green: 180, blue: 180)
        pstcode.font = UIFont.systemFont(ofSize: 14)
		self.pstcode.snp.makeConstraints { (make) in
			make.bottom.equalToSuperview().offset(-10)
			make.left.equalToSuperview().offset(10)
			make.right.equalToSuperview().offset(-15)
			make.height.equalTo(20)
 
		}
		
		
 		bg.addSubview(self.address)
		address.textColor = UIColor(red: 180, green: 180, blue: 180)
		address.font = UIFont.systemFont(ofSize: 15)
 		address.numberOfLines = 0
  		self.address.snp.makeConstraints { (make) in
			
			make.top.equalToSuperview().offset(10)
			make.left.equalTo(self.pstcode.snp.left)
			make.right.equalTo(choiceBtn.snp.left).offset(-10)
			make.bottom.equalTo(self.pstcode.snp.top).offset(-5)
  		}
		
	}
	
	@objc private func choiceAction(){
 
		guard let dic = self.dic else { return ; }
		self.choiceMap(dic)
	}
	
	public func getDic(dic:NSDictionary){
		self.dic = dic
	
		let pstdic:NSDictionary = self.dic?.object(forKey: "postcd") as! NSDictionary
  		let addrsecdic:NSDictionary = self.dic?.object(forKey: "addrjibun") as! NSDictionary
 		let pst:String = pstdic.object(forKey: "cdatasection") as! String
 		let addrsec:String = addrsecdic.object(forKey: "cdatasection") as! String
		
  		self.pstcode.text = "邮编：" + pst
		self.address.text = "地址：" + addrsec 
		
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     }
    
}
