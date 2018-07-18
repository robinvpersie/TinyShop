//
//  TableViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/13.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class MyStoreMainViewController: UITableViewController {
	var headavator: UIImageView?
	var shopname: UILabel?
	var stateBtn: BusinessStateView?
	var todayPay: UILabel = UILabel()
	var tadayCount: UILabel = UILabel()
	var orderManagerBadage: UILabel?
	var orderbackBadage: UILabel?
	var requestDic: NSDictionary?

	let badageCircle:(String) -> UILabel = {(text:String) -> UILabel in
		let badage:UILabel = UILabel()
		badage.textAlignment = .center
		badage.textColor = UIColor.white
		badage.layer.cornerRadius = 7
		badage.layer.masksToBounds = true
		badage.text = text
		badage.font = UIFont.systemFont(ofSize: 12)
		badage.backgroundColor = UIColor(red: 222, green: 0, blue: 0)
		return badage
	}

	
	let mapCollectionview = { (viewController:UIViewController) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .vertical;
		let collectionview = UICollectionView(frame:CGRect(x: 0,y: 0, width: screenWidth ,height: 2 * screenWidth / 3), collectionViewLayout: layout)
		collectionview.layer.backgroundColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionviewcell")
		collectionview.delegate = viewController as? UICollectionViewDelegate
		collectionview.dataSource = viewController as? UICollectionViewDataSource

		return collectionview
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
 		setNaviBar()

	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.stateBtn?.hiddenPopView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		addTableHeadView()
 		requestData()
    }
	
	private func requestData(){
		KLHttpTool.requestSaleOrderAmountwithUri("/api/AppSM/requestSaleOrderAmount", success: { (response) in
			self.requestDic = (response as? NSDictionary)!
			let status:String = self.requestDic!.object(forKey: "status") as! String
			if status == "1" {
				self.headavator?.setImageWith(NSURL(string: self.requestDic?.object(forKey: "shop_thumnail_image") as! String)! as URL)
				self.shopname?.text = self.requestDic?.object(forKey: "custom_name") as? String
				self.todayPay.text = self.requestDic?.object(forKey: "sale_amount") as? String
				self.tadayCount.text = self.requestDic?.object(forKey: "order_amount") as? String

			}
		}) { (error) in
			
		}
	}
}

