//
//  RecommendMatchController.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecommendMatchController: UIViewController {
    
    lazy var searchPopView: RecommendSearchPopView = {
        let searchPopView = RecommendSearchPopView()
        searchPopView.selectAction = { [weak self] model in
            guard let this = self else { return }
            this.selectModel = model
        }
       return searchPopView
    }()
    var inputField: UITextField!
    var status: MatchManageController.matchStatus = .unmatch
    var tableView: UITableView!
    var selectModel: CheckParentModel? {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    var from: Int = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推荐人匹配"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(yc_back))
        view.backgroundColor = UIColor(hex: 0xf3f4f8)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
        }
        
        let descriptionlb = UILabel()
        descriptionlb.textColor = UIColor.darkText
        descriptionlb.text = "推荐人编号"
        descriptionlb.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(descriptionlb)
        descriptionlb.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        descriptionlb.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(15)
            make.centerY.equalTo(containerView)
        }
        
        let customlev = YCAccountModel.getAccount()?.customlev
        let checkBtn = UIButton(type: .custom)
        checkBtn.addTarget(self, action: #selector(didCheck), for: .touchUpInside)
        checkBtn.setTitle("查询", for: .normal)
        checkBtn.setTitleColor(UIColor.white, for: .normal)
        checkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        checkBtn.layer.backgroundColor = UIColor(hex: 0xf85828).cgColor
        checkBtn.layer.cornerRadius = 3
        checkBtn.alpha = customlev == YCAccountModel.customlevType.none.rawValue ? 1:0.6
        checkBtn.isEnabled = customlev == YCAccountModel.customlevType.none.rawValue ? true:false
        containerView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(containerView).offset(-15)
            make.centerY.equalTo(containerView)
            make.height.equalTo(25)
            make.width.equalTo(60)
        }
        
        inputField = UITextField(frame: .zero)
        inputField.placeholder = "请输入编号"
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.textAlignment = .left
        inputField.clearButtonMode = .whileEditing
        inputField.delegate = self
        containerView.addSubview(inputField)
        inputField.snp.makeConstraints { (make) in
            make.leading.equalTo(descriptionlb.snp.trailing).offset(10)
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(checkBtn.snp.leading).offset(-10)
        }
        
        let bottomContainerView = UIView()
        bottomContainerView.backgroundColor = UIColor.white
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(containerView.snp.bottom).offset(10)
        }
        
        let matchBtn = UIButton(type: .custom)
        matchBtn.addTarget(self, action: #selector(didMatch), for: .touchUpInside)
        matchBtn.setTitle("匹配", for: .normal)
        matchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        matchBtn.layer.backgroundColor = UIColor(hex: 0x1aac19).cgColor
        matchBtn.layer.cornerRadius = 3
        matchBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(matchBtn)
        matchBtn.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(view).offset(-10)
            }
            make.width.equalTo(view).multipliedBy(0.95)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.registerClassOf(LeftRightlbCell.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        switch status {
        case .match:
            tableView.separatorStyle = .singleLine
        case .unmatch:
            tableView.separatorStyle = .none
        }
        bottomContainerView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(bottomContainerView)
            make.top.equalTo(bottomContainerView).offset(15)
            make.bottom.equalTo(matchBtn.snp.top).offset(-15)
        }
        
    }
    
    @objc func didMatch() {
        if let model = self.selectModel,
            let customcode = YCAccountModel.getAccount()?.customCode {
            showLoading()
            MatchParentModel.matchingParentWith(customCode: customcode,
                                                sellerTyp: model.seller_type ?? "",
                                                parentId: inputField.text ?? "",
                                                completion:
            { [weak self] result in
                guard let this = self else { return }
                this.hideLoading()
                switch result {
                case .success(let model):
                    if model.flag == "1501" {
                        let account = YCAccountModel.getAccount()!
                        account.parentId = this.inputField.text!
                        let data = NSKeyedArchiver.archivedData(withRootObject: account)
                        YCUserDefaults.accountModel.value = data
                        if this.from == 0 {
                            this.navigationController?.popToRootViewController(animated: true)
                        }else {
                            this.navigationController?.popViewController(animated: true)
                        }
                    }
                    this.showMessage(model.msg)
                case .failure:
                    break
                }
            })
        }

    }
    
    @objc func didCheck(){
        inputField.resignFirstResponder()
        if let parentId = inputField.text {
            showLoading()
            CheckParentModel.checkParentWithParentId(parentId, completion: { [weak self] result in
                guard let this = self else { return }
                this.hideLoading()
                switch result {
                case .success(let json):
                    let Json = JSON(json)
                    if Json["isParent"].string == "1" {
                        let model = try? CheckParentModel(json: json)
                        this.searchPopView.showInView(this.view.window, with: model)
                    }else {
                        this.showMessage("没有这个推荐人")
                    }
                case .failure:
                    break
                }
            })
       }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RecommendMatchController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension RecommendMatchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension RecommendMatchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftRightlbCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.leftlb.text = "搜索结果"
        }else if indexPath.row == 1 {
            if let model = selectModel {
               cell.leftlb.text = "区分"
               cell.leftlb.textColor = UIColor.darkText
                if model.seller_type == "121" {
                    cell.rightlb.text = "医疗"
                }else if model.seller_type == "122" {
                    cell.rightlb.text = "学生"
                }else if model.seller_type == "123" {
                    cell.rightlb.text = "微信"
                }
            }else {
               cell.leftlb.textColor = UIColor.YClightGrayColor
               cell.leftlb.text = "输入推荐人的编号点击查询"
            }
        }else if indexPath.row == 2 {
            cell.leftlb.text = "姓名"
            cell.rightlb.text = selectModel?.custom_name
        }else if indexPath.row == 3 {
            cell.leftlb.text = "电话号码"
            cell.rightlb.text = selectModel?.mobilepho
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = selectModel else  {
            return 2
        }
        return 4
    }
    
}



