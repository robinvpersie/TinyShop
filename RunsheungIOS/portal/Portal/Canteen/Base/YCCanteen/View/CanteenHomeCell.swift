//
//  CanteenHomeCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher

class CanteenHomeCell: UITableViewCell {

    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var numlable: UILabel!
    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var pricelable: UILabel!
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    var longGesture:UILongPressGestureRecognizer!
    var longPressAction:(()->Void)?
    
    var model:Restaurantlis!{
        didSet{
            namelable.text = model.restaurantFullName
            if let scoreFloat = Double(model.averageRate) {
               cosmos.rating = scoreFloat/2.0
            }
            pricelable.text = "￥\(model.averagePay)/人"
            typeLable.text = model.distance
            numlable.text = "已接待:" + "\(model.salesCount)"
            avatarImgView.kf.setImage(with: model.shopThumImage, options: [.transition(.fade(0.5))])
          
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func longPress(){
        longPressAction?()
    }
    
    func updateWithModel(_ model:Favoritedat){
        
         namelable.text = model.restaurantName
         pricelable.text = "￥\(model.averagePay)"
         avatarImgView.kf.setImage(with: model.shopThumImage, options: [.transition(.fade(0.5))])
         if let scorePoint = Double(model.averageRate) {
            cosmos.rating = scorePoint/2.0
        }
    
    }
    
    class func getHeight() -> CGFloat {
        return 100
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


