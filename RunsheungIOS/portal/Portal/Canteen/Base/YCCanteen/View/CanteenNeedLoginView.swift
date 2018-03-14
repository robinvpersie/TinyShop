//
//  CanteenNeedLoginView.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CanteenNeedLoginView: UIView {
    
    
    var loginAction:(()->Void)?
    
    lazy var avatarimageView:UIImageView = {
        let avatarImageView = UIImageView()
        return avatarImageView
    }()
    
    lazy var infolb:UILabel = {
        let info = UILabel()
        info.font = UIFont.systemFont(ofSize: 13)
        info.text = "您还没登录,请登录后查看订单"
        info.textColor = UIColor.darkcolor
        return info
    }()
    
    lazy var loginBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.navigationbarColor
        btn.setTitle("登录/注册", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(stackView)
        makeConstraint()
        stackView.addArrangedSubview(avatarimageView)
        avatarimageView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        stackView.addArrangedSubview(infolb)
        stackView.addArrangedSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(35)
        }
        
        
    }
    
    @objc private func login(){
       loginAction?()
    }
    
    func hideAndDo(_ action:(()->Void)?){
       self.removeFromSuperview()
       action?()
    }
    
    func showInView(_ view:UIView){
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func makeConstraint(){
        
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(300)
            make.height.equalTo(120)
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class KLProjectDetailCollectionCell:UICollectionViewCell,Previewable {
    
    var imageView:UIImageView!
    var url:YCURLConvertible!{
        didSet {
            let width = imageView.frame.size.width * UIScreen.main.scale
            let height = imageView.frame.size.height * UIScreen.main.scale
            self.imageView.kf.setImage(with: url.asURL(), options: [.transition(.fade(0.6)),.processor(ResizingImageProcessor(targetSize:CGSize(width: width, height: height)))])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        addSubview(imageView)
        makeConstraints()
    }
    
    func makeConstraints(){
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    public var transitionReference: Reference {
        return Reference(view: imageView, image: imageView.image)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

