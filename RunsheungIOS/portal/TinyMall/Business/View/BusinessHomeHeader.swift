//
//  BusinessHomeHeader.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher

class BusinessHomeHeader: UIView {
    
    var avatarBigImgView: UIImageView!
    var avatarlittleImgView: UIImageView!
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
        
        backgroundColor = UIColor.white
        
        avatarBigImgView = UIImageView()
        addSubview(avatarBigImgView)
        avatarBigImgView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(Ruler.iPhoneVertical(170, 150, 160, 160).value)
        }
        
        let effect = UIBlurEffect(style: .light)
        let avatarBlurView = UIVisualEffectView(effect: effect)
        addSubview(avatarBlurView)
        avatarBlurView.snp.makeConstraints { make in
            make.edges.equalTo(avatarBigImgView)
        }
        
        let bottomline = UIView()
        bottomline.backgroundColor = UIColor.groupTableViewBackground
        addSubview(bottomline)
        bottomline.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
        
        avatarlittleImgView = UIImageView()
        avatarlittleImgView.layer.shadowOffset = CGSize(width: 0, height: -1)
        avatarlittleImgView.layer.shadowColor = UIColor.darkText.withAlphaComponent(0.7).cgColor
        addSubview(avatarlittleImgView)
        avatarlittleImgView.snp.makeConstraints { make in
            make.bottom.equalTo(avatarBigImgView).offset(10)
            make.width.height.equalTo(75)
            make.left.equalTo(self).offset(15)
        }
        
        businessNamelb = UILabel()
        businessNamelb.font = UIFont.boldSystemFont(ofSize: 19)
        businessNamelb.textColor = UIColor.white
        addSubview(businessNamelb)
        businessNamelb.snp.makeConstraints { make in
            make.left.equalTo(avatarlittleImgView.snp.right).offset(8)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(avatarlittleImgView)
        }
        
        sellNumlb = UILabel()
        sellNumlb.textColor = UIColor.white
        sellNumlb.font = UIFont.systemFont(ofSize: 13)
        addSubview(sellNumlb)
        sellNumlb.snp.makeConstraints { make in
            make.left.equalTo(businessNamelb)
            make.top.equalTo(businessNamelb.snp.bottom).offset(10)
        }
        
        rationNum = UILabel()
        rationNum.textColor = UIColor(red: 255, green: 201, blue: 40)
        rationNum.font = UIFont.boldSystemFont(ofSize: 24)
        rationNum.textAlignment = .center
        addSubview(rationNum)
        rationNum.snp.makeConstraints { make in
            make.left.equalTo(avatarlittleImgView)
            make.width.equalTo(75)
            make.top.equalTo(avatarlittleImgView.snp.bottom).offset(15)
        }
        
        ratioStarView = CosmosView()
        ratioStarView.settings.emptyColor = UIColor.groupTableViewBackground
        ratioStarView.settings.filledColor = UIColor(red: 255, green: 201, blue: 40)
        ratioStarView.settings.fillMode = .precise
        ratioStarView.settings.starSize = 15
        ratioStarView.settings.starMargin = 1
        ratioStarView.settings.updateOnTouch = false
        addSubview(ratioStarView)
        ratioStarView.snp.makeConstraints { make in
            make.left.equalTo(rationNum)
            make.height.equalTo(15)
            make.width.equalTo(90)
            make.top.equalTo(rationNum.snp.bottom).offset(8)
        }
        
        telView = UIButton(type: .custom)
        telView.setImage(UIImage(named: "icon_phonenumber"), for: .normal)
        telView.addTarget(self, action: #selector(tel), for: .touchUpInside)
        addSubview(telView)
        telView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-15)
        }
        
        let vline = UIView()
        vline.backgroundColor = UIColor.groupTableViewBackground
        addSubview(vline)
        vline.snp.makeConstraints { make in
            make.right.equalTo(telView.snp.left).offset(-15)
            make.bottom.equalTo(ratioStarView)
            make.width.equalTo(0.8)
            make.height.equalTo(40)
        }
        
        commentInfoView = InfoView()
        replyInfoView = InfoView()
        distanceInfoView = InfoView()
        
        let stackView = UIStackView(arrangedSubviews: [commentInfoView, replyInfoView, distanceInfoView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.right.equalTo(vline.snp.left).offset(-8)
            make.left.equalTo(ratioStarView.snp.right).offset(8)
            make.bottom.equalTo(vline)
            make.height.equalTo(35)
        }
    }
    
    func reloadData(_ data: StoreInfo) {
        avatarBigImgView.kf.setImage(with: URL(string: data.shop_thumnail_image))
        businessNamelb.text = data.custom_name
        sellNumlb.text = "주문수" + data.sale_cnt
//        rationNum.text = data.fav_cnt
        avatarlittleImgView.kf.setImage(with: URL(string: data.shop_thumnail_image), options: [.processor(RoundCornerImageProcessor(cornerRadius: 5))])
        commentInfoView.infolb.text = "최근리뷰"
        commentInfoView.numlb.text = data.sale_cnt
        replyInfoView.infolb.text = "사장님댓글"
        replyInfoView.numlb.text = "38"
        distanceInfoView.infolb.text = "상가거리"
        distanceInfoView.numlb.text = data.distance
        ratioStarView.rating = Double(data.fav_cnt) ?? 0
        rationNum.text = data.fav_cnt
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
        numlb.font = UIFont.systemFont(ofSize: Ruler.iPhoneHorizontal(9, 11, 14).value)
        
        infolb = UILabel()
        infolb.textColor = UIColor(hex: 0x999999)
        infolb.font = UIFont.systemFont(ofSize: Ruler.iPhoneHorizontal(9, 11, 14).value)
        
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
