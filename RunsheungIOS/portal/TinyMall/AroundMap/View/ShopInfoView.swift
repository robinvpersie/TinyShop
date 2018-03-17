//
//  ShopInfoView.swift
//  Portal
//
//  Created by 이정구 on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class ShopInfoView: UIView {
    
    var avatarImgView: UIImageView!
    var titlelb: UILabel!
    var ratingView: CosmosView!
    var distancelb: UILabel!
    var sellNumlb: UILabel!
    var commentlb: UILabel!
    var discountlb: UILabel!
    let infoHeight: CGFloat = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        makeConstraints()
    }
    
    func makeUI() {
        
        backgroundColor = UIColor.white
        
        avatarImgView = UIImageView()
        avatarImgView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(avatarImgView)

        titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 15)
        titlelb.text = "正新鸡排"
        addSubview(titlelb)
       
        ratingView = CosmosView()
        ratingView.settings.emptyBorderColor = UIColor.orange
        ratingView.settings.filledBorderColor = UIColor.orange
        ratingView.settings.emptyColor = UIColor.clear
        ratingView.settings.emptyBorderWidth = 0.8
        ratingView.settings.starSize = 15
        ratingView.settings.starMargin = 5
        ratingView.rating = 3.5
        addSubview(ratingView)
    
        distancelb = UILabel()
        distancelb.textColor = UIColor.YClightGrayColor
        distancelb.font = UIFont.systemFont(ofSize: 13)
        distancelb.text = "124m"
        addSubview(distancelb)
      
        sellNumlb = UILabel()
        sellNumlb.textColor = UIColor.YClightGrayColor
        sellNumlb.font = UIFont.systemFont(ofSize: 13)
        sellNumlb.text = "月售1024"
        addSubview(sellNumlb)
   
        commentlb = UILabel()
        commentlb.textColor = UIColor.YClightGrayColor
        commentlb.font = UIFont.systemFont(ofSize: 13)
        commentlb.text = "256评论"
        addSubview(commentlb)
      
        discountlb = UILabel()
        discountlb.textColor = UIColor.white
        discountlb.font = UIFont.systemFont(ofSize: 15)
        discountlb.layer.backgroundColor = UIColor(red: 30, green: 184, blue: 59).cgColor
        let cornerRadius = UIFont.systemFont(ofSize: 15).pointSize * 1.5 / 2.0
        discountlb.layer.cornerRadius = cornerRadius
        discountlb.textAlignment = .center
        discountlb.text = "特价优惠"
        addSubview(discountlb)
     
        
    }
    
    func makeConstraints() {
        
        avatarImgView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(15)
            make.height.equalTo(avatarImgView.snp.width)
            make.height.equalTo(self).multipliedBy(0.85)
            make.centerY.equalTo(self)
        }
        
        titlelb.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.top.equalTo(avatarImgView)
        }
        
        ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(titlelb.snp.bottom).offset(10)
            make.leading.equalTo(titlelb)
            make.width.equalTo(100)
            make.height.equalTo(16)
        }
        
        distancelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-15)
            make.centerY.equalTo(ratingView)
        }
        
        sellNumlb.snp.makeConstraints { (make) in
            make.leading.equalTo(ratingView)
            make.top.equalTo(ratingView.snp.bottom).offset(10)
        }
        
        commentlb.snp.makeConstraints { (make) in
            make.centerY.equalTo(sellNumlb)
            make.leading.equalTo(sellNumlb.snp.trailing).offset(10)
        }
        
        discountlb.snp.makeConstraints { (make) in
            make.leading.equalTo(titlelb)
            make.bottom.equalTo(avatarImgView)
            make.height.equalTo(UIFont.systemFont(ofSize: 15).pointSize * 1.5)
            make.width.equalTo(UIFont.systemFont(ofSize: 15).pointSize * 5)
        }
        
    }
    
    override func didMoveToSuperview() {
        if let superView = self.superview {
         self.frame = CGRect(x: 0, y: superView.frame.height, width: superView.frame.width, height: infoHeight)
        UIView.animate(withDuration: 0.3) {
            if #available(iOS 11.0, *) {
                let maxY = superView.safeAreaLayoutGuide.layoutFrame.maxY
                self.frame = CGRect(x: 0, y: maxY - self.infoHeight, width: superView.frame.width, height: self.infoHeight)
            } else {
                self.frame = CGRect(x: 0, y: superView.frame.height - self.infoHeight, width: superView.frame.width, height: self.infoHeight)
            }
        }
      }
    }
    
    func showInView(_ view: UIView) {
        view.addSubview(self)
    }
    
    func hide() {
        guard let superView = self.superview else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: superView.frame.height, width: superView.frame.width, height: self.infoHeight)
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
