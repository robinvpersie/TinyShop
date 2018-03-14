//
//  OrderHeaderReusableView.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/2.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderHeaderReusableView: UICollectionReusableView {
    
    var headerLable:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerLable = UILabel()
        headerLable.font = UIFont.systemFont(ofSize: 13)
        headerLable.textColor = UIColor.darkcolor
        addSubview(headerLable)
        headerLable.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
