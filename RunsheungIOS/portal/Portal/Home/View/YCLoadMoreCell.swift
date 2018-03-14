//
//  YCLoadMoreCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class YCLoadMoreCell: UITableViewCell {

    @IBOutlet weak var loadMoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var info:String? {
      didSet{
        loadMoreLabel.text = info
      }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        separatorInset = UIEdgeInsetsMake(0, 0, 0, screenWidth)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
