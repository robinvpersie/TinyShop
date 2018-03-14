//
//  TotalPointCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class TotalPointCell: UITableViewCell {
    
    var point:Double = 0{
        didSet{
          starPoint.text = String(format: "%.1f", point) + "星"
          pointView.rating = point
        }
    }
    
    var pointView:CosmosView!
    var starPoint:UILabel!
    var totallabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        totallabel = UILabel()
        totallabel.textColor = UIColor.darkcolor
        totallabel.font = UIFont.systemFont(ofSize: 15)
        totallabel.text = "总分"
        contentView.addSubview(totallabel)
        
        pointView = CosmosView()
        pointView.settings.updateOnTouch = false
        pointView.settings.fillMode = .precise
        pointView.settings.emptyBorderColor = UIColor.orange
        pointView.settings.filledBorderColor = UIColor.orange
        pointView.settings.filledColor = UIColor.orange
        pointView.settings.starSize = 15
        pointView.settings.starMargin = 1
        contentView.addSubview(pointView)
        
        starPoint = UILabel()
        starPoint.textColor = UIColor.darkcolor
        starPoint.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(starPoint)
        
        totallabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        pointView.snp.makeConstraints { (make) in
            make.leading.equalTo(totallabel.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.width.equalTo(80)
            make.height.equalTo(15)
        }
        
        starPoint.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    class func getHeight() -> CGFloat {
        return 40
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
