//
//  OrderCommentHeader.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit


public enum OrderFoodSelectType:Int {
    case all
    case image
}

class OrderCommentHeaderCell: UITableViewCell {
    
    var seperateView:UIView!
    var userCommentlb:UILabel!
    var rightarrow:UIButton!
    var segment:UISegmentedControl!
    var baseStackView:UIStackView!
    var leftStackView:UIStackView!
    var rightStackView:UIStackView!
    var pointLable:UILabel!
    var commentNun:UILabel!
    var taste:UILabel!
    var environment:UILabel!
    var service:UILabel!
    var selectIndex:Int = OrderFoodSelectType.all.rawValue
    var didClickType:((_ type:OrderFoodSelectType) -> Void)?
    var foodModel:OrderFoodModel?{
        didSet {
           guard let foodModel = foodModel else {
            return
           }
           taste.text = "口味".localized + foodModel.data.score1
           environment.text = "环境".localized + foodModel.data.score2
           service.text = "服务".localized + foodModel.data.score3
           commentNun.text = "(" + foodModel.data.rateCount + ") " + "评价".localized
            
           guard let score1 = Float(foodModel.data.score1),
            let score2 = Float(foodModel.data.score2),
            let score3 = Float(foodModel.data.score3) else {
                return
            }
           let averageValue = (score1+score2+score3)/3.0
           pointLable.text = "\(averageValue)"
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        userCommentlb = UILabel()
        userCommentlb.textColor = UIColor.darkcolor
        userCommentlb.font = UIFont.systemFont(ofSize: 18)
        userCommentlb.text = "用户点评".localized
        contentView.addSubview(userCommentlb)
        userCommentlb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(5)
            make.height.equalTo(20)
        }
        
        segment = UISegmentedControl()
        segment.tintColor = UIColor.navigationbarColor
        segment.insertSegment(withTitle: "全部".localized, at: 0, animated: false)
        segment.insertSegment(withTitle: "晒图".localized, at: 1, animated: false)
        contentView.addSubview(segment)
        segment.addTarget(self, action: #selector(controlPressed(segment:)), for: .valueChanged)
        segment.selectedSegmentIndex = selectIndex
        segment.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(userCommentlb.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        baseStackView = UIStackView()
        baseStackView.axis = .horizontal
        baseStackView.alignment = .center
        baseStackView.spacing = 10
        contentView.addSubview(baseStackView)
        baseStackView.snp.makeConstraints { (make) in
           make.centerX.equalTo(contentView)
           make.top.equalTo(segment.snp.bottom).offset(10)
           make.height.equalTo(90)
        }
        
        leftStackView = UIStackView()
        leftStackView.distribution = .equalSpacing
        leftStackView.alignment = .center
        leftStackView.axis = .vertical
        baseStackView.addArrangedSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        
        rightStackView = UIStackView()
        rightStackView.distribution = .equalSpacing
        rightStackView.alignment = .center
        rightStackView.axis = .vertical
        baseStackView.addArrangedSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        
        pointLable = UILabel()
        pointLable.textColor = UIColor.orange
        pointLable.font = UIFont.systemFont(ofSize: 20)
        pointLable.textAlignment = .center
        leftStackView.addArrangedSubview(pointLable)
        
        commentNun = UILabel()
        commentNun.textColor = UIColor.YClightGrayColor
        commentNun.font = UIFont.systemFont(ofSize: 12)
        leftStackView.addArrangedSubview(commentNun)
        
        taste = UILabel()
        taste.textColor = UIColor.YClightGrayColor
        taste.font = UIFont.systemFont(ofSize: 12)
        rightStackView.addArrangedSubview(taste)
        
        environment = UILabel()
        environment.textColor = UIColor.YClightGrayColor
        environment.font = UIFont.systemFont(ofSize: 12)
        rightStackView.addArrangedSubview(environment)
        
        service = UILabel()
        service.textColor = UIColor.YClightGrayColor
        service.font = UIFont.systemFont(ofSize: 12)
        rightStackView.addArrangedSubview(service)
    }
    
    class func getHeight() -> CGFloat {
        return 5 + 20 + 10 + 30 + 10 + 100
    }
    
    func controlPressed(segment:UISegmentedControl){
         guard let selectdType = OrderFoodSelectType(rawValue: segment.selectedSegmentIndex) else { return }
         if let didClickType = didClickType {
            didClickType(selectdType)
        }
    }
    
    func clickRight(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
