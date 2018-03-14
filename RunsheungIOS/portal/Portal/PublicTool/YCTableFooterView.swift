//
//  YCTableFooterView.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/1.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class YCTableFooterView: UIView {
    
    private lazy var imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "img_no_news")
        return imgView
    }()
    
    private lazy var titlelb:UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(hex: 0x999999)
        lable.text = "这里什么新闻都没有"
        return lable
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.addSubview(imgView)
        self.addSubview(titlelb)
        self.makeConstraint()

    }
    
    private func makeConstraint(){
        
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        titlelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
