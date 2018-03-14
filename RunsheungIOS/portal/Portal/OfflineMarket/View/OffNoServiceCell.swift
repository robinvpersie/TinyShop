//
//  OffNoServiceCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OffNoServiceCell: UITableViewCell {
    
    var imgView:UIImageView!
    var titlelb:UILabel!
    var goodnumlb:UILabel!
    var timelb:UILabel!
    var pricelb:UILabel!
    var model:OffOrderListModel.Orderlis! {
        didSet {
            let mutableattributeString = NSMutableAttributedString()
            let attributeDic = [
                NSFontAttributeName:UIFont.systemFont(ofSize: 13),
                NSForegroundColorAttributeName:UIColor.YClightGrayColor
            ]
            let attributeString = NSAttributedString(string: "总金额:", attributes: attributeDic)
            mutableattributeString.append(attributeString)
            let priceDic = [
                NSFontAttributeName:UIFont.systemFont(ofSize: 13),
                NSForegroundColorAttributeName:UIColor.navigationbarColor
            ]
            let price = "￥" + model.realAmount
            let priceString = NSAttributedString(string: price, attributes: priceDic)
            mutableattributeString.append(priceString)
            pricelb.attributedText = mutableattributeString
            timelb.text = model.orderDate
            let itemNameCnt = model.itemNameCnt.components(separatedBy: "|")
            titlelb.text = itemNameCnt[0]
            goodnumlb.text = "商品数量" + itemNameCnt[2]
            imgView.kf.setImage(with: URL(string:itemNameCnt[1]))
        }
    }
    
    var foodModel:OffFoodListModel.Foodorderlis! {
        didSet {
            let mutableattributeString = NSMutableAttributedString()
            let attributeDic = [
                NSFontAttributeName:UIFont.systemFont(ofSize: 13),
                NSForegroundColorAttributeName:UIColor.YClightGrayColor
            ]
            let attributeString = NSAttributedString(string: "总金额:", attributes: attributeDic)
            mutableattributeString.append(attributeString)
            let priceDic = [
                NSFontAttributeName:UIFont.systemFont(ofSize: 13),
                NSForegroundColorAttributeName:UIColor.navigationbarColor
            ]
            let price = "￥" + foodModel.realAmount
            let priceString = NSAttributedString(string: price, attributes: priceDic)
            mutableattributeString.append(priceString)
            pricelb.attributedText = mutableattributeString
            timelb.text = foodModel.orderDate
            titlelb.text = foodModel.itemNameCnt
            goodnumlb.text = "商品数量" + foodModel.rnum
            imgView.kf.setImage(with: foodModel.itemImageUrl)

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgView)
        
        titlelb = UILabel()
        titlelb.font = UIFont.systemFont(ofSize: 17)
        titlelb.textColor = UIColor.darkcolor
        titlelb.numberOfLines = 1
        titlelb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titlelb)
        
        goodnumlb = UILabel()
        goodnumlb.numberOfLines = 1
        goodnumlb.font = UIFont.systemFont(ofSize: 13)
        goodnumlb.textColor = UIColor.YClightGrayColor
        goodnumlb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(goodnumlb)
        
        timelb = UILabel()
        timelb.font = UIFont.systemFont(ofSize: 13)
        timelb.textColor = UIColor.YClightGrayColor
        timelb.numberOfLines = 1
        timelb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timelb)
        
        pricelb = UILabel()
        pricelb.font = UIFont.systemFont(ofSize: 13)
        pricelb.numberOfLines = 1
        pricelb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pricelb)
        
        let imgHeight = titlelb.font.lineHeight + goodnumlb.font.lineHeight * 3 + 30
        
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        
        titlelb.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        titlelb.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        titlelb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        titlelb.heightAnchor.constraint(equalToConstant: titlelb.font.lineHeight).isActive = true
        
        goodnumlb.leadingAnchor.constraint(equalTo: titlelb.leadingAnchor).isActive = true
        goodnumlb.topAnchor.constraint(equalTo: titlelb.bottomAnchor, constant: 10).isActive = true
        goodnumlb.trailingAnchor.constraint(equalTo: titlelb.trailingAnchor).isActive = true
        goodnumlb.heightAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: 13).lineHeight).isActive = true
        
        timelb.leadingAnchor.constraint(equalTo: goodnumlb.leadingAnchor).isActive = true
        timelb.trailingAnchor.constraint(equalTo: goodnumlb.trailingAnchor).isActive = true
        timelb.topAnchor.constraint(equalTo: goodnumlb.bottomAnchor, constant: 10).isActive = true
        timelb.heightAnchor.constraint(equalTo: goodnumlb.heightAnchor).isActive = true
        
        pricelb.leadingAnchor.constraint(equalTo: timelb.leadingAnchor).isActive = true
        pricelb.trailingAnchor.constraint(equalTo: timelb.trailingAnchor).isActive = true
        pricelb.heightAnchor.constraint(equalTo: timelb.heightAnchor).isActive = true
        pricelb.topAnchor.constraint(equalTo: timelb.bottomAnchor, constant: 10).isActive = true
    }
    

    class func getHeight() -> CGFloat {
        let height = UIFont.systemFont(ofSize: 17).lineHeight + UIFont.systemFont(ofSize: 13).lineHeight * 3 + 30 + 30
        return height
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
