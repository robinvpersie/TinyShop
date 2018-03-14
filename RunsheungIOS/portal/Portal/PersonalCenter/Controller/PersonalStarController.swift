//
//  PersonalStarController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonalStarController: YCBaseTableViewController {
    
    
    var StarData:[RecommanddatPersonalCenter] = [RecommanddatPersonalCenter]()
    weak var message:PersonalMessageController?
    
    func updateMainData(mode:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        showCustomloading()
        PersonalCenterMyRecommand { result in
            self.hideLoading()
            self.isFetching = false
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            switch result {
            case .failure(let error):
                waytoUpdate.performWithTableView(tableview: self.tableView)
                self.showMessage(error.localizedDescription)
            case .success(let value):
                self.StarData = value
                waytoUpdate.performWithTableView(tableview: self.tableView)
            }
            finish?()
        }
    }
    
    
    override func pullRefresher(sender:UIRefreshControl){
        updateMainData(mode: .TopRefresh, finish: {
            sender.endRefreshing()
        })
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的消息".localized
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerNibOf(PersonalStarHeaderCell.self)
        tableView.registerClassOf(PersonalStarContentCell.self)
        updateMainData(mode: .Static)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return 1
        }else {
          return StarData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
          return 40
        }else {
          return PersonalStarContentCell.getHeightwithModel(model: StarData[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
           return 0.01
        }else {
           return 10
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:PersonalStarHeaderCell = tableView.dequeueReusableCell()
            return cell
        }else {
            let cell:PersonalStarContentCell = tableView.dequeueReusableCell()
            cell.HeaderView.starImageView.isHidden = true
            cell.HeaderView.starLabel.isHidden = true
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
          let cell = cell as? PersonalStarContentCell
          cell?.updateWithModel(model: StarData[indexPath.row])
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
          let myStar = PersonalMyStarController()
          navigationController?.pushViewController(myStar, animated: true)
        }else {
          let urlstring = StarData[indexPath.row].url
          guard let url = URL(string: urlstring!) else { return }
          let webview = YCWebViewController(url: url)
          present(webview, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

        
     }
}

extension PersonalStarController {
    
    func PersonalCenterMyRecommand(completion:@escaping (NetWorkResult<[RecommanddatPersonalCenter]>) -> Void){
        
        let parse:(JSONDictionary) -> [RecommanddatPersonalCenter] = { json in
            var jsonArray = [RecommanddatPersonalCenter]()
            if let reply = PersonalShareModel(json: json) {
                jsonArray = reply.RecommandData
                jsonArray = jsonArray.map({
                    var element = $0
                    element.isStar = true
                    return element
                })
            }
            return jsonArray
        }
        let MemberID:String = YCAccountModel.getAccount()!.memid!
        let requestParameters:[String:Any] = [
            "MemberID":MemberID
        ]
        let netResource = NetResource(path: "/MyInfo/MyRecommand",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource, queue: nil, completion: completion)
        
    }


}
