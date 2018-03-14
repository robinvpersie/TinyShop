//
//  YCSegMentTitleCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit


protocol tabTitleCellProtocol {
    var titleLabel:UILabel {get}
}

class YCSegMentTitleCell: UICollectionViewCell,tabTitleCellProtocol {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      contentView.addSubview(titleLabel)
      contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.contentView.bounds
    }
    
}
