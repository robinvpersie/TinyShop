//
//  GeneralizeSecondCell.swift
//  Portal
//
//  Created by 이정구 on 2018/5/31.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GeneralizeSecondCell: UITableViewCell {

    @IBOutlet weak var contentlb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none 
        // Initialization code
    }
    
    func configureWithData(_ data: StoreInfomation?) {
        
        contentlb.text = data?.shop_info
        
    }
    
    class func getHeightWithData(_ data: StoreInfomation?) -> CGFloat {
        if let shopInfo = data?.shop_info {
            let height = shopInfo.heightWithConstrainedWidth(width: Constant.screenWidth - 30, font: UIFont.systemFont(ofSize: 14)) + 70
            return height
        }
        return 70
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
