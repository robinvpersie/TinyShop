//
//  OrderDetailAddressCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderDetailAddressCell: UITableViewCell {
    
    var leftImageView:UIImageView!
    var infoLable:UILabel!
    var rightBtn:UIButton!
    var clickRightAction:(()->Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
//        accessoryType = .disclosureIndicator
        
        leftImageView = UIImageView()
        contentView.addSubview(leftImageView)
        
        rightBtn = UIButton(type: .custom)
        rightBtn.addTarget(self, action: #selector(clickRight), for: .touchUpInside)
        contentView.addSubview(rightBtn)

        
        infoLable = UILabel()
        infoLable.textColor = UIColor.darkcolor
        infoLable.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(infoLable)
        
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        leftImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }

        
        infoLable.snp.makeConstraints { (make) in
            make.leading.equalTo(leftImageView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(rightBtn.snp.leading).offset(10)
        }

       
    }
    
    @objc private func clickRight(){
        clickRightAction?()
    }
    
    class func getHeight() -> CGFloat {
        return 44
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
