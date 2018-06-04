//
//  OrderHeaderScrollView.swift
//  Portal
//
//  Created by 이정구 on 2018/6/1.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class OrderHeaderScrollView: UITableViewHeaderFooterView {
    
    var segmentView: YCSegmentView!
    var category = [Category]() {
        didSet {
            segmentView.reloadData()
        }
    }
    var selectAction: ((Category) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        segmentView = YCSegmentView()
        segmentView.normalBackgroundColor = UIColor(hex: 0xe6e6e6)
        segmentView.underlineColor = UIColor.clear
        segmentView.cellEdge = 10
        segmentView.cellSpacing = 0
        segmentView.normalTextFont = UIFont.systemFont(ofSize: 15)
        segmentView.selectedTextFont = UIFont.systemFont(ofSize: 15)
        segmentView.selectedTextColor = UIColor.darkText
        segmentView.normalTextColor = UIColor(hex: 0x999999)
        segmentView.didselectItemAtIndexPath = { [weak self] index in
            guard let this = self else {
                return
            }
            let unitCategory = this.category[index]
            this.selectAction?(unitCategory)
        }
        segmentView.numberOfItems = { [weak self] in
            guard let this = self else {
                return 0
            }
            return this.category.count
        }
        segmentView.titleForIndex = { [weak self] index in
            guard let this = self else {
                return nil
            }
            return this.category[index].level_name
        }
        segmentView.currentIndex = 0
        segmentView.backgroundColor = UIColor(hex: 0xe6e6e6)
        addSubview(segmentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segmentView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
