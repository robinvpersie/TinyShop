//
//  PersonalMyStarController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/24.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonalMyStarController: YCBaseTableViewController {
    
    var StarData:[RecommanddatPersonalCenter] = [RecommanddatPersonalCenter]()
    
    
    fileprivate func updateMainData(mode:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        
        PersonalCenterMyRecommand { (result) in
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            self.isFetching = false
            self.isloading = false
            switch result {
            case .success(let value):
                self.StarData = value
                waytoUpdate.performWithTableView(tableview: self.tableView)
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                waytoUpdate.performWithTableView(tableview: self.tableView)
            }
            finish?()
        }
    
    }
    
    override func fetchAgain() {
        
        updateMainData(mode: .Static)
    }
    
    
    override func pullRefresher(sender:UIRefreshControl){
        
        updateMainData(mode: .TopRefresh, finish: {
            sender.endRefreshing()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我点过的赞"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(popBack))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        tableView.registerClassOf(PersonalMyStarCell.self)
        updateMainData(mode: .Static)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StarData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = StarData[indexPath.row].url
        let webview = YCWebViewController(url: URL(string: url!)!)
        present(webview, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PersonalMyStarCell = tableView.dequeueReusableCell()
        cell.updateWithModel(model: StarData[indexPath.row])
        cell.clickstar = { [weak self] isstar in
            guard let strongself = self else {
                return
            }
            var starModel = strongself.StarData[indexPath.row]
            starModel.isStar = isstar
            if isstar {
             starModel.recommandCount = starModel.recommandCount + 1
            }else {
             starModel.recommandCount = starModel.recommandCount - 1
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PersonalMyStarCell.getHeightwithModel(model: StarData[indexPath.row])
    }
}

extension PersonalMyStarController {
    
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
        YCProvider.requestDecoded(netResource, completion: completion)
        
    }

}
