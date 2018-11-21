//
//  MatchManageController.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class MatchManageController: UIViewController {
    
    public enum matchStatus:Int {
        case match
        case unmatch
        
        var matchTitle: String {
            switch self {
            case .match:
                return "查看详情"
            case .unmatch:
                return "匹配"
            }
        }
    }
    
//    var containerView: UIView!
    var tableView: UITableView!
    var status: matchStatus!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "匹配管理"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(yc_back))
        view.backgroundColor = UIColor(hex: 0xf3f4f8)
        
//        tableView = UITableView(frame: .zero, style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.tableFooterView = UIView()
//        tableView.backgroundColor = UIColor.clear
//        tableView.registerClassOf(LeftRightlbCell.self)
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        if #available(iOS 11.0, *) {
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            containerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }


        let descriptionlb = UILabel()
        descriptionlb.textColor = UIColor.darkText
        descriptionlb.text = "我的推荐人信息"
        descriptionlb.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(descriptionlb)
        descriptionlb.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(15)
            make.centerY.equalTo(containerView)
        }

        let rightArror = UIButton(type: .custom)
        rightArror.setImage(UIImage(named: "icon_02_02"), for: .normal)
        rightArror.addTarget(self, action: #selector(didMatch), for: .touchUpInside)
        containerView.addSubview(rightArror)
        rightArror.snp.makeConstraints { (make) in
            make.trailing.equalTo(containerView).offset(-15)
            make.centerY.equalTo(containerView)
            make.width.equalTo(rightArror.snp.height)
            make.height.equalTo(25)
        }

        let matchBtn = UIButton(type: .custom)
        matchBtn.setTitle(status.matchTitle, for: .normal)
        matchBtn.setTitleColor(UIColor(hex: 0x999999), for: .normal)
        matchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        matchBtn.translatesAutoresizingMaskIntoConstraints = false
        matchBtn.addTarget(self, action: #selector(didMatch), for: .touchUpInside)
        containerView.addSubview(matchBtn)
        matchBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(rightArror.snp.leading).offset(-10)
            make.centerY.equalTo(rightArror)
        }
        
        if status == .match {
            let underView = UIView()
            underView.backgroundColor = UIColor.YClightGrayColor
            view.addSubview(underView)
            underView.snp.makeConstraints({ (make) in
                make.leading.trailing.equalTo(view)
                make.height.equalTo(0.8)
                make.top.equalTo(containerView.snp.bottom)
            })
            
            let containerViewQR = UIView()
            containerViewQR.backgroundColor = UIColor.white
            view.addSubview(containerViewQR)
            containerViewQR.snp.makeConstraints({ (make) in
                make.leading.trailing.equalTo(view)
                make.top.equalTo(containerView.snp.bottom)
                make.height.equalTo(50)
            })
            
            let descriptionQRlb = UILabel()
            descriptionQRlb.textColor = UIColor.darkText
            descriptionQRlb.text = "我的匹配QR"
            descriptionQRlb.font = UIFont.systemFont(ofSize: 16)
            containerViewQR.addSubview(descriptionQRlb)
            descriptionQRlb.snp.makeConstraints { (make) in
                make.leading.equalTo(containerViewQR).offset(15)
                make.centerY.equalTo(containerViewQR)
            }

            let QRBtn = UIButton(type: .custom)
            QRBtn.setImage(UIImage(named: "icon_09_01"), for: .normal)
            QRBtn.addTarget(self, action: #selector(didQR), for: .touchUpInside)
            containerViewQR.addSubview(QRBtn)
            QRBtn.snp.makeConstraints({ (make) in
                make.trailing.equalTo(containerViewQR).offset(-15)
                make.centerY.equalTo(containerViewQR)
                make.width.height.equalTo(30)
            })
            
        }
    }
    
    @objc func didQR() {
        let qrController = MyQRController()
        navigationController?.pushViewController(qrController, animated: true)
    }
    
    @objc func didMatch(){
        switch status {
		case .match?:
            let info = RecommendInfoController()
            navigationController?.pushViewController(info, animated: true)
		case .unmatch?:
            let recommendMatch = RecommendMatchController()
            recommendMatch.status = status
            navigationController?.pushViewController(recommendMatch, animated: true)
        default:
            break 
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//extension MatchManageController: UITableViewDelegate {
//
//
//}
//
//extension MatchManageController: UITableViewDataSource {
//
//}

