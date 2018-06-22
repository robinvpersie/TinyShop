//
//  RefundProductCell.swift
//  Portal
//
//  Created by 이정구 on 2018/6/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class RefundOrderMenuCell: UITableViewCell {
    
    private var tableView: UITableView!
    private var titlelb: UILabel!
    private var tableHeightConstraint: Constraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        makeUI()
        makeConstraints()
    }
    
    func makeUI() {
        titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titlelb.text = "订单商品"
        contentView.addSubview(titlelb)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(hex: 0xf2f4f6)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false 
        contentView.addSubview(tableView)
    }
    
    func makeConstraints() {
        titlelb.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(15)
            make.height.equalTo(titlelb.font.lineHeight)
            make.right.equalTo(contentView).offset(-15)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titlelb.snp.bottom).offset(20)
            make.left.equalTo(titlelb)
            make.right.equalTo(contentView).offset(-15)
            tableHeightConstraint = make.height.equalTo(RefundProductCell.getHeight() * 2.0).constraint
        }
        
        
    }
    
    class func getHeight() -> CGFloat {
        let fontHeight: CGFloat = UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight
        let tableHeight: CGFloat = RefundProductCell.getHeight() * 2.0
        return fontHeight + tableHeight + 55
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RefundOrderMenuCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RefundProductCell.getHeight()
    }
    
}

extension RefundOrderMenuCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RefundProductCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}


fileprivate class RefundProductCell: UITableViewCell {
    
    var avatarView: UIImageView!
    var namelb: UILabel!
    var numlb: UILabel!
    var pricelb: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        avatarView = UIImageView()
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(50)
        }
        
        namelb = UILabel()
        namelb.textColor = UIColor.darkText
        namelb.font = UIFont.systemFont(ofSize: 14)
        namelb.text = "Chizza烤堡薯条餐"
        contentView.addSubview(namelb)
        namelb.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(avatarView)
        }
        
        numlb = UILabel()
        numlb.textColor = UIColor(hex: 0x999999)
        numlb.font = UIFont.systemFont(ofSize: 14)
        numlb.text = "x 1"
        contentView.addSubview(numlb)
        
        pricelb = UILabel()
        pricelb.textColor = UIColor(hex: 0x999999)
        pricelb.font = UIFont.systemFont(ofSize: 14)
        pricelb.text = "￥10"
        contentView.addSubview(pricelb)
        
        numlb.snp.makeConstraints { make in
            make.left.equalTo(namelb)
            make.bottom.equalTo(avatarView)
            make.right.equalTo(contentView).offset(-15)
        }
        
        pricelb.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(numlb)
        }
        
    }
    
    class func getHeight() -> CGFloat {
        return 70
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
