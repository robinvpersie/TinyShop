//
//  RSCategoryCollectionCell.swift
//  Portal
//
//  Created by zhengzeyou on 2017/12/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class RSCategoryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageName:String{
        didSet{
            iconImg.image = UIImage(named: imageName)
        }
    }
     var imageTitle:String {
        didSet{
           titleLabel.text = imageTitle
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
      
        self.imageName = ""
        self.imageTitle = ""
        super.init(coder: aDecoder)
        
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }

}
extension RSCategoryCollectionCell{

    
}



