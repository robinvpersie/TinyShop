//
//  YCHomeBusinessCell.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let CellviewMargin:CGFloat = 10.0
fileprivate let collectionviweMargin:CGFloat = Ruler.iPhoneHorizontal(10, 10, 20).value
fileprivate let minimumLineSpacing:CGFloat = 10.0

protocol SelectItemDelegate: class {
    func tapItem(type: YCHomeBusinessHeader.BusinessType)
}


public class YCHomeBusinessHeader: UITableViewHeaderFooterView {
    
    
    public enum BusinessType: Int {
        case main
        case superMarket
        case ordermanage
        case customerservice
        case wallet
        case agency
        case chat
        case addressmanage
        
        init(indexPath: IndexPath) {
            self.init(rawValue: indexPath.row)!
        }
    }

  
    var dataSourceArray:  [(UIImage?, String)] = []
    var collectionView: UICollectionView!
    weak var delegate: SelectItemDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex:0xf2f2f2)
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: (screenWidth - 2 * CellviewMargin - 2 * collectionviweMargin) / 4,
                                     height: (screenWidth - 2 * CellviewMargin - 2 * collectionviweMargin) / 4)
        flowlayout.sectionInset = UIEdgeInsetsMake(CellviewMargin, CellviewMargin, CellviewMargin, CellviewMargin)
        flowlayout.minimumLineSpacing = minimumLineSpacing
        flowlayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClassOf(YCHomeBusinessCollectionCell.self)
        collectionView.layer.backgroundColor = UIColor.white.cgColor
        collectionView.layer.cornerRadius = 5
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView).offset(collectionviweMargin)
            make.trailing.bottom.equalTo(contentView).offset(-collectionviweMargin)
        }
     }
    
    
    func updateWithVer(_ ver:String?,and state:String?){
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        if ver == appVersion && state == "1" {
             dataSourceArray =  [(UIImage(named:"icon_funcationnav_home"), "主页"),
                                 (UIImage(named:"icon_funcationnav_shoppingmall"), "购物商城"),
                                 (UIImage(named:"icon_funcationnav_community"), "社区"),
                                 (UIImage(named:"icon_funcationnav_service"), "客服中心")]
        }else {
            dataSourceArray =  [(UIImage(named:"icon_funcationnav_home"), "主页"),
                                (UIImage(named:"icon_funcationnav_shoppingmall"), "购物商城"),
                                (UIImage(named:"icon_02"), "订单管理"),
                                (UIImage(named:"icon_funcationnav_service"), "客服中心"),
                                (UIImage(named:"icon_funcationnav_wallet"), "钱包"),
                                (UIImage(named:"icon_funcationnav_agent"), "代理申请"),
                                (UIImage(named:"icon_funcationnav_message"), "聊天"),
                                (UIImage(named:"icon_03"), "地址管理")]
        }
        collectionView.reloadData()
    }
    
    
    
    class func GetHeight(_ ver: String?,_ state: String?) -> CGFloat {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        if ver == appVersion && state == "1" {
            return (screenWidth - 2 * CellviewMargin - 2 * collectionviweMargin)/4  +  collectionviweMargin * 2 + CellviewMargin * 2
        }
        return collectionviweMargin * 2 + CellviewMargin * 2 + (screenWidth - 2 * CellviewMargin - 2 * collectionviweMargin)/2 + minimumLineSpacing
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}

extension YCHomeBusinessHeader: UICollectionViewDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = BusinessType(indexPath: indexPath)
        switch index {
        case .main:
            delegate?.tapItem(type: .main)
        case .superMarket:
            delegate?.tapItem(type: .superMarket)
        case .ordermanage:
            delegate?.tapItem(type: .ordermanage)
        case .customerservice:
            delegate?.tapItem(type: .customerservice)
        case .wallet:
            delegate?.tapItem(type: .wallet)
        case .agency:
            delegate?.tapItem(type: .agency)
        case .chat:
            delegate?.tapItem(type: .chat)
        case .addressmanage:
            delegate?.tapItem(type: .addressmanage)
        }
    }
   
}

extension YCHomeBusinessHeader: UICollectionViewDataSource{
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: YCHomeBusinessCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           let cell = cell as? YCHomeBusinessCollectionCell
           cell?.dataSource = dataSourceArray[indexPath.row]
        
    }

}

class YCHomeBusinessCollectionCell: UICollectionViewCell {
    
    var dataSource:(image: UIImage?,text: String)?{
        didSet{
        self.namelabel.text = dataSource?.text
        self.imageview.image = dataSource?.image
      }
    }
    
    var imageview:UIImageView!
    var namelabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageview = UIImageView()
        contentView.addSubview(imageview)
        imageview.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(contentView)
            make.height.equalTo(imageview.snp.width)
            make.width.equalTo(contentView).multipliedBy(0.7)
        }
      
        namelabel = UILabel()
        namelabel.textAlignment = .center
        namelabel.textColor = UIColor.darkcolor
        namelabel.font = UIFont.boldSystemFont(ofSize: 11)
        contentView.addSubview(namelabel)
        namelabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageview)
            make.bottom.equalTo(contentView)
        }
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
