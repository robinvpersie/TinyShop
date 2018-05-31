//
//  ParcelViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/5/29.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class ParcelViewController: UIViewController {
	var scroview:UIScrollView?
	public var lev1:String?
	var locationView:ParecellocationView?
	var parcelView:UICollectionView?
	lazy var flowLayout:UICollectionViewLayout = {
		let flt = UICollectionViewFlowLayout()
		flt.minimumLineSpacing = 0
		flt.minimumInteritemSpacing = 0
		flt.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
		flt.scrollDirection = UICollectionViewScrollDirection.vertical
		flt.itemSize = CGSize(width: (screenWidth - 20)/3.0 , height: 5*screenWidth/12.0)
		return flt
	}()
	
	var data:NSArray = NSArray(array: [])
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.parcelView?.layer.backgroundColor = UIColor(red: 254, green: 222, blue: 209).cgColor

	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
		createNavi()
		createScroview()
		createCollectionview()
		loadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isTranslucent = false
		WJSetLineColor.share().setNavi(self, with: UIColor(red: 254, green: 222, blue: 209))
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
		self.navigationController?.navigationBar.isTranslucent = true
		WJSetLineColor.share().setNavi(self, with:  UIColor.white)

	}
}

extension ParcelViewController :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)
		cell.contentView.backgroundColor = UIColor(red: 254, green: 222, blue: 209)
		
		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		let bgcell:UIView = UIView()
		bgcell.backgroundColor = UIColor.white
		cell.contentView.addSubview(bgcell)
		bgcell.snp.makeConstraints { (make) in
			make.leading.top.equalTo(1)
			make.trailing.bottom.equalTo(-1)
		}
		
		let logo:UIImageView = UIImageView()
		logo.isUserInteractionEnabled = true
		logo.setImageWith(NSURL(string: dic.object(forKey: "image_url") as! String)! as URL)
		logo.contentMode = .scaleAspectFit
		bgcell.addSubview(logo)
		logo.snp.makeConstraints { (make) in
			make.leading.top.equalTo(5)
			make.trailing.bottom.equalTo(-5)
		}
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let dic:NSDictionary = self.data.object(at: indexPath.row) as! NSDictionary
		let vc:TSCategoryController = TSCategoryController()
		vc.hidesBottomBarWhenPushed = true
		vc.leves = [dic.object(forKey: "custom_lev1") ?? "1",dic.object(forKey: "custom_lev2") ?? "1","1"]
		self.navigationController?.pushViewController(vc, animated: true)

	}
}

extension ParcelViewController{
	private func createScroview(){
		self.scroview = UIScrollView()
		self.view.addSubview(self.scroview!)
		self.scroview?.isScrollEnabled = true
		self.scroview?.snp.makeConstraints({ (make) in
			make.top.equalTo((self.locationView?.snp_bottom)!).offset(10)
			make.leading.trailing.bottom.equalTo(0)
		})
	}
	private func createCollectionview(){
		
		self.parcelView = UICollectionView(frame: CGRect(x: 10, y:0, width: screenWidth-20, height: 5*screenWidth/4), collectionViewLayout: flowLayout)
		self.parcelView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		self.parcelView?.delegate = self
		self.parcelView?.dataSource = self
		self.parcelView?.layer.borderColor = UIColor(red: 254, green: 222, blue: 209).cgColor
		self.parcelView?.layer.borderWidth = 5;
		self.scroview?.addSubview(self.parcelView!)
		
		let btmImg:UIImageView = UIImageView(image: UIImage(named: "test001"))
		btmImg.contentMode = .scaleAspectFit
		btmImg.frame = CGRect(x: 0, y:(self.parcelView?.frame.maxY)!, width: screenWidth, height: screenWidth)
		self.scroview?.addSubview(btmImg)
		
		self.scroview?.contentSize = CGSize(width: screenWidth, height: btmImg.frame.maxY)

	}
	
	private func createNavi(){
		
		let returnLeft:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "shengqing_back"), style: .plain, target: self, action: #selector(leftAction))
		returnLeft.tintColor = UIColor.black
		self.navigationItem.leftBarButtonItem = returnLeft
		
		let Search:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_search"), style: .plain, target: self, action: #selector(searchAction))
		Search.tintColor = UIColor.black
		self.navigationItem.rightBarButtonItem = Search
		
		let titleImg:UIImageView = UIImageView.init(image: UIImage.init(named: "img_top_slogan"))
		titleImg.contentMode = .scaleAspectFill
		self.navigationItem.titleView = titleImg
		
		self.locationView = ParecellocationView()
		self.locationView?.backgroundColor = UIColor(red: 254, green: 222, blue: 209)
		self.view.addSubview(self.locationView!)
		self.locationView?.snp.makeConstraints({ (make) in
			make.leading.trailing.equalTo(0)
			make.top.equalTo(0)
			make.height.equalTo(40)

		})
	}
	
	@objc private func leftAction(sender:UIButton){
		
		self.navigationController?.popViewController(animated: true)
		
	}
	
	@objc private func searchAction(sender:UIButton){
		let hotSearches:NSArray = NSArray()
		let searchVC:PYSearchViewController = PYSearchViewController(hotSearches: hotSearches as! [String], searchBarPlaceholder: "搜索关键字".localized) { (searchViewController, searchBar, searchText) in
			let searchResultVC:TSearchViewController = TSearchViewController()
			searchResultVC.searchKeyWord = searchText
			searchResultVC.navigationItem.title = "搜索结果".localized
			searchViewController?.navigationController?.pushViewController(searchResultVC, animated: true)
			
		}
		let navi:UINavigationController = UINavigationController(rootViewController: searchVC)
		self.present(navi, animated: false, completion: nil)
	}
	
	private func loadData(){
		KLHttpTool.getFoodCatewithUri("StoreCate/requestCategory2List", withCustom_lev1: self.lev1, success: { (res) in
			let response:NSDictionary = res as! NSDictionary
			self.data = response.object(forKey: "data") as! NSArray
			self.parcelView?.reloadData()
		}) { (err) in
			
		}
		
	}
	
}
