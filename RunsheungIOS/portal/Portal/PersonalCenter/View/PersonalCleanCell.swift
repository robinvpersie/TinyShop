//
//  PersonalCleanCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class PersonalCleanCell: UITableViewCell {

    @IBOutlet weak var descritionlb: UILabel!
    @IBOutlet weak var cachesize: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
