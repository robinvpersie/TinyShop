//
//  OrderTypeView.swift
//  Portal
//
//  Created by 이정구 on 2018/5/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class OrderTypeView: UIView {
    
    var backgroudView: UIView!
    var popView: OrderPopView!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroudView = UIView()
        backgroudView.backgroundColor = UIColor.darkText.withAlphaComponent(0.5)
        addSubview(backgroudView)
        backgroudView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        popView = OrderPopView()
        popView.closeAction = { [weak self] in
            self?.hide()
        }
        popView.buyAction = { [weak self] in
            self?.hide()
        }
        addSubview(popView)
        popView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.85)
            make.height.equalTo(self).multipliedBy(0.65)
        }
        
    }
    
    func reloadDataWith(_ storeDetail: StoreDetail, title: String? = nil) {
        popView.reloadDataWith(storeDetail)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        popView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.popView.alpha = 1
        }) { (finish) in
            
        }
    }
    
    func showInView(_ view: UIView) {
        view.addSubview(self)
        self.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.popView.alpha = 0
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
