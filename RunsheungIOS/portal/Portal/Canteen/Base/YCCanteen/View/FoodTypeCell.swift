//
//  FoodTypeCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/4.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class FoodTypeCell: UITableViewCell {
    
    var name:UILabel!
    var yellowView:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        name = UILabel()
        name.numberOfLines = 0
        name.font = UIFont.systemFont(ofSize: 13)
        name.textColor = UIColor.darkcolor
        name.highlightedTextColor = UIColor.navigationbarColor
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-10)
            make.leading.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        yellowView = UIView()
        yellowView.backgroundColor = UIColor.navigationbarColor
        contentView.addSubview(yellowView)
        yellowView.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(5)
            make.width.equalTo(3)
            make.height.equalTo(45)
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
        
        contentView.backgroundColor = selected ? UIColor.white : UIColor.clear
        isHighlighted = selected
        name.isHighlighted = selected
        yellowView.isHidden = !selected
    }

}
