//
//  LeftRightlbCell.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class LeftRightlbCell: UITableViewCell {
    
    var leftlb: UILabel!
    var rightlb: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftlb = UILabel()
        leftlb.font = UIFont.systemFont(ofSize: 15)
        leftlb.textColor = UIColor.darkText
        contentView.addSubview(leftlb)
        leftlb.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(15)
        }
        
        rightlb = UILabel()
        rightlb.textColor = UIColor.YClightGrayColor
        rightlb.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(rightlb)
        rightlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
