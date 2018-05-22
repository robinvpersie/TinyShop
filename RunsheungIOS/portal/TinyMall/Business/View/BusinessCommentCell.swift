//
//  BusinessCommentCell.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessCommentCell: UITableViewCell {
    
    var avatarImgView: UIImageView!
    var nicknamelb: UILabel!
    var rationView: CosmosView!
    var timelb: UILabel!
    var textView: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImgView = UIImageView()
        contentView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(18)
            make.width.height.equalTo(30)
        }
        
        nicknamelb = UILabel()
        nicknamelb.textColor = UIColor.darkText
        nicknamelb.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(nicknamelb)
        nicknamelb.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(10)
            make.centerY.equalTo(avatarImgView)
        }
        
        timelb = UILabel()
        timelb.textColor = UIColor(hex: 0x999999)
        timelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(timelb)
        timelb.snp.makeConstraints { (make) in
            make.centerY.equalTo(nicknamelb)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        rationView = CosmosView()
        rationView.settings.emptyColor = UIColor.groupTableViewBackground
        rationView.settings.filledColor = UIColor(red: 255, green: 201, blue: 40)
        rationView.settings.fillMode = .precise
        rationView.settings.starSize = 20
        rationView.settings.starMargin = 4
        rationView.settings.updateOnTouch = false
        contentView.addSubview(rationView)
        rationView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView)
            make.top.equalTo(avatarImgView.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        contentView.addSubview(textView)
    
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
