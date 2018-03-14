//
//  YCHomeHeaderCell.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit


fileprivate let itemheight:CGFloat = Ruler.iPhoneVertical(140, 140, 150, 160).value


class YCHomeHeaderCell: UITableViewCell {
    
    var didselectIndex:((Int) -> Void)?
    var dataModel: MainModel? {
        didSet{
            if let datamodel = dataModel{
                var items = [YCInfiniteItem]()
                let bannerData = datamodel.bannerData
                for x in bannerData {
                    let item = YCInfiniteItem(imageUrl: URL(string: baseImgUrl + x.imgUrl)!, imageVer: x.ver)
                    items.append(item)
                }
            }
        }
    }
    
    var infiniteView: YCInfiniteScrollView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        infiniteView = YCInfiniteScrollView()
        addSubview(infiniteView)
        infiniteView.didSelectItemAtIndex = { [weak self] index in
            guard let strongself = self else { return }
            strongself.didselectIndex?(index)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infiniteView.frame = CGRect(x: 0, y: 0, width: frame.width, height: itemheight)
    }
    
    class func GetHeight() -> CGFloat{
        return itemheight
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
