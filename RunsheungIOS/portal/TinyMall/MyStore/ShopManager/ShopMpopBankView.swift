//
//  ShopMpopBankView.swift
//  Portal
//
//  Created by 이정구 on 2018/10/10.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ShopMpopBankView: UIView {
    var maskview:UIImageView = UIImageView()
    var choiceView:UIView = UIView()
    var inputfieldperson: UITextField = UITextField()
    var inputfieldbankname: UITextField = UITextField()
    var inputfieldNo: UITextField = UITextField()

    @objc public var finishCompleteMap:(String,String,String)->Void = {(name:String,bankname:String,number:String)->Void in }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSuv(){
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.maskview.backgroundColor = UIColor.black
        self.maskview.alpha = 0.3
        self.maskview.isUserInteractionEnabled = true
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
        self.maskview.addGestureRecognizer(tap)
        UIApplication.shared.delegate?.window??.addSubview(self.maskview)
        self.maskview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let cancel:UIButton = UIButton()
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancel.setImage(UIImage(named: "icon_close_date"), for: .normal)
        self.addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(25)
        }
        
        let title:UILabel = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.4))
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        let okbtn:UIButton = UIButton()
        okbtn.setTitle("确定".localized, for: .normal)
        okbtn.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
        okbtn.setTitleColor(UIColor.white, for: .normal)
        okbtn.layer.cornerRadius = 5
        okbtn.layer.masksToBounds = true
        okbtn.addTarget(self, action: #selector(sumbit), for: .touchUpInside)
        self.addSubview(okbtn)
        okbtn.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(40)
        })
        
        
        self.addSubview(self.inputfieldperson)
        self.inputfieldperson.placeholder = "持卡人".localized
        self.inputfieldperson.layer.cornerRadius = 5
        self.inputfieldperson.layer.masksToBounds = true
        self.inputfieldperson.textColor = UIColor(red: 160, green: 160, blue: 160)
        self.inputfieldperson.tintColor = UIColor(red: 160, green: 160, blue: 160)
        self.inputfieldperson.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
        self.inputfieldperson.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        self.addSubview(self.inputfieldbankname)
        self.inputfieldbankname.placeholder = "开户行".localized
        self.inputfieldbankname.layer.cornerRadius = 5
        self.inputfieldbankname.layer.masksToBounds = true
        self.inputfieldbankname.textColor = UIColor(red: 160, green: 160, blue: 160)
        self.inputfieldbankname.tintColor = UIColor(red: 160, green: 160, blue: 160)
        self.inputfieldbankname.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
        self.inputfieldbankname.snp.makeConstraints { (make) in
            make.top.equalTo(self.inputfieldperson.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        
        self.addSubview(self.inputfieldNo)
        self.inputfieldNo.placeholder = "卡号".localized
        self.inputfieldNo.layer.cornerRadius = 5
        self.inputfieldNo.layer.masksToBounds = true
        self.inputfieldNo.textColor = UIColor(red: 160, green: 160, blue: 160)
        self.inputfieldNo.tintColor = UIColor(red: 160, green: 160, blue: 160)
        self.inputfieldNo.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
        self.inputfieldNo.snp.makeConstraints { (make) in
            make.top.equalTo(self.inputfieldbankname.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        
        title.text = "结算账户".localized
 
       
    }
    
}

extension ShopMpopBankView{
    
    @objc public func getTag(tag:Int){
        self.tag = tag
        createSuv()
        
    }
    @objc private func sumbit(tag:Int){
        self.hidden()
        
        if let name = self.inputfieldperson.text, let bankname = self.inputfieldbankname.text ,let no = self.inputfieldNo.text {
            
            self.finishCompleteMap(name,bankname,no)
                
         }
        
    }
    
    @objc private func cancelAction(){
        self.hidden()
    }
    
    private func hidden(){
        self.maskview.removeFromSuperview()
        self.removeFromSuperview()
    }
    
}
