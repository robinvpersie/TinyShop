//
//  OrderMenuPushView.swift
//  Portal
//
//  Created by 이정구 on 2018/5/24.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class OrderMenuPushView: UIView {
    
    var containerView: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIButton(type: .custom)
        containerView.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    @objc func hide() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
