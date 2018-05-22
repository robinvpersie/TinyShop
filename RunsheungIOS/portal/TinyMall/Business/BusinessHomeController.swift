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
        
        navigationBar = UINavigationBar()
        navigationBar.barStyle = .default
        navigationBar.backgroundColor = UIColor.clear
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didback))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-_collection_n")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(star))
        navigationBar.setItems([navigationItem], animated: false)
        view.addSubview(navigationBar)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navigationBarHeight = navigationController?.navigationBar.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        navigationBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(navigationBarHeight + statusBarHeight)
        }
    }
    
    @objc func star() {
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
