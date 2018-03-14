//
//  MenuFoodCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/4.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MenuFoodCell: UITableViewCell,CAAnimationDelegate {
    
    var foodImageView:UIImageView!
    var name:UILabel!
    var priceLabel:UILabel!
    var menuCountView:UIView!
    var addBtn:UIButton!
    var subBtn:UIButton!
    var countLable:UILabel!
    var countAction: ((_ num:Int,_ type:actionType)->Void)?
    var btnWidth:CGFloat = 24
    var type:actionType = .none
    var subtraingConstraint:Constraint? = nil

    var totalnum:Int = 0{
        didSet{
           countLable.text = "\(totalnum)"
        }
    }
    
    enum actionType{
        case none
        case addAction
        case subAction
    }
    
    
    func updateWithModel(_ model:Menulis){
       foodImageView.kf.setImage(with: model.imageURL, options: [.transition(.fade(0.6))])
       name.text = model.itemName
       priceLabel.text = "￥" + "\(model.itemAmount)"
    }
    
    
    func updateNum(_ num:Int?){
        if let newnum = num {
            if newnum > 0 {
                countLable.isHidden = false
                totalnum = newnum
                subtraingConstraint?.update(offset: -(78-btnWidth)) 
               
            }else {
                countLable.isHidden = true
                totalnum = 0
                subtraingConstraint?.update(offset: 0)
            }
       }else {
            countLable.isHidden = true
            totalnum = 0
            subtraingConstraint?.update(offset: 0)
        }
     }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        foodImageView = UIImageView()
        foodImageView.kf.indicatorType = .activity
        contentView.addSubview(foodImageView)
        foodImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.equalTo(70)
        }
        
        name = UILabel()
        name.textColor = UIColor.darkcolor
        name.font = UIFont.systemFont(ofSize: 15)
        name.numberOfLines = 2
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.leading.equalTo(foodImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.top.equalTo(foodImageView)
        }
        
        priceLabel = UILabel()
        priceLabel.textColor = UIColor.navigationbarColor
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(foodImageView.snp.trailing).offset(10)
            make.bottom.equalTo(foodImageView)
        }
        
        menuCountView = UIView()
        contentView.addSubview(menuCountView)
        menuCountView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-10)
            make.width.equalTo(78)
            make.bottom.equalTo(priceLabel)
            make.height.equalTo(26)
        }
        
        subBtn = UIButton(type: .custom)
        subBtn.setTitle("-", for: .normal)
        subBtn.setTitleColor(UIColor.darkcolor, for: .normal)
        subBtn.addTarget(self, action: #selector(sub), for: .touchUpInside)
        subBtn.backgroundColor = UIColor.white
        subBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        subBtn.layer.masksToBounds = true
        subBtn.layer.cornerRadius = 12
        subBtn.layer.borderColor = UIColor.YClightGrayColor.cgColor
        subBtn.layer.borderWidth = 0.5
        menuCountView.addSubview(subBtn)
        subBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.btnWidth)
            make.centerY.equalTo(menuCountView)
            subtraingConstraint = make.trailing.equalTo(menuCountView).offset(0).constraint
        }
        
        
        addBtn = UIButton(type: .custom)
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        addBtn.backgroundColor = UIColor.navigationbarColor
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        addBtn.layer.masksToBounds = true
        addBtn.layer.cornerRadius = 12
        menuCountView.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.trailing.centerY.equalTo(menuCountView)
            make.width.height.equalTo(self.btnWidth)
        }
        
        countLable = UILabel()
        countLable.textAlignment = .center
        countLable.font = UIFont.systemFont(ofSize: 13)
        countLable.textColor = UIColor.darkcolor
        countLable.isHidden = true
        countLable.text = "\(totalnum)"
        menuCountView.addSubview(countLable)
        countLable.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(24)
            make.trailing.equalTo(addBtn.snp.leading)
            make.centerY.equalTo(menuCountView)
        }
     }
    
    func add(){
        type = .addAction
        if totalnum == 0 {
            countLable.isHidden = false
            addGroupAnimation()
        }
        totalnum = totalnum + 1
        countAction?(totalnum,type)
    }

    
    func sub(){
        if totalnum <= 0 {
          return
        }
        type = .subAction
        totalnum = totalnum - 1
        countAction?(totalnum,type)
        if totalnum == 0 {
            subGroupAnimation()
            countLable.isHidden = true
        }
    }
    
    
    func addGroupAnimation(){
        
        let startPoint = addBtn.center
        let endPoint = CGPoint(x: 12, y: addBtn.center.y)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.rotationMode = kCAAnimationRotateAuto
        animation.path = path.cgPath
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = Double.pi
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation,rotateAnimation]
        animationGroup.duration = 0.3
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        subBtn.layer.add(animationGroup, forKey: nil)
    }

    
    
    func subGroupAnimation(){
        
        let startPoint =  CGPoint(x: 12, y: addBtn.center.y)
        let endPoint =  addBtn.center
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.rotationMode = kCAAnimationRotateAuto
        animation.path = path.cgPath
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = Double.pi
        rotateAnimation.toValue = 0
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation,rotateAnimation]
        animationGroup.duration = 0.3
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        subBtn.layer.add(animationGroup, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            switch type {
            case .none:
                break
            case .addAction:
                self.subtraingConstraint?.update(offset: -(menuCountView.width - btnWidth))
            case .subAction:
                self.subtraingConstraint?.update(offset: 0)
            }
        }
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



