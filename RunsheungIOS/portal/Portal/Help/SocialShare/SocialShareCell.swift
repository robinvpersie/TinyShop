//
//  SocialShareCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class SocialShareCell: UICollectionViewCell {
    
    var shareBtn:UIButton!
    var shareTitlelb:UILabel!
    var shareAction:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shareBtn = UIButton(type: .custom)
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        shareBtn.layer.backgroundColor = UIColor.white.cgColor
        shareBtn.layer.cornerRadius = 3
        contentView.addSubview(shareBtn)
        
        shareTitlelb = UILabel()
        shareTitlelb.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(shareTitlelb)
        
        shareBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(40)
            make.top.equalTo(contentView).offset(10)
        }
        
        shareTitlelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(shareBtn.snp.bottom).offset(10)
        }
        
    }
    
    @objc func share(){
        shareAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
