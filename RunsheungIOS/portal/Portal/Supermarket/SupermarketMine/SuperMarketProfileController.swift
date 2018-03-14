//
//  SuperMarketProfileController.swift
//  Portal
//
//  Created by linpeng on 2018/1/10.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class SuperMarketProfileController: UIViewController {
    
    enum sectionType:Int {
        case header
        case bottom
        static let count = 2
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.section)!
        }
        
        init(section:Int){
            self.init(rawValue: section)!
        }
    }
    
    enum headerType:Int {
        case avatar
        case service
        static let count = 2
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.row)!
        }
    }
    
    enum bottomType:Int {
        case message
        case collect
        case share
        case systemSet
        static let count = 4
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.row)!
        }
        var image:UIImage? {
            switch self {
            case .message:
                return UIImage(named: "icon_notice2")?.withRenderingMode(.alwaysOriginal)
            case .collect:
                return UIImage(named: "icon_collection2")?.withRenderingMode(.alwaysOriginal)
            case .share:
                return UIImage(named: "icon_share2")?.withRenderingMode(.alwaysOriginal)
            case .systemSet:
                return UIImage(named: "icon_setting2")?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        var title:String? {
            switch self {
            case .message:
                return "我的消息"
            case .collect:
                return "我的收藏"
            case .share:
                return "我的分享"
            case .systemSet:
                return "系统设置"
            }
        }
    }
    
    var profileModel:ProfileModel?
    var tableView:UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkText]
    }
    
    func requestProfileData(){
        
        ProfileModel.requestWith(6) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let model):
                this.profileModel = model
                OperationQueue.main.addOperation({
                    this.tableView.reloadData()
                })
            case .failure(let error):
                this.showMessage(error.localizedDescription)
            case .tokenError:
                this.goToLogin(completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的"
    
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.01))
        tableView.tableFooterView = UIView()
        tableView.registerClassOf(UITableViewCell.self)
        tableView.registerClassOf(ProfileAvatarCell.self)
        tableView.registerClassOf(ProfileServiceCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        requestProfileData()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SuperMarketProfileController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectiontype = sectionType(section: section)
        switch sectiontype {
        case .header:
            return 0.01
        case .bottom:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sectionType(indexPath: indexPath)
        switch section {
        case .header:
            let headertype = headerType(indexPath: indexPath)
            switch headertype {
            case .avatar:
                return ProfileAvatarCell.getHeight()
            case .service:
                return ProfileServiceCell.getHeight()
            }
        case .bottom:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .bottom:
            let bottomtype = bottomType(indexPath: indexPath)
            switch bottomtype {
            case .collect:
                let personal = PersonalCollectionController()
                personal.hidesBottomBarWhenPushed = true 
                navigationController?.pushViewController(personal, animated: true)
            case .message:
                let message = PersonalMessageController()
                message.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(message, animated: true)
            case .share:
                let share = PersonalShareController()
                share.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(share, animated: true)
            case .systemSet:
                let set = PersinalSetController()
                set.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(set, animated: true)
            }
        default:
            break
        }
    }
}

extension SuperMarketProfileController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionType(section: section)
        switch section {
        case .header:
            return headerType.count
        case .bottom:
            return bottomType.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sectionType(indexPath: indexPath)
        switch section {
        case .header:
            let headertype = headerType(indexPath: indexPath)
            switch headertype {
            case .avatar:
                let cell:ProfileAvatarCell = tableView.dequeueReusableCell()
                cell.configureWithModel(profileModel)
                return cell
            case .service:
                let cell:ProfileServiceCell = tableView.dequeueReusableCell()
                cell.configureWithModel(profileModel)
                cell.selectAction = { [weak self] type in
                    guard let this = self else { return }
                    switch type {
                    case .needComment:
                        let vc = SupermarketMyOrderController()
                        vc.title = "待评论"
                        vc.controllerType = .supermarket
                        vc.pageIndex = 4
                        vc.hidesBottomBarWhenPushed = true
                        this.navigationController?.pushViewController(vc, animated: true)
                    case .needDeliver:
                        let vc = SupermarketMyOrderController()
                        vc.title = "待发货"
                        vc.controllerType = .supermarket
                        vc.pageIndex = 2
                        vc.hidesBottomBarWhenPushed = true
                        this.navigationController?.pushViewController(vc, animated: true)
                   case .needPay:
                        let vc = SupermarketMyOrderController()
                        vc.controllerType = .supermarket
                        vc.title = "待付款"
                        vc.pageIndex = 1
                        vc.refresh = {
                            this.requestProfileData()
                        }
                        vc.hidesBottomBarWhenPushed = true
                        this.navigationController?.pushViewController(vc, animated: true)
                    case .needReceive:
                        let vc = SupermarketMyOrderController()
                        vc.controllerType = .supermarket
                        vc.pageIndex = 3
                        vc.refresh = {
                            this.requestProfileData()
                        }
                        vc.hidesBottomBarWhenPushed = true
                        this.navigationController?.pushViewController(vc, animated: true)
                    case .needRefund:
                        break
                    }
                }
                return cell
            }
        case .bottom:
            let bottomtype = bottomType(indexPath: indexPath)
            let cell:UITableViewCell = tableView.dequeueReusableCell()
            cell.imageView?.image = bottomtype.image
            cell.textLabel?.text = bottomtype.title
            return cell
        }
    }

}
