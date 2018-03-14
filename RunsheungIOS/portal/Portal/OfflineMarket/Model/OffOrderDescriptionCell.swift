//
//  OffOrderDescriptionCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OffOrderDescriptionCell: UITableViewCell {
    
    var leftlb:UILabel!
    var trailinglb:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        leftlb = UILabel()
        leftlb.textColor = UIColor.YClightGrayColor
        leftlb.font = UIFont.systemFont(ofSize: 17)
        leftlb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftlb)
        leftlb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftlb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:15).isActive = true
        
        trailinglb = UILabel()
        trailinglb.textColor = UIColor.darkText
        trailinglb.font = UIFont.systemFont(ofSize: 16)
        trailinglb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trailinglb)
        trailinglb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        trailinglb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant:-15).isActive = true 
        
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
