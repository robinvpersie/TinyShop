//
//  SearchListCell.swift
//  Portal
//
//  Created by 이정구 on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class SearchListCell: UITableViewCell {
    
    var avatarImgView: UIImageView!
    var titlelb: UILabel!
    var distancelb: UILabel!
    var ratingView: CosmosView!
    var countlb: UILabel!
    var numlb: UILabel!
    var redBtn: UIButton!
    var rightScopeBtn: UIButton!
    var descriptionlb: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImgView = UIImageView()
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(avatarImgView)
        
        titlelb = UILabel()
        titlelb.numberOfLines = 1
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 17)
        titlelb.text = "这是餐馆"
        contentView.addSubview(titlelb)
        
        distancelb = UILabel()
        distancelb.numberOfLines = 1
        distancelb.textColor = UIColor.lightGray
        distancelb.font = UIFont.systemFont(ofSize: 14)
        distancelb.text = "1.5km"
        contentView.addSubview(distancelb)
        
        ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .full
        ratingView.settings.starSize = 20
        ratingView.settings.starMargin = 3
        ratingView.settings.filledColor = UIColor.orange
        ratingView.settings.emptyBorderColor = UIColor.orange
        ratingView.settings.filledBorderColor = UIColor.orange
        contentView.addSubview(ratingView)
        
        countlb = UILabel()
        countlb.numberOfLines = 1
        countlb.textColor = UIColor.darkText
        countlb.font = UIFont.systemFont(ofSize: 14)
        countlb.text = "三个四个"
        contentView.addSubview(countlb)
        
        numlb = UILabel()
        numlb.numberOfLines = 1
        numlb.textColor = UIColor.darkText
        numlb.font = UIFont.systemFont(ofSize: 14)
        numlb.text = "一个两个"
        contentView.addSubview(numlb)
        
        redBtn = UIButton(type: .custom)
        redBtn.addTarget(self, action: #selector(didRed), for: .touchUpInside)
        redBtn.setTitle("按钮", for: .normal)
        redBtn.setTitleColor(UIColor.white, for: .normal)
        redBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        redBtn.layer.backgroundColor = UIColor.red.cgColor
        redBtn.layer.cornerRadius = 2
        contentView.addSubview(redBtn)
        
        descriptionlb = UILabel()
        descriptionlb.numberOfLines = 1
        descriptionlb.font = UIFont.systemFont(ofSize: 15)
        descriptionlb.textColor = UIColor.lightGray
        descriptionlb.text = "这是一个cell"
        contentView.addSubview(descriptionlb)
        
        rightScopeBtn = UIButton(type: .custom)
        rightScopeBtn.setImage(nil, for: .normal)
        contentView.addSubview(rightScopeBtn)
        
        makeConstraints()
        
    }
    
    class func getHeight() -> CGFloat {
        let titleHeight: CGFloat = UIFont.systemFont(ofSize: 17).lineHeight
        let starHeight: CGFloat = 20.0
        let countHeight: CGFloat = UIFont.systemFont(ofSize: 14).lineHeight
        let redBtnHeight: CGFloat = UIFont.systemFont(ofSize: 13).pointSize * 1.5
        return (titleHeight + starHeight + countHeight + redBtnHeight + 15) / 0.85
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRaius = self.frame.height * 0.85 / 2.0
        avatarImgView.layer.cornerRadius = cornerRaius
    }
    
    func makeConstraints() {
        
        titlelb.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(8)
            make.top.equalTo(avatarImgView)
            make.trailing.equalTo(distancelb.snp.leading).offset(-5)
        }
        
        distancelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.top.equalTo(avatarImgView)
        }
        
        ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(titlelb.snp.bottom).offset(5)
            make.leading.equalTo(titlelb)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        countlb.snp.makeConstraints { (make) in
            make.leading.equalTo(titlelb)
            make.top.equalTo(ratingView.snp.bottom).offset(5)
        }
        
        numlb.snp.makeConstraints { (make) in
            make.leading.equalTo(countlb.snp.trailing).offset(15)
            make.top.equalTo(countlb)
        }
        
        redBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(titlelb)
            make.top.equalTo(countlb.snp.bottom).offset(5)
            make.width.equalTo(70)
            make.height.equalTo(UIFont.systemFont(ofSize: 13).pointSize * 1.5)
        }
        
        descriptionlb.snp.makeConstraints { (make) in
            make.centerY.equalTo(redBtn)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        avatarImgView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(avatarImgView.snp.height)
            make.height.equalTo(contentView).multipliedBy(0.85)
        }
        
        
    }
    
    @objc func didRed() {
        
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
