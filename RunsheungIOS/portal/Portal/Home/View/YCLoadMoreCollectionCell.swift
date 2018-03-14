//
//  YCLoadMoreCollectionCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class YCLoadMoreCollectionCell: UICollectionViewCell {

    @IBOutlet weak var infolb: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var info:String? {
        didSet{
            if let info = info {
                infolb.text = info
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        activity.hidesWhenStopped = true

    }

}
