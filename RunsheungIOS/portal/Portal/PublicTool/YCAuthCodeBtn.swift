//
//  YCAuthCodeBtn.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit

class YCAuthCodeBtn:UIButton{
    
    var timer:Timer?
    var totalTime:Int = 20
    var clickAuth:(() -> Void)?
    var canstart:(() -> Bool)?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("接收验证码".localized, for: .normal)
        self.backgroundColor = UIColor.navigationbarColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addTarget(self, action: #selector(YCAuthCodeBtn.startTimer), for: .touchUpInside)
        
    }
    
    func restore(){
        
       timer?.invalidate()
       self.setTitle("接收验证码".localized, for: .normal)
       self.isEnabled = true
        
    }
    
    func startTimer(){
        
        let isCan = canstart!()
        if !isCan {
          clickAuth!()
          return
        }
        totalTime = 60
        if let clickAuth = self.clickAuth{
           clickAuth()
        }
        self.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(YCAuthCodeBtn.changeTitle), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        if let timer = timer{
          timer.invalidate()
        }
        self.isEnabled = true
        self.setTitle("接收验证码".localized, for: .normal)
    }
    
    
    @objc private func changeTitle(){
        if totalTime == 0 {
           stopTimer()
           return
        }
        self.isEnabled = false
        totalTime = totalTime - 1
        self.setTitle("\(totalTime)", for: .normal)
        
     }
    
    deinit {
        if let timer = timer{
          timer.invalidate()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
