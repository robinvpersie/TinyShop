//
//  CommentMainController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class CommentMainController: MyStoreBaseViewController {
	var bottomCollectView:UICollectionView?
	var dataHead:DataStatisticsHeadView?
	var commentTop:CommentTopView = CommentTopView()

 	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UserDefaults.standard.set("", forKey: "changeComment")
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "评价管理"
		createSuvs()

	}
	private func createSuvs(){
		self.view.addSubview(self.commentTop)
		self.commentTop.snp.makeConstraints { (make) in
			make.top.left.right.equalToSuperview()
			make.height.equalTo( screenWidth / 2)
		}
	
		self.dataHead = DataStatisticsHeadView()
 		self.dataHead?.getTitles(array:["全部(234)","差评(13)","未读(23)"])
		self.dataHead?.clickHeadIndexMap = {[weak self](index:Int)->Void in
			
			let indexPath = IndexPath(row: index, section: 0)
			self?.bottomCollectView?.scrollToItem(at: indexPath, at: .left, animated: false)
			
		}
		self.view.addSubview(self.dataHead!)
		self.dataHead?.snp.makeConstraints({ (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(self.commentTop.snp.bottom)
			make.height.equalTo(50)
		})
		
		self.createCollectionView()

	}
	
	private func createCollectionView(){
		let layout = UICollectionViewFlowLayout();
		layout.scrollDirection = .horizontal
		self.bottomCollectView = UICollectionView(frame:CGRect(x:0,y:0,width: 0,height:0), collectionViewLayout: layout)
		self.bottomCollectView?.layer.backgroundColor = UIColor.white.cgColor
		self.bottomCollectView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ID")
		self.bottomCollectView?.delegate = self
		self.bottomCollectView?.dataSource = self
		self.view.addSubview(self.bottomCollectView!)
		self.bottomCollectView?.snp.makeConstraints({ (make) in
			make.bottom.left.right.equalToSuperview()
			make.top.equalTo((self.dataHead?.snp.bottom)!)
		})

	}

}
extension CommentMainController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath)
		let dataCell:CommentCellTableView = CommentCellTableView()
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
