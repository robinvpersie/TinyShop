//
//  GoodsManagerView.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/14.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
class GoodsManagerView: UIView {
	
	var segment:UIView?
	var bottomline:UILabel?
	var firstBtn:UIButton = UIButton()
	var secBtn:UIButton = UIButton()
	var bottomCollectView:UICollectionView?
	var index:Int = 0

	let mapCollectionview = { (selfDelegate:UIViewController) -> UICollectionView in
		
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .horizontal
		let collectionview = UICollectionView(frame:CGRect(x:0,y:60,width: screenWidth,height:screenHeight - 60), collectionViewLayout: layout)
		collectionview.layer.backgroundColor = UIColor.white.cgColor
		collectionview.contentSize = CGSize(width: 4*screenWidth, height: screenHeight)
		collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "parcelviewcell")
		collectionview.delegate = selfDelegate as? UICollectionViewDelegate
		collectionview.dataSource = selfDelegate as? UICollectionViewDataSource
		return collectionview
	}

	
	let addSegmentView:() -> UIView = { () -> UIView in
		let bgs:UIView = UIView()
		bgs.layer.borderColor = UIColor(red: 242, green: 244, blue: 246).cgColor
		bgs.layer.borderWidth = 1
		return bgs
	}
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

