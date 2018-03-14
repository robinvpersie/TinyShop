//
//  HomeNaviView.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class HomeNaviView: UIView {
    
    var addressView:canteenleftView!
    var backGroundView:UIView!
    var scanQRView:UIImageView!
    var underlineView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        backGroundView = UIView()
        backGroundView.backgroundColor = UIColor.clear
        addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top).offset(20)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        addressView = canteenleftView(frame: CGRect.zero)
        backGroundView.addSubview(addressView)
        addressView.snp.makeConstraints { (make) in
            make.leading.equalTo(backGroundView.snp.leading).offset(5)
            make.centerY.equalTo(backGroundView.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(93)
        }
        
        underlineView = UIView()
        backGroundView.addSubview(underlineView)
        underlineView.backgroundColor = UIColor.groupTableViewBackground
        underlineView.snp.makeConstraints { (make) in
            make.leading.equalTo(backGroundView.snp.leading)
            make.bottom.equalTo(backGroundView.snp.bottom)
            make.height.equalTo(1)
            make.trailing.equalTo(backGroundView.snp.trailing)
        }

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}





class canteenleftView:UIView{
    
    var addressLable:UILabel!
    var dropView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addressLable = UILabel()
        addressLable.textColor = UIColor.darkcolor
        addressLable.font = UIFont.systemFont(ofSize: 15)
        addSubview(addressLable)
        addressLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading)
            make.width.lessThanOrEqualTo(80)
            make.height.equalTo(20)
        }
        
        dropView = UIImageView()
        dropView.image = UIImage(named: "icon_dropdown")
        addSubview(dropView)
        dropView.snp.makeConstraints { (make) in
            make.leading.equalTo(addressLable.snp.trailing).offset(3)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
    }
    
    func updateAddress(_ address:String?){
        addressLable.text = address
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

