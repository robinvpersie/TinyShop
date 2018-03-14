//
//  YCDropdownView.swift
//  Portal
//
//  Created by PENG LIN on 2017/1/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class YCDropdownView: UIView {
    
    var shapeLayer = CAShapeLayer()
    var bezierpath:UIBezierPath = UIBezierPath()
    var tableview:UITableView!
    var showTopPoint:CGPoint?
    var dropWidth:CGFloat?
    
    enum Item {
        case Default(title:String,checked:Bool,action:(Int,String)->Void)
    }
    
    var sourceArray:[Item]?{
        didSet{
            self.tableview.reloadData()
        }
    }
    
    lazy var containerView:UIView = {
        let containerview = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        containerview.backgroundColor = UIColor.clear
        containerview.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickContainer))
        containerview.addGestureRecognizer(gesture)
        return containerview
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerClassOf(UITableViewCell.self)
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = UIColor.clear
        tableview.separatorColor = UIColor.white
        addSubview(tableview)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let leftUpPoint = CGPoint(x: 0, y: 10)
        let leftbottomPoint = CGPoint(x: 0, y: frame.size.height)
        let rightbottomPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        let rightTopPoint = CGPoint(x: frame.size.width, y: 10)
        let trangleleft = CGPoint(x: 5, y: 10)
        let trangletop = CGPoint(x: 10, y: 0)
        let trangleRight = CGPoint(x: 15, y: 10)
        self.bezierpath.move(to: leftUpPoint)
        self.bezierpath.addLine(to: leftbottomPoint)
        self.bezierpath.addLine(to: rightbottomPoint)
        self.bezierpath.addLine(to: rightTopPoint)
        self.bezierpath.addLine(to: trangleRight)
        self.bezierpath.addLine(to: trangletop)
        self.bezierpath.addLine(to: trangleleft)
        self.shapeLayer.path = self.bezierpath.cgPath
        shapeLayer.fillColor = UIColor.darkcolor.cgColor
        shapeLayer.strokeColor = UIColor.darkcolor.cgColor
        tableview.frame = CGRect(x: 0, y: 10, width: frame.size.width, height: frame.size.height)
    }
    
    func clickContainer(){
        hide()
    }
    
    func showInView(superview:UIView,items:[Item],frame:CGRect){
        weak var superView = superview
        containerView.frame = superView!.frame
        superView?.addSubview(containerView)
        sourceArray = items
        superView?.addSubview(self)
        self.frame = frame
    }
    
    
    func hide(){
        containerView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func hideAndDo(afterHideAction:(() -> Void)?){
        self.removeFromSuperview()
        delay(0.1, work: {
            afterHideAction?()
        })
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YCDropdownView:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sourceArray = self.sourceArray {
           return sourceArray.count
        }else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableview.dequeueReusableCell()
        if let item:Item = self.sourceArray?[indexPath.row] {
            switch item {
            case let .Default(text, checked, _):
                cell.textLabel?.text = text
                cell.textLabel?.textColor = UIColor.white
                if checked {
                cell.textLabel?.textColor = UIColor.orange
                }
            }
        }
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textAlignment = .center
        return cell
    }
}

extension YCDropdownView:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item:Item = self.sourceArray![indexPath.row]
        switch item {
        case let .Default(text, _, action):
            action(indexPath.row,text)
        }
        hide()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
