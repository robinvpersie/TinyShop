//
//  RecommendSearchController.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RecommendSearchController: UIViewController {
    
    var blacKContainerView: UIView!
    var whiteContainerView: UIView!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        view.backgroundColor = UIColor.clear
        
        blacKContainerView = UIView()
        blacKContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(blacKContainerView)
        blacKContainerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(view)
        }
        
        whiteContainerView = UIView()
        whiteContainerView.backgroundColor = UIColor.white
        view.addSubview(whiteContainerView)
        whiteContainerView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.95)
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
    
    @objc func didClose() {
        
    }
    
    @objc func didSelect() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RecommendSearchController: UITableViewDelegate {
    
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

extension RecommendSearchController: UITableViewDataSource {
    
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
        case 1:
            cell.leftlb.text = "姓名"
        case 2:
            cell.leftlb.text = "电话号码"
        default:
            break
        }
        return cell
    }
    
}

extension RecommendSearchController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RecommendSearchPresent()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RecommendSearchDismiss()     }
    
    
    
}
