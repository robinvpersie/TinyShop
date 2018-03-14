//
//  PersonalStarHeaderView.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class PersonalStarHeaderView: UIView {
    
    lazy var imageView:UIImageView = {
       let imageView = UIImageView(frame: CGRect.zero)
       imageView.layer.masksToBounds = true
       imageView.layer.cornerRadius = 18
       return imageView
    }()
    
    
    lazy var timelabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.YClightGrayColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    
    }()
    
    lazy var namelabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.YClightGrayColor
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var starImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.Tapgesture)
        return imageView
    }()
    
    lazy var Tapgesture:UITapGestureRecognizer = {
       let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didClickStarImageView(gesture:)))
       return gesture
    }()
    
    lazy var starLabel:UILabel = {
       let label = UILabel()
        label.textColor = UIColor.navigationbarColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    var didclickStarImage:((_ isstar:Bool) -> ())?
    
    
    func didClickStarImageView(gesture:UITapGestureRecognizer){
        
        scaleStarImage()
        if dataModel!.isStar! {
        dataModel!.recommandCount = dataModel!.recommandCount - 1
        }else {
        dataModel!.recommandCount = dataModel!.recommandCount + 1
        }
        dataModel!.isStar = !dataModel!.isStar!
        setRecommend()
        if let didclickStarImage = didclickStarImage {
            didclickStarImage(dataModel!.isStar!)
        }
    }
    
    func setRecommend(){
        NetWorkManager.manager.SetStar(newsSeq: dataModel!.BannerSeq, replySeq: dataModel!.ReplySeq, failureHandler: { (reason,message) in
           
        }, completion: { data in
            let resultCode = data!["ResultCode"] as? Int
            if resultCode == 0 {
              
            }
        })
    }
    
    var dataModel:RecommanddatPersonalCenter?
    
    func scaleStarImage(){
        
       let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = 1.0
        animation.toValue = 1.4
        animation.delegate = self
        starImageView.layer.add(animation, forKey: "scale_layer")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(timelabel)
        addSubview(namelabel)
        addSubview(starImageView)
        addSubview(starLabel)
        MakeConstraints()
    }
    
    func MakeConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(imageView.snp.height).multipliedBy(1)
        }
        
        namelabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.top.equalTo(imageView.snp.top)
        }
        
        timelabel.snp.makeConstraints { (make) in
            make.left.equalTo(namelabel.snp.left)
            make.bottom.equalTo(imageView.snp.bottom)
        }
        
        starImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        starLabel.snp.makeConstraints { (make) in
            make.right.equalTo(starImageView.snp.left).offset(-5)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    class func getHeight() -> CGFloat {
        return 36.0
    }
    
    func updateWithModel(model:RecommanddatPersonalCenter){
         dataModel = model
         timelabel.text = model.date
         namelabel.text = model.NickName
         starLabel.text = "\(model.recommandCount)"
         imageView.kf.setImage(with: URL(string:model.imgUrl!),placeholder:UIImage.YCAvatarPlaceHolderImage, options: nil)
         boring()
    }
    
    
    func boring(){
        if let isStar = dataModel!.isStar {
            if isStar {
                self.starImageView.image = UIImage.redlike
                self.starLabel.textColor = UIColor.navigationbarColor
            }else {
                self.starImageView.image = UIImage.nolike
                self.starLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonalStarHeaderView:CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        boring()
        self.starLabel.text = "\(dataModel!.recommandCount)"
    }
}
