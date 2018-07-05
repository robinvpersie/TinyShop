//
//  RefundInfoTableViewCell.swift
//  Portal
//
//  Created by 이정구 on 2018/7/5.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RefundInfoTableViewCell: UITableViewCell {
    
    var orderlb: UILabel!
    var refundlb: UILabel!
    var pricelb: UILabel!
    var statuslb: UILabel!
    var timelb: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let refundInfolb = UILabel()
        refundInfolb.text = "환불정보"
        refundInfolb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        refundInfolb.textColor = UIColor.darkText
        addSubview(refundInfolb)
        refundInfolb.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(15)
        }
        
        let orderleftlb = UILabel()
        orderleftlb.text = "주문번호:"
        orderleftlb.font = UIFont.systemFont(ofSize: 13)
        orderleftlb.textColor = UIColor(hex: 0x999999)
        addSubview(orderleftlb)
        
        orderlb = UILabel()
        orderlb.font = UIFont.systemFont(ofSize: 13)
        orderlb.textColor = UIColor(hex: 0x999999)
        addSubview(orderlb)
        
        orderleftlb.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(refundInfolb.snp.bottom).offset(15)
            make.right.equalTo(orderlb.snp.left).offset(-15)
        }
        
        orderlb.snp.makeConstraints { make in
            make.left.equalTo(orderleftlb.snp.right).offset(15)
            make.centerY.equalTo(orderleftlb)
        }
        
        let refundleftlb = UILabel()
        refundleftlb.font = UIFont.systemFont(ofSize: 13)
        refundleftlb.text = "환불번호:"
        refundleftlb.textColor = UIColor(hex: 0x999999)
        addSubview(refundleftlb)
        
        refundlb = UILabel()
        refundlb.font = UIFont.systemFont(ofSize: 13)
        refundlb.textColor = UIColor(hex: 0x999999)
        addSubview(refundlb)
        
        refundleftlb.snp.makeConstraints { make in
            make.left.equalTo(orderleftlb)
            make.top.equalTo(orderleftlb.snp.bottom).offset(15)
            make.right.equalTo(refundlb.snp.left).offset(-15)
        }
        
        refundlb.snp.makeConstraints { make in
            make.left.equalTo(refundleftlb.snp.right).offset(15)
            make.centerY.equalTo(refundleftlb)
        }
        
        let priceleftlb = UILabel()
        priceleftlb.font = UIFont.systemFont(ofSize: 13)
        priceleftlb.textColor = UIColor(hex: 0x999999)
        priceleftlb.text = "환불금액:"
        addSubview(priceleftlb)
        
        pricelb = UILabel()
        pricelb.font = UIFont.systemFont(ofSize: 14)
        pricelb.textColor = UIColor(hex: 0x999999)
        addSubview(pricelb)
        
        priceleftlb.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(refundleftlb.snp.bottom).offset(15)
            make.right.equalTo(pricelb.snp.left).offset(-15)
        }
        
        pricelb.snp.makeConstraints { make in
            make.left.equalTo(priceleftlb.snp.right).offset(15)
            make.centerY.equalTo(priceleftlb)
        }
        
        let statusleftlb = UILabel()
        statusleftlb.textColor = UIColor(hex: 0x999999)
        statusleftlb.font = UIFont.systemFont(ofSize: 13)
        statusleftlb.text = "환불상태:"
        addSubview(statusleftlb)
        
        statuslb = UILabel()
        statuslb.textColor = UIColor(hex: 0x999999)
        statuslb.font = UIFont.systemFont(ofSize: 14)
        addSubview(statuslb)
        
        statusleftlb.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(priceleftlb.snp.bottom).offset(15)
            make.right.equalTo(statuslb.snp.left).offset(-15)
        }
        
        statuslb.snp.makeConstraints { make in
            make.left.equalTo(statusleftlb.snp.right).offset(15)
            make.centerY.equalTo(statusleftlb)
        }
        
        let timeleftlb = UILabel()
        timeleftlb.textColor = UIColor(hex: 0x999999)
        timeleftlb.font = UIFont.systemFont(ofSize: 13)
        timeleftlb.text = "신청시간:"
        addSubview(timeleftlb)
        
        timelb = UILabel()
        timelb.textColor = UIColor(hex: 0x999999)
        timelb.font = UIFont.systemFont(ofSize: 14)
        addSubview(timelb)
        
        timeleftlb.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(statusleftlb.snp.bottom).offset(15)
            make.right.equalTo(timelb.snp.left).offset(-15)
        }
        
        timelb.snp.makeConstraints { make in
            make.left.equalTo(timeleftlb.snp.right).offset(15)
            make.centerY.equalTo(timeleftlb)
        }
        
    }
    
    class func getHeight() -> CGFloat {
        return 200
    }
    
    func configureWithModel(_ model: OrderReturnModel) {
        orderlb.text = model.order_num
        refundlb.text = model.cancel_num
        pricelb.text = model.tot_amt
        statuslb.text = model.status_classify
        timelb.text = model.cancel_date
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
