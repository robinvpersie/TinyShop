//
//  ProtocolController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/16.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import RxCocoa
import RxSwift

class ProtocolController: UIViewController {
    
    enum chooseType: Int {
        case all
        case location
        case live
        case notification
    }
    
    var scrollView: TPKeyboardAvoidingScrollView!
    var headPlaceImgView: UIImageView!
    var chooseAllBtn: UIButton!
    var locationChooseBtn: UIButton!
    var liveChooseBtn: UIButton!
    var notificationChooseBtn: UIButton!
    var locationProtocolTV: UITextView!
    var startAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
    }
    
    func makeUI() {
        
        scrollView = TPKeyboardAvoidingScrollView()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(view)
        }
        
        headPlaceImgView = UIImageView()
        headPlaceImgView.image = UIImage(named: "img_login_bg2")
        scrollView.addSubview(headPlaceImgView)
        headPlaceImgView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(scrollView)
            make.height.equalTo(250)
            make.width.equalTo(scrollView)
        }
        
        let welcomelb = UILabel()
        welcomelb.textColor = UIColor(hex: 0x21c043)
        welcomelb.font = UIFont.systemFont(ofSize: 25)
        welcomelb.text = "우리동네 \("함께가게")에 오신 여러분 환영합니다!"
        welcomelb.textAlignment = .center
        welcomelb.numberOfLines = 0
        scrollView.addSubview(welcomelb)
        welcomelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.leading.equalTo(scrollView).offset(15)
            make.trailing.equalTo(scrollView).offset(-15)
            make.top.equalTo(headPlaceImgView.snp.bottom).offset(25)
        }
        
        let agreenlb = UILabel()
        agreenlb.textColor = UIColor(hex: 0x111111)
        agreenlb.font = UIFont.systemFont(ofSize: 15)
        agreenlb.numberOfLines = 0
        agreenlb.text = "아래 약관에 동의 하시면 즐거운 여정이 시작 됩니다"
        scrollView.addSubview(agreenlb)
        agreenlb.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(welcomelb.snp.bottom).offset(18)
            make.leading.equalTo(scrollView).offset(30)
            make.trailing.equalTo(scrollView).offset(-30)
        }
 
        locationProtocolTV = UITextView()
        let locationRichText = NSMutableAttributedString()
        let locationFirstText = NSAttributedString(string: "위치 기반 서비스 약관 동의")
        locationRichText.append(locationFirstText)
        let locationLastText = NSAttributedString(string: "(필수)", attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0x999999)])
        locationRichText.append(locationLastText)
        locationRichText.addAttribute(NSAttributedStringKey.link, value: "location://", range: NSRange(location: 0, length: locationFirstText.length))
        locationProtocolTV.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.YClightBlueColor]
        locationProtocolTV.attributedText = locationRichText
        locationProtocolTV.font = UIFont.systemFont(ofSize: 13)
        locationProtocolTV.delegate = self
        locationProtocolTV.isEditable = false
        locationProtocolTV.isScrollEnabled = false
        locationProtocolTV.textContainer.lineFragmentPadding = 0
        locationProtocolTV.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollView.addSubview(locationProtocolTV)
        
        locationChooseBtn = UIButton(type: .custom)
        locationChooseBtn.tag = chooseType.location.rawValue
        locationChooseBtn.addTarget(self, action: #selector(didChoose(sender:)), for: .touchUpInside)
        locationChooseBtn.setImage(UIImage(named: "icon_select"), for: .normal)
        locationChooseBtn.setImage(UIImage(named: "icon_selected2"), for: .selected)
        scrollView.addSubview(locationChooseBtn)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor(hex: 0xe6e6e6)
        scrollView.addSubview(line1)
        
        locationProtocolTV.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollView).offset(30)
            make.top.equalTo(agreenlb.snp.bottom).offset(25)
            make.trailing.equalTo(locationChooseBtn.snp.leading).offset(-5)
//            make.top.equalTo(layoutGuide.snp.bottom).offset(25)
//            make.trailing.equalTo(locationChooseBtn.snp.leading).offset(-5)
            make.height.equalTo(locationProtocolTV.font!.lineHeight)
        }
        
        locationChooseBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(scrollView).offset(-30)
            make.width.height.equalTo(30)
            make.centerY.equalTo(locationProtocolTV)
        }
        
        line1.snp.makeConstraints { (make) in
            make.leading.equalTo(locationProtocolTV)
            make.trailing.equalTo(locationChooseBtn)
            make.top.equalTo(locationProtocolTV.snp.bottom).offset(15)
            make.height.equalTo(0.8)
        }
        
 
        let startBtn = UIButton(type: .custom)
        startBtn.addTarget(self, action: #selector(didStart), for: .touchUpInside)
        startBtn.setTitle("시작하기", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        startBtn.layer.backgroundColor = UIColor(hex: 0x21c043).cgColor
        startBtn.layer.cornerRadius = 3
        scrollView.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollView).offset(30)
            make.trailing.equalTo(scrollView).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(line1.snp.bottom).offset(50)
            make.bottom.equalTo(scrollView)
        }
        
    }
    
    @objc func didStart() {
        if locationChooseBtn.isSelected {
        //&& liveChooseBtn.isSelected {
            startAction?()
        }
        
    }
    
    @objc func didChoose(sender: UIButton) {
        let type = chooseType(rawValue: sender.tag)!
        switch type {
        case .all:
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                locationChooseBtn.isSelected = true
                liveChooseBtn.isSelected = true
                notificationChooseBtn.isSelected = true
            }else {
                locationChooseBtn.isSelected = false
                liveChooseBtn.isSelected = false
                notificationChooseBtn.isSelected = false
            }
        case .live, .location, .notification:
            sender.isSelected = !sender.isSelected
//            if sender.isSelected == false {
//                chooseAllBtn.isSelected = false
//            }
        }
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ProtocolController: UITextViewDelegate {
    
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
      
        let web = YCWebViewController(urlConvertible: "http://www.gigawon.co.kr:1314/CS2/CS10")
        web.backtype = .dismiss
        let nav = UINavigationController(rootViewController: web)
        self.present(nav, animated: true, completion: nil)
   
//        if (URL.scheme == "location") {
//
//            return false
//        } else if (URL.scheme == "live") {
//            return false
//        } else if (URL.scheme == "noti") {
//            return false
//        }
        return false
    }
    
}


    


