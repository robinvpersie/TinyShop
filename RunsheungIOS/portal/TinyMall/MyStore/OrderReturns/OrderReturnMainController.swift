//
//  OrderReturnMainController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//


import UIKit

class OrderReturnMainController: MyStoreBaseViewController {
	var dataHead:DataStatisticsHeadView?
	var bottomCollectView:UICollectionView?
	var datepicker:DataStatisticsDatePicker?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.initUI()
	}
	let mapCollectionview = { (selfDelegate:UIViewController) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .horizontal
		let collectionview = UICollectionView(frame:CGRect(x:0,y:60,width: screenWidth,height:screenHeight - 60), collectionViewLayout: layout)
		collectionview.isPagingEnabled = true
		collectionview.layer.backgroundColor = UIColor.white.cgColor
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		collectionview.delegate = selfDelegate as? UICollectionViewDelegate
		collectionview.dataSource = selfDelegate as? UICollectionViewDataSource
		return collectionview
	}
	
	
	private func initUI(){
		self.view.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.navigationItem.title = "退款订单".localized
		
		self.dataHead = DataStatisticsHeadView()
		self.dataHead?.getTitles(array:["待退货".localized,"已处理".localized])
		self.dataHead?.clickHeadIndexMap = {[weak self](index:Int)->Void in
		
			let indexPath = IndexPath(row: index, section: 0)
			self?.bottomCollectView?.scrollToItem(at: indexPath, at: .left, animated: false)
				
		}
		self.view.addSubview(self.dataHead!)
		self.dataHead?.snp.makeConstraints({ (make) in
			make.left.right.top.equalToSuperview()
			make.height.equalTo(50)
		})
		
		self.bottomCollectView = self.mapCollectionview(self)
		self.view.addSubview(self.bottomCollectView!)
		
	}
	
	
	
}

extension OrderReturnMainController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		let offsetX:CGFloat = scrollView.contentOffset.x
		let index:Int = Int(offsetX / screenWidth)
		self.dataHead?.transferIndex(index: index)
		print(index)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)
		let dataCell:OrderReturnCellTableView = OrderReturnCellTableView()
		dataCell.tag = indexPath.row
		cell.contentView.addSubview(dataCell)
		dataCell.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		
		return cell
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width:CGFloat = screenWidth
		let height:CGFloat = collectionView.frame.size.height
		
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
}

