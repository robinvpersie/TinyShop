//
//  OrderCommentDetailCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit


private let avatarToTopEdge:CGFloat = 10
private let avatarImageWith:CGFloat = 30
private let avatarImageHeight:CGFloat = 30
private let texttotime:CGFloat = 10
private let texttocollection:CGFloat = 10
private let collectionToBottom:CGFloat = 20


class OrderCommentBasicCell: UITableViewCell {
    
    lazy var textView:UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkcolor
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return textView
    }()
    
    lazy var namelable:UILabel = {
        let name = UILabel()
        name.textColor = UIColor.darkcolor
        name.font = UIFont.systemFont(ofSize:15)
        return name
    }()
    
    lazy var avatarImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var timelable:UILabel = {
          let time = UILabel()
          time.textColor = UIColor.YClightGrayColor
          time.font = UIFont.systemFont(ofSize: 11)
          return time
    }()
    
    lazy var ImageCollection:UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.registerClassOf(KLProjectDetailCollectionCell.self)
        return collection
    }()
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.itemSize = CGSize(width: 80, height: 80)
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsetsMake(0, 50, 0, 15)
        return flowlayout
    }()
    
    var cosmosView:CosmosView!
    var FeedTapImagesAction:((_ transitionReferences:[Reference?],_ attchments:[URL],_ image:UIImage?,_ index:Int) -> Void)?
    var textHeightCosntraint:Constraint? = nil
    var scrollHeightConstraint:Constraint? = nil
    var images = [URL](){
        didSet{
            ImageCollection.reloadData()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(namelable)
        contentView.addSubview(timelable)
        contentView.addSubview(textView)
        contentView.addSubview(ImageCollection)
        
        cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.starSize = 15
        cosmosView.settings.starMargin = 1
        cosmosView.settings.filledColor = UIColor.orange
        cosmosView.settings.emptyBorderColor = UIColor.orange
        cosmosView.settings.filledBorderColor = UIColor.orange
        contentView.addSubview(cosmosView)
        
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(avatarToTopEdge)
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.width.equalTo(avatarImageWith)
            make.height.equalTo(avatarImageHeight)
        }
        
        cosmosView.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImageView)
            make.width.equalTo(80)
            make.height.equalTo(15)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        
        namelable.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.top.equalTo(avatarImageView.snp.top)
        }
        
        timelable.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.bottom.equalTo(avatarImageView.snp.bottom)
        }
        
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(timelable.snp.leading)
            make.top.equalTo(timelable.snp.bottom).offset(texttotime)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            self.textHeightCosntraint = make.height.equalTo(0).constraint
        }
        
        ImageCollection.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            self.scrollHeightConstraint = make.height.equalTo(0).constraint
            make.top.equalTo(textView.snp.bottom).offset(texttocollection)
        }
    }
    
    func updateWithModel(_ model:OrderFoodRepl){
        let textHeight = model.content.heightWithConstrainedWidth(width: screenWidth-15-30-10-15, font: UIFont.systemFont(ofSize: 13))
        self.textHeightCosntraint?.update(offset: ceil(textHeight))
        if model.images.isEmpty {
           self.scrollHeightConstraint?.update(offset: 0)
        }else {
           self.scrollHeightConstraint?.update(offset: 80)
        }
        
        avatarImageView.kf.setImage(with: model.iconImg, options: [.processor(RoundCornerImageProcessor(cornerRadius: 15 * UIScreen.main.scale,targetSize:CGSize(width: 30 * UIScreen.main.scale , height: 30 * UIScreen.main.scale)))])
        
        namelable.text = model.nickName
        timelable.text = model.date
        cosmosView.rating = Double(model.rate)!/2
        textView.text = model.content
        images = model.images.map({
             $0.imgUrl
        })
    }
    
    func updateWithCommentModel(_ model:CommentLis){
        
        let textHeight = model.content.heightWithConstrainedWidth(width: screenWidth-15-30-10-15, font: UIFont.systemFont(ofSize: 13))
        self.textHeightCosntraint?.update(offset: ceil(textHeight))
        if model.ImageList.isEmpty {
            self.scrollHeightConstraint?.update(offset: 0)
        }else {
            self.scrollHeightConstraint?.update(offset: 80)
        }
        avatarImageView.kf.setImage(with: model.iconImgUrl, options: [.processor(RoundCornerImageProcessor(cornerRadius: 15,targetSize:CGSize(width: 30 , height: 30)))])
        namelable.text = model.nickName
        timelable.text = model.date
        cosmosView.rating = Double(model.rate)!/2
        textView.text = model.content
        images = model.ImageList.map({
            $0.imgUrl
        })
    }
    
    class func getHeightWithCommentModel(_ model:CommentLis) -> CGFloat{
      
        let textHeight = model.content.heightWithConstrainedWidth(width: screenWidth-15-30-10-15, font: UIFont.systemFont(ofSize: 13))
        let collectionHeight:CGFloat = model.ImageList.isEmpty ? 0:80
        let textToCollection:CGFloat = model.ImageList.isEmpty ? 0:10
        return  avatarToTopEdge + avatarImageHeight + texttotime + ceil(textHeight) + collectionHeight + textToCollection + collectionToBottom
    }
    
    
    class func getHeightWithModel(_ model:OrderFoodRepl) -> CGFloat {
        
        let textHeight = model.content.heightWithConstrainedWidth(width: screenWidth-15-30-10-15, font: UIFont.systemFont(ofSize: 13))
        let collectionHeight:CGFloat = model.images.isEmpty ? 0:80
        let textToCollection:CGFloat = model.images.isEmpty ? 0:10
        return avatarToTopEdge + avatarImageHeight + texttotime + ceil(textHeight) + collectionHeight + textToCollection + collectionToBottom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OrderCommentBasicCell:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = images.first else {
            return
        }
        
        guard let imageCell = collectionView.cellForItem(at: indexPath) as? KLProjectDetailCollectionCell else {
             return
        }
        
        let references: [Reference?] = (0..<images.count).map {
            let indexPath = IndexPath(item: $0, section: indexPath.section)
            let cell = collectionView.cellForItem(at: indexPath) as? KLProjectDetailCollectionCell
            
            if cell?.superview == nil {
               return nil
            }else {
               return cell?.transitionReference
            }
        }
        FeedTapImagesAction?(references,images,imageCell.imageView.image,indexPath.item)
    }
}


