//
//  SocailView.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class SocailView: UIView {
    
    enum shareType:Int{
        case long
        case wechatSession
        case wechatTimeLine
        case wechatFavorite
        case qq
        case sina
        
        var title:String {
            switch self {
            case .long:
                return "龙聊"
            case .wechatSession:
                return "微信"
            case .wechatTimeLine:
                return "朋友圈"
            case .wechatFavorite:
                return "收藏"
            case .qq:
                return "QQ"
            case .sina:
                return "新浪"
            }
        }
        
        var image:UIImage?{
            switch self {
            case .long:
                return UIImage(named: "longicon")
            case .qq:
                return UIImage(named: "umsocial_qq")
            case .sina:
                return UIImage(named: "umsocial_sina")
            case .wechatFavorite:
                return UIImage(named: "umsocial_wechat_favorite")
            case .wechatSession:
                return UIImage(named: "umsocial_wechat")
            case .wechatTimeLine:
                return UIImage(named: "umsocial_wechat_timeline")
            }
        }
       
        static let count = 6
        
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.row)!
        }
        
        init(section:Int){
            self.init(rawValue: section)!
        }
    }
    
    var collectionView:UICollectionView!
    var cancleBtn:UIButton!
    var containerView:UIButton!
    var fatherView:UIView!
    let cellSize:CGSize = CGSize(width: 60, height: 90)
    let cancleBtnHeight:CGFloat = 45
    var bottomConstraint:Constraint?
    var layout:UICollectionViewFlowLayout!
    var shareAction:((shareType)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        containerView = UIButton()
        containerView.addTarget(self, action: #selector(cancle), for: .touchUpInside)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(containerView)

        fatherView = UIView()
        fatherView.backgroundColor = UIColor.white
        addSubview(fatherView)

        cancleBtn = UIButton(type: .custom)
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(UIColor.darkText, for: .normal)
        cancleBtn.layer.backgroundColor = UIColor.white.cgColor
        cancleBtn.addTarget(self, action: #selector(cancle), for: .touchUpInside)
        fatherView.addSubview(cancleBtn)


        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.BaseControllerBackgroundColor
        collectionView.registerClassOf(SocialShareCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        fatherView.addSubview(collectionView)
        
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        fatherView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(cellSize.height * 2 + cancleBtnHeight)
            bottomConstraint = make.bottom.equalTo(self).offset(cellSize.height * 2 + cancleBtnHeight).constraint
        }


        cancleBtn.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(fatherView)
            make.height.equalTo(cancleBtnHeight)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(fatherView)
            make.bottom.equalTo(cancleBtn.snp.top)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout.itemSize = CGSize(width: width/4.0, height: cellSize.height)
    }
    
    func showInView(_ view:UIView){
        
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint?.update(offset: 0)
        })
        
    }
    
    @objc func cancle(){
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint?.update(offset: self.cellSize.height * 2 + self.cancleBtnHeight)
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocailView:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SocialShareCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        let type = shareType(indexPath: indexPath)
        cell.shareTitlelb.text = type.title
        cell.shareBtn.setImage(type.image, for: .normal)
        cell.shareAction = { [weak self] in
            guard let strongself = self else {
                return
            }
            strongself.shareAction?(type)
            strongself.cancle()
        }
        return cell
    }
}

extension SocailView:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
