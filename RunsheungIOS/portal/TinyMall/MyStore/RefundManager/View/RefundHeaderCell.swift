//
//  RefundHeaderCell.swift
//  Portal
//
//  Created by 이정구 on 2018/6/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RefundHeaderCell: UITableViewCell {
    
    var namelb: UILabel!
    var phonelb: UILabel!
    var addresslb: UILabel!
    var telBtn: UIButton!
    var telAction: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        makeUI()
        makeConstraints()
    }
    
    func makeUI() {
        
        namelb = UILabel()
        namelb.textColor = UIColor.darkText
        namelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(namelb)
        
        phonelb = UILabel()
        phonelb.textColor = UIColor.darkText
        phonelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(phonelb)
        
        addresslb = UILabel()
        addresslb.textColor = UIColor.darkText
        addresslb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(addresslb)
        
        telBtn = UIButton(type: .custom)
        telBtn.setImage(UIImage(named: "icon_customer_tel"), for: .normal)
        telBtn.addTarget(self, action: #selector(didtel), for: .touchUpInside)
        contentView.addSubview(telBtn)
        
    }
    
    func makeConstraints() {
        
        namelb.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(phonelb.snp.left).offset(-15)
            make.height.equalTo(namelb.font.lineHeight)
        }
        
        phonelb.snp.makeConstraints { make in
            make.left.equalTo(namelb.snp.right).offset(15)
            make.top.equalTo(namelb)
            make.right.equalTo(telBtn.snp.left).offset(-10)
            make.height.equalTo(namelb)
        }
        
        addresslb.snp.makeConstraints { make in
            make.left.equalTo(namelb)
            make.top.equalTo(namelb.snp.bottom).offset(15)
            make.right.equalTo(telBtn.snp.left).offset(-10)
            make.height.equalTo(namelb)
        }
        
        telBtn.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        
        
    }
    
    func configureWithModel(_ model: OrderReturnModel) {
        namelb.text = model.custom_name
        phonelb.text = model.mobilepho
        addresslb.text = model.to_address
    }
    
    class func getHeight() -> CGFloat {
        return 45 + UIFont.systemFont(ofSize: 14).lineHeight * 2
    }
    
    @objc func didtel() {
        telAction?()
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
