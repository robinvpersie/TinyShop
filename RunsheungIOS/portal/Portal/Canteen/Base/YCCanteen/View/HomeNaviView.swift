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
    var searchBackView:UIView!
    var searchImageView:UIImageView!
    var searchLabel:UILabel!
    var scanBtn:UIButton!
    var addressbtn:UIButton!
    var clickAddressAction:(()->Void)?
    var clickScanAction:(() -> Void)?
    
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
        
        addressbtn = UIButton(type: .custom)
        addressbtn.addTarget(self, action: #selector(clickAddress), for: .touchUpInside)
        backGroundView.addSubview(addressbtn)
        addressbtn.snp.makeConstraints { (make) in
            make.leading.equalTo(addressView.snp.leading)
            make.trailing.equalTo(addressView.snp.trailing)
            make.top.equalTo(addressView.snp.top)
            make.bottom.equalTo(addressView.snp.bottom)
        }
        
        
        underlineView = UIView()
        backGroundView.addSubview(underlineView)
        underlineView.backgroundColor = UIColor.YCGrayColor
        underlineView.snp.makeConstraints { (make) in
            make.leading.equalTo(backGroundView.snp.leading)
            make.bottom.equalTo(backGroundView.snp.bottom)
            make.height.equalTo(1)
            make.trailing.equalTo(backGroundView.snp.trailing)
        }
        
        searchBackView = UIView()
        backGroundView.addSubview(searchBackView)
        searchBackView.backgroundColor = UIColor.YCGrayColor
        searchBackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backGroundView.snp.centerX)
            make.centerY.equalTo(backGroundView.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(140)
        }
        
        searchBackView.layer.masksToBounds = true
        searchBackView.layer.cornerRadius = 15
        
        searchImageView = UIImageView()
        searchBackView.addSubview(searchImageView)
        searchImageView.image = UIImage(named: "icon_search_001")
        searchImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(searchBackView.snp.leading).offset(15)
            make.height.equalTo(15)
            make.width.equalTo(15)
            make.centerY.equalTo(searchBackView.snp.centerY)
        }
        
        searchLabel = UILabel()
        searchLabel.textColor = UIColor.darkcolor
        searchLabel.font = UIFont.systemFont(ofSize: 15)
        searchLabel.text = "商家名称"
        searchBackView.addSubview(searchLabel)
        searchLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(searchImageView.snp.trailing).offset(5)
            make.centerY.equalTo(searchBackView.snp.centerY)
        }
        
        scanBtn = UIButton(type: .custom)
        scanBtn.setTitle("扫一扫", for: .normal)
        scanBtn.setTitleColor(UIColor.darkcolor, for: .normal)
        scanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        scanBtn.addTarget(self, action: #selector(didScan), for: .touchUpInside)
        backGroundView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(backGroundView.snp.trailing).offset(-5)
            make.centerY.equalTo(backGroundView.snp.centerY)
            make.height.equalTo(20)
        }
    }
    
    func didScan(){
        clickScanAction?()
    }
    
    func clickAddress(){
        clickAddressAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}





class canteenleftView:UIView{
    
    var addressLable:UILabel!
    var dropView:UIImageView!
    var text:String?{
        didSet{
          addressLable.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addressLable = UILabel()
        addressLable.textColor = UIColor.darkcolor
        addressLable.font = UIFont.systemFont(ofSize: 15)
        addSubview(addressLable)
        addressLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(20)
        }
    }
    
    func updateAddress(_ address:String?){
        addressLable.text = address
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

