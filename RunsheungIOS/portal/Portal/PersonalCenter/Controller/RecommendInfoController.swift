//
//  RecommendInfoController.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RecommendInfoController: UIViewController {
    
    var tableView: UITableView!
    var model: CheckParentModel? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的推荐人信息"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(yc_back))
        view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.clear 
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(LeftRightlbCell.self)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        checkParent()
    }
    
    func checkParent() {
        guard let parentId = YCAccountModel.getAccount()?.parentId else { return }
        showLoading()
        CheckParentModel.checkParentWithParentId(parentId, completion: { [weak self] result in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
              case .success(let json):
                let model = try? CheckParentModel(json: json)
                this.model = model
              case .failure:
                break
              }
           })

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RecommendInfoController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension RecommendInfoController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftRightlbCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none 
        if indexPath.row == 0 {
            cell.leftlb.text = "我的推荐人信息"
        }else if indexPath.row == 1 {
            cell.leftlb.text = "区分"
            if model?.seller_type == "121" {
                cell.rightlb.text = "医疗"
            }else if model?.seller_type == "122" {
                cell.rightlb.text = "学生"
            }else if model?.seller_type == "123" {
                cell.rightlb.text = "微信"
            }
        }else if indexPath.row == 2 {
            cell.leftlb.text = "姓名"
            cell.rightlb.text = model?.custom_name
        }else if indexPath.row == 3 {
            cell.leftlb.text = "电话号码"
            cell.rightlb.text = model?.mobilepho
        }
        return cell
    }
}
