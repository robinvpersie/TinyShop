//
//  MenuTypeView.swift
//  Portal
//
//  Created by 이정구 on 2018/6/11.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class MenuTypeView: UIView {
    
    var leftlb: UILabel!
    var rightlb: UILabel!
    var tapAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: 0xe6e6e6)
        
        leftlb = UILabel()
        leftlb.textColor = UIColor.YClightGrayColor
        leftlb.font = UIFont.systemFont(ofSize: 13)
        addSubview(leftlb)
        
        rightlb = UILabel()
        rightlb.textColor = UIColor.YClightGrayColor
        rightlb.font = UIFont.systemFont(ofSize: 13)
        addSubview(rightlb)
        
        let control = UIControl()
        control.backgroundColor = UIColor.clear
        control.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        addSubview(control)
        
        leftlb.snp.makeConstraints { make in
            make.left.equalTo(self).offset(8)
            make.centerY.equalTo(self)
            make.right.equalTo(rightlb.snp.left).offset(8)
        }
        
        rightlb.snp.makeConstraints { make in
            make.left.equalTo(leftlb.snp.right).offset(8)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(8)
        }
        
        control.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        
    }
    
    @objc func didTap() {
        tapAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
