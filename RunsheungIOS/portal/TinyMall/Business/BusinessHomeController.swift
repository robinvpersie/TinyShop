//
//  BusinessHomeController.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessHomeController: BaseController {
    
    enum pageType: Int {
        case order
        case comment
        case business
        case generalize
        
        static let count: Int = 4
        
        var title: String {
            switch self {
            case .order:
                return "点单"
            case .comment:
                return "评价"
            case .business:
                return "商家"
            case .generalize:
                return "推广"
            }
        }
    }
    
    var navigationBar: UINavigationBar!
    var headerView: BusinessHomeHeader!
    var pageView: TYTabButtonPagerController!
    var pg: Int = 1
    @objc var dic: NSDictionary?
    var orderController = BusinessOrderController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didback))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-_collection_n"), style: .plain, target: self, action: #selector(star))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        headerView = BusinessHomeHeader()
        view.addSubview(headerView)
        
        pageView = TYTabButtonPagerController()
        pageView.normalTextColor = UIColor.darkText
        pageView.selectedTextColor = UIColor(hex: 0x21c043)
        pageView.progressColor = UIColor(hex: 0x21c043)
        pageView.selectedTextFont = UIFont.systemFont(ofSize: 15)
        pageView.normalTextFont = UIFont.systemFont(ofSize: 15)
        pageView.cellWidth = Constant.screenWidth / 4.0
        pageView.delegate = self
        pageView.dataSource = self
        addChildViewController(pageView)
        view.addSubview(pageView.view)
        
        requestData()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: Ruler.iPhoneVertical(260, 240, 250, 250).value)
        pageView.view.frame = CGRect(x: 0, y: headerView.maxy, width: view.width, height: view.height - headerView.height)
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
                    self?.headerView.reloadData(element.StoreInfo)
                    self?.orderController.productList = element.plist
                    }
                case .error:
                    break
                }
            }.disposed(by: Constant.dispose)
    }
    
    @objc func star() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension BusinessHomeController: TYTabPagerControllerDelegate {
    
}

extension BusinessHomeController: TYPagerControllerDataSource {
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let type = pageType(rawValue: index)!
        return type.title
    }
    
    func numberOfControllersInPagerController() -> Int {
        return pageType.count
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        let type = pageType(rawValue: index)!
        switch type {
        case .order:
            return orderController
        default:
            return UIViewController()
        }
    }
    
}
