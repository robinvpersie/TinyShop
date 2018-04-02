//
//  PersonalCenterController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/21.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import MBProgressHUD
import SwiftyJSON

fileprivate let headerHeight: CGFloat = 184

class PersonalCenterController: BaseController, UITableViewDelegate, UITableViewDataSource {
    
    var isHotel = false
    
    private lazy var headerview: UIView = {
        let headerview = UIImageView()
        if RSJudgeIsX.current.isX() {
            headerview.frame.size = CGSize(width: screenWidth, height: headerHeight + 32)
        }else{
            headerview.frame.size = CGSize(width: screenWidth, height: headerHeight)
        }
        headerview.isUserInteractionEnabled = true
        headerview.image = UIImage(named: "img_personalcenter_bg")
        headerview.addSubview(self.avatarBorderImageView)
        headerview.addSubview(self.avatarImageView)
        headerview.addSubview(self.namelabel)
        headerview.addSubview(self.editbtn)
        
        avatarBorderImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(65)
            if RSJudgeIsX.current.isX(){
                 make.top.equalTo(headerview).offset(headerHeight - 78)
            }else {
                 make.top.equalTo(headerview).offset(headerHeight - 110)
            }
            make.right.equalTo(headerview).offset(-20)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(avatarBorderImageView)
        }
        
