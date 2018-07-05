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
    var tableView: UITableView!
    var dataSource = [OrderReturnModel]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		self.initUI()
        self.requestData()
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
    
    private func createTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
        tableView.registerNibOf(OrderReturnMainCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    private func requestData() {
        let target = OrderReturnTarget(pg: 1)
        
        API.request(target)
            .filterSuccessfulStatusCodes()
            .map([OrderReturnModel].self, atKeyPath: "data")
            .subscribe { [weak self] event in
                guard let this = self else {
                    return
                }
                switch event {
                case let .success(modelArray):
                    this.dataSource = modelArray
                    OperationQueue.main.addOperation {
                        this.tableView.reloadData()
                    }
                case .error:
                    break
                }
            }.disposed(by: Constant.dispose)
        
    }
	
	
	private func initUI(){
		self.view.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
		self.navigationItem.title = "退款订单".localized
        
        createTableView()
		
//        self.dataHead = DataStatisticsHeadView()
//        self.dataHead?.getTitles(array:["待退货".localized,"已处理".localized])
//        self.dataHead?.clickHeadIndexMap = {[weak self](index:Int)->Void in
//        
//            let indexPath = IndexPath(row: index, section: 0)
//            self?.bottomCollectView?.scrollToItem(at: indexPath, at: .left, animated: false)
//                
//        }
//        self.view.addSubview(self.dataHead!)
//        self.dataHead?.snp.makeConstraints({ (make) in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(50)
//        })
//        
//        self.bottomCollectView = self.mapCollectionview(self)
//        self.view.addSubview(self.bottomCollectView!)
//        
	}
}

extension OrderReturnMainController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manager = RefundManagerController()
        manager.model = dataSource[indexPath.row]
        navigationController?.pushViewController(manager, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderReturnMainCell = tableView.dequeueReusableCell()
        cell.contentView.backgroundColor = UIColor(red: 242, green: 244, blue: 246)
        cell.configureWithModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156.0
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

