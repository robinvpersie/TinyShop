//
//  YCSegMentTitleCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit


protocol TabTitleCellProtocol: class {
    var titleLabel: UILabel { get }
}

class YCSegMentTitleCell: UICollectionViewCell, TabTitleCellProtocol {
    
    var titleLabel: UILabel
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.darkText
        titleLabel.textAlignment = .center
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
    }
    
}
