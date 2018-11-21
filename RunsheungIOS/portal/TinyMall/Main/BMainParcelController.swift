//
//  BMainParcelController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/11/1.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BMainParcelController: UIViewController {
	fileprivate var tableview:UITableView!
	fileprivate var imageview:UIImageView = UIImageView()
	fileprivate var tableHeadView:BMainHeadPicView!
	fileprivate var model:NSDictionary!
	private(set) var newstoreCount:Int?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setNavigation()
		addTableView()
		addTableHeadView()
		loadSectionData()

	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
	}
	
	private func setNavigation(){
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(serachAction))
		self.navigationController?.navigationBar.tintColor = UIColor.black
		self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
		self.navigationItem.title = "外卖".localized
 	}
	
	func withMallModel(model:NSDictionary){
		self.model = model
		
	}

	@objc private func serachAction(sender:UIButton){
		let hotSearches:NSArray = NSArray()
		let searchVC:PYSearchViewController = PYSearchViewController(hotSearches: hotSearches as? [String], searchBarPlaceholder: "搜索关键字".localized) { (searchViewController, searchBar, searchText) in
			
			let searchResultVC:TSearchViewController = TSearchViewController()
			searchResultVC.searchKeyWord = searchText
			searchResultVC.navigationItem.title = "搜索结果".localized
			searchViewController?.navigationController?.pushViewController(searchResultVC, animated: true)
			
		}
		let navi:UINavigationController = UINavigationController(rootViewController: searchVC)
		self.present(navi, animated: false, completion: nil)
	}

}

extension BMainParcelController:UITableViewDelegate,UITableViewDataSource {
	private func addTableView(){
		guard tableview == nil else {
			return
		}
		tableview = UITableView(frame: .zero, style: .grouped)
		tableview.delegate = self
		tableview.dataSource = self
		tableview.tableFooterView = UIView()
		tableview.estimatedRowHeight = 0
		tableview.estimatedSectionHeaderHeight = 0
		tableview.estimatedSectionFooterHeight = 0
		tableview.register(BMainParcelGridCell.self, forCellReuseIdentifier: "GridCell")
		tableview.register(BMainNewStoreCell.self, forCellReuseIdentifier: "StoreCell")
		tableview.register(BMainParcelMoreCell.self, forCellReuseIdentifier: "MoreCell")
 		self.view.addSubview(tableview)
		tableview.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
		})
		
	}
	
	private func addTableHeadView(){
//		let _:String = self.model?.object(forKey: "level1") as! String
 		tableHeadView = BMainHeadPicView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth/2.0))
		tableHeadView.reloadBannerData(url: "StoreCate/requestCateTopBanner",level: "1")
		tableview.tableHeaderView = tableHeadView



	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
		switch indexPath.section {
		case 0:
			let gridcell:BMainParcelGridCell = tableview?.dequeueReusableCell(withIdentifier: "GridCell") as! BMainParcelGridCell
 			return gridcell
		case 1:
			let storecell:BMainNewStoreCell = tableview?.dequeueReusableCell(withIdentifier: "StoreCell") as! BMainNewStoreCell
			storecell.loadNewsData(url: "StoreCate/requestCatePopularBanner", level: "1")
			return storecell
		default:
			let morecell:BMainParcelMoreCell = tableview?.dequeueReusableCell(withIdentifier: "MoreCell") as! BMainParcelMoreCell
			morecell.finishReloadData = {(count:Int) in
 				self.newstoreCount = count
				self.tableview?.reloadSections( NSIndexSet(index: 2) as IndexSet, with: .none)
 			}
			return morecell
			
		}
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 3.0 * (screenWidth / 3.0)
		case 2:
			return CGFloat(newstoreCount ?? 0) * screenWidth / 2.0
		default:
			return screenWidth / 2.0 + 30.0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		return section == 1 ? (screenWidth / 4.0) : 0.01
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let sectionView:UIView = UIView()
		sectionView.backgroundColor = UIColor.init(red: 232, green: 232, blue: 232)
		
  		sectionView.addSubview(imageview)
		imageview.snp.makeConstraints { (make) in
			make.right.left.equalToSuperview()
			make.bottom.equalTo(-8)
			make.top.equalTo(8)
 		}
 		return section == 1 ? sectionView : nil
  	}
	
	
	private func loadSectionData(){
		let _:String = self.model?.object(forKey: "level1") as! String
		let params:Dictionary = ["lang_type":"语言".localized,"level1":"1"]
		DispatchQueue.global().async {
			Alamofire.request( Constant.swiftMallBaseUrl + "StoreCate/requestCateBotBanner", method:.post, parameters: params as Parameters).responseJSON { (response) in
				
				switch response.result {
				case .success:
					let value = response.result.value as? [String:AnyObject]
					let data:NSArray = (value?["data"]?["BotBanner"] as? NSArray)!
					let dic:NSDictionary = data.firstObject as! NSDictionary
					DispatchQueue.main.async {
 						self.imageview.kf.setImage(with:URL(string:dic.object(forKey: "ad_image") as! String))
					}
					break
				case .failure:
					break
					
				}
			}
		}
	}
	
	
}
