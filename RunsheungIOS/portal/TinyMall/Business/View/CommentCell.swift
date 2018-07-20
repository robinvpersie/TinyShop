//
//  CommentCell.swift
//  Portal
//
//  Created by 이정구 on 2018/5/30.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var starView: CosmosView!
    var textView: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        starView = CosmosView()
        starView.settings.emptyBorderColor = UIColor(hex: 0xf9a80d)
        starView.settings.emptyBorderWidth = 0.8
        starView.settings.emptyColor = UIColor.clear
        starView.settings.filledColor = UIColor(hex: 0xf9a80d)
        starView.settings.fillMode = .precise
        starView.settings.starMargin = 1
        starView.settings.starSize = 15
        starView.settings.updateOnTouch = false
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(15)
        }
        
        textView = UITextView()
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        contentView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.height.equalTo(100)
        }
        
        
    }
    
    func configureWithData(_ data: ShopAssessData) {
        textView.text = data.rep_content
        starView.rating = Double(data.score) ?? 0
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
