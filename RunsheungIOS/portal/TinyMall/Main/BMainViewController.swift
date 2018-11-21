//
//  BMianViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/10/24.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BMainViewController: UIViewController {

	fileprivate var tableview:UITableView!
	fileprivate var tableHeadView:BMainHeadPicView!
	fileprivate var choiceView:ChoiceHeadView!
	fileprivate var locationView:ShowLocationView!
	fileprivate var imageview:UIImageView = UIImageView()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		location()
		setNavigation()
		addSubViews()

    }
	
	private func addSubViews(){
		addTableView()
		addTableHeadView()
		loadSectionData()
	}

	
	private func setNavigation(){
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(serachAction))
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "mainlogo.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
		
		choiceView = ChoiceHeadView(frame: CGRect(x: 0, y: 0, width: 200, height: 30), withTextColor:UIColor.white, withData: ["icon_location","icon_arrow_bottom"])
		choiceView.showAction = { [weak self] in
			if self?.locationView == nil {
				self?.locationView = ShowLocationView()
			}
			self?.locationView.show(in: self?.view.window)
			
			self?.locationView.map = {
				let around:AroundMapController = AroundMapController()
				around.hidesBottomBarWhenPushed = true
				self?.navigationController?.pushViewController(around, animated: true)
			}
			
			
		}
 		self.navigationItem.titleView = self.choiceView
 	}

	private func location(){
		YCLocationService.turnOn()
		YCLocationService.singleUpdate({ (location) in
			let location2d:CLLocationCoordinate2D = location.coordinate
			UserDefaults.standard.set(String(format:"%.2f",location2d.latitude), forKey: "latitude")
			UserDefaults.standard.set(String(format:"%.2f",location2d.longitude), forKey: "longitude")

			YCLocationService.turnOff()
			let geocoder:CLGeocoder = CLGeocoder()
			geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, err) in
				if (placemarks?.count)! > 0 {
					
					let placemark:CLPlacemark = (placemarks?.first)!
					UserDefaults.standard.set(placemark.name, forKey: "Address")
					self.choiceView.addressName = placemark.name
					
				}else {
					self.choiceView.addressName = "定位失败".localized
				}
			})

		}) { (err) in
			YCLocationService.turnOff()
			self.choiceView.addressName = "定位失败".localized
		}
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

extension BMainViewController:UITableViewDelegate,UITableViewDataSource {
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
		tableview.register(BMainGridTableCell.self, forCellReuseIdentifier: "GridCell")
		tableview.register(BMainNewStoreCell.self, forCellReuseIdentifier: "StoreCell")
		self.view.addSubview(tableview)
		tableview.snp.makeConstraints({ (make) in
			make.edges.equalToSuperview()
		})

	}
	
	private func addTableHeadView(){

		tableHeadView = BMainHeadPicView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth/2.0))
		tableHeadView.reloadBannerData(url: "StoreCate/requestTopBanner",level: "")
		tableview.tableHeaderView = tableHeadView
 
 
		
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
		switch indexPath.section {
		case 0:
			let gridcell:BMainGridTableCell = tableview?.dequeueReusableCell(withIdentifier: "GridCell") as! BMainGridTableCell
 			return gridcell
		default:
			let storecell:BMainNewStoreCell = tableview?.dequeueReusableCell(withIdentifier: "StoreCell") as! BMainNewStoreCell
			storecell.loadNewsData(url: "StoreCate/requestNewStoreList", level: "")
			return storecell
		}

 	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 4.0 * (screenWidth / 3.0 + 30.0)
		default:
			return screenWidth / 2.0 + 30.0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return section == 0 ? 0 : (screenWidth / 3.0)
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionView:UIView = UIView()
		sectionView.backgroundColor = UIColor.init(red: 232, green: 232, blue: 232)
		
 		sectionView.addSubview(imageview)
		imageview.snp.makeConstraints { (make) in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(10)
		}
		return sectionView

	}
	
	
	private func loadSectionData(){
		
		let params:Dictionary = ["lang_type":"语言".localized]
		DispatchQueue.global().async {
			Alamofire.request( Constant.swiftMallBaseUrl + "StoreCate/requestBotBanner", method:.post, parameters: params as Parameters).responseJSON { (response) in
				
				switch response.result {
				case .success:
					let value:[String:AnyObject] = (response.result.value as? [String:AnyObject])!
					guard value != nil else {
						return;
					}
					let temp1:[String:AnyObject] = value["data"] as! [String:AnyObject]
					let data:NSArray = temp1["BotBanner"] as! NSArray
					let dic:NSDictionary = data.firstObject as! NSDictionary
					DispatchQueue.main.async {
//						let imageNamed:String = dic.object(forKey: "ad_image")
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
