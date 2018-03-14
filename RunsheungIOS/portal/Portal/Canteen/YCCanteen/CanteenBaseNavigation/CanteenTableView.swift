//
//  CanteenTableView.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class CanteenTableView: UITableView {
    
    var pullRefreshAction:(() -> Void)?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        
    }
    
    func refresh(){
        if let pullRefreshAction = pullRefreshAction {
            pullRefreshAction()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
