//
//  OrderDescriptionCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderDescriptionCell: UITableViewCell {
    
    var textView:UITextView!
    var descriptionlb:UILabel!
    var heightConstraint:Constraint?=nil
    var orderinfo:OrderFoodModel!{
        didSet{
          textView.text = orderinfo.data.info
          let height = orderinfo.data.info.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 13))
          heightConstraint?.update(offset: height+1)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        descriptionlb = UILabel()
        descriptionlb.font = UIFont.systemFont(ofSize: 15)
        descriptionlb.textColor = UIColor.YClightGrayColor
        descriptionlb.text = "餐厅简介".localized + ":"
        contentView.addSubview(descriptionlb)
        descriptionlb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.height.equalTo(20)
        }
        
        textView = UITextView()
        textView.textColor = UIColor.darkcolor
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        contentView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(descriptionlb.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            self.heightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    class func getHeightWithModel(_ model:OrderFoodModel) -> CGFloat{
       let height = model.data.info.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 13))
       return height + 10 + 10 + 20 + 10 + 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
