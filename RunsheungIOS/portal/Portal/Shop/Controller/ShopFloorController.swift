//
//  ShopFloorController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit


class ShopFloorController:ShopCollectionViewController,UICollectionViewDelegateFlowLayout {
    
    init(floorNum:Int){
        let collectionViewLayOut = UICollectionViewFlowLayout()
        collectionViewLayOut.scrollDirection = .vertical
        self.floorNum = floorNum
        super.init(collectionViewLayout: collectionViewLayOut)
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section:Int{
       case info
       case segment
       case brand
       case product
       case hot
       static let count = 5
       
        init(section:Int){
            self = Section(rawValue: section)!
        }
        
        init(indexPath:IndexPath){
            self = Section(rawValue: indexPath.section)!
        }
        
    }
    var currentIndex:Int = 0
    var floorNum:Int
    var mainModel:ShopHomeModel?
    var divCode:String?
    var floorModel:ShopFloorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let collectionView = collectionView {
             collectionView.registerClassOf(YCInfiniteCollectionCell.self)
             collectionView.registerClassOf(ShopBrandFilterCell.self)
             collectionView.registerHeaderClassOf(BrandHeader.self)
             collectionView.registerClassOf(ShopHomeHeaderCell.self)
             collectionView.registerClassOf(ShopHomeSegmentCell.self)
             collectionView.registerClassOf(ShopDescriptionCell.self)
             collectionView.backgroundColor = UIColor.groupTableViewBackground
             requestData(.Static)
        }
    }
    
    private func requestData(_ updateModel:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching { return }
        isFetching = true
        ShopFloorModel.getWithFloorNum(floorNum,divCode:divCode ?? "1") { result in
            self.isFetching = false
            self.isloading = false
            switch result {
            case .success(let model):
                self.floorModel = model
                let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
                waytoUpdate.performWithCollectionView(collectionview: self.collectionView!)
                finish?()
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
                waytoUpdate.performWithCollectionView(collectionview: self.collectionView!)
                finish?()

            }
        }
    }
    
    override func topRefresh() {
        requestData(.TopRefresh) {
            self.collectionView?.mj_header.endRefreshing()
        }
    }
    
    override func fetchAgain() {
        requestData(.Static)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let _ = self.floorModel else { return 0 }
        return Section.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(section: section)
        switch section {
        case .info:
            return floorModel!.adInfo.isEmpty ? 1:2
        case .segment:
            return 1
        case .brand:
              let count = floorModel!.floorBrandCategory.count
              if count > currentIndex {
                 return floorModel!.floorBrandCategory[currentIndex].mBrandList.count
              }else {
                return 0
              }
        case .product:
            if let eventGoods = floorModel?.floorEvent10.first {
               return eventGoods.eventGoods10.count
            }else {
                return 0
            }
        case .hot:
            if let event = floorModel?.floorEvent20.first {
                return event.eventGoods20.count
            }else {
                return 0
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(indexPath: indexPath)
        switch section {
        case .info:
           if indexPath.row == 0 {
                if !self.floorModel!.adInfo.isEmpty {
                    let cell:ShopHomeHeaderCell = collectionView.dequeueReusableCell(indexpath: indexPath)
                    cell.updateWithMainModel(floorModel: floorModel!)
                    cell.selectIndex = { [weak self] banner in
                    guard let strongself = self else { return }
                    let detail = GoodsDetailController()
                    detail.controllerType = .departmentStores
                    detail.item_code = banner.itemCode
                    detail.divCode = strongself.divCode
                    strongself.navigationController?.pushViewController(detail, animated: true)
                  }
                  return cell
                }else {
                    let cell:ShopDescriptionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
                    cell.updateWithModel(floorModel!)
                    return cell
                 }
            }else {
                let cell:ShopDescriptionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
                cell.updateWithModel(floorModel!)
                return cell
            }
        case .segment:
            let cell:ShopHomeSegmentCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        case .brand,.product:
            let cell:YCInfiniteCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        case .hot:
            let cell:ShopBrandFilterCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(indexPath: indexPath)
        switch section {
        case .brand:
            let brandcode = floorModel!.floorBrandCategory[currentIndex].mBrandList[indexPath.row].customCode
            let parameter = FilterParameter(brandCode:brandcode,divCode:divCode ?? "")
            let filter = ShopBrandFilterController(with: parameter)
            self.navigationController?.pushViewController(filter, animated: true)
        case .product:
            let detail = GoodsDetailController()
            detail.controllerType = .departmentStores
            detail.item_code = floorModel!.floorEvent10[0].eventGoods10[indexPath.row].itemCode
            detail.divCode = divCode ?? ""
            navigationController?.pushViewController(detail, animated: true)
        case .hot:
            let itemcode = floorModel!.floorEvent20[0].eventGoods20[indexPath.row].itemCode
            let detail = GoodsDetailController()
            detail.controllerType = .departmentStores
            detail.item_code = itemcode
            detail.divCode = divCode ?? ""
            self.navigationController?.pushViewController(detail, animated: true)
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = Section(indexPath: indexPath)
        switch section {
        case .info:
            break
        case .segment:
            let cell = cell as? ShopHomeSegmentCell
            cell?.updateWithModel(floorModel!,offset:currentIndex)
            cell?.selectIndex = { [weak self] Floorbrandcategor,index in
                guard let strongself = self else { return }
                strongself.currentIndex = index
                collectionView.reloadSections([Section.brand.rawValue])
            }
        case .brand:
            let cell = cell as? YCInfiniteCollectionCell
            cell?.imageUrl = floorModel?.floorBrandCategory[currentIndex].mBrandList[indexPath.row].imageUrl
        case .product:
            let cell = cell as? YCInfiniteCollectionCell
            cell?.imageUrl = floorModel?.floorEvent10.first?.eventGoods10[indexPath.row].imageUrl
        case .hot:
            let cell = cell as? ShopBrandFilterCell
            cell?.updateWithEvent((floorModel!.floorEvent20.first?.eventGoods20[indexPath.row])!)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = Section(indexPath: indexPath)
        let brand:BrandHeader = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionHeader, forIndexPath: indexPath)
        brand.backgroundColor = UIColor.white
        brand.titlelb.textColor = UIColor.navigationbarColor
        switch section {
          case .product:
            brand.titlelb.text = "产品促销".localized
        case .hot:
            brand.titlelb.text = "热销推荐".localized
         default:
            break
        }
         return brand
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(indexPath: indexPath)
        switch section {
        case .info:
            if indexPath.row == 0 {
                if floorModel!.adInfo.isEmpty {
                    return ShopDescriptionCell.GetSize(floorModel: floorModel!)
                }else {
                  return ShopHomeHeaderCell.GetSizeWithModel(floorModel!)
                }
            }else {
               return ShopDescriptionCell.GetSize(floorModel:floorModel!)
            }
        case .segment:
            return ShopHomeSegmentCell.getSize()
        case .brand:
            let Itemwidth = (screenWidth-3)/4.0
            return CGSize(width: Itemwidth, height: Itemwidth)
        case .product:
            let itemwidth = (screenWidth-2)/3.0
            return CGSize(width: itemwidth, height: itemwidth)
        case .hot:
            return ShopBrandFilterCell.getSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(section: section)
        switch section {
        case .info:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .product:
            return UIEdgeInsets(top: 1, left: 0, bottom: 10, right: 0)
        case .hot:
            return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        case .brand:
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        default:
            return UIEdgeInsetsMake(10, 0, 0, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = Section(section: section)
        switch section {
        case .product,.hot:
            return CGSize(width: screenWidth, height: 40)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}









