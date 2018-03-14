//
//  OffOrderDetailCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/11/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OffOrderDetailCell: UITableViewCell {
    
    var imgView:UIImageView!
    var titlelb:UILabel!
    var priceAndNumlb:UILabel!
    var totalPricelb:UILabel!
    var model:OffOrderDetailModel.Orderdetai!{
        didSet{
            imgView.kf.setImage(with: URL(string: model.itemImage))
            titlelb.text = model.itemName
            let unitPrice = model.orderP
            let multi = model.orderQ
            let total = model.orderO
            priceAndNumlb.text = "￥" + unitPrice + "   " + "x\(multi)"
            totalPricelb.text = "￥" + total
            isDeleteSelected = model.isNeedDelete
            if model.str300t_refund_status == "CR" {
                statuslb.text = "退款申请完成"
                statuslb.textColor = UIColor.orange
                statuslb.isHidden = false
                helpBtn.isHidden = false
            }else if model.sof110t_refund_status == "5" {
                statuslb.text = "退款完毕"
                statuslb.textColor = UIColor(red: 116.0/255.0, green: 117.0/255.0, blue: 92.0/255.0, alpha: 1)
                statuslb.isHidden = false
                helpBtn.isHidden = true
            }else if model.str300t_refund_status != "CR" && model.sof110t_refund_status != "5" {
                statuslb.text = "支付完毕"
                statuslb.textColor = UIColor.darkText
                statuslb.isHidden = false
                helpBtn.isHidden = true
            }
        }
    }
    var containerLeadingConstraint:NSLayoutConstraint!
    var scopeBtn:UIButton!
    var statuslb:UILabel!
    var helpBtn:UIButton!
    var scopeAction: ((Bool)->())?
    var helpAction:(() -> ())?
    var isDeleteSelected:Bool = false {
        didSet {
            if isDeleteSelected {
                scopeBtn.setImage(UIImage(named: "icon_qq1"), for: .normal)
            }else {
                scopeBtn.setImage(UIImage(named: "icon_qq1c"), for: .normal)
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        
        scopeBtn = UIButton(type: .custom)
        scopeBtn.addTarget(self, action: #selector(didScope), for: .touchUpInside)
        scopeBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scopeBtn)
        scopeBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        scopeBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        scopeBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        scopeBtn.heightAnchor.constraint(equalTo: scopeBtn.widthAnchor).isActive = true
        
        
        let height = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold).lineHeight + 15 + UIFont.systemFont(ofSize: 13).lineHeight * 2 + 10
        selectionStyle = .none
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        containerLeadingConstraint.isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imgView)
        imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant:15).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: height).isActive = true
        imgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        titlelb.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titlelb)
        titlelb.leadingAnchor.constraint(equalTo: imgView.trailingAnchor,constant:8).isActive = true
        titlelb.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        
        priceAndNumlb = UILabel()
        priceAndNumlb.textColor = UIColor.YClightGrayColor
        priceAndNumlb.font = UIFont.systemFont(ofSize: 13)
        priceAndNumlb.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(priceAndNumlb)
        priceAndNumlb.leadingAnchor.constraint(equalTo: titlelb.leadingAnchor).isActive = true
        priceAndNumlb.topAnchor.constraint(equalTo: titlelb.bottomAnchor,constant:15).isActive = true
        
        totalPricelb = UILabel()
        totalPricelb.textColor = UIColor.YClightGrayColor
        totalPricelb.font = UIFont.systemFont(ofSize: 13)
        totalPricelb.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(totalPricelb)
        totalPricelb.leadingAnchor.constraint(equalTo: priceAndNumlb.leadingAnchor).isActive = true
        totalPricelb.topAnchor.constraint(equalTo: priceAndNumlb.bottomAnchor, constant: 10).isActive = true
        
        statuslb = UILabel()
        statuslb.translatesAutoresizingMaskIntoConstraints = false
        statuslb.isHidden = true
        statuslb.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(statuslb)
        statuslb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        statuslb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        helpBtn = UIButton(type: .custom)
        helpBtn.addTarget(self, action: #selector(didHelp), for: .touchUpInside)
        helpBtn.setTitle("帮助?", for: .normal)
        helpBtn.setTitleColor(UIColor.YClightBlueColor, for: .normal)
        helpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        helpBtn.translatesAutoresizingMaskIntoConstraints = false
        helpBtn.isHidden = true
        contentView.addSubview(helpBtn)
        helpBtn.topAnchor.constraint(equalTo: statuslb.bottomAnchor, constant: 3).isActive = true
        helpBtn.centerXAnchor.constraint(equalTo: statuslb.centerXAnchor).isActive = true 
       
        
    }
    
    @objc func didHelp(){
        helpAction?()
    }
    
    @objc func didScope(){
        isDeleteSelected = !isDeleteSelected
        scopeAction?(isDeleteSelected)
    }
    
    func updateShowScope(_ isShow:Bool){
        
        if model.str300t_refund_status != "CR" && model.sof110t_refund_status != "5" {
               UIView.performWithoutAnimation { [weak self] in
                  self?.containerLeadingConstraint.constant = isShow ? 40:0
               }
            }
     }
    
    
    class func getHeight() -> CGFloat {
        let height = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold).lineHeight + 15 + UIFont.systemFont(ofSize: 13).lineHeight * 2 + 30
        return height
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
