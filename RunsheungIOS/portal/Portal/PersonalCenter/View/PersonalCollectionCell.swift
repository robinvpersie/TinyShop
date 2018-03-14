//
//  PersonalCollectionCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

fileprivate let titleToTopedge:CGFloat = 10
fileprivate let titleHeight:CGFloat = 21
fileprivate let titleToTimeedge:CGFloat = 15
fileprivate let timeHeight:CGFloat = 13.5



class PersonalCollectionCell: UITableViewCell {

    @IBOutlet weak var Watchlabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithModel(model:PersonalMyScrab){
       timeLabel.text = model.date
       titleLabel.text = model.title
       Watchlabel.text = "\(model.replyCount)"
    }
    
    class func getHeight() -> CGFloat {
       return 2 * titleToTopedge + titleHeight + titleToTimeedge + timeHeight
    }
    
}
