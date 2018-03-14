//
//  OrderMyCommentCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

private let cellleftEdge:CGFloat = 15
private let celltopEdge:CGFloat = 10
private let CellBottomEdge:CGFloat = 10
private let textToAvatarEdge:CGFloat = 10
private let textToImgEdge:CGFloat = 10
private let textOrImageToShopEdge:CGFloat = 10

final class OrderMyCommentImageCell:OrderMyCommentBaseCell,UICollectionViewDelegate,UICollectionViewDataSource{
    
    lazy var collectionView:UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.registerClassOf(KLProjectDetailCollectionCell.self)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: 60, height: 60)
        flow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        return flow
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         selectionStyle = .none
         contentView.addSubview(collectionView)
         collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(60)
            make.top.equalTo(self.textView.snp.bottom).offset(textToImgEdge)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:KLProjectDetailCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! KLProjectDetailCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override class func getHeight() -> CGFloat {
        return  super.getHeight() + textToImgEdge
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class OrderMyCommentBaseCell: UITableViewCell {
    
    lazy var avatarImgView:UIImageView = UIImageView()
    
    lazy var namelb:UILabel = {
        let name = UILabel()
        name.textColor = UIColor.darkcolor
        name.font = UIFont.systemFont(ofSize: 15)
        return name
    }()
    
    var timelb:UILabel = {
        let time = UILabel()
        time.textColor = UIColor.YClightGrayColor
        time.font = UIFont.systemFont(ofSize: 13)
        return time
    }()
    
    
    var cosmosView:CosmosView!
    
    lazy var shopView:MyCommentShopView = MyCommentShopView()
    
    lazy var textView:UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkcolor
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    var textHeightConstraint:Constraint? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(avatarImgView)
        contentView.addSubview(namelb)
        contentView.addSubview(timelb)
        
        cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.starSize = 10
        cosmosView.settings.starMargin = 1
        cosmosView.settings.filledColor = UIColor.orange
        cosmosView.settings.emptyBorderColor = UIColor.orange
        cosmosView.settings.filledBorderColor = UIColor.orange
        contentView.addSubview(cosmosView)
        
        contentView.addSubview(shopView)
        contentView.addSubview(textView)
        
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        avatarImgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(celltopEdge)
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        namelb.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImgView.snp.top)
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
         }
        
        cosmosView.snp.makeConstraints { (make) in
            make.leading.equalTo(namelb)
            make.bottom.equalTo(avatarImgView)
            make.height.equalTo(10)
            make.width.equalTo(80)
        }
        
        timelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.centerY.equalTo(namelb.snp.centerY)
        }
        
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(avatarImgView.snp.bottom).offset(textToAvatarEdge)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            self.textHeightConstraint = make.height.equalTo(0).constraint
        }
        
        shopView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.bottom.equalTo(contentView.snp.bottom).offset(-CellBottomEdge)
            make.height.equalTo(50)
        }
    }
    
    class func getHeight() -> CGFloat {
         return celltopEdge + 30  + CellBottomEdge + 50 + textToAvatarEdge + textOrImageToShopEdge
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


class MyCommentShopView:UIView {
    
    var shopAvatarImgView:UIImageView!
    var shopName:UILabel!
    var shopType:UILabel!
    var price:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.YClightGrayColor
        shopAvatarImgView = UIImageView()
        addSubview(shopAvatarImgView)
        shopAvatarImgView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(shopAvatarImgView.snp.height)
        }
        
        shopName = UILabel()
        shopName.textColor = UIColor.darkcolor
        shopName.font = UIFont.systemFont(ofSize: 13)
        addSubview(shopName)
        shopName.snp.makeConstraints { (make) in
            make.leading.equalTo(shopAvatarImgView.snp.trailing).offset(10)
            make.top.equalTo(shopAvatarImgView.snp.top)
        }
        
        shopType = UILabel()
        shopType.textColor = UIColor.darkcolor
        shopType.font = UIFont.systemFont(ofSize: 13)
        addSubview(shopType)
        shopType.snp.makeConstraints { (make) in
            make.bottom.equalTo(shopAvatarImgView.snp.bottom)
            make.leading.equalTo(shopName.snp.leading)
        }
        
        price = UILabel()
        price.textColor = UIColor.YClightGrayColor
        price.font = UIFont.systemFont(ofSize: 13)
        addSubview(price)
        price.snp.makeConstraints { (make) in
            make.centerY.equalTo(shopType.snp.centerY)
            make.leading.equalTo(shopType.snp.trailing).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}






