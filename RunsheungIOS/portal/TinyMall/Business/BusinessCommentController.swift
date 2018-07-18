//
//  BusinessCommentController.swift
//  Portal
//
//  Created by 이정구 on 2018/5/30.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BusinessCommentController: UIViewController {
    
    var tableView: UITableView!
    @objc var dic: NSDictionary?
    var dataSource = [ShopAssessData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        requestData()
        
    }
    
    func makeUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.rowHeight = 100.hrpx
        tableView.estimatedRowHeight = 100.hrpx
        tableView.registerClassOf(CommentCell.self)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func requestData() {
        let saleCustomCode = dic?["custom_code"] as? String
        let storeAssestTarget = ShopAssessTarget(saleCustomCode: saleCustomCode ?? "")
        
        API.request(storeAssestTarget)
            .filterSuccessfulStatusCodes()
            .map([ShopAssessData].self, atKeyPath: "ShopAssessData")
            .subscribe { [weak self] event in
                guard let this = self else { return }
                switch event {
                case let .success(model):
                    this.dataSource = model
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

extension BusinessCommentController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "There is no data")
    }
    
}



extension BusinessCommentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension BusinessCommentController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCell = tableView.dequeueReusableCell()
        cell.configureWithData(dataSource[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}
