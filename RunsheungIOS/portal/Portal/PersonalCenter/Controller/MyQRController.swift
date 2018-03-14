//
//  MyQRController.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher

class MyQRController: UIViewController {
    
    var avatarImageView: UIImageView!
    var phonelb: UILabel!
    var nicklb: UILabel!
    var qrImgView: UIImageView!
    var qrGenerate: DCQRCode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的QR"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(yc_back))
        view.backgroundColor = UIColor.white
        
        let account = YCAccountModel.getAccount()

        avatarImageView = UIImageView()
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(30)
            make.width.equalTo(avatarImageView.snp.height)
            make.height.equalTo(70)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(30)
            }
        }
        let avatarURL = URL(string: account?.avatarPath ?? "")
        avatarImageView.kf.setImage(with: avatarURL)
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20).isActive = true
        layoutGuide.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true

        
        phonelb = UILabel()
        phonelb.textColor = UIColor.darkText
        phonelb.font = UIFont.systemFont(ofSize: 15)
        phonelb.text = account?.customId
        view.addSubview(phonelb)
        
        nicklb = UILabel()
        nicklb.textColor = UIColor.darkText
        nicklb.font = UIFont.systemFont(ofSize: 15)
        nicklb.text = account?.userName
        view.addSubview(nicklb)
        
        nicklb.snp.makeConstraints { (make) in
            make.leading.equalTo(layoutGuide.snp.leading)
            make.bottom.equalTo(layoutGuide.snp.bottom)
            make.top.equalTo(phonelb.snp.bottom).offset(10)
        }
        
        phonelb.snp.makeConstraints { (make) in
            make.leading.equalTo(layoutGuide.snp.leading)
            make.top.equalTo(layoutGuide.snp.top)
            make.bottom.equalTo(nicklb.snp.top).offset(-10)
        }
        
        qrImgView = UIImageView()
        view.addSubview(qrImgView)
        qrImgView.snp.makeConstraints { (make) in
           make.width.equalTo(view).multipliedBy(0.8)
           make.height.equalTo(qrImgView.snp.width)
           make.top.equalTo(avatarImageView.snp.bottom).offset(50)
           make.centerX.equalTo(view)
        }
        
        DispatchQueue.global().async {
            self.qrGenerate = DCQRCode(info: account?.customId ?? "",
                                       size: CGSize(width: screenWidth * 0.8, height: screenWidth * 0.8))
            let qrImage = self.qrGenerate.image()
            DispatchQueue.main.async(execute: {
                 self.qrImgView.image = qrImage
            })
        }
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
