//
//  OrderAddressCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderAddressCell: UITableViewCell {
    
    var addressLable:UILabel!
    var cosmosView:CosmosView!
    var shareItem:UIButton!
    var collectItem:UIButton!
    var shareAction:(()->Void)?
    var collectAction:(()->Void)?
    
    var orderInfoModel:OrderFoodModel?{
        didSet{
            if let model = orderInfoModel {
               addressLable.text = model.data.restaurantName
               cosmosView.rating = Double(model.data.rate)!/2
            }
        }
    }
    
    var favoriteYN:String?{
        didSet{
            let image = favoriteYN == "Y" ? UIImage(named: "icon_h") : UIImage.collectImage
            collectItem.setImage(image, for: .normal)
        }
    }
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addressLable = UILabel()
        addressLable.textColor = UIColor.black
        addressLable.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(addressLable)
        addressLable.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(10)
            make.height.equalTo(20)
        }
        
        cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .full
        cosmosView.settings.starSize = 15
        cosmosView.settings.starMargin = 1
        cosmosView.settings.filledColor = UIColor.orange
        cosmosView.settings.emptyBorderColor = UIColor.orange
        cosmosView.settings.filledBorderColor = UIColor.orange
        contentView.addSubview(cosmosView)
        cosmosView.snp.makeConstraints { (make) in
            make.top.equalTo(addressLable.snp.bottom).offset(5)
            make.leading.equalTo(addressLable)
            make.height.equalTo(15)
            make.width.equalTo(80)
        }
        
        shareItem = UIButton(type: .custom)
        shareItem.setImage(UIImage.shareImage, for: .normal)
        shareItem.setImage(nil, for: .highlighted)
        shareItem.addTarget(self, action: #selector(share), for: .touchUpInside)
        contentView.addSubview(shareItem)
        shareItem.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(44)
        }
        
        collectItem = UIButton(type: .custom)
        collectItem.addTarget(self, action: #selector(collect), for: .touchUpInside)
        contentView.addSubview(collectItem)
        collectItem.snp.makeConstraints { (make) in
            make.trailing.equalTo(shareItem.snp.leading).offset(10)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(shareItem)
        }
        
    }
    
    func collect(){
        collectAction?()
    }
    
    func share(){
       shareAction?()
    }
    
    class func getHeight() -> CGFloat{
        return 65
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

