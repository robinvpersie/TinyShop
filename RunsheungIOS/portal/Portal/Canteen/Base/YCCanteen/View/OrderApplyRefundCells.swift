//
//  OrderApplyRefundCells.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SnapKit

class  OrderApplyRefundDetailCell:UITableViewCell {
    
    var leftStackView:UIStackView!
    var rightstackView:UIStackView!
    var leftHeight:Constraint? = nil
    var rightHeight:Constraint? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .fillEqually
        contentView.addSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(contentView.snp.top).offset(10)
           self.leftHeight = make.height.equalTo(0).constraint
        }
        
        rightstackView = UIStackView()
        rightstackView.axis = .vertical
        rightstackView.alignment = .leading
        rightstackView.distribution = .fillEqually
        contentView.addSubview(rightstackView)
        rightstackView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing).offset(10)
            make.top.equalTo(leftStackView.snp.top)
            make.trailing.equalTo(rightstackView.snp.trailing).offset(-15)
            self.rightHeight = make.height.equalTo(0).constraint
        }
       
    }
    
    class func getHeight() -> CGFloat {
         return 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class OrderApplyRefundReasonCell:UITableViewCell {
    
    var backGroundView:UIView!
    var reasonLabel:UILabel!
    var reasonAction:(()->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        let reason = UILabel()
        reason.font = UIFont.systemFont(ofSize: 15)
        reason.textColor = UIColor.darkcolor
        reason.text = "退款原因"
        contentView.addSubview(reason)
        reason.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.height.equalTo(20)
        }
        
        backGroundView = UIView()
        backGroundView.backgroundColor = UIColor.white
        backGroundView.layer.borderColor = UIColor.YClightGrayColor.cgColor
        backGroundView.layer.borderWidth = 0.3
        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(reason.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.height.equalTo(30)
        }
        
        reasonLabel = UILabel()
        reasonLabel.textColor = UIColor.YClightGrayColor
        reasonLabel.font = UIFont.systemFont(ofSize: 13)
        backGroundView.addSubview(reasonLabel)
        reasonLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(backGroundView.snp.leading).offset(5)
            make.centerY.equalTo(backGroundView.snp.centerY)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        backGroundView.addGestureRecognizer(tapGesture)
        
    }
    
    func didTap(){
        reasonAction?()
    }
    
    class func getHeight() -> CGFloat {
        return 10 + 20 + 10 + 30 + 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