extension MyStoreMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 6
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcell", for: indexPath)
		cell.contentView.backgroundColor = UIColor.white
		let iconarray: NSArray = [
            "icon_store_order",
            "icon_store_goods",
            "icon_store_comments",
            "icon_store_aftersale",
            "icon_store_data",
            "icon_store_info"
        ]
		let icon: UIImageView = UIImageView(image: UIImage(named: iconarray.object(at: indexPath.row) as! String))
		cell.contentView.addSubview(icon)
		icon.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.width.height.equalTo(cell.frame.width/3)
		}
		let icontitles: NSArray = [
            "订单管理".localized,
            "商品管理".localized,
            "评价管理".localized,
            "退款订单".localized,
            "数据统计".localized,
            "店铺信息".localized
        ]
		
		let icontitle:UILabel = UILabel()
		icontitle.text = icontitles.object(at: indexPath.row) as? String
		icontitle.textAlignment = .center
		icontitle.font = UIFont.systemFont(ofSize: 15)
		icontitle.textColor = UIColor(red: 45, green: 45, blue: 45)
		cell.contentView.addSubview(icontitle)
		icontitle.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(icon.snp.bottom).offset(5)
		}
		
		switch indexPath.row {
		case 0:
          do{
			self.orderManagerBadage = self.badageCircle("2")
			cell.contentView.addSubview(self.orderManagerBadage! )
			self.orderManagerBadage?.snp.makeConstraints { (make) in
					make.width.height.equalTo(14)
					make.left.equalTo(icontitle.snp.centerX).offset(25)
					make.top.equalTo(icon.snp.bottom).offset(-5)
			}
			}
		case 3:
			do{
				self.orderbackBadage = self.badageCircle("1")
				cell.contentView.addSubview(self.orderbackBadage! )
				self.orderbackBadage?.snp.makeConstraints { (make) in
					make.width.height.equalTo(14)
					make.left.equalTo(icontitle.snp.centerX).offset(25)
					make.top.equalTo(icon.snp.bottom).offset(-5)
				}
			}

		default:
			break
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			let ordermanager:OrderManagerViewController = OrderManagerViewController()
			self.navigationController?.pushViewController(ordermanager, animated: true)
			self.orderManagerBadage?.isHidden = true
			break

		case 1:
			let goodmanager:GoodsManagerController = GoodsManagerController()
			self.navigationController?.pushViewController(goodmanager, animated: true)
			break
		case 2:
			let commentmanager:CommentMainController = CommentMainController()
			self.navigationController?.pushViewController(commentmanager, animated: true)
			break
		case 3:
			let orderReturnmanager:OrderReturnMainController = OrderReturnMainController()
			self.navigationController?.pushViewController(orderReturnmanager, animated: true)

			self.orderbackBadage?.isHidden = true
			break

		case 4:
			let dataStatistic:DataStatisticsController = DataStatisticsController()
			self.navigationController?.pushViewController(dataStatistic, animated: true)
			break

		case 5:
			let shopmanager:ShopMTableViewController = ShopMTableViewController()
			shopmanager.changeHeadAvatorMap = {(imageurl:String)->Void in
				self.headavator?.setImageWith(NSURL(string:imageurl )! as URL)

			}
			self.navigationController?.pushViewController(shopmanager, animated: true)
			break

		default:
			break
		}
    }
    
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width:CGFloat = (screenWidth-2)/3
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
}
extension MyStoreMainViewController  {
	
	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 2*screenWidth/3
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = UITableViewCell()
		cell.contentView.addSubview(mapCollectionview(self))
		
		return cell
	}
	
	
}

extension MyStoreMainViewController {
	
