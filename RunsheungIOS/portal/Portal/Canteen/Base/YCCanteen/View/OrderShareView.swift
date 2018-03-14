//
//  OrderShareView.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderShareView:UIView {
    
    enum rowType:Int {
        case chatfriend
        case scan
        case copy
        case wechatfriend
        case wechattimeline
        
        var image:UIImage?{
            switch self {
            case .chatfriend:
                return UIImage(named: "")
            case .scan:
                return UIImage(named: "")
            case .copy:
                return UIImage(named: "")
            case .wechatfriend:
                return UIImage(named: "")
            case .wechattimeline:
                return UIImage(named: "")
            }
        }
        
        var name:String {
            switch self {
            case .chatfriend:
                return "龙聊好友"
            case .scan:
                return "当面扫码"
            case .copy:
                return "复制链接"
            case .wechatfriend:
                return "微信好友"
            case .wechattimeline:
                return "微信朋友圈"
            }
        }
    }
    
    enum sectionType:Int{
       case share
       case cancle
    }
    var shareAction:((_ type:rowType) -> Void)?
    var backgroundView:UIButton!
    var collectionView:UICollectionView!
    var bottomConstraint:Constraint? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        backgroundView = UIButton(type: .custom)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.5
        backgroundView.addTarget(self, action: #selector(hide), for: .touchUpInside)
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClassOf(CanteenHeaderScrollCell.self)
        collectionView.registerClassOf(OrderShareCancleCell.self)
        collectionView.backgroundColor = UIColor.white
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(200)
            self.bottomConstraint = make.bottom.equalTo(self.snp.bottom).offset(200).constraint
        }
    }
    
    func hideAndDo(finishAction:(()->Void)?){
        
        UIView.animate(withDuration: 0.1, animations: {
            self.removeFromSuperview()
        }) { (finish) in
            if finish {
              self.bottomConstraint?.update(offset: 200)
              finishAction?()
            }
        }
    
    }
    
    
    func hide(){
       
        UIView.animate(withDuration: 0.1, animations: {
            self.removeFromSuperview()
        }) { (finish) in
            if finish {
            self.bottomConstraint?.update(offset: 200)
           }
        }
    
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }

    }
    
    
    func showInView(superView view:UIView?){
        
        guard let superview = view else { return }
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(superview).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrderShareView:UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .share:
            guard let rowtype = rowType(rawValue: indexPath.row) else { return }
            hideAndDo(finishAction: {
                self.shareAction?(rowtype)
             })
        case .cancle:
            hide()
        }
        
    }
}

extension OrderShareView:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .share:
            return CGSize(width: screenWidth/4.0, height: 80)
        case .cancle:
            return CGSize(width: screenWidth, height: 40)
        }
        
    }

}

extension OrderShareView:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = sectionType(rawValue: section) else { return 0 }
        switch section {
        case .share:
            return 5
        case .cancle:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .share:
            let cell:CanteenHeaderScrollCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        case .cancle:
            let cell:OrderShareCancleCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .share:
            guard let type = rowType(rawValue: indexPath.row) else { return }
            let cell = cell as! CanteenHeaderScrollCell
            cell.imageView.image = type.image
            cell.titleLable.text = type.name
        default:
            break
        }
    }
}


class OrderShareCancleCell:UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        let cancle = UILabel()
        cancle.textColor = UIColor.darkcolor
        cancle.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(cancle)
        cancle.text = "取消"
        cancle.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
