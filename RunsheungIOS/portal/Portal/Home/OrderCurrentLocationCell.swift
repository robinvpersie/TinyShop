//
//  OrderCurrentLocationCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/2.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderCurrentLocationCell: UICollectionViewCell {
    
    var locationLabel:UILabel!
    var locationName:UILabel!
    var changeBtn:UIButton!
    var clickChangeAction:(()->Void)?
    var addressText:String = ""{
        didSet{
          locationName.text = addressText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        locationLabel = UILabel()
        locationLabel.textColor = UIColor.darkcolor
        locationLabel.text = "当前定位:"
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        locationName = UILabel()
        locationName.textColor = UIColor.darkcolor
        locationName.text = addressText
        locationName.font = UIFont.systemFont(ofSize: 15)
        addSubview(locationName)
        locationName.snp.makeConstraints { (make) in
            make.leading.equalTo(locationLabel.snp.trailing).offset(5)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        changeBtn = UIButton(type: .custom)
        changeBtn.addTarget(self, action: #selector(clickChange), for: .touchUpInside)
        changeBtn.setTitle("切换商场", for: .normal)
        changeBtn.setTitleColor(UIColor.YClightGrayColor, for: .normal)
        changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        addSubview(changeBtn)
        changeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.centerY.equalTo(self.snp.centerY)
        }
        
    }
    
    func clickChange(){
       clickChangeAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
