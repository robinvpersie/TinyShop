//
//  ShopClassifyController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopClassifyController: ShopBaseViewController {
    
    enum naviFrom{
       case tab
       case mall
    }
    
    fileprivate lazy var collectionView:UICollectionView = {
        
       let flowlayout = UICollectionViewFlowLayout()
       flowlayout.itemSize = CGSize(width: (screenWidth-1.0)/2.0, height: 80)
       flowlayout.minimumInteritemSpacing = 1
       flowlayout.minimumLineSpacing = 1
       let collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
       collectionview.backgroundColor = UIColor.groupTableViewBackground
       collectionview.registerClassOf(ClassifyCell.self)
       collectionview.delegate = self
       collectionview.dataSource = self
       return collectionview
        
    }()
    
    var navif:naviFrom = .tab
    var datasourceArray = [ClassifyModel]()
    var divCode:String!
    
    private lazy var activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch self.navif {
        case .tab:
            self.navigationItem.leftBarButtonItem = nil
        case .mall:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "分类".localized
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.view.addSubview(activity)
        self.activity.hidesWhenStopped = true
        activity.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        requestData()
    }
    
    private func requestData(){
       self.activity.startAnimating()
       ClassifyModel.Get({ reason, errormessage in
         self.activity.stopAnimating()
         self.showMessage(errormessage)
      }) { classifyModel in
        self.activity.stopAnimating()
        if let array = classifyModel {
           self.datasourceArray = array
           let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
           waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
        }
      }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShopClassifyController:UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ClassifyCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? ClassifyCell
        cell?.updateWithModel(self.datasourceArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.datasourceArray.count
    }

}

extension ShopClassifyController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.datasourceArray[indexPath.row]
        let parameter = FilterParameter(divCode:self.divCode,level1:model.level)
        let filter = ShopBrandFilterController(with: parameter)
        filter.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(filter, animated: true)
    }
    
}


fileprivate class ClassifyCell:UICollectionViewCell {
    
    private lazy var imgView:UIImageView = {
         let imgview = UIImageView()
         return imgview
    }()
    
    private lazy var titlelb:UILabel = {
         let title = UILabel()
         title.numberOfLines = 1
         title.textColor = UIColor.darkcolor
         title.font = UIFont.systemFont(ofSize: 15)
         return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.titlelb)
        self.makeConstraints()
    }
    
    private func makeConstraints(){
        
        self.imgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(self).offset(15)
        }
        
        self.titlelb.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imgView.snp.trailing).offset(10)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-10)
        }
        
    }
    
    func updateWithModel(_ model:ClassifyModel){
        self.imgView.kf.setImage(with: model.iconUrl)
        self.titlelb.text = model.categoryName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