        namelabel.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.equalTo(10)
            make.bottom.equalTo(avatarBorderImageView).offset(-15)
        }
        
        editbtn.snp.makeConstraints({ (make) in
            make.height.equalTo(16)
            make.width.equalTo(16)
            make.top.equalTo(namelabel).offset(10)
            make.left.equalTo(namelabel.snp.right).offset(10)
        })
        return headerview
    }()
    
    private lazy var avatarBorderImageView: UIImageView = {
       let avatarBorderImageView = UIImageView()
       avatarBorderImageView.backgroundColor = UIColor(red: 235, green: 98, blue: 105)
       avatarBorderImageView.layer.masksToBounds = true
       avatarBorderImageView.layer.cornerRadius = CGFloat(75.0/2.0)
       return avatarBorderImageView
    }()
    
    private lazy var avatarImageView: UIImageView = {
       let avatarImageView = UIImageView()
       avatarImageView.image = UIImage(named: "img_headphoto")
       avatarImageView.layer.masksToBounds = true
       avatarImageView.layer.cornerRadius = CGFloat(65.0/2.0)
       return avatarImageView
    }()
    
    
    var tableview: UITableView!
    
    private lazy var namelabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var editbtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(editAction(sender:)), for:
            .touchUpInside)
        button.setBackgroundImage(UIImage.init(named: "editbtn"), for: .normal)
        return button
    }()
    
    @objc func editAction(sender: UIButton) -> () {
//        print("现在开始编辑个人的相关信息")
        let setvc = PersinalSetController()
        setvc.showflag = 1
        self.navigationController?.pushViewController(setvc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMainData()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkText]

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的".localized
    
        view.backgroundColor = UIColor.groupTableViewBackground
        
        tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 40
        tableview.tableHeaderView = self.headerview
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = UIColor.clear
        tableview.registerNibOf(PersonalCenterCell.self)
        tableview.registerClassOf(ProfileServiceCell.self)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableview)
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
     
        let versionLabel = UILabel()
        versionLabel.textColor = UIColor.gray
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
        versionLabel.text = "人生药业Version:" + "1.0.0"
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-40)
        }
     

        initTheLocalData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func refreshLanguage(_ noti:Notification){
        title = "我的".localized
        tableview.reloadData()
    }
    
    func initTheLocalData(){
        let account = YCAccountModel.getAccount()
        if let avatarPath = account?.avatarPath {
           let avatar = PlainAvatar(avatarURLString: avatarPath, avatarStyle: miniAvatarStyle)
           avatarImageView.navi_setAvatar(avatar)
        }
        namelabel.text = account?.memid
        
    }
    
    
    func updateMainData(){
        
        CheckToken.chekcTokenAPI { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let check):
              if check.status == "1" {
                GetWithToken(check.newtoken,check.custom_code)
              }else {
                YCUserDefaults.accountModel.value = nil
                this.goToLogin()
              }
            case .failure:
                break 
            }
        }
        
        func GetWithToken(_ token:String,_ memid:String){
            PersonalGetProfileModel.Get(memberID:memid,token: token){ [weak self] result in
                guard let strongself = self else { return }
                switch result {
                   case .success(let json):
                     let avatar = PlainAvatar(avatarURLString: json.imagePath ?? "", avatarStyle: miniAvatarStyle)
                     strongself.avatarImageView.navi_setAvatar(avatar)
                     strongself.namelabel.text = json.memberID?.substring(to:(json.memberID?.index((json.memberID?.startIndex)!, offsetBy: 11))!)
                     let accountmodel = YCAccountModel.getAccount()!
                     accountmodel.avatarPath = json.imagePath
                     accountmodel.userName = json.nickName
                     if json.gender == "m" {
                        accountmodel.usersex = YCAccountModel.userSex.girl
                     }else if json.gender == "f"{
                        accountmodel.usersex = YCAccountModel.userSex.boy
                     }
                     let datas = NSKeyedArchiver.archivedData(withRootObject: accountmodel )
                    UserDefaults.standard.set(datas, forKey: "accountModel")

                case .failure(let error):
                     strongself.showMessage(error.localizedDescription)
                }
             }
          }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
           return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
           return 5
        }
        return 1
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
           return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return  50
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PersonalCenterCell = tableview.dequeueReusableCell()
   
        if indexPath.section == 1 {
          if indexPath.row == 0 {
            cell.CellImageView.image = UIImage(named: "icon_notice2")
            cell.CellLable.text = "我的消息".localized
            
          }else if indexPath.row == 1 {
            cell.CellImageView.image = UIImage(named: "icon_collection2")
            cell.CellLable.text = "我的收藏".localized
           
          }else if indexPath.row == 2{
            cell.CellImageView.image = UIImage(named: "icon_share2")
            cell.CellLable.text = "我的分享".localized
           
          }else if indexPath.row == 3 {
            cell.CellImageView.image = UIImage(named: "icon_01_01")
            cell.CellLable.text = "匹配管理".localized
          }else {
            cell.CellImageView.image = UIImage(named: "icon_setting2")
            cell.CellLable.text = "系统设置".localized
            }
        }else {
            let cells = ProfileServiceCell()
            cells.selectAction = { [weak self] type in
                guard let this = self else { return }
                switch type {
                case .needComment:
                    let vc = SupermarketMyOrderController()
                    vc.title = "待评论"
                    vc.controllerType = .supermarket
                    vc.pageIndex = 4
                    vc.hidesBottomBarWhenPushed = true
                    let nvi = UINavigationController(rootViewController: vc)
                    this .present(nvi, animated: true, completion: nil)
                    
                case .needDeliver:
                    let vc = SupermarketMyOrderController()
                    vc.title = "待发货"
                    vc.controllerType = .supermarket
                    vc.pageIndex = 2
                    vc.hidesBottomBarWhenPushed = true
                    let nvi = UINavigationController(rootViewController: vc)
                    this .present(nvi, animated: true, completion: nil)
                    
                case .needPay:
                    let vc = SupermarketMyOrderController()
                    vc.controllerType = .supermarket
                    vc.title = "待付款"
                    vc.pageIndex = 1
                    vc.refresh = {
                        this.updateMainData()
                    }
                    vc.hidesBottomBarWhenPushed = true
                    let navi = UINavigationController(rootViewController: vc)
                    this.present(navi, animated: true, completion: nil)
                   
                case .needReceive:
                    let vc = SupermarketMyOrderController()
                    vc.controllerType = .supermarket
                    vc.pageIndex = 3
                    vc.refresh = {
                       this.updateMainData()
                    }
                    vc.hidesBottomBarWhenPushed = true
                    let nvi = UINavigationController(rootViewController: vc)
                    this .present(nvi, animated: true, completion: nil)

                case .needRefund:
                    break
                }
            }
            return cells
            
    }
        cell.CellLable.textColor = UIColor.darkcolor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let message = PersonalMessageController()
                self.navigationController?.pushViewController(message, animated: true)
            }else if indexPath.row == 1 {
                let personal = PersonalCollectionController()
                self.navigationController?.pushViewController(personal, animated: true)
            }else if indexPath.row == 2{
                let share = PersonalShareController()
                self.navigationController?.pushViewController(share, animated: true)
            }else if indexPath.row == 3 {
                checkParent()
            }else {
                let set = PersinalSetController()
                self.navigationController?.pushViewController(set, animated: true)
            }
        }
    }
}

extension PersonalCenterController {
    
    func checkParent() {
        let matchManager = MatchManageController()
        guard let parentId = YCAccountModel.getAccount()?.parentId else {
            matchManager.status = .unmatch
            navigationController?.pushViewController(matchManager, animated: true)
            return
        }
        showLoading()
        CheckParentModel.checkParentWithParentId(parentId, completion: { [weak self] result in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
            case .success(let json):
                  let Json = JSON(json)
                  if let isMatching = Json["isMatching"].string, isMatching == "1" {
                    matchManager.status = .match
                    let account = YCAccountModel.getAccount()!
                    account.customlev = Json["data"].dictionaryValue["seller_type"]?.string
                    let data = NSKeyedArchiver.archivedData(withRootObject: account)
                    YCUserDefaults.accountModel.value = data
                  }else {
                    matchManager.status = .unmatch
                  }
                  this.navigationController?.pushViewController(matchManager, animated: true)
            case .failure:
                break
            }
        })
    }
    
}


