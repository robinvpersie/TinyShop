//
//  BadgeView.swift
//  Portal
//
//  Created by 이정구 on 2018/6/1.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BadgeView: UIButton {
    
    var badgelb: UILabel!
    var badgeNum: Int! {
        didSet {
            if let badge = badgeNum {
                if badge > 0 {
                    badgelb.isHidden = false
                } else {
                    badgelb.isHidden = true
                }
                badgelb.text = "\(badge)"
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        badgelb = UILabel()
        badgelb.textAlignment = .center
        badgelb.isHidden = true
        badgelb.font = UIFont.systemFont(ofSize: 9)
        badgelb.textColor = UIColor.white
        let height = badgelb.font.pointSize * 1.5
        badgelb.layer.cornerRadius = height / 2.0
        badgelb.layer.backgroundColor = UIColor.navigationbarColor.cgColor
        addSubview(badgelb)
        badgelb.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(5)
            make.top.equalTo(self).offset(-5)
            make.height.equalTo(height)
            make.width.greaterThanOrEqualTo(height)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
