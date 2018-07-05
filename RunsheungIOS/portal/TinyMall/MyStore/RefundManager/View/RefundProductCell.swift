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
    private var model: OrderReturnModel?
    
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
        titlelb.text = "주문상품"
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
        tableView.registerClassOf(RefundProductCell.self)
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
            tableHeightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    func configureWithModel(_ model: OrderReturnModel) {
        self.model = model
        let height = CGFloat(model.dataitem.count) * RefundProductCell.getHeight()
        tableHeightConstraint?.update(offset: height)
        self.tableView.reloadData()
    }
    
    class func getHeightWithModel(_ model: OrderReturnModel) -> CGFloat {
        let fontHeight: CGFloat = UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight
        let tableHeight: CGFloat = RefundProductCell.getHeight() * CGFloat(model.dataitem.count)
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
        if let item = model?.dataitem {
            cell.configureWithModel(item[indexPath.row])
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.dataitem.count ?? 0
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
        contentView.addSubview(namelb)
        namelb.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(avatarView)
        }
        
        numlb = UILabel()
        numlb.textColor = UIColor(hex: 0x999999)
        numlb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(numlb)
        
        pricelb = UILabel()
        pricelb.textColor = UIColor(hex: 0x999999)
        pricelb.font = UIFont.systemFont(ofSize: 14)
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
    
    func configureWithModel(_ model: DataItem) {
        avatarView.kf.setImage(with: URL(string: model.item_image_url))
        namelb.text = model.item_name
        numlb.text = "x" + model.order_q
        pricelb.text = "￥" + model.order_o
    }
    
    class func getHeight() -> CGFloat {
        return 70
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

