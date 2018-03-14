//
//  BrightnessView.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

open class BrightnessView: UIView {
    
    var isLockScreen:Bool = false
    var isAllowLandscape:Bool = false
    
    private var backImage = UIImageView()
    private var title = UILabel()
    private var longView = UIView()
    private var tipArray = [UIImageView]()
    private var orientationDidChange:Bool = false
    
    static let share = BrightnessView()
    
    private init(){
        
        super.init(frame: CGRect(x: screenWidth * 0.5, y: screenHeight * 0.5, width: 155, height: 155))
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        let toolbar = UIToolbar(frame: self.bounds)
        toolbar.alpha = 0.97
        self.addSubview(toolbar)
        
        self.backImage.image = UIImage(named: "")
        self.addSubview(self.backImage)
        self.backImage.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(79)
            make.height.equalTo(76)
        }
        
        
        self.title.font = UIFont.systemFont(ofSize: 16)
        self.title.textColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1)
        self.title.textAlignment = .center
        self.title.text = "亮度"
        self.addSubview(self.title)
        self.title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.width.equalTo(self)
            make.height.equalTo(30)
        }
        
        self.longView.backgroundColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1)
        self.addSubview(self.longView)
        self.longView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(13)
            make.top.equalTo(self).offset(132)
            make.width.equalTo(self.bounds.size.width-26)
            make.height.equalTo(7)
        }
        
        self.createTips()
        self.addNotification()
        self.addObserve()
        self.alpha = 0.0
    }
    
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: "brightness")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObserve(){
        UIScreen.main.addObserver(self, forKeyPath: "brightness", options: .new, context: nil)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let sound = change?[.newKey] as? CGFloat {
          self.appearSoundView()
          self.updateLongView(sound: sound)
        }
    }
    
    
    private func appearSoundView(){
        
        if alpha == 0 {
            self.orientationDidChange = false
            self.alpha = 1
            delay(3, work: { 
                self.disAppearSoundView()
            })
        }
        
    }
    
    private func disAppearSoundView(){
        
        if self.alpha == 1 {
            UIView.animate(withDuration: 0.8, animations: { 
                self.alpha = 0
            })
        }
        
    }
    
    private func addNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayer(noti:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc private func updateLayer(noti:Notification){
        self.orientationDidChange = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func createTips(){
        
        let tipW = (self.bounds.size.width - 26 - 17)/16
        let tipH = 5
        let tipY = 1

        for offset in 0..<16 {
           let image = UIImageView()
           image.backgroundColor = UIColor.white
           self.longView.addSubview(image)
           image.snp.makeConstraints({ (make) in
                make.leading.equalTo(self.longView).offset(CGFloat(offset)*(tipW+1) + 1)
                make.top.equalTo(self.longView).offset(tipY)
                make.width.equalTo(tipW)
                make.height.equalTo(tipH)
           })
           self.tipArray.append(image)
        }
        self.updateLongView(sound: UIScreen.main.brightness)
    }
    
    func updateLongView(sound:CGFloat){
        
        let stage:CGFloat = 1/15
        let level:Int = Int(sound/stage)
        self.tipArray = self.tipArray.enumerated().map { offset,img in
            if offset <= level {
               img.isHidden = false
            }else {
               img.isHidden = true
            }
            return img
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
