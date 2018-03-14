//
//  OffPasswordInputView.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class OffPasswordInputView:UIView {
    
    enum loadingState {
        case loading
        case normal
    }
    
    var trapezoidLayer:CAShapeLayer!
    var middleBtn:UIButton!
    var timelb:UILabel!
    var confirmBtn:UIButton!
    var indicator:UIActivityIndicatorView!
    var inputlbArr = [UILabel]()
    var payAction:(()->Void)?
    var middleAction:(()->Void)?
    var totalcount:Int = 0 {
        didSet{
            for (offset,lb) in inputlbArr.enumerated() {
                if offset < totalcount {
                    lb.text = "•"
                }else {
                    lb.text = nil
                }
            }
        }
    }
    var state:loadingState = .normal {
        didSet {
            switch state {
            case .loading:
                confirmBtn.isEnabled = false
                confirmBtn.setTitle("", for: .normal)
                indicator.startAnimating()
            case .normal:
                confirmBtn.isEnabled = true
                confirmBtn.setTitle("确认支付", for: .normal)
                indicator.stopAnimating()
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        addObserve()
        
        trapezoidLayer = CAShapeLayer()
        trapezoidLayer.fillColor = UIColor.white.cgColor
        trapezoidLayer.shadowColor = UIColor.YClightGrayColor.cgColor
        trapezoidLayer.shadowOpacity = 0.7
        trapezoidLayer.shadowOffset = CGSize(width: 0, height: 0)
        layer.addSublayer(trapezoidLayer)
        
        middleBtn = UIButton(type: .custom)
        middleBtn.addTarget(self, action: #selector(didMiddle), for: .touchUpInside)
        middleBtn.setImage(UIImage(named: "btn_pulldown"), for: .normal)
        addSubview(middleBtn)
        middleBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        timelb = UILabel()
        timelb.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightHeavy)
        timelb.textColor = UIColor.darkcolor
        addSubview(timelb)
        timelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(middleBtn.snp.bottom).offset(20)
            make.height.equalTo(24)
            
        }
        
        let descriptionlb = UILabel()
        descriptionlb.text = "请输入支付密码"
        descriptionlb.textColor = UIColor(hex: 0x999999)
        descriptionlb.font = UIFont.systemFont(ofSize: 13)
        addSubview(descriptionlb)
        descriptionlb.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(timelb.snp.bottom).offset(30)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(290)
            make.top.equalTo(descriptionlb.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
        inputlbArr = Array(0..<6).map({ offset in
            let lb = UILabel()
            lb.tag = offset
            lb.font = UIFont.systemFont(ofSize: 30)
            lb.textAlignment = .center
            lb.layer.borderColor = UIColor(hex: 0x999999).cgColor
            lb.layer.borderWidth = 1
            stackView.addArrangedSubview(lb)
            return lb
        })
        
        confirmBtn = UIButton(type: .custom)
        confirmBtn.addTarget(self, action: #selector(pay), for: .touchUpInside)
        confirmBtn.setTitle("确认支付", for: .normal)
        confirmBtn.layer.backgroundColor = UIColor(hex: 0x67d159).cgColor
        confirmBtn.layer.cornerRadius = 20
        confirmBtn.layer.shadowColor = UIColor(hex: 0x67d159).cgColor
        confirmBtn.layer.shadowOpacity = 0.7
        confirmBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        confirmBtn.titleLabel?.textColor = UIColor.white
        addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(250)
            make.top.equalTo(stackView.snp.bottom).offset(30)
        }
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.hidesWhenStopped = true
        confirmBtn.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(confirmBtn)
        }
    }
    
    func addObserve(){
        NotificationCenter.default.addObserver(self, selector: #selector(add(_:)), name: NSNotification.Name.addstring, object: nil)
    }
    
    @objc func add(_ noti:Notification){
        totalcount = (noti.object as! String).characters.count
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trapezoidLayer.path = nil
        let startPoint:CGPoint = CGPoint(x: 0, y: self.frame.size.height)
        let finalPoint:CGPoint = CGPoint(x: 0, y: 70)
        let secondPoint:CGPoint = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
        let thirdPoint:CGPoint = CGPoint(x: self.frame.size.width, y: 70)
        let controlPoint:CGPoint = CGPoint(x: self.frame.size.width/2.0, y: 0)
        let bezier = UIBezierPath()
        bezier.move(to: finalPoint)
        bezier.addLine(to: startPoint)
        bezier.addLine(to: secondPoint)
        bezier.addLine(to: thirdPoint)
        bezier.addQuadCurve(to: finalPoint, controlPoint: controlPoint)
        trapezoidLayer.path = bezier.cgPath
    }
    
    @objc func pay(){
        if totalcount == 6 {
           state = .loading
           payAction?()
        }
    }
    
    @objc func didMiddle(){
        state = .normal
        middleAction?()
    }
    
    class func getHeight() -> CGFloat {
        let keyboardHeight = Ruler.iPhoneVertical(320, 230, 240, 250).value
        return CGFloat(275 + keyboardHeight)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
