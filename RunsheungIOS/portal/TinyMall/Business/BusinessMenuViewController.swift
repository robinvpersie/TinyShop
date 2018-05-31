//
//  BusinessMenuViewController.swift
//  Portal
//
//  Created by 이정구 on 2018/5/30.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessMenuViewController: BaseViewController {
    
    enum pageType: Int {
        case order
        case comment
        case business
        
        static let count: Int = 3
        
        var title: String {
            switch self {
            case .order:
                return "메뉴"
            case .comment:
                return "리뷰"
            case .business:
                return "정보"
            }
        }
        
        init(index: Int) {
            self.init(rawValue: index)!
        }
    }
    
    var pg: Int = 1
    @objc var dic: NSDictionary?
    var avatarImgView: UIImageView!
    var ratiolb: UILabel!
    var starView: CosmosView!
    var tabController: TYTabButtonPagerController!
    var orderController = BusinessOrderController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19),
            NSAttributedStringKey.foregroundColor:UIColor.white
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19),
            NSAttributedStringKey.foregroundColor:UIColor.darkText
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "국빈 반점"
        
        let starBtn = UIButton(type: .custom)
        starBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starBtn.setImage(UIImage(named: "icon_cart_store"), for: .normal)
        starBtn.addTarget(self, action: #selector(didStar), for: .touchUpInside)
//        let starItem = UIBarButtonItem(image: UIImage(named: "icon_cart_store")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didStar))
        let starItem = UIBarButtonItem(customView: starBtn)
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchBtn.setImage(UIImage(named: "icon_search_store"), for: .normal)
        searchBtn.addTarget(self, action: #selector(didSearch), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: searchBtn)
        
//        let searchItem = UIBarButtonItem(image: UIImage(named: "icon_search_store")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didSearch))
      
        
        let collectBtn = UIButton(type: .custom)
        collectBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        collectBtn.setImage(UIImage(named: "icon_uncollected_store"), for: .normal)
        collectBtn.addTarget(self, action: #selector(didCollect), for: .touchUpInside)
        let collectItem = UIBarButtonItem.init(customView: collectBtn)
//        let collectItem = UIBarButtonItem(image: UIImage(named: "icon_uncollected_store")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didCollect))
        navigationItem.rightBarButtonItems = [starItem, searchItem, collectItem]
        
        avatarImgView = UIImageView()
        view.addSubview(avatarImgView)
        
        let blackContainer = UIView()
        blackContainer.backgroundColor = UIColor.darkText.withAlphaComponent(0.6)
        view.addSubview(blackContainer)
        blackContainer.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        ratiolb = UILabel()
        ratiolb.textColor = UIColor(hex: 0xf9a80d)
        ratiolb.font = UIFont.boldSystemFont(ofSize: 25)
        blackContainer.addSubview(ratiolb)
        ratiolb.snp.makeConstraints { (make) in
            make.centerX.equalTo(blackContainer)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        
        starView = CosmosView()
        starView.settings.emptyBorderColor = ratiolb.textColor
        starView.settings.emptyBorderWidth = 0.8
        starView.settings.emptyColor = UIColor.clear
        starView.settings.filledColor = ratiolb.textColor
        starView.settings.fillMode = .precise
        starView.settings.starMargin = 1
        starView.settings.starSize = 15
        starView.settings.updateOnTouch = false
        blackContainer.addSubview(starView)
        starView.snp.makeConstraints { (make) in
            make.centerX.equalTo(blackContainer)
            make.top.equalTo(ratiolb.snp.bottom).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(10)
        }
        
        tabController = TYTabButtonPagerController()
        tabController.normalTextColor = UIColor(hex: 0x999999)
        tabController.selectedTextColor = UIColor.darkText
        tabController.progressColor = UIColor.orange
        tabController.cellWidth = Constant.screenWidth / 3.0
        tabController.cellSpacing = 0.0
        tabController.cellEdging = 0.0
        tabController.animateDuration = 0.2
        tabController.selectedTextFont = UIFont.systemFont(ofSize: 15)
        tabController.normalTextFont = UIFont.systemFont(ofSize: 15)
        tabController.delegate = self
        tabController.dataSource = self
        addChildViewController(tabController)
        view.addSubview(tabController.view)
        
        requestData()
    }
    
    @objc func didCollect() {
        
    }
    
    @objc func didSearch() {
        
    }
    
    @objc func didStar() {
        
    }
    
    
    func requestData() {
        let saleCustomCode = dic?["custom_code"] as? String
        let targetType = StoreInfoProductTarget(saleCustomCode: saleCustomCode, pg: pg)
        
        API.request(targetType)
            .filterSuccessfulStatusCodes()
            .map(StoreInfoProduct.self, atKeyPath: "data")
            .subscribe { [weak self] event in
                switch event {
                case let .success(element):
                    OperationQueue.main.addOperation {
                        self?.avatarImgView.kf.setImage(with: URL(string: element.StoreInfo.shop_thumnail_image))
                        self?.ratiolb.text = element.StoreInfo.custom_name
                        self?.starView.rating = Double(element.StoreInfo.cnt) ?? 0
                        self?.ratiolb.text = element.StoreInfo.cnt
                        self?.orderController.productList = element.plist
                    }
                case .error:
                    break
                }
            }.disposed(by: Constant.dispose)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            avatarImgView.frame = CGRect(x: 0, y: view.safeAreaLayoutGuide.layoutFrame.minY, width: view.frame.width, height: 150.hrpx)
        } else {
            avatarImgView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: 150.hrpx)
        }
        tabController.view.frame = CGRect(x: 0, y: avatarImgView.frame.maxY, width: view.frame.width, height: view.frame.height - avatarImgView.frame.maxY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusinessMenuViewController: TYTabPagerControllerDelegate {
    
}

extension BusinessMenuViewController: TYPagerControllerDataSource {
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let type = pageType(index: index)
        return type.title
    }
    
    func numberOfControllersInPagerController() -> Int {
        return pageType.count
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        let type = pageType(index: index)
        switch type {
        case .order:
            orderController.dic = self.dic
            return orderController
        case .comment:
            let comment = BusinessCommentController()
            return comment
        case .business:
            return UIViewController()
        }
    }
}
