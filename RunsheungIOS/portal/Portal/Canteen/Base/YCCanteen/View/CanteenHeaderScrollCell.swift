//
//  CanteenHeaderScrollCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class CanteenHeaderScrollCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    var titleLable:UILabel!
    var stackView:UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.8)
        }
        
        imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        titleLable = UILabel()
        titleLable.numberOfLines = 1
        titleLable.font = UIFont.systemFont(ofSize: 13)
        titleLable.textColor = UIColor.darkcolor
        stackView.addArrangedSubview(titleLable)
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
