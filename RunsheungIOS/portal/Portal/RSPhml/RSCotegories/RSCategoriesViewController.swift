//
//  RSCategoriesViewController.swift
//  Portal
//
//  Created by zhengzeyou on 2017/12/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class RSCategoriesViewController: UIViewController {
   
    var collectVeiw:UICollectionView?
    
    lazy var flowLayout:UICollectionViewLayout = {
        let flt = UICollectionViewFlowLayout()
        flt.minimumLineSpacing = 0
        flt.minimumInteritemSpacing = 0
        flt.sectionInset = UIEdgeInsetsMake(0.5, 1, 0.5, 1)
        flt.scrollDirection = UICollectionViewScrollDirection.vertical
        flt.itemSize = CGSize(width: (screenWidth - 4)/3 , height: (screenWidth - 4)/3)
        return flt
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectView()
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor.white
    }
   
   @objc private func setNavBar(){
    
    
    let titleView:UILabel = UILabel()
    titleView.text = "药品分类"
    titleView.textColor = UIColor(red: 16/225, green: 16/225, blue: 16/225, alpha: 1)
    self.tabBarController?.navigationItem.titleView = titleView
    self.tabBarController?.navigationController?.navigationBar.barTintColor = UIColor.white
  
    let setlineColor = WJSetLineColor.share()
    setlineColor?.setNavi(self.tabBarController, with: UIColor(red: 240/225, green: 240/225, blue: 240/225, alpha: 1))
    }
}

extension RSCategoriesViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func createCollectView(){
        self.collectVeiw = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectVeiw?.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        var frams = self.collectVeiw?.frame ?? self.view.bounds
        frams.size.height = screenWidth+108
        frams.origin.y = -44
        self.collectVeiw?.frame = frams;

        self.collectVeiw?.register(UINib(nibName: "RSCategoryCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "collectionViewCell_ID")
        
        self.collectVeiw?.dataSource = self
        self.collectVeiw?.delegate = self
        self.view.addSubview(self.collectVeiw!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var iconImgs: [String] = ["icon_funcationnav_home",
                                  "icon_funcationnav_shoppingmall",
                                  "icon_02", "icon_funcationnav_service",
                                  "icon_funcationnav_wallet",
                                  "icon_funcationnav_agent",
                                  "icon_funcationnav_message","icon_03"]
        var icontitle: [String] = ["主页",
                                   "购物商城",
                                   "订单管理",
                                   "客服中心",
                                   "钱包",
                                   "代理申请",
                                   "聊天",
                                   "地址管理"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell_ID", for: indexPath) as! RSCategoryCollectionCell
        if (indexPath.row + 3*indexPath.section) < iconImgs.count {
            cell.imageName = iconImgs[indexPath.row + 3*indexPath.section]
            cell.imageTitle = icontitle[indexPath.row + 3*indexPath.section]
        }
        
        return cell

    }
    
   
}

extension RSCategoriesViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了分类")
    }
    
}
