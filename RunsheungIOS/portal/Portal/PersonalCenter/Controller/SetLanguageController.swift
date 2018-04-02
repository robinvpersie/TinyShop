//
//  SetLanguageController.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class SetLanguageController: BaseViewController {
    
    var tableView: UITableView!
    var selectlanType: languageType = .base{
        didSet{
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    enum languageType: Int {
        case base
        case chinese
        case korea
        
        var language: String {
            switch self {
            case .chinese:
                return "zh-Hans"
            case .base:
                return "Base"
            case .korea:
                return "ko"
            }
        }
        
        static let count = 3
        
        init(indexPath: IndexPath) {
            self.init(rawValue: indexPath.row)!
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置语言"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target:self, action: #selector(didTrailing))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkText
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.registerClassOf(UITableViewCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        if let value = YCUserDefaults.languageType.value,
            let type = languageType(rawValue: value) {
            selectlanType = type
        }
        
    }
    
    
    @objc
    func didTrailing(){
       let type = selectlanType.rawValue
       YCUserDefaults.language.value = selectlanType.language
       YCUserDefaults.languageType.value = selectlanType.rawValue
       languageTool.shared.initLanguage()
       NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: YCBox<Int>(type), userInfo: nil)
       yc_back()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension SetLanguageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = languageType(indexPath: indexPath)
        selectlanType = type
     }

}

extension SetLanguageController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell()
        let type = languageType(indexPath: indexPath)
        switch type {
        case .base:
            cell.textLabel?.text = "默认"
        case .chinese:
            cell.textLabel?.text = "简体中文"
        case .korea:
            cell.textLabel?.text = "韩文"
        }
        if selectlanType == type {
            cell.textLabel?.textColor = UIColor.navigationbarColor
        }else {
            cell.textLabel?.textColor = UIColor.darkcolor
        }
        return cell
    }
}
