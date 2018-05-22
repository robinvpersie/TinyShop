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
    fileprivate var commentInfoView: InfoView!
    fileprivate var replyInfoView: InfoView!
    fileprivate var distanceInfoView: InfoView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarBigImgView = UIImageView()
        addSubview(avatarBigImgView)
        avatarBigImgView.snp.makeConstraints { (make) in
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


fileprivate class InfoView: UIView {
    
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
