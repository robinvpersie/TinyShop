//
//  BusinessOrderCell.swift
//  Portal
//
//  Created by 이정구 on 2018/5/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessOrderCell: UITableViewCell {
    
    var productImgView: UIImageView!
    var productNamelb: UILabel!
    var sellNumlb: UILabel!
    var minmunPricelb: UILabel!
    var buyBtn: UIButton!
    var addBtn: UIButton!
    
    var addAction: (() -> ())?
    var buyAction: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        productImgView = UIImageView()
        contentView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.width.height.equalTo(70.hrpx)
            make.centerY.equalTo(contentView)
        }
        
        productNamelb = UILabel()
        productNamelb.textColor = UIColor.darkText
        productNamelb.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(productNamelb)
        productNamelb.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView.snp.right).offset(8)
            make.top.equalTo(productImgView)
        }
        
        sellNumlb = UILabel()
        sellNumlb.font = UIFont.systemFont(ofSize: 13)
        sellNumlb.textColor = UIColor(hex: 0x999999)
        contentView.addSubview(sellNumlb)
        sellNumlb.snp.makeConstraints { (make) in
            make.left.equalTo(productNamelb)
            make.centerY.equalTo(productImgView)
        }
        
        minmunPricelb = UILabel()
        contentView.addSubview(minmunPricelb)
        minmunPricelb.snp.makeConstraints { (make) in
            make.left.equalTo(productNamelb)
            make.bottom.equalTo(productImgView)
        }
        
        buyBtn = UIButton(type: .custom)
        buyBtn.addTarget(self, action: #selector(didBuy), for: .touchUpInside)
        buyBtn.setTitle("选购", for: .normal)
        buyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        buyBtn.setTitleColor(UIColor.white, for: .normal)
        buyBtn.layer.backgroundColor = UIColor(red: 31, green: 184, blue: 59).cgColor
        buyBtn.layer.cornerRadius = 15
        contentView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(productImgView)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        addBtn = UIButton(type: .custom)
        addBtn.addTarget(self, action: #selector(didAdd), for: .touchUpInside)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.setTitle("添加", for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addBtn.layer.backgroundColor = buyBtn.layer.backgroundColor
        addBtn.layer.cornerRadius = 15
        contentView.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(buyBtn)
        }
        
    }
    
    func configureWithPlist(_ plist: Plist) {
        productImgView.kf.setImage(with: URL(string: plist.image_url))
        productNamelb.text = plist.item_name
        sellNumlb.text = "주문수" + plist.MonthSaleCount
        
        let mutableAttributeString = NSMutableAttributedString()
        let priceAttributeStr = NSAttributedString(string: "￥\(plist.item_p)", attributes: [
            NSAttributedStringKey.foregroundColor: UIColor(hex: 0xdd0909),
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)])
        mutableAttributeString.append(priceAttributeStr)
        let startStr = NSAttributedString(string: "起", attributes: [
            NSAttributedStringKey.foregroundColor: UIColor(hex: 0x999999),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)])
        mutableAttributeString.append(startStr)
        minmunPricelb.attributedText = mutableAttributeString
        
        if plist.isSingle == "0" {
            addBtn.isHidden = true
            buyBtn.isHidden = false
        } else {
            addBtn.isHidden = false
            buyBtn.isHidden = true
        }
        
    }
    
    @objc func didAdd() {
        addAction?()
    }
    
    @objc func didBuy() {
        buyAction?()
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
