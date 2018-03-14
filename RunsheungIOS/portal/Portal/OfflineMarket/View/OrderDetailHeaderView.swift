//
//  OrderDetailHeaderView.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OrderDetailHeaderView: UITableViewHeaderFooterView {
    
    var titlelb:UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titlelb = UILabel()
        titlelb.font = UIFont.systemFont(ofSize: 15)
        titlelb.textColor = UIColor(hex: 0x43c3ff)
        titlelb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titlelb)
        titlelb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titlelb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
