//
//  OffRefundView.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/30.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import UIKit

class OffRefundView:UIView {
    
    enum refundStatus {
        case zeroStep
        case firstStep
        case secondStep
        
        mutating func hook(){
            if self == .firstStep {
                self = .secondStep
            }else if self == .zeroStep {
                self = .firstStep
            }
        }
        
        var borderColor:UIColor {
            switch self {
            case .firstStep,.zeroStep:
                return UIColor.darkText
            case .secondStep:
                return UIColor.navigationbarColor
            }
        }
    }
    var Status:refundStatus = .zeroStep {
        didSet {
            if case .firstStep = Status {
                scope.isHidden = false
                alllb.isHidden = false
            }else if case .secondStep = Status {
                scope.isHidden = false
                alllb.isHidden = false
            }else {
                scope.isHidden = true
                scope.isHidden = true
            }
        }
    }
    var refundBtn:UIButton!
    var scope:UIButton!
    var alllb:UILabel!
    var isAll:Bool = false {
        didSet{
            let image = isAll ? UIImage(named: "icon_qq1") : UIImage(named: "icon_qq1c")
            scope.setImage(image, for: .normal)
        }
    }
    var refundAction:((refundStatus)->())?
    var scopeAction:((Bool)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        refundBtn = UIButton(type: .custom)
        refundBtn.layer.borderWidth = 1
        refundBtn.layer.cornerRadius = 3
        refundBtn.layer.backgroundColor = UIColor.clear.cgColor
        refundBtn.layer.borderColor = Status.borderColor.cgColor
        refundBtn.setTitle("退款", for: .normal)
        refundBtn.setTitleColor(Status.borderColor, for: .normal)
        refundBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        refundBtn.addTarget(self, action: #selector(didRefund), for: .touchUpInside)
        refundBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(refundBtn)
        refundBtn.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-15).isActive = true
        refundBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        refundBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        refundBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scope = UIButton(type: .custom)
        scope.addTarget(self, action: #selector(didScope), for: .touchUpInside)
        scope.setImage(UIImage(named: "icon_qq1c"), for: .normal)
        scope.imageView?.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
        scope.translatesAutoresizingMaskIntoConstraints = false
        scope.isHidden = true
        addSubview(scope)
        scope.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        scope.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scope.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        alllb = UILabel()
        alllb.text = "全选"
        alllb.textColor = UIColor.darkText
        alllb.translatesAutoresizingMaskIntoConstraints = false
        alllb.isHidden = true
        addSubview(alllb)
        alllb.leadingAnchor.constraint(equalTo: scope.trailingAnchor, constant: 3).isActive = true
        alllb.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true 
    }
    
    
    func didScope(){
        isAll = !isAll
        let image = isAll ? UIImage(named: "icon_qq1") : UIImage(named: "icon_qq1c")
        scope.setImage(image, for: .normal)
        scopeAction?(isAll)
    }
    
    func didRefund(){
       
        refundBtn.layer.borderColor = Status.borderColor.cgColor
        refundBtn.setTitleColor(Status.borderColor, for: .normal)
        Status.hook()
        refundAction?(Status)

       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
