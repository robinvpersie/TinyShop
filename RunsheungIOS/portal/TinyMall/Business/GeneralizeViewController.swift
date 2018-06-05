//
//  GeneralizeViewController.swift
//  Portal
//
//  Created by 이정구 on 2018/5/31.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class GeneralizeViewController: UIViewController {
    
    var tableView: UITableView!
    var dic: NSDictionary!
    var data: StoreInfomation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.hrpx
        tableView.registerNibOf(GeneralizeHeaderCell.self)
        tableView.registerNibOf(GeneralizeSecondCell.self)
        tableView.registerNibOf(GeneralizeBottomCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        requestData()
        // Do any additional setup after loading the view.
    }
    
    func requestData() {
        let saleCustomCode = dic?["custom_code"] as? String
        let storeInfoTarget = StoreInfoTarget(saleCustomCode: saleCustomCode ?? "")
        
        API.request(storeInfoTarget)
            .filterSuccessfulStatusCodes()
            .map(StoreInfomation.self, atKeyPath: nil)
            .subscribe { [weak self] event in
                guard let this = self else {
                    return
                }
                switch event {
                case let .success(element):
                    this.data = element
                    OperationQueue.main.addOperation {
                        this.tableView.reloadData()
                    }
                case .error:
                    break
                }
        }.disposed(by: Constant.dispose)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GeneralizeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if indexPath.row == 1 {
            return GeneralizeSecondCell.getHeightWithData(data)
        } else {
            return 150
        }
    }
}

extension GeneralizeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: GeneralizeHeaderCell = tableView.dequeueReusableCell()
            cell.configureWithData(data)
            return cell
        } else if indexPath.row == 1 {
            let cell: GeneralizeSecondCell = tableView.dequeueReusableCell()
            cell.configureWithData(data)
            return cell
        } else {
            let cell: GeneralizeBottomCell = tableView.dequeueReusableCell()
            return cell
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    
}
