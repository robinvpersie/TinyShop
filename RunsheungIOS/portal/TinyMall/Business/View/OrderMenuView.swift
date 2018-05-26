//
//  OrderMenuView.swift
//  Portal
//
//  Created by 이정구 on 2018/5/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit


class OrderMenuView: UIView {
    
    var priceLable: UILabel!
    var payBtn: UIButton!
    var backGroundView: UIView!
    var carView: ShopCarView!
    var numlable: UILabel!
    var containerView: UIView!
    var pushBtn: UIButton!
    private var _bageValue: Int = 0
    var _totalPrice: Float = 0
    var badgeValue: Int {
        set {
            _bageValue = newValue
            containerView.showBadge(with: .number, value: newValue, animationType: .none)
        }
        get {
            return _bageValue
        }
    }
    var totalPrice: Float {
        get {
            return _totalPrice
        }
        set {
            _totalPrice = newValue
            let price = String(format: "%.2f", newValue)
            priceLable.text = "￥\(price)"
        }
    }
    var pushAction: (() -> ())?
    var payAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backGroundView = UIView()
        backGroundView.backgroundColor = UIColor.darkcolor
        backGroundView.alpha = 0.95
        addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self).offset(20)
        }
        
        payBtn = UIButton(type: .custom)
        payBtn.addTarget(self, action: #selector(pay), for: .touchUpInside)
        payBtn.setTitle("주문하기", for: .normal)
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        payBtn.backgroundColor = Theme.orderStyleColor
        backGroundView.addSubview(payBtn)
        payBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(backGroundView)
            make.width.equalTo(Ruler.iPhoneHorizontal(100, 110, 120).value)
        }
        
        containerView = UIView()
        containerView.badgeCenterOffset = CGPoint(x: -8, y: 10)
        containerView.backgroundColor = UIColor.clear
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self)
            make.width.height.equalTo(50)
        }
        
        carView = ShopCarView()
        containerView.addSubview(carView)
        carView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        
        priceLable = UILabel()
        priceLable.numberOfLines = 1
        priceLable.font = UIFont.boldSystemFont(ofSize: 19)
        priceLable.textColor = UIColor.white
        priceLable.text = "￥0"
        backGroundView.addSubview(priceLable)
        priceLable.snp.makeConstraints { (make) in
            make.left.equalTo(backGroundView).offset(80)
            make.centerY.equalTo(backGroundView)
        }
        
        pushBtn = UIButton(type: .custom)
        pushBtn.addTarget(self, action: #selector(push), for: .touchUpInside)
        pushBtn.backgroundColor = UIColor.clear
        backGroundView.addSubview(pushBtn)
        pushBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(backGroundView)
            make.right.equalTo(payBtn.snp.left)
        }
    }
    
    @objc func push() {
        pushAction?()
    }
    
    @objc func pay() {
        payAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ShopCarView: UIView{
    
    private var carImageView: UIImageView!
    var carImage: UIImage?{
        didSet{
            carImageView.image = carImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        carImageView = UIImageView()
        carImageView.image = UIImage(named: "icon_cart")
        addSubview(carImageView)
        carImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(50)
        }
    }
  
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
