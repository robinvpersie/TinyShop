//
//  GeneralizeHeaderCell.swift
//  Portal
//
//  Created by 이정구 on 2018/5/31.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GeneralizeHeaderCell: UITableViewCell {

    @IBOutlet weak var fourthlb: UILabel!
    @IBOutlet weak var thirdlb: UILabel!
    @IBOutlet weak var firstlb: UILabel!
    @IBOutlet weak var secondlb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureWithData(_ data: StoreInfomation?) {
        firstlb.text = data?.custom_name
        secondlb.text = data?.telephon
        thirdlb.text = data?.addr
        fourthlb.text = data?.mobilepho
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
