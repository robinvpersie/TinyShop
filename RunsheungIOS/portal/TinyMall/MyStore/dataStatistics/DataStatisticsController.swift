//
//  DataStatisticsController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataStatisticsController: MyStoreBaseViewController {
	
	var dataHead:DataStatisticsHeadView?
	var bottomCollectView:UICollectionView?
	var datepicker:DataStatisticsDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
    }
	let mapCollectionview = { (selfDelegate:UIViewController, dataHead:DataStatisticsHeadView) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .horizontal
		let collectionview = UICollectionView(frame:CGRect(x:0,y:0,width: 0,height:0), collectionViewLayout: layout)
		collectionview.layer.backgroundColor = UIColor.white.cgColor
		collectionview.isPagingEnabled = true
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		collectionview.delegate = selfDelegate as? UICollectionViewDelegate
		collectionview.dataSource = selfDelegate as? UICollectionViewDataSource
		selfDelegate.view.addSubview(collectionview)
		collectionview.snp.makeConstraints({ (make) in
			make.top.equalTo(dataHead.snp.bottom)
			make.left.right.equalToSuperview()
			make.bottom.equalToSuperview()
		})
		return collectionview
	}
	

	private func initUI(){
		self.view.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.navigationItem.title = "数据统计"

		self.dataHead = DataStatisticsHeadView()
		self.dataHead?.getTitles(array:["今日".localized,"本周".localized,"本月".localized,"自定".localized])
		self.dataHead?.clickHeadIndexMap = {[weak self](index:Int)->Void in
			
			if index == 3 {
				self?.popChoiceDatePicker(index:index)
				
			}else{
				let indexPath = IndexPath(row: index, section: 0)
				self?.bottomCollectView?.scrollToItem(at: indexPath, at: .left, animated: false)
				

			}
		}
		self.view.addSubview(self.dataHead!)
		self.dataHead?.snp.makeConstraints({ (make) in
			make.left.right.top.equalToSuperview()
			make.height.equalTo(50)
		})
		
		self.bottomCollectView = self.mapCollectionview(self, self.dataHead!)
//		self.view.addSubview(self.bottomCollectView!)
		
	}
    
	
	private func popChoiceDatePicker(index:Int){		
		
		self.datepicker = DataStatisticsDatePicker()
		self.datepicker?.choicePickerMap = { (picker1Value:String,picker2Value:String)->Void in
		    let indexPath = IndexPath(row: index, section: 0)
		    self.bottomCollectView?.scrollToItem(at: indexPath, at: .left, animated: false)
			print(picker1Value,picker2Value)
		
		}
		
		UIApplication.shared.delegate?.window??.addSubview(self.datepicker!)
		self.datepicker?.snp.makeConstraints({ (make) in
			make.center.equalToSuperview()
			make.width.equalTo(screenWidth - 60)
			make.height.equalTo(screenHeight/2+80.0)
		})
		
	}

}

extension DataStatisticsController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		let offsetX:CGFloat = scrollView.contentOffset.x
		let index:Int = Int(offsetX / screenWidth)
		if index == 3 {
			self.popChoiceDatePicker(index: index)

		}
		self.dataHead?.transferIndex(index: index)
 
		print(index)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parcelviewcell", for: indexPath)
		let dataCell:DataStatisticsCellTableView = DataStatisticsCellTableView()
		dataCell.tag = indexPath.row
		dataCell.getData(type:indexPath.row)
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
