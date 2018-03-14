//
//  ChooseMarketSquareCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class ChooseMarketSquareCell: UITableViewCell {
    
    var backView:UIView!
    var squareLable:UILabel!
    var widthConstraint:Constraint? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        backView = UIView()
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerY.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.8)
            self.widthConstraint = make.width.equalTo(0).constraint
        }
        
        squareLable = UILabel()
        squareLable.font = UIFont.systemFont(ofSize: 15)
        backView.addSubview(squareLable)
        squareLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(backView)
            make.centerY.equalTo(backView)
            make.height.equalTo(20)
        }
    }
    
    func updateWithSelected(_ selected:Bool,with model:Squarelis){
        if selected {
           squareLable.textColor = UIColor.navigationbarColor
        }else {
           squareLable.textColor = UIColor.darkcolor
        }
        squareLable.text = model.divName
        let width = squareLable.text?.widthWithConstrainedWidth(height: 20, font: UIFont.systemFont(ofSize: 15))
        widthConstraint?.update(offset: width! + 20)
        
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
