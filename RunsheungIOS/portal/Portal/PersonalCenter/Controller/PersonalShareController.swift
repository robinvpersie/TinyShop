//
//  PersonalShareController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonalShareController: YCBaseTableViewController {

    private var ShareData = [PersonalMyShareModel]()
    
    private func updateMainData(mode:UpdateMode,finish:(()->Void)? = nil){
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        PersonalMyShareModel.Get { (result) in
            self.isFetching = false
            self.isloading = false
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            switch result {
            case .success(let value):
               self.ShareData = value
               waytoUpdate.performWithTableView(tableview: self.tableView)
               finish?()
            case .failure(_):
               waytoUpdate.performWithTableView(tableview: self.tableView)
               finish?()
            }
        }
        }
    
    
    override func fetchAgain() {
        updateMainData(mode: .Static, finish: nil)
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
        
        title = "我的分享".localized
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popBack))
        tableView.registerClassOf(YCHomeNewsCell.self)
        tableView.addSubview(refreshController)
        updateMainData(mode: .Static, finish:{ })
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ShareData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YCHomeNewsCell = tableView.dequeueReusableCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! YCHomeNewsCell
        cell.updateWithModel(model: ShareData[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return YCHomeNewsCell.getHeightWithModel(model:ShareData[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlstring = ShareData[indexPath.row].shareUrl
        guard let url = URL(string: urlstring) else { return }
        let webview = YCWebViewController(url: url)
        self.navigationController?.pushViewController(webview, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        PersonalCenterDeleteShare(shareSeq: ShareData[indexPath.row].shareSeq)
        ShareData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}


extension PersonalShareController {
    
     func PersonalCenterDeleteShare(shareSeq:Int){
        
        let memberID:String = YCAccountModel.getAccount()?.memid ?? ""
        let requestParameters:[String:Any] = [
            "MemberID":memberID,
            "ShareSeq":shareSeq
        ]
        let parse:(JSONDictionary) -> JSONDictionary? = { json in
             return json
        }
        let netResource = NetResource(path: "/NewsView/DelShare",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource) { (result) in
            
        }
    }


}
