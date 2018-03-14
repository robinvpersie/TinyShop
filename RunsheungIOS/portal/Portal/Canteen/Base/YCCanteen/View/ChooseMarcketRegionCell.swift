//
//  ChooseMarcketRegionCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class ChooseMarcketRegionCell: UITableViewCell {
    
    var backView:UIView!
    var regionLable:UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        backView = UIView()
        backView.backgroundColor = UIColor.white
        backView.layer.masksToBounds = true
        backView.layer.borderWidth = 0.4
        backView.layer.borderColor = UIColor.YClightGrayColor.cgColor
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(15)
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.height.equalTo(self.snp.height).multipliedBy(0.8)
        }
        
        regionLable = UILabel()
        regionLable.textColor = UIColor.darkcolor
        regionLable.font = UIFont.systemFont(ofSize: 15)
        backView.addSubview(regionLable)
        regionLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(backView.snp.centerX)
            make.centerY.equalTo(backView.snp.centerY)
        }
    }
    
    func updateWithSelected(_ selected:Bool,model mode:Areaandsquar){
        if selected {
           backView.backgroundColor = UIColor.BaseControllerBackgroundColor
        }else {
           backView.backgroundColor = UIColor.white
        }
        regionLable.text = mode.areaName
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
