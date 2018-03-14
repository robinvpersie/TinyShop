//
//  ShopConsultController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopConsultController: ShopBaseViewController {
    
    fileprivate enum Section:Int{
        case header
        case detail
    }
    
    private lazy var tableview:TPKeyboardAvoidingTableView = {
        let tableview = TPKeyboardAvoidingTableView(frame: CGRect.zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.groupTableViewBackground
        tableview.tableFooterView = self.footerView()
        tableview.registerClassOf(SBCell.self)
        return tableview
    }()
    
    fileprivate lazy var namefield:UITextField = {
         let field = UITextField(frame: CGRect.zero)
         field.placeholder = "请输入您的姓名"
         field.font = UIFont.systemFont(ofSize: 15)
         field.textAlignment = .left
         return field
    }()
    
    fileprivate lazy var phonefield:UITextField = {
        let field = UITextField(frame: CGRect.zero)
        field.placeholder = "请输入您的电话"
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    fileprivate lazy var mailfield:UITextField = {
        let field = UITextField(frame: CGRect.zero)
        field.placeholder = "请输入您的邮箱"
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()

    fileprivate lazy var detailTextView:YYTextView = {
        let textview = YYTextView(frame: CGRect.zero)
        textview.placeholderText = "请输入您的咨询内容"
        textview.font = UIFont.systemFont(ofSize: 15)
        textview.showsVerticalScrollIndicator = false
        textview.showsHorizontalScrollIndicator = false
        textview.isScrollEnabled = false
        return textview
    }()
    
    
    private func footerView() -> UIView {
        let footer = UIView()
        footer.backgroundColor = UIColor.clear
        footer.frame.size = CGSize(width: screenWidth, height: 70)
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(didCommit), for: .touchUpInside)
        footer.addSubview(btn)
        btn.backgroundColor = UIColor.navigationbarColor
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.snp.makeConstraints { (make) in
            make.center.equalTo(footer)
            make.width.equalTo(footer).multipliedBy(0.8)
            make.height.equalTo(30)
        }
        return footer
    }
    
    func didCommit(){
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ShopConsultController:UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ShopConsultController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return 1
        }else {
           return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
           let cell = ShopThankCell(style: .default, reuseIdentifier: nil)
           cell.updateWithString("宇成朝阳广场旨在为顾客提供优质的生活，现正在进行入驻本百货商场的品牌的招商活动，有意入驻的商家请填写以下信息")
           return cell
        }else {
            if indexPath.row == 3 {
               let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
               cell.contentView.addSubview(self.detailTextView)
               self.detailTextView.snp.makeConstraints({ (make) in
                make.leading.equalTo(cell.contentView).offset(15)
                make.trailing.equalTo(cell.contentView).offset(-15)
                make.top.equalTo(cell.contentView).offset(15)
                make.bottom.equalTo(cell.contentView).offset(-15)
               })
               return cell
            }else {
                let cell:SBCell = SBCell(style: .default, reuseIdentifier: nil)
                if indexPath.row == 0 {
                  cell.textlb.text = "姓名"
                  cell.contentView.addSubview(self.namefield)
                  self.namefield.snp.makeConstraints({ (make) in
                     make.leading.equalTo(cell.textlb.snp.trailing).offset(15)
                     make.centerY.equalTo(cell.contentView)
                     make.height.equalTo(30)
                  })
                }else if indexPath.row == 1 {
                  cell.textlb.text = "电话"
                  cell.contentView.addSubview(self.phonefield)
                  self.phonefield.snp.makeConstraints({ (make) in
                    make.leading.equalTo(cell.textlb.snp.trailing).offset(15)
                    make.centerY.equalTo(cell.contentView)
                    make.height.equalTo(30)
                  })
                }else {
                  cell.textlb.text = "邮箱"
                  cell.contentView.addSubview(self.mailfield)
                  self.mailfield.snp.makeConstraints({ (make) in
                    make.leading.equalTo(cell.textlb.snp.trailing).offset(15)
                    make.centerY.equalTo(cell.contentView)
                    make.height.equalTo(30)
                  })
                }
               return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ShopThankCell.getHeightWithStr("宇成朝阳广场旨在为顾客提供优质的生活，现正在进行入驻本百货商场的品牌的招商活动，有意入驻的商家请填写以下信息")
        }else{
            if indexPath.row == 3{
               return 150
            }
            return 44
        }
    }
}


fileprivate class SBCell:UITableViewCell{
    
    lazy var textlb:UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkcolor
        lable.font = UIFont.systemFont(ofSize: 15)
        return lable
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(textlb)
        textlb.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
