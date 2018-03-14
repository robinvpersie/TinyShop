//
//  RecommendSearchPopView.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RecommendSearchPopView: UIView {
    
    var blacKContainerView: UIView!
    var whiteContainerView: UIView!
    var tableView: UITableView!
    var checkModel: CheckParentModel! {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    var selectAction: ((CheckParentModel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        blacKContainerView = UIView()
        blacKContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(blacKContainerView)
        blacKContainerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(self)
        }
        
        whiteContainerView = UIView()
        whiteContainerView.backgroundColor = UIColor.white
        addSubview(whiteContainerView)
        whiteContainerView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.95)
            make.height.equalTo(whiteContainerView.snp.width).multipliedBy(1.5)
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        whiteContainerView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(whiteContainerView)
            make.height.equalTo(50)
        }
        
        let titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 15)
        titlelb.text = "推荐查询"
        headerView.addSubview(titlelb)
        titlelb.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(headerView)
        }
        
        let bottomBtnContainerView = UIView()
        bottomBtnContainerView.backgroundColor = UIColor.clear
        whiteContainerView.addSubview(bottomBtnContainerView)
        bottomBtnContainerView.snp.makeConstraints { (make) in
            make.leading.equalTo(whiteContainerView).offset(15)
            make.trailing.equalTo(whiteContainerView).offset(-15)
            make.height.equalTo(60)
            make.bottom.equalTo(whiteContainerView).offset(-15)
        }
        
        let selectBtn = UIButton(type: .custom)
        selectBtn.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        selectBtn.layer.backgroundColor = UIColor(hex: 0xf85828).cgColor
        selectBtn.layer.cornerRadius = 5
        selectBtn.setTitle("选择", for: .normal)
        selectBtn.setTitleColor(UIColor.white, for: .normal)
        selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bottomBtnContainerView.addSubview(selectBtn)
        
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.addTarget(self, action: #selector(didClose), for: .touchUpInside)
        closeBtn.layer.backgroundColor = UIColor(hex: 0xc6c6c6).cgColor
        closeBtn.layer.cornerRadius = 5
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bottomBtnContainerView.addSubview(closeBtn)
        
        selectBtn.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(bottomBtnContainerView)
            make.trailing.equalTo(closeBtn.snp.leading).offset(-20)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(bottomBtnContainerView)
            make.leading.equalTo(selectBtn.snp.trailing).offset(20)
            make.width.equalTo(selectBtn)
        }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.registerClassOf(LeftRightlbCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        whiteContainerView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(whiteContainerView)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(bottomBtnContainerView.snp.top)
        }

    }
    
    func showInView(_ view: UIView?,with model: CheckParentModel?) {
        guard let view = view,
            let model = model else { return }
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        self.checkModel = model
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        whiteContainerView.alpha = 0.0
        blacKContainerView.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.whiteContainerView.alpha = 1
            self.blacKContainerView.alpha = 0.6
        }) { (finish) in
            
        }
    }
    
    @objc func didClose() {
    
        UIView.animate(withDuration: 0.2, animations: {
            self.blacKContainerView.alpha = 0
            self.whiteContainerView.alpha = 0
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func didSelect() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blacKContainerView.alpha = 0
            self.whiteContainerView.alpha = 0
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
                self.selectAction?(self.checkModel)
            }
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension RecommendSearchPopView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
}

extension RecommendSearchPopView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeftRightlbCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.leftlb.text = "区分"
            if checkModel.seller_type == "121" {
                cell.rightlb.text = "医疗"
            }else if checkModel.seller_type == "122" {
                cell.rightlb.text = "学生"
            }else if checkModel.seller_type == "123" {
                cell.rightlb.text = "微信"
            }
         case 1:
            cell.leftlb.text = "姓名"
            cell.rightlb.text = checkModel.custom_name
        case 2:
            cell.leftlb.text = "电话号码"
            cell.rightlb.text = checkModel.mobilepho
        default:
            break
        }
        return cell
    }
    
}

