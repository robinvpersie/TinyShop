//
//  YCInfoView.swift
//  Portal
//
//  Created by PENG LIN on 2017/1/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

final class YCInfoView: UIView {

    var info: String?{
        didSet{
          self.infoLabel?.text = info
        }
    }
    
    private var infoLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    convenience init(_ info: String? = nil) {
        self.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 240))
        self.info = info
    }
    
    func makeUI() {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        self.infoLabel = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let views: [String: AnyObject] = [
            "label": label
        ]
        
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[label]-margin-|", options: [], metrics: ["margin": Ruler.iPhoneHorizontal(20, 40, 40).value], views: views)
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraintsH)
        NSLayoutConstraint.activate(constraintsV)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        infoLabel?.text = info
    }
}
