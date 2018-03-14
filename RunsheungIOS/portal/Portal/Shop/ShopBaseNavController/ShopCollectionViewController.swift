//
//  ShopCollectionViewController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class ShopCollectionViewController: UICollectionViewController {
    
    var isFetching:Bool = false
    var currentPage:Int = 0
    var nextPage:Int = 1
    var isloading:Bool = true
    
    enum UpdateMode{
        case Static
        case TopRefresh
        case LoadMore
    }
    
   @objc func popBack(){
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let back = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(popBack))
        back.tintColor = UIColor.darkcolor
        navigationItem.leftBarButtonItem = back

    }


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(topRefresh))
        collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        collectionView?.mj_footer.isHidden = true
        collectionView?.emptyDataSetSource = self
        collectionView?.keyboardDismissMode = .onDrag
        view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func fetchAgain(){
        
    }

    
   @objc func loadMore(){
        
    }
    
   @objc func topRefresh(){
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

}

extension ShopCollectionViewController:DZNEmptyDataSetSource {
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if isloading {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            return indicator
        } else {
            let nodata = YCNoDataAlertView()
            nodata.freshAction = { [weak self] in
                guard let strongself = self else { return }
                strongself.fetchAgain()
            }
            return nodata
        }
    }
}

