//
//  PersonalHeaderCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class PersonalHeaderCell: UITableViewCell {

    @IBOutlet weak var descriptionlb: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    var clickImage:(() ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = CGFloat(45.0/2.0)
        avatarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(clickTap))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        
    }
    
    func clickTap(){
        if let clickImage = clickImage {
          clickImage()
        }
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
