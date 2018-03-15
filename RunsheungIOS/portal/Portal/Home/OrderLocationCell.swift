//
//  OrderLocationCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/2.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderLocationCell: UICollectionViewCell {
    
    var cityLabel:UILabel!
    var cityName:String = ""{
        didSet{
           cityLabel.text = cityName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        cityLabel = UILabel()
        cityLabel.font = UIFont.systemFont(ofSize: 15)
        cityLabel.textColor = UIColor.darkcolor
        addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
