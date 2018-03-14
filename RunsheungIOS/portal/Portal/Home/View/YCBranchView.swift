//
//  YCBranchView.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/14.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class YCBranchView: UIView {

    enum Item {
        case Default(title:String,checked:Bool,action:(Int,String)->Void)
    }
    
    var sourceArray:[Item]?{
        didSet{
            self.tableview.reloadData()
        }
    }
    var branchIsShow:Bool = false
    
    lazy var tableview:UITableView = {
        let tableview =  UITableView(frame:CGRect.zero,style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerClassOf(UITableViewCell.self)
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = UIColor.clear
        return tableview
    }()
    
    lazy var containerView:UIView = {
       let containerview = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        containerview.backgroundColor = UIColor.clear
        containerview.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickContainer))
        containerview.addGestureRecognizer(gesture)
        gesture.cancelsTouchesInView = true
        return containerview
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(tableview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeConstraints()
    }
    
    
    func makeConstraints(){
       tableview.snp.makeConstraints { (make) in
           make.left.equalTo(self.snp.left)
           make.right.equalTo(self.snp.right)
           make.top.equalTo(self.snp.top)
           make.height.equalTo(44 * sourceArray!.count)
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


     func clickContainer(){
           hide()
    }
    
    
    
    func showInView(superview:UIView,items:[Item]){
        
        weak var superView = superview
        sourceArray = items
        superView?.addSubview(self)
        containerView.alpha = 1
        branchIsShow = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
              self?.containerView.backgroundColor = UIColor.black
              self?.containerView.alpha = 0.4
            }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { [weak self] _ in
              self?.tableview.y = 0
        }, completion: nil)
    }
    
    
    func hide(){
        
        branchIsShow = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] _ in
            guard let strongself = self else {
              return
            }
            strongself.tableview.height = 0
               // CGFloat(-44 * 4)
            }, completion:nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
            
               self?.containerView.backgroundColor = UIColor.clear
            
            }, completion: { [weak self] _ in
                
                self?.removeFromSuperview()
        })
    }
    
    func hideAndDo(afterHideAction:(() -> Void)?){
        
        branchIsShow = false 
        UIView.animate(withDuration: 0.2, animations: {
          [weak self] in
            guard let strongself = self else {
                          return
                        }
           strongself.containerView.alpha = 0
            strongself.tableview.y = CGFloat(-44 * 4)
          }, completion: { [weak self] _ in
             self?.removeFromSuperview()
        })
        
        delay(0.1, work: {
            afterHideAction?()
        })
    }
}


extension YCBranchView:UITableViewDelegate{
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

extension YCBranchView:UITableViewDataSource{
    
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
            case let .Default(text,_ ,_):
                cell.textLabel?.text = text
            }

        }
        return cell
    }
    
}
