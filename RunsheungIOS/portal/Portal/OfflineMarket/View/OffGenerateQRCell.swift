//
//  OffGenerateQRCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OffGenerateQRCell: UITableViewCell {
    
    var imgView:UIImageView!
    var orderNum:String? {
        didSet{
            if let ordernum = orderNum,ordernum != oldValue {
                DispatchQueue.global().async {
                    let qrcode = DCQRCode(info: ordernum, size: CGSize(width: 180, height: 180))
                    let image = qrcode.image()
                    DispatchQueue.main.async {
                        self.imgView.image = image
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgView)
        imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getHeight() -> CGFloat {
        return 210
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
