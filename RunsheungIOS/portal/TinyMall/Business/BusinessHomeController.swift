//
//  BusinessHomeController.swift
//  Portal
//
//  Created by 이정구 on 2018/5/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BusinessHomeController: BaseController {
    
    var navigationBar: UINavigationBar!
    var headerView: BusinessHomeHeader!
    var pageView: TYTabButtonPagerController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = BusinessHomeHeader()
        view.addSubview(headerView)
        
        navigationBar = UINavigationBar()
        navigationBar.barStyle = .default
        navigationBar.backgroundColor = UIColor.clear
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didback))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-_collection_n")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(star))
        navigationBar.setItems([navigationItem], animated: false)
        view.addSubview(navigationBar)
        
        pageView = TYTabButtonPagerController()
        pageView.normalTextColor = UIColor.darkText
        pageView.selectedTextColor = UIColor(hex: 0x21c043)
        pageView.progressColor = UIColor(hex: 0x21c043)
        pageView.cellWidth = Constant.screenWidth / 4.0
        pageView.collectionLayoutEdging = 15
        pageView.delegate = self
        pageView.dataSource = self
        addChildViewController(pageView)
        view.addSubview(pageView.view)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navigationBarHeight = navigationController?.navigationBar.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.width, height: navigationBarHeight + statusBarHeight)
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 460.hrpx)
        pageView.view.frame = CGRect(x: 0, y: headerView.maxy, width: view.width, height: view.height - headerView.height)
    }
    
    func requestData() {
        let targetType = StoreInfoProductTarget(saleCustomCode: "", customCode: "", pg: 1)
        API.request(targetType)
            .filterSuccessfulStatusCodes()
            .map(StoreInfoProduct.self, atKeyPath: "data")
            .subscribe { [weak self] event in
                switch event {
                case let .success(element):
                    break
                case let .error(error):
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
    
    func numberOfControllersInPagerController() -> Int {
        return 4
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        return nil
    }
    
}
