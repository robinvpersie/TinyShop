//
//  BusinessMenuCell.swift
//  Portal
//
//  Created by 이정구 on 2018/5/30.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessMenuCell: UITableViewCell {

    @IBOutlet weak var scopeBtn: UIButton!
    @IBOutlet weak var pricelb: UILabel!
    @IBOutlet weak var introducelb: UILabel!
    @IBOutlet weak var titlelb: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    var addAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    func configureWithData(_ plist: Plist) {
        pricelb.text = plist.item_p
        titlelb.text = plist.item_name
        introducelb.text = plist.Remark
        avatarImgView.kf.setImage(with: URL.init(string: plist.image_url))
    }

    @IBAction func didScope(_ sender: Any) {
        addAction?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