extension OrderCommentBasicCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:KLProjectDetailCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! KLProjectDetailCollectionCell
        cell.url = images[indexPath.row]
    }
}





class CommentMerchantCell:OrderCommentBasicCell {
    
    var merchantView:MerchantView!
    var topConstraint:Constraint?
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        merchantView = MerchantView()
        contentView.addSubview(merchantView)
        merchantView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(textView)
            make.height.equalTo(50)
            self.topConstraint = make.top.equalTo(ImageCollection.snp.bottom).offset(15).constraint
        }
    }
    
    override class func getHeightWithCommentModel(_ model:CommentLis) -> CGFloat{
          let superHeight = super.getHeightWithCommentModel(model)
          return superHeight + 15 + 50
    }
    
    override func updateWithCommentModel(_ model:CommentLis){
          super.updateWithCommentModel(model)
          merchantView.namelb.text = model.restaurantName
          merchantView.typelb.text = model.restaurantType
          merchantView.pricelb.text = "￥" + model.averagePay! + "/人"
          merchantView.imageView.kf.setImage(with: model.thumnailImage)
        if model.ImageList.isEmpty {
           self.topConstraint?.update(offset: 0)
        }else {
           self.topConstraint?.update(offset: 15)
        }
        
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class MerchantView:UIView {
    
    var imageView:UIImageView!
    var namelb:UILabel!
    var typelb:UILabel!
    var pricelb:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground
        
        imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        namelb = UILabel()
        namelb.textColor = UIColor.darkcolor
        namelb.font = UIFont.systemFont(ofSize: 12)
        addSubview(namelb)
        namelb.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.top.equalTo(imageView)
        }
        
        typelb = UILabel()
        typelb.textColor = UIColor.YClightGrayColor
        typelb.font = UIFont.systemFont(ofSize: 11)
        addSubview(typelb)
        typelb.snp.makeConstraints { make in
            make.leading.equalTo(namelb)
            make.top.equalTo(namelb.snp.bottom).offset(10)
            make.bottom.equalTo(imageView)
        }
        
        pricelb = UILabel()
        pricelb.textColor = UIColor.YClightGrayColor
        pricelb.font = UIFont.systemFont(ofSize: 11)
        addSubview(pricelb)
        pricelb.snp.makeConstraints { make in
            make.leading.equalTo(typelb.snp.trailing).offset(15)
            make.centerY.equalTo(typelb)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}











