//
//  CanteenHomeCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class CanteenHomeCell: UITableViewCell {

    @IBOutlet weak var numlable: UILabel!
    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var pricelable: UILabel!
    @IBOutlet weak var starView: WSStarRatingView!
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


