//
//  CanteenHomeTypeCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit


enum MenulTypeEnum{
    case foodCode([Foodcodelis])
    case shop([Ico])
    case mall([MallIco])
}


class CanteenHomeTypeCell: UITableViewCell {
    
    var dataSource:[MenulTypeEnum] = []{
        didSet{
            let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
            waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
        }
    }
    var collectionView:UICollectionView!
    var callBackAction:((Foodcodelis)->Void)?
    var callBackIconAction:((Ico)->Void)?
    var callBackMallIcon:((MallIco)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.classBackGroundColor
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.registerClassOf(ContainerCell.self)
        contentView.addSubview(collectionView)
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    class func getHeight() -> CGFloat {
        return 160
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
}

extension CanteenHomeTypeCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContainerCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         let cell = cell as? ContainerCell
         cell?.model = self.dataSource[indexPath.row]
         cell?.callBack = { [weak self] model in
            guard let strongself = self else { return }
            strongself.callBackAction?(model)
         }
         cell?.callBackIcon = { [weak self] ico in
            guard let strongself = self else { return }
            strongself.callBackIconAction?(ico)
         }
         cell?.callBackMallIcon = { [weak self] icon in
            guard let strongself = self else { return }
            strongself.callBackMallIcon?(icon)
         }
     }
}

extension CanteenHomeTypeCell:UICollectionViewDelegate {
    
}

extension CanteenHomeTypeCell:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: screenWidth, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
}



class ContainerCell:UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var model:MenulTypeEnum = .foodCode([]){
        didSet{
            let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
            waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
        }
    }

    
    var collectionView:UICollectionView!
    var callBack:((_ food:Foodcodelis) -> Void)?
    var callBackIcon:((_ icon:Ico) -> Void)?
    var callBackMallIcon:((_ icon:MallIco)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let flowlayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.registerClassOf(CanteenHeaderScrollCell.self)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
             make.edges.equalTo(contentView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch model {
        case .foodCode(let foodCode):
            return foodCode.count
        case .shop(let ico):
            return ico.count
        case .mall(let mallico):
            return mallico.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CanteenHeaderScrollCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CanteenHeaderScrollCell
        switch model {
        case .foodCode(let foodCode):
            cell.titleLable.text = foodCode[indexPath.row].displayName
            if let url = URL(string: foodCode[indexPath.row].imgUrl){
              cell.imageView.kf.setImage(with: url)
            }
        case .shop(let ico):
            cell.titleLable.text = ico[indexPath.row].title
            cell.imageView.kf.setImage(with: ico[indexPath.row].icon)
        case .mall(let mallico):
            cell.titleLable.text = mallico[indexPath.row].title
            cell.imageView.kf.setImage(with: mallico[indexPath.row].icon)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch model {
        case .foodCode(let foodCode):
            callBack?(foodCode[indexPath.row])
        case .shop(let ico):
            callBackIcon?(ico[indexPath.row])
        case .mall(let mallicon):
            callBackMallIcon?(mallicon[indexPath.row])
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(screenWidth/4), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


