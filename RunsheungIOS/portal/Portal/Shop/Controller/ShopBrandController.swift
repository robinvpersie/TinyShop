//
//  ShopBrandController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopBrandController: ShopCollectionViewController,UICollectionViewDelegateFlowLayout {
    
    init(divCode:String){
      self.divCode = divCode
      let collectionViewLayOut = UICollectionViewFlowLayout()
      super.init(collectionViewLayout: collectionViewLayOut)
    }
    
    var divCode:String
    var BrandModel:ShopBrandModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "品牌".localized
        collectionView?.registerClassOf(YCInfiniteCollectionCell.self)
        collectionView?.registerHeaderClassOf(BrandHeader.self)
        collectionView?.backgroundColor = UIColor.groupTableViewBackground
        requestData(.Static)

    }
    
    override func topRefresh() {
         requestData(.TopRefresh) { [weak self] in
            self?.collectionView?.mj_header.endRefreshing()
        }
    }
    
    override func fetchAgain() {
        requestData(.Static)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func requestData(_ updateModel:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        ShopBrandModel.GetWithDiv(self.divCode, failureHandler: { [weak self] reason, errormessage in
            self?.showMessage(errormessage)
            self?.isFetching = false
            self?.isloading = false
            self?.collectionView?.reloadData()
            finish?()
        }) { [weak self] shopBrandModel in
            self?.isFetching = false
            self?.isloading = false
            self?.BrandModel = shopBrandModel
            let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
            waytoUpdate.performWithCollectionView(collectionview: (self?.collectionView!)!)
            finish?()
        }
    
    }

   

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.BrandModel!.data[indexPath.section].brandList[indexPath.row]
        let filter = FilterParameter(brandCode: model.customCode, divCode: self.divCode)
        let shopBrandFilter = ShopBrandFilterController(with: filter)
        self.navigationController?.pushViewController(shopBrandFilter, animated: true)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let model = self.BrandModel else {
            return 0
        }
        return model.data.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.BrandModel!.data[section].brandList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:YCInfiniteCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header:BrandHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, forIndexPath: indexPath)
        header.titlelb.text = self.BrandModel!.data[indexPath.section].brandType
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? YCInfiniteCollectionCell
        cell?.imageUrl = self.BrandModel!.data[indexPath.section].brandList[indexPath.row].imageUrl
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Itemwidth = (screenWidth-3)/4.0
        return CGSize(width: Itemwidth, height: Itemwidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class BrandHeader:UICollectionReusableView {
    
    lazy var titlelb:UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor = UIColor.darkcolor
        return lable
    }()
    
    var bottomView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(titlelb)
        self.titlelb.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(self.bottomView)
        self.bottomView.backgroundColor = UIColor.groupTableViewBackground
        self.bottomView.isHidden = true 
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
