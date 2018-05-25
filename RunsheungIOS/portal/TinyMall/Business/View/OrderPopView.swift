//
//  OrderPopView.swift
//  Portal
//
//  Created by 이정구 on 2018/5/24.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class OrderPopView: UIView {
    
    var collectionView: UICollectionView!
    var bottomView: UIView!
    var titlelb: UILabel!
    var closeBtn: UIButton!
    var flowlayout: UICollectionViewFlowLayout!
    var pricelb: UILabel!
    var dataSource: StoreDetail?
    var foodSpecIndex: Int = 0
    var foodFlavorIndex: Int = 0
    var buyAction: ((_ itemcode: String, _ price: Float, _ name: String) -> ())?
    var title: String?
    var closeAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.white.cgColor
        
        closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(didClose), for: .touchUpInside)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(10)
            make.width.height.equalTo(21)
        }
        
        titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 17)
        addSubview(titlelb)
        titlelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(closeBtn)
        }
        
        flowlayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.registerClassOf(OrderTypeCell.self)
        collectionView.registerHeaderClassOf(OrderHeaderView.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(titlelb.snp.bottom).offset(15)
            make.bottom.equalTo(self)
        }
        
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(60)
        }
        
        pricelb = UILabel()
        pricelb.textColor = UIColor(hex: 0xdd0909)
        pricelb.font = UIFont.systemFont(ofSize: 18)
        bottomView.addSubview(pricelb)
        pricelb.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(15)
            make.centerY.equalTo(bottomView)
        }
        
        let buyBtn = UIButton(type: .custom)
        buyBtn.addTarget(self, action: #selector(didBuy), for: .touchUpInside)
        buyBtn.setTitle("加入购物车", for: .normal)
        buyBtn.setTitleColor(UIColor.white, for: .normal)
        buyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        buyBtn.layer.cornerRadius = 4
        buyBtn.layer.backgroundColor = UIColor(red: 31, green: 184, blue: 59).cgColor
        bottomView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView).offset(-15)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
    }
    
    func reloadDataWith(_ storeDetail: StoreDetail, title: String?) {
        foodSpecIndex = 0
        foodFlavorIndex = 0
        dataSource = storeDetail
        titlelb.text = title
        self.title = title
        pricelb.text = "￥" + storeDetail.FoodSpec[foodSpecIndex].item_p
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowlayout.itemSize = CGSize(width: floor((frame.width - 50.0) / 3.0), height: 40.0)
        flowlayout.minimumInteritemSpacing = 10
        flowlayout.minimumLineSpacing = 10
        flowlayout.headerReferenceSize = CGSize(width: self.frame.width - 30, height: 40)
        
    }
    
    @objc func didBuy() {
        if let dataSource = dataSource {
            let foodSpec = dataSource.FoodSpec[foodSpecIndex]
            let littleName = dataSource.FoodSpec[foodSpecIndex].item_name
            var totalName: String = "" 
            if let title = self.title {
              totalName = title + "(\(littleName))"
            }
            buyAction?(foodSpec.item_code, Float(foodSpec.item_p) ?? 0, totalName)
        }
    }
    
    @objc func didClose() {
        closeAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OrderPopView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            foodSpecIndex = indexPath.row
            pricelb.text = "￥" + dataSource!.FoodSpec[foodSpecIndex].item_p
            collectionView.reloadSections([indexPath.section])
        } else {
            foodFlavorIndex = indexPath.row
            collectionView.reloadSections([indexPath.section])
        }
    }
}

extension OrderPopView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            if section == 0 {
                return dataSource.FoodSpec.count
            } else {
                return dataSource.FoodFlavor.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OrderTypeCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        
        func configureCell(_ isSelected: Bool) {
            if isSelected {
                cell.backgroundColor = UIColor(red: 31, green: 184, blue: 59)
                cell.titlelb.textColor = UIColor.white
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.clear.cgColor
            } else {
                cell.backgroundColor = UIColor.white
                cell.titlelb.textColor = UIColor.YClightGrayColor
                cell.layer.borderWidth = 0.8
                cell.layer.borderColor = UIColor.YClightGrayColor.cgColor
            }
        }
        
        if indexPath.section == 0 {
            cell.titlelb.text = dataSource?.FoodSpec[indexPath.row].item_name
            configureCell(foodSpecIndex == indexPath.row)
        } else {
            cell.titlelb.text = dataSource?.FoodFlavor[indexPath.row].flavorName
            configureCell(foodFlavorIndex == indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: OrderHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, forIndexPath: indexPath)
        if indexPath.section == 0 {
            header.titlelb.text = "规格:"
        } else {
            header.titlelb.text = "口味"
        }
        return header
    }
    
}


private class OrderHeaderView: UICollectionReusableView {
    
    var titlelb: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titlelb = UILabel()
        titlelb.textColor = UIColor.darkText
        titlelb.font = UIFont.systemFont(ofSize: 15)
        addSubview(titlelb)
        titlelb.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private class OrderTypeCell: UICollectionViewCell {
    
    var titlelb: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        
        titlelb = UILabel()
        titlelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(titlelb)
        titlelb.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
