//
//  OffBackView.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OffBackView:UIView {
    
    var imgView:UIImageView!
    var code:String!{
        didSet{
            let qrcode = DCQRCode(info: code, size: CGSize(width: 200, height: 200))
            imgView.image = qrcode.image()
        }
    }
    var continueAction:(()->Void)?
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let backView = UIView()
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        backView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backView)
        backView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imgView = UIImageView()
        imgView.backgroundColor = UIColor.white
        imgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgView)
        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: Ruler.iPhoneVertical(170, 140, 150, 160).value).isActive = true
        
        let descriptionlb = UILabel()
        descriptionlb.text = "出示二维码扫码退出无人超市"
        descriptionlb.font = UIFont.systemFont(ofSize: 15)
        descriptionlb.textColor = UIColor.white
        descriptionlb.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionlb)
        descriptionlb.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
        descriptionlb.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let continueBtn = UIButton(type: .custom)
        continueBtn.setImage(UIImage(named: "icon_canlce_000"), for: .normal)
        continueBtn.addTarget(self, action: #selector(didContinue), for: .touchUpInside)
        continueBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(continueBtn)
        continueBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        continueBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        continueBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        continueBtn.topAnchor.constraint(equalTo: descriptionlb.bottomAnchor, constant: 20).isActive = true
    }
    
    func showInView(_ view:UIView){
        view.addSubview(self)
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true 
    }
    
    func didContinue(){
        continueAction?()
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
