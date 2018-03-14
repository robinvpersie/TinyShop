//
//  OffShopCarUnderView.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class OffShopCarUnderView:UIView {
    
    enum payState {
        case empty
        case canpay
    }
    
    var payBtn:UIButton!
    var addgoodsBtn:UIButton!
    var canPay:payState = .empty {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    var Action:((payState)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        addgoodsBtn = UIButton(type: .custom)
        addgoodsBtn.setImage(UIImage(named: "btn_addgoods-1"), for: .normal)
        addgoodsBtn.addTarget(self, action: #selector(didMiddle), for: .touchUpInside)
        addSubview(addgoodsBtn)
        
        payBtn = UIButton(type: .custom)
        payBtn.setImage(UIImage(named: "btn_checkout-1"), for: .normal)
        payBtn.addTarget(self, action: #selector(didpay), for: .touchUpInside)
        addSubview(payBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        switch canPay {
        case .empty:
            payBtn.isHidden = true
        case .canpay:
            payBtn.isHidden = false
        }

        payBtn.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(45)
            make.width.equalTo(self).multipliedBy(0.45)
        })

        switch canPay {
        case .canpay:
            addgoodsBtn.snp.remakeConstraints({ (make) in
                make.leading.equalTo(self)
                make.centerY.equalTo(self)
                make.height.equalTo(45)
                make.width.equalTo(self).multipliedBy(0.45)
            })
        case .empty:
            addgoodsBtn.snp.remakeConstraints({ (make) in
                make.centerX.centerY.equalTo(self)
                make.width.equalTo(self).multipliedBy(0.45)
                make.height.equalTo(45)
            })
        }
    }
    
    @objc func didpay(){
       Action?(.canpay)
    }
    
    @objc func didMiddle(){
       Action?(.empty)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
