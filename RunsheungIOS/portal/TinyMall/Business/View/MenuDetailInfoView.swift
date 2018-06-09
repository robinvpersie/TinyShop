//
//  MenuDetailInfoView.swift
//  Portal
//
//  Created by 이정구 on 2018/6/8.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class MenuDetailInfoView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var backContainer: UIControl!
    var whiteContainer: UIControl!
    var bottomView: UIView!
    var pricelb: UILabel!
    var tableView: UITableView!
    var dataSource: Plist? {
        didSet {
            if let plist = dataSource {
                pricelb.text = "가격:" + plist.item_p + "원"
            }
            tableView.reloadData()
        }
    }
    var collectAction: ((Plist) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backContainer = UIControl(frame: .zero)
        backContainer.backgroundColor = UIColor.darkText.withAlphaComponent(0.6)
        backContainer.addTarget(self, action: #selector(hide), for: .touchUpInside)
        addSubview(backContainer)
        backContainer.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        whiteContainer = UIControl(frame: .zero)
        whiteContainer.backgroundColor = UIColor.white
        whiteContainer.layer.cornerRadius = 8
        whiteContainer.layer.masksToBounds = true
        addSubview(whiteContainer)
        whiteContainer.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(0.88)
            make.height.equalTo(500)
            make.center.equalTo(self)
        }
        
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.layer.cornerRadius = 8
        whiteContainer.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.edges.equalTo(whiteContainer)
        }
        
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.groupTableViewBackground
        effectView.contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(effectView.contentView)
            make.height.equalTo(50)
        }
        
        pricelb = UILabel()
        pricelb.textColor = UIColor.darkText
        pricelb.font = UIFont.systemFont(ofSize: 15)
        bottomView.addSubview(pricelb)
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(bottomView).offset(10)
            make.centerY.equalTo(bottomView)
        }
        
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(didBtn), for: .touchUpInside)
        btn.setTitle("구매하기", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.backgroundColor = UIColor(hex: 0xee3a3a).cgColor
        btn.layer.cornerRadius = 5
        bottomView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.right.equalTo(bottomView).offset(-10)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.registerClassOf(InfoHeaderCell.self)
        tableView.registerClassOf(InfoBottomCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        effectView.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalTo(effectView.contentView)
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    @objc func didBtn() {
        hide()
        if let dataSource = self.dataSource {
            collectAction?(dataSource)
        }
    }
    
    @objc func hide() {
        endEditing(true)
        removeFromSuperview()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        whiteContainer.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.whiteContainer.alpha = 1.0
        }
    }
    
    func showInView(_ view: UIView?, plist: Plist) {
        if let view = view {
            view.addSubview(self)
            frame = view.bounds
            dataSource = plist
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return InfoHeaderCell.getHeightWithPlist(dataSource)
        } else {
            return InfoBottomCell.getHeightWithPlist(dataSource)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: InfoHeaderCell = tableView.dequeueReusableCell()
            cell.configureWithPlist(dataSource)
            return cell
        } else {
            let cell: InfoBottomCell = tableView.dequeueReusableCell()
            cell.configureWithCellWithPlist(dataSource)
            return cell
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}



fileprivate class InfoHeaderCell: UITableViewCell {
    
    var avatarImgView: UIImageView!
    var titlelb: UILabel!
    var pricelb: UILabel!
    var field: UITextField!
    var contentlb: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        avatarImgView = UIImageView()
        contentView.addSubview(avatarImgView)
     
        titlelb = UILabel()
        titlelb.numberOfLines = 1
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titlelb)

        pricelb = UILabel()
        pricelb.numberOfLines = 1
        pricelb.textColor = UIColor(hex: 0xee3a3a)
        pricelb.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(pricelb)

        let rightlb = UILabel()
        rightlb.textColor = UIColor.darkText
        rightlb.text = "개"
        rightlb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(rightlb)
        
        let leftlb = UILabel()
        leftlb.textColor = UIColor.darkText
        leftlb.text = "수량"
        leftlb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(leftlb)

        field = UITextField()
        field.textAlignment = .center
        field.textColor = UIColor.darkText
        field.backgroundColor = UIColor(hex: 0xe6e6e6)
        field.font = UIFont.systemFont(ofSize: 13)
        field.text = "1"
        contentView.addSubview(field)
        
        let bottomlb = UILabel()
        bottomlb.textColor = UIColor.darkText
        bottomlb.text = "재료 및 요리"
        bottomlb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(bottomlb)
        
        contentlb = UILabel()
        contentlb.textColor = UIColor(hex: 0x999999)
        contentlb.font = UIFont.systemFont(ofSize: 12)
        contentlb.numberOfLines = 0
        contentView.addSubview(contentlb)
        
        avatarImgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(10)
            make.width.height.equalTo(140)
        }
        
        titlelb.snp.makeConstraints { make in
            make.left.equalTo(avatarImgView.snp.right).offset(5)
            make.top.equalTo(avatarImgView)
            make.right.equalTo(contentView).offset(-8)
        }
        
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(titlelb)
            make.top.equalTo(titlelb.snp.bottom).offset(10)
            make.right.equalTo(contentView).offset(-8)
        }
        
        rightlb.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-8)
            make.top.equalTo(pricelb.snp.bottom).offset(8)
            make.left.equalTo(field.snp.right).offset(2)
        }
        
        field.snp.makeConstraints { make in
            make.right.equalTo(rightlb.snp.left).offset(-2)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalTo(rightlb)
            make.left.equalTo(leftlb.snp.right).offset(2)
        }
        
        leftlb.snp.makeConstraints { make in
            make.right.equalTo(field.snp.left).offset(-2)
            make.centerY.equalTo(field)
        }
        
        bottomlb.snp.makeConstraints { make in
            make.top.equalTo(avatarImgView.snp.bottom).offset(15)
            make.left.equalTo(avatarImgView)
        }
        
        contentlb.snp.makeConstraints { make in
            make.left.equalTo(avatarImgView)
            make.top.equalTo(bottomlb.snp.bottom).offset(15)
            make.right.equalTo(contentView).offset(-8)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    func configureWithPlist(_ plist: Plist?) {
        if let plist = plist {
            avatarImgView.kf.setImage(with: URL(string: plist.image_url))
            titlelb.text = "상품명:" + plist.item_name
            pricelb.text = "가격:" + plist.item_p + "원"
            contentlb.text = plist.Remark
        }
    }
    
    class func getHeightWithPlist(_ plist: Plist?) -> CGFloat {
        let width = Constant.screenWidth * 0.88
        if let plist = plist {
            let height = plist.Remark.heightWithConstrainedWidth(width: width - 18, font: UIFont.systemFont(ofSize: 12))
            return 150 + 35 + 15 + height + 20
        } else {
            return 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


fileprivate class InfoBottomCell: UITableViewCell {
    
    var toplb: UILabel!
    var contentlb: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        toplb = UILabel()
        toplb.textColor = UIColor(hex: 0x999999)
        toplb.font = UIFont.systemFont(ofSize: 14)
        toplb.text = "원산지 표기:"
        contentView.addSubview(toplb)
        
        contentlb = UILabel()
        contentlb.textColor = UIColor(hex: 0x999999)
        contentlb.font = UIFont.systemFont(ofSize: 12)
        contentlb.numberOfLines = 0
        contentView.addSubview(contentlb)
        
        toplb.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(15)
        }
        
        contentlb.snp.makeConstraints { make in
            make.left.equalTo(toplb)
            make.right.equalTo(contentView).offset(-8)
            make.top.equalTo(toplb.snp.bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-15)
        }
        
    }
    
    func configureWithCellWithPlist(_ plist: Plist?) {
        contentlb.text = plist?.ITEM_DETAILS
    }
    
    class func getHeightWithPlist(_ plist: Plist?) -> CGFloat {
        let width = Constant.screenWidth * 0.88
        let topHeight = UIFont.systemFont(ofSize: 14).lineHeight
        if let plist = plist {
            let contentHeight = plist.ITEM_DETAILS.heightWithConstrainedWidth(width: width - 18, font: UIFont.systemFont(ofSize: 12))
            return topHeight + contentHeight + 30 + 10
        } else {
            return topHeight + 15
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
