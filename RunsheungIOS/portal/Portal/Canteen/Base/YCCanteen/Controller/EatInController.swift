//
//  EatInController.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/25.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class EatInController: CanteenBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var from:fromController!
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headerView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    private var avatarImgView:UIButton!
    private var namelb:UILabel!
    private func headerView() -> UIView {
        let header = UIView()
        header.frame.size = CGSize(width: screenWidth, height: 150)
        header.backgroundColor = UIColor.groupTableViewBackground
        avatarImgView = UIButton(type: .custom)
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.cornerRadius = 20
        header.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.top.equalTo(header).offset(20)
            make.width.height.equalTo(40)
        }
        namelb = UILabel()
        namelb.textColor = UIColor.darkcolor
        namelb.font = UIFont.systemFont(ofSize: 15)
        header.addSubview(namelb)
        namelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.top.equalTo(avatarImgView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        let joinBtn = UIButton(type: .custom)
        joinBtn.addTarget(self, action: #selector(didJoin), for: .touchUpInside)
        joinBtn.backgroundColor = UIColor.navigationbarColor
        joinBtn.setTitle("参与拼单", for: .normal)
        joinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        joinBtn.setTitleColor(UIColor.white, for: .normal)
        header.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(header).offset(-10)
            make.width.equalTo(header).multipliedBy(0.8)
            make.height.equalTo(30)
            make.centerX.equalTo(header)
        }
        return header
    }
    
    var groupMemberId:String = ""
    var groupId:String = ""
    var token:String = ""
    private var model:GroupInfoModel?
    
    @objc private func didJoin(){
        self.showLoading()
        SetJoinGroup(groupMemberId: groupMemberId, groupId: groupId, token: token, failureHandler: { (reason, errormessage) in
            self.hideLoading()
            self.showMessage(errormessage)
        }) { (status) in
            self.hideLoading()
            if status == 1 {
              let eatTogether = EatTogetherController(groupID: self.groupId)
              eatTogether.from = .fromPush
              self.navigationController?.pushViewController(eatTogether, animated: true)
            }else {
              self.showMessage("加入失败")
            }
        }
    }
    
    
    func getInfo(){
        self.showLoading()
        GroupInfoModel.GetGroupInviteInfo(groupId: groupId, memberId: groupMemberId, token: token, failureHandler: { reason, errormessage in
            self.hideLoading()
            self.showMessage(errormessage)
        }) { json in
            self.hideLoading()
            if let jsonData = json {
              self.model = GroupInfoModel.createWithJson(json!)
              self.tableView.reloadData()
              let json = JSON(jsonData)
              let status = json["status"].int
                if status != nil && status == 1 {
                    let newstatus = json["data"].dictionaryValue["status"]?.string
                    if let urlstring = json["data"].dictionaryValue["imgUrl"]?.string,let imgUrl = URL(string: urlstring) {
                       self.avatarImgView.kf.setImage(with: imgUrl, for: .normal)
                    }
                    let restaurantName = json["data"].dictionaryValue["restaurantName"]?.string
                    self.namelb.text = restaurantName
                    if newstatus != "S" {
                       let together = EatTogetherController(groupID: self.groupId)
                       self.navigationController?.pushViewController(together, animated: true)
                    }
                }else if status != nil && status == -9001 {
                    self.goToLogin(completion: { 
                        self.groupMemberId = YCAccountModel.getAccount()!.memid!
                        self.token = YCAccountModel.getAccount()!.token!
                        self.getInfo()
                    })
                }else {
                   let msg = json["msg"].string
                   self.showMessage(msg)
                   delay(2, work: {
                     self.yc_back()
                   })
                }
              
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "参加一起吃吧"
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                   self.groupMemberId = check.custom_code
                   self.token = check.newtoken
                   self.getInfo()
                }else {
                    self.goToLogin()
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            }
        }
        
    }
    
    override func yc_back() {
        if let navi = self.navigationController {
            navi.popToRootViewController(animated: true)
        }else {
           self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if let model = self.model {
            if indexPath.row == 0 {
                cell.textLabel?.text = model.data?.phone
                cell.imageView?.image = UIImage(named: "icon_cdh")
            }else if indexPath.row == 1 {
                cell.imageView?.image = UIImage(named: "icon_dt")
                cell.textLabel?.text = model.data?.address
                cell.accessoryType = .disclosureIndicator
            }else {
                cell.imageView?.image = UIImage(named: "icon_sj-1")
                cell.textLabel?.text = model.data?.businessTime
            }
         }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.model {
            return 3
        }else {
           return 0
        }
    }

    
}
