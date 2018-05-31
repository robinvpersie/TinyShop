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

        // Do any additional setup after loading the view.
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
            return 110
        } else {
            return 150
        }
    }
}

extension GeneralizeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: GeneralizeHeaderCell = tableView.dequeueReusableCell()
            return cell
        } else if indexPath.row == 1 {
            let cell: GeneralizeSecondCell = tableView.dequeueReusableCell()
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
