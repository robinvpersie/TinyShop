//
//  OffShopCarCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OffShopCarCell: UITableViewCell {
    
   enum actionType {
        case add
        case minus
    }
    
    var imgView:UIImageView!
    var namelb:UILabel!
    var priceAmountlb:UILabel!
    var line:UIView!
    var underline:UIView!
    var minusBtn:UIButton!
    var addBtn:UIButton!
    var amountlb:UILabel!
    var unitPricelb:UILabel!
    var unitQuantitylb:UILabel!
    var stockQuantitylb:UILabel!
    var leadingConstraint:NSLayoutConstraint!
    var plaintlb:UILabel!
    var actionBlock:((_ type:actionType,_ price:Double)->())?
    var model:OffShopCarModel!{
        didSet{
            namelb.text = model.name
            priceAmountlb.text = "￥\(model.price)"
            amountlb.text = "\(model.quantity)"
            unitPricelb.text = model.unitPrice
            unitQuantitylb.text = model.unitQuantity
            if model.stockQuantity != nil {
             stockQuantitylb.text = "库存\(model.stockQuantity!)"
            }
            if model.unitPrice != nil {
                leadingConstraint.priority = 1000
            }else {
                leadingConstraint.priority = 998
            }
            imgView.kf.setImage(with: model.imgUrl)
            plaintlb.isHidden = model.isEmptyStock ? false : true
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none 
        
        imgView = UIImageView()
        contentView.addSubview(imgView)

        namelb = UILabel()
        namelb.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        namelb.textColor = UIColor.darkcolor
        namelb.numberOfLines = 1
        contentView.addSubview(namelb)
        
        unitPricelb = UILabel()
        unitPricelb.textColor = UIColor.YClightGrayColor
        unitPricelb.font = UIFont.systemFont(ofSize: 12)
        unitPricelb.numberOfLines = 1
        contentView.addSubview(unitPricelb)
        
        unitQuantitylb = UILabel()
        unitQuantitylb.font = UIFont.systemFont(ofSize: 12)
        unitQuantitylb.textColor = UIColor.YClightGrayColor
        unitQuantitylb.numberOfLines = 1
        unitQuantitylb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(unitQuantitylb)
        
        stockQuantitylb = UILabel()
        stockQuantitylb.font = UIFont.systemFont(ofSize: 12)
        stockQuantitylb.textColor = UIColor.YClightGrayColor
        stockQuantitylb.numberOfLines = 1
        contentView.addSubview(stockQuantitylb)
        
        plaintlb = UILabel()
        plaintlb.font = UIFont.systemFont(ofSize: 10)
        plaintlb.textColor = UIColor.white
        plaintlb.text = "!"
        plaintlb.layer.backgroundColor = UIColor.navigationbarColor.cgColor
        plaintlb.layer.cornerRadius = UIFont.systemFont(ofSize: 12).lineHeight/2.0
        plaintlb.textAlignment = .center
        contentView.addSubview(plaintlb)
        
        priceAmountlb = UILabel()
        priceAmountlb.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        priceAmountlb.textColor = UIColor.navigationbarColor
        contentView.addSubview(priceAmountlb)

        line = UIView()
        line.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line)
        
        underline = UIView()
        underline.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(underline)
        
        let bottomView = UIView()
        contentView.addSubview(bottomView)

        let amountDescriptionlb = UILabel()
        amountDescriptionlb.textColor = UIColor(hex: 0x999999)
        amountDescriptionlb.font = UIFont.systemFont(ofSize: 14)
        amountDescriptionlb.text = "数量"
        bottomView.addSubview(amountDescriptionlb)

        addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "icon_add"), for: .normal)
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        bottomView.addSubview(addBtn)

        minusBtn = UIButton(type: .custom)
        minusBtn.setImage(UIImage(named:"icon_minus"), for: .normal)
        minusBtn.addTarget(self, action: #selector(minus), for: .touchUpInside)
        bottomView.addSubview(minusBtn)

        amountlb = UILabel()
        amountlb.font = UIFont.systemFont(ofSize: 14)
        amountlb.textColor = UIColor(hex: 0x999999)
        amountlb.backgroundColor = UIColor(hex: 0xe5e5e5)
        amountlb.textAlignment = .center
        bottomView.addSubview(amountlb)
        
        imgView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(10)
            make.width.height.equalTo(60)
        }

        namelb.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(5)
            make.top.equalTo(imgView).offset(5)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        unitPricelb.snp.makeConstraints { (make) in
            make.leading.equalTo(namelb)
            make.height.equalTo(UIFont.systemFont(ofSize: 12).lineHeight)
            make.top.equalTo(namelb.snp.bottom).offset(5)
        }
        
        leadingConstraint = NSLayoutConstraint(item: unitQuantitylb, attribute: .leading, relatedBy: .equal, toItem: unitPricelb, attribute: .trailing, multiplier: 1.0, constant: 5)
        leadingConstraint.priority = 1000
        let leading2 = NSLayoutConstraint(item: unitQuantitylb, attribute: .leading, relatedBy: .equal, toItem: unitPricelb, attribute: .trailing, multiplier: 1.0, constant: 0)
        leading2.priority = 999
        let top = NSLayoutConstraint(item: unitQuantitylb, attribute: .top, relatedBy: .equal, toItem: unitPricelb, attribute: .top, multiplier: 1.0, constant: 0)
        let height = NSLayoutConstraint(item: unitQuantitylb, attribute: .height, relatedBy: .equal, toItem: unitPricelb, attribute: .height, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,leading2,top,height])
        
        
        stockQuantitylb.snp.makeConstraints { (make) in
            make.leading.equalTo(namelb)
            make.top.equalTo(unitPricelb.snp.bottom).offset(5)
        }
        
        plaintlb.snp.makeConstraints { (make) in
            make.leading.equalTo(stockQuantitylb.snp.trailing).offset(5)
            make.width.height.equalTo(UIFont.systemFont(ofSize: 12).lineHeight)
            make.top.equalTo(stockQuantitylb)
        }
        
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.top.equalTo(contentView).offset(80)
            make.height.equalTo(1.2)
        }
        
        underline.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(1.2)
        }
        
        priceAmountlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.bottom.equalTo(line.snp.top).offset(-5)
        }

        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(contentView)
            make.top.equalTo(line.snp.bottom)
        }

        amountDescriptionlb.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.leading.equalTo(bottomView).offset(15)
        }

        addBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(bottomView).offset(-15)
            make.width.height.equalTo(25)
            make.centerY.equalTo(bottomView)
        }

        amountlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(addBtn.snp.leading).offset(-5)
            make.height.equalTo(addBtn)
            make.width.equalTo(40)
            make.centerY.equalTo(bottomView)
        }

        minusBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(amountlb.snp.leading).offset(-5)
            make.width.height.centerY.equalTo(addBtn)
        }
        
        
    }
    
    
    @objc func minus(){
        if model.quantity == 1 {
            return 
        }
//        model.quantity -= 1
//        model.price -= model.unitPrice
//        priceAmountlb.text = "\(model.price)"
//        amountlb.text = "\(model.quantity)"
        actionBlock?(.minus,model.price)
    }
    
    @objc func add(){
//        model.quantity += 1
//        model.price += model.unitPrice
//        amountlb.text = "\(model.quantity)"
    //        priceAmountlb.text = "\(model.price)"
        actionBlock?(.add,model.price)
    }
    
    class func getHeight() -> CGFloat {
        return 123
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
