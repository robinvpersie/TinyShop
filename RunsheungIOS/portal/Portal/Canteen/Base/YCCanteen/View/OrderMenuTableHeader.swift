//
//  OrderMenuTableHeader.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/4.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderMenuTableHeader: UITableViewHeaderFooterView {

    var headerLable:UILabel!
    var headerName:String = ""{
        didSet{
          headerLable.text = headerName
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        headerLable = UILabel()
        headerLable.textColor = UIColor.YClightGrayColor
        headerLable.font = UIFont.systemFont(ofSize: 15)
        addSubview(headerLable)
        headerLable.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
