//
//  RSCustomerService.swift
//  Portal
//
//  Created by zhengzeyou on 2018/1/13.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class RSCustomerService: UIViewController {
   
    enum Sections:Int {
        case cusgreen
        case cusblue
        case cusyellow
        static let couns = 3

        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.section)!
        }
        var bgColor:UIColor? {
            switch self {
            case .cusgreen:
                return   UIColor.init(red: 48, green: 231, blue: 229)
            case .cusblue:
                return   UIColor.init(red: 81, green: 195, blue: 255)
            case .cusyellow:
                return   UIColor.init(red: 255, green: 211, blue: 60)
       
            }
        }
        
        var title:String? {
            
            switch self {
            case .cusgreen:
                return "派送咨询"
            case .cusblue:
                return "产品咨询"
            case .cusyellow:
                return "退货咨询"
                
            }
    }
    }

    var cellLabel:UILabel = {
        let label:UILabel = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        return label
        
    }()
    
    
    lazy var backItem:UIBarButtonItem? = {
        let back:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "shengqing_back") , style: .plain, target: self, action: #selector(popController))
        back.tintColor=UIColor.init(red: 67, green: 67, blue: 67)
        
        return back
    }()
    
    @objc func popController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var tableview:UITableView = { () -> UITableView in
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.separatorColor = UIColor.init(red: 240, green: 240, blue: 240)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240)
        return table
    }()
    
   
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.title = "客服中心"
        tableView = tableview
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        self.navigationItem.leftBarButtonItem = backItem
        
        
    }
}
extension RSCustomerService:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell()
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240)
        let section:Sections = Sections(indexPath:indexPath)

        let label:UILabel = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.text = section.title
        label.backgroundColor = section.bgColor
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
        
            make.width.equalTo(cell.width)
            make.height.equalTo(120)
            make.center.equalTo(cell.contentView)
        }

        
     
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

}
extension RSCustomerService:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label:UILabel = UILabel()
        label.textColor = UIColor.darkcolor
        label.textAlignment = .left
      
        label.text = "   连接客服"
        label.font = UIFont.systemFont(ofSize: 19)
        if section == 0 {
           return label
        }

        return nil
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var phone:String
        var schem:String
        
        switch indexPath.section {
        case 0://派送咨询
            phone = "12099999999"
            schem = "sendCustomer"
            self.pushApp(phone: phone, schems: schem)
            break
        case 1://产品咨询
            phone = "12088888888"
            schem = "productCustomer"
            self.pushApp(phone: phone, schems: schem)
            break
        case 2://退货咨询
            phone = "12077777777"
            schem = "returnCustomer"
            self.pushApp(phone: phone, schems: schem)
            break
        default:
            break
        }
    }
}

extension RSCustomerService{
    func pushApp(phone:String,schems:String){
        print(phone + schems)
        CheckToken.chekcTokenAPI { (result) in
                self.hideLoading()
                switch result {
                case .success(let check):
                    if check.status == "1"{
                        let urlstr = "ycapp://\(schems)$\(check.custom_code)$\(phone)$\(check.newtoken)"
                        let utf8Str = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        guard let utf8 = utf8Str,
                            let url = URL(string: utf8),UIApplication.shared.canOpenURL(url)
                            else {
//                                if self.currentVersion == appVersion && self.currentState == "0" { return } else {
                                 YCAlert.confirmOrCancel(title: "提示",
                                                         message: "龙聊暂未安装，是否前往AppStore下载？",
                                                         confirmTitle: "确定",
                                                         cancelTitle: "取消",
                                                         inViewController: self,
                                                         withConfirmAction:
                                    {
                                        let url : URL = URL(string: "itms-apps://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8")!
                                        UIApplication.shared.openURL(url)
                                    })
                                return
//                              }
                            }
                       UIApplication.shared.openURL(url)
                    }else {
                      self.goToLogin()
                    }
                case .failure(let error):
                    self.showMessage(error.localizedDescription)
                }
            }
    }
}
