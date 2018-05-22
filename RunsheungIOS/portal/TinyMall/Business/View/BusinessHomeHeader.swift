//
//  BusinessHomeHeader.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessHomeHeader: UIView {
    
    var avatarBigImgView: UIImageView!
    var avatarlittleImgView: UIImageView!
    var avatarBlurView: UIVisualEffectView!
    var businessNamelb: UILabel!
    var sellNumlb: UILabel!
    var rationNum: UILabel!
    var ratioStarView: CosmosView!
    var telView: UIButton!
    private var commentInfoView: InfoView!
    private var replyInfoView: InfoView!
    private var distanceInfoView: InfoView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarBigImgView = UIImageView()
        addSubview(avatarBigImgView)
        avatarBigImgView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(150.hrpx)
        }
        
        let effect = UIBlurEffect(style: .light)
        avatarBlurView = UIVisualEffectView(effect: effect)
        addSubview(avatarBlurView)
        avatarBlurView.snp.makeConstraints { make in
            make.edges.equalTo(avatarBigImgView)
        }
        
        avatarlittleImgView = UIImageView()
        avatarlittleImgView.layer.shadowOffset = CGSize(width: 0, height: -1)
        avatarlittleImgView.layer.shadowColor = UIColor.darkText.withAlphaComponent(0.7).cgColor
        addSubview(avatarlittleImgView)
        avatarlittleImgView.snp.makeConstraints { make in
            make.bottom.equalTo(avatarBigImgView).offset(20.hrpx)
            make.width.height.equalTo(75.wrpx)
            make.left.equalTo(self).offset(15.wrpx)
        }
        
        businessNamelb = UILabel()
        businessNamelb.font = UIFont.boldSystemFont(ofSize: 19)
        businessNamelb.textColor = UIColor.white
        addSubview(businessNamelb)
        businessNamelb.snp.makeConstraints { make in
            make.left.equalTo(avatarlittleImgView.snp.right).offset(8)
            make.right.equalTo(self).offset(-15.wrpx)
            make.top.equalTo(avatarlittleImgView)
        }
        
        sellNumlb = UILabel()
        sellNumlb.textColor = UIColor.white
        sellNumlb.font = UIFont.systemFont(ofSize: 13)
        addSubview(sellNumlb)
        sellNumlb.snp.makeConstraints { make in
            make.left.equalTo(businessNamelb)
            make.top.equalTo(businessNamelb.snp.bottom).offset(20.hrpx)
        }
        
        let bottomContainer = UIView()
        bottomContainer.backgroundColor = UIColor.white
        addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(avatarBigImgView.snp.bottom)
            make.height.equalTo(80.hrpx)
        }
        
        rationNum = UILabel()
        rationNum.textColor = UIColor(red: 255, green: 201, blue: 40)
        rationNum.font = UIFont.boldSystemFont(ofSize: 24)
        rationNum.textAlignment = .center
        bottomContainer.addSubview(rationNum)
        rationNum.snp.makeConstraints { make in
            make.left.equalTo(15.wrpx)
            make.width.equalTo(75.wrpx)
            make.top.equalTo(bottomContainer).offset(30.hrpx)
        }
        
        ratioStarView = CosmosView()
        ratioStarView.settings.emptyColor = UIColor.groupTableViewBackground
        ratioStarView.settings.filledColor = UIColor(red: 255, green: 201, blue: 40)
        ratioStarView.settings.fillMode = .precise
        ratioStarView.settings.starSize = 20
        ratioStarView.settings.starMargin = 4
        ratioStarView.settings.updateOnTouch = false
        bottomContainer.addSubview(ratioStarView)
        ratioStarView.snp.makeConstraints { make in
            make.center.equalTo(rationNum)
            make.top.equalTo(rationNum.snp.bottom).offset(10.hrpx)
            make.height.equalTo(20.hrpx)
            make.width.equalTo(120)
        }
        
        telView = UIButton(type: .custom)
        telView.setImage(UIImage(named: "icon_phonenumber"), for: .normal)
        telView.addTarget(self, action: #selector(tel), for: .touchUpInside)
        bottomContainer.addSubview(telView)
        telView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.equalTo(bottomContainer).offset(-15)
            make.bottom.equalTo(bottomContainer).offset(30.hrpx)
        }
        
        let vline = UIView()
        vline.backgroundColor = UIColor.groupTableViewBackground
        bottomContainer.addSubview(vline)
        vline.snp.makeConstraints { make in
            make.right.equalTo(telView.snp.left).offset(-15)
            make.bottom.equalTo(bottomContainer).offset(-20)
            make.width.equalTo(0.8)
            make.height.equalTo(50)
        }
        
        commentInfoView = InfoView()
        replyInfoView = InfoView()
        distanceInfoView = InfoView()
        
        let stackView = UIStackView(arrangedSubviews: [commentInfoView, replyInfoView, distanceInfoView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        bottomContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.right.equalTo(vline.snp.left).offset(-20)
            make.left.equalTo(ratioStarView.snp.right).offset(30)
            make.bottom.equalTo(vline)
            make.height.equalTo(60)
        }
        
        let bottomline = UIView()
        bottomline.backgroundColor = UIColor.groupTableViewBackground
        bottomContainer.addSubview(bottomline)
        bottomContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(bottomContainer)
            make.height.equalTo(0.8)
        }
        
        
    }
    
    @objc func tel() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private class InfoView: UIView {
    
    var numlb: UILabel!
    var infolb: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        numlb = UILabel()
        numlb.textColor = UIColor(hex: 0x111111)
        numlb.font = UIFont.systemFont(ofSize: 15)
        
        infolb = UILabel()
        infolb.textColor = UIColor(hex: 0x999999)
        infolb.font = UIFont.systemFont(ofSize: 15)
        
        let stackView = UIStackView(arrangedSubviews: [numlb, infolb])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    func reloadData() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