	private func setNaviBar(){
		
		self.tableView.bounces = false
		self.tableView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		
		let titleview:UILabel = UILabel()
		titleview.textColor = UIColor.white
		titleview.text = "我的店铺".localized
		self.navigationItem.titleView = titleview
		
		let backItem:UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_white"), style: .plain, target: self, action: #selector(pop))
		self.navigationItem.leftBarButtonItem = backItem
		
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.tintColor = UIColor.white
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 33, green: 192, blue: 67)
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		
	}
	@objc private func pop(){
		
		self.stateBtn?.hiddenPopView()
		self.navigationController?.popViewController(animated: true)
	}
	private func addTableHeadView(){
		
		let headView:() -> UIView = {()->UIView in
			
			let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260))
			view.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
 			let greenview:UIView = UIView()
			greenview.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
			view.addSubview(greenview)
			greenview.snp.makeConstraints({ (make) in
				make.top.left.right.equalToSuperview()
				make.height.equalTo(130)
			})
			
			self.headavator = UIImageView()
			self.headavator?.layer.cornerRadius = 5
			self.headavator?.layer.masksToBounds = true
			greenview.addSubview(self.headavator!)
			self.headavator?.snp.makeConstraints({ (make) in
				make.width.height.equalTo(70)
				make.top.equalTo(10)
				make.left.equalTo(20)
			})
			
			self.shopname = UILabel()
 			self.shopname?.textColor = UIColor.white
			self.shopname?.font = UIFont.systemFont(ofSize: 20)
			greenview.addSubview(self.shopname!)
			self.shopname?.snp.makeConstraints({ (make) in
				make.top.equalTo((self.headavator?.snp.top)!)
				make.left.equalTo((self.headavator?.snp.right)!).offset(10)
				make.right.equalTo(-10)
 				make.bottom.equalTo((self.headavator?.snp.centerY)!)
			})
 
			self.stateBtn = BusinessStateView()
			self.stateBtn?.choiceMap = {(_:NSDictionary,_:Int,index:Int) in
				var status = "Y"
				switch index {
				case 1:
					status = "N"
					break
 				default:
					break
				}
 
			KLHttpTool.requestUpdateSalesStatuswithUri("/api/AppSM/requestUpdateSalesStatus", withStatus: status, success: { (response) in
					let res:NSDictionary = (response as? NSDictionary)!
					let status:String = (res.object(forKey: "status") as! String)
					if status == "1" {
 
					}
 				}, failure: { (error) in
					
				})
			}
			self.stateBtn?.getTitlesArray(titles: [["level_name":"营业中".localized,"id":"1"],["level_name":"打烊中".localized,"id":"1"]])
			self.stateBtn?.setTitleColor(UIColor.black, for: .normal)
			self.stateBtn?.backgroundColor = UIColor.white
			self.stateBtn?.layer.cornerRadius = 5
			self.stateBtn?.layer.masksToBounds = true
			self.stateBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
			greenview.addSubview(self.stateBtn!)
			self.stateBtn?.snp.makeConstraints({ (make) in
				make.top.equalTo((self.shopname?.snp.bottom)!).offset(8)
				make.left.equalTo((self.headavator?.snp.right)!).offset(10)
				make.bottom.equalTo((self.headavator?.snp.bottom)!)
				make.width.equalTo(80)
				
			})
			

			let restView:UIView = UIView()
			restView.backgroundColor = UIColor.white
			restView.layer.cornerRadius = 8
			restView.layer.masksToBounds = true
			view.addSubview(restView)
			restView.snp.makeConstraints({ (make) in
				make.left.equalTo(20)
				make.right.equalTo(-20)
				make.bottom.equalToSuperview().offset(-20)
				make.top.equalTo(greenview.snp.bottom).offset(-20)
			})
			
			let title:UILabel = UILabel()
			title.text = "今日销售数据".localized
			restView.addSubview(title)
			title.snp.makeConstraints({ (make) in
				make.centerX.equalToSuperview().offset(10)
				make.top.equalToSuperview().offset(5)
			})
			
			self.todayPay.text = "3524.5"
			self.todayPay.textAlignment = .center
			self.todayPay.font = UIFont.systemFont(ofSize: 24)
			restView.addSubview(self.todayPay)
			self.todayPay.snp.makeConstraints({ (make) in
				make.top.equalTo(title.snp.bottom).offset(20)
				make.left.equalToSuperview()
				make.height.equalTo(30)
				make.right.equalTo(title.snp.centerX)
			})
			
			let cellbit:UILabel = UILabel()
			cellbit.text = "今日营业额（元）".localized
			cellbit.font = UIFont.systemFont(ofSize: 14)
			cellbit.textColor = UIColor(red: 192, green: 192, blue: 192)
			cellbit.textAlignment = .center
			restView.addSubview(cellbit)
			cellbit.snp.makeConstraints({ (make) in
				make.top.equalTo(self.todayPay.snp.bottom).offset(5)
				make.left.equalToSuperview()
				make.height.equalTo(30)
				make.right.equalTo(title.snp.centerX)

			})
			
			
			self.tadayCount.text = "284"
			self.tadayCount.textAlignment = .center
			self.tadayCount.font = UIFont.systemFont(ofSize: 24)
			restView.addSubview(self.tadayCount)
			self.tadayCount.snp.makeConstraints({ (make) in
				make.top.equalTo(title.snp.bottom).offset(20)
				make.right.equalToSuperview()
				make.height.equalTo(30)
				make.left.equalTo(title.snp.centerX)
			})
			
			let cellbit1:UILabel = UILabel()
			cellbit1.text = "今日订单数（单）".localized
			cellbit1.font = UIFont.systemFont(ofSize: 14)
			cellbit1.textColor = UIColor(red: 192, green: 192, blue: 192)
			cellbit1.textAlignment = .center
			restView.addSubview(cellbit1)
			cellbit1.snp.makeConstraints({ (make) in
				make.top.equalTo(self.todayPay.snp.bottom).offset(5)
				make.right.equalToSuperview()
				make.height.equalTo(30)
				make.left.equalTo(title.snp.centerX)
				
			})

			
			return view
			
		}
		self.tableView.tableHeaderView = headView()
		
 
	}
}
