//
//  ProfileServiceCell.swift
//  Portal
//
//  Created by linpeng on 2018/1/10.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ProfileServiceCell: UITableViewCell {
    
    enum serviceType:Int {
        case needPay
        case needDeliver
        case needReceive
        case needComment
        case needRefund
        static let count = 5
        
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.row)!
        }
        
        var title:String {
            switch self {
            case .needPay:
                return "待付款"
            case .needDeliver:
                return "待发货"
            case .needReceive:
                return "待收货"
            case .needComment:
                return "待评论"
            case .needRefund:
                return "退款/售后"
            }
        }
        
        var image:UIImage? {
            switch self {
            case .needPay:
                return UIImage(named: "icon_pending_payment")?.withRenderingMode(.alwaysOriginal)
            case .needDeliver:
                return UIImage(named: "icon_pending_delivery")?.withRenderingMode(.alwaysOriginal)
            case .needReceive:
                return UIImage(named: "icon_pending_sign")?.withRenderingMode(.alwaysOriginal)
            case .needComment:
                return UIImage(named: "icon_pending_evaluate")?.withRenderingMode(.alwaysOriginal)
            case .needRefund:
                return  UIImage(named: "icon_after_sales")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    var collectionView:UICollectionView!
    var collectionFlowLayout:UICollectionViewFlowLayout!
    var selectAction: ((serviceType) -> Void)?
    var profileModel:ProfileModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none 
        
        collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClassOf(ServiceUnitCell.self)
        collectionView.backgroundColor = UIColor.clear
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    func configureWithModel(_ model:ProfileModel?) {
            profileModel = model
            collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionFlowLayout.itemSize = CGSize(width: frame.size.width / 5.0, height: frame.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func getHeight() -> CGFloat {
        return 80
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfileServiceCell:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let servicetype = serviceType(indexPath: indexPath)
        let cell:ServiceUnitCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        cell.imgView.image = servicetype.image
        cell.titlelb.text = servicetype.title
        switch servicetype {
        case .needComment:
            cell.imgView.showBadge(with: .number, value: profileModel?.waitCommentCount ?? 0, animationType: .none)
        case .needDeliver:
            cell.imgView.showBadge(with: .number, value: profileModel?.waitSendCount ?? 0, animationType: .none)
        case .needPay:
            cell.imgView.showBadge(with: .number, value: profileModel?.waitPayCount ?? 0, animationType: .none)
        case .needReceive:
            cell.imgView.showBadge(with: .number, value: profileModel?.waitReceiveCount ?? 0, animationType: .none)
        case .needRefund:
            cell.imgView.showBadge(with: .number, value: profileModel?.waitSendCount ?? 0, animationType: .none)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let servicetype = serviceType(indexPath: indexPath)
        selectAction?(servicetype)
    }
    
}


fileprivate class ServiceUnitCell: UICollectionViewCell {
    
    var imgView:UIImageView!
    var titlelb:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        titlelb = UILabel()
        titlelb.textColor = UIColor.YClightGrayColor
        titlelb.font = UIFont.systemFont(ofSize: 13)
        addSubview(titlelb)
        titlelb.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-4)
            make.centerX.equalTo(self)
        }
        
        imgView = UIImageView()
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(titlelb.snp.top).offset(-10)
            make.width.height.equalTo(25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
