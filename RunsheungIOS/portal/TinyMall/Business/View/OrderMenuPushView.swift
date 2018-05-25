//
//  OrderMenuPushView.swift
//  Portal
//
//  Created by 이정구 on 2018/5/24.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class PushModel {
    var model: SelectModel
    var num: Int
    
    init(model: SelectModel, num: Int) {
        self.model = model
        self.num = num
    }
}

class OrderMenuPushView: UIView {
    
    var containerView: UIButton!
    var tableView: UITableView!
    var dataSource = [PushModel]()
    var hideAction: (() -> ())?
    var isUp: Bool = false
    var tableHeight: CGFloat = 240
    var actionBlock:((_ actionType: OrderMenuPushCell.actionType, _ pushModel: PushModel) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        backgroundColor = UIColor.clear
        
        containerView = UIButton(type: .custom)
        containerView.addTarget(self, action: #selector(hide), for: .touchUpInside)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderMenuPushCell.self)
        tableView.rowHeight = OrderMenuPushCell.getHeight()
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 45
        tableView.sectionFooterHeight = 0.01
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0)
        addSubview(tableView)
    
    }
    
    func headerView() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackground
        headerView.frame.size = CGSize(width: Constant.screenWidth, height: 45)
        
        let titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.text = "购物车"
        titlelb.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(titlelb)
        titlelb.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(15)
            make.centerY.equalTo(headerView)
        }
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("清空购物车", for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        deleteBtn.setTitleColor(Theme.orderStyleColor, for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteShopCar), for: .touchUpInside)
        headerView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(headerView).offset(-15)
            make.centerY.equalTo(headerView)
        }
        return headerView
    }
    
    @objc func deleteShopCar() {
        hide()
    }
    
    func showWithModel(_ modelDic: [SelectModel: Int]) {
        isHidden = false
        var data = [PushModel]()
        modelDic.forEach { model, num in
            let model = PushModel(model: model, num: num)
            data.append(model)
        }
        dataSource = data
        tableView.reloadData()
        tableView.frame = CGRect.init(x: 0, y: frame.maxY, width: frame.width, height: tableHeight)

        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.frame.maxY - self.tableHeight, width: self.frame.width, height: self.tableHeight)
        }) { finish in
            if finish {
                self.toggle()
            }
        }
    }
    
    func toggle() {
        self.isUp = !self.isUp
    }
    
    @objc func hide() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.frame.maxY , width: self.frame.width, height: self.tableHeight)
        }) { [weak self] finish in
            if finish {
                self?.hideAction?()
                self?.isHidden = true
                self?.toggle()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OrderMenuPushView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
 
    
}

extension OrderMenuPushView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderMenuPushCell = tableView.dequeueReusableCell()
        cell.configureWith(dataSource[indexPath.row])
        cell.actionBlock = { [weak self] type, model in
            guard let this = self else {
                return
            }
            this.dataSource[indexPath.row] = model
            this.actionBlock?(type, model)
            switch type {
            case .add:
                break
            case .sub:
                if model.num == 0 {
                    this.dataSource.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
           
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}



class OrderMenuPushCell: UITableViewCell {
    
    public enum actionType {
        case add
        case sub
    }
    
    private var namelb: UILabel!
    private var pricelb: UILabel!
    private var addbtn: UIButton!
    private var subBtn: UIButton!
    private var numlb: UILabel!
    private var model: PushModel!
//    var totalNum: Int = 0 {
//        didSet{
//            numlb.text = "\(totalNum)"
//        }
//    }
    var actionBlock:((_ actionType: actionType, _ pushModel: PushModel) -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        namelb = UILabel()
        namelb.textColor = UIColor.darkText
        namelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(namelb)
        namelb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        addbtn = UIButton(type: .custom)
        addbtn.addTarget(self, action: #selector(didAdd), for: .touchUpInside)
        addbtn.backgroundColor = Theme.orderStyleColor
        addbtn.layer.masksToBounds = true
        addbtn.layer.cornerRadius = 15
        addbtn.setTitle("+", for: .normal)
        addbtn.setTitleColor(UIColor.white, for: .normal)
        addbtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(addbtn)
        addbtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        
        numlb = UILabel()
        numlb.textColor = UIColor.darkcolor
        numlb.font = UIFont.systemFont(ofSize: 14)
        numlb.textAlignment = .center
        contentView.addSubview(numlb)
        numlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(addbtn.snp.leading)
            make.centerY.equalTo(addbtn)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
        
        subBtn = UIButton(type: .custom)
        subBtn.addTarget(self, action: #selector(didSub), for: .touchUpInside)
        subBtn.backgroundColor = UIColor.white
        subBtn.layer.masksToBounds = true
        subBtn.layer.cornerRadius = 15
        subBtn.layer.borderColor = UIColor.classBackGroundColor.cgColor
        subBtn.layer.borderWidth = 1
        subBtn.setTitle("-", for: .normal)
        subBtn.setTitleColor(UIColor.darkText, for: .normal)
        subBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(subBtn)
        subBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(numlb.snp.leading)
            make.centerY.equalTo(contentView)
        }
        
        pricelb = UILabel()
        pricelb.textColor = UIColor.darkText
        pricelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(pricelb)
        pricelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(subBtn.snp.leading).offset(-20)
            make.centerY.equalTo(contentView)
        }
    }
    
    func configureWith(_ model: PushModel) {
        self.model = model
//        totalNum = model.num
        numlb.text = "\(model.num)"
        namelb.text = model.model.name
        let price = model.model.itemP
        pricelb.text = "￥" + "\(price)"
    }
    
    @objc private func didSub(){
        if model.num == 0 {
            return
        }
        model.num -= 1
        numlb.text = "\(model.num)"
        actionBlock?(.sub, model)
    }
    
    @objc private func didAdd(){
        model.num += 1
        numlb.text = "\(model.num)"
        actionBlock?(.add, model)
    }
    
    class func getHeight() -> CGFloat {
        return 45
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
