//
//  PersonalCommentController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonalCommentController: YCBaseTableViewController {
    
    var dataArray = [Replydat]()
    
    func updateMainData(mode: UpdateMode, finish: (() -> Void)? = nil){
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        PersonalCenterComment { [weak self] result in
            self?.isFetching = false
            self?.isloading = false
            switch result {
            case .success(let json):
                self?.dataArray = json
                OperationQueue.main.addOperation {
                    self?.tableView.reloadData()
                }
            case .failure:
                OperationQueue.main.addOperation {
                    self?.tableView.reloadEmptyDataSet()
                }
            }
            finish?()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func fetchAgain() {
        updateMainData(mode: .Static)
    }
    
    override func pullRefresher(sender: UIRefreshControl){
        updateMainData(mode: .TopRefresh, finish: {
            sender.endRefreshing()
        })
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false 
        
        tableView.registerClassOf(PersonalNewsCell.self)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.groupTableViewBackground
        
        updateMainData(mode: .Static)
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
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PersonalNewsCell = tableView.dequeueReusableCell()
        cell.longPress = { [weak self] in
            guard let strongself = self else {
                return
            }
            YCAlert.confirmOrCancel(title: "提示".localized,
                                    message: "您确定要删除这条评论吗",
                                    confirmTitle: "确定".localized,
                                    cancelTitle: "取消",
                                    inViewController: strongself,
                                    withConfirmAction:
                {
                    strongself.PersonalDeleteComment(newsReplySeq: strongself.dataArray[indexPath.row].ReplySeq)
                    strongself.dataArray.remove(at: indexPath.row)
                    tableView.reloadData()
                })
        }
        return cell
    }
    
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PersonalNewsCell
        cell.updateWithModel(model: dataArray[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let urlString = dataArray[indexPath.row].url,
            let url = URL(string: urlString) {
            let webview = YCWebViewController(url: url)
            present(webview, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PersonalNewsCell.getHeightWithModel(model: dataArray[indexPath.row])
    }
    

}


extension PersonalCommentController {
    
    func PersonalCenterComment(completion:@escaping (NetWorkResult<[Replydat]>) -> Void){
        let parse:(JSONDictionary) -> [Replydat] = { json in
            var jsonArray = [Replydat]()
            let replyData = PersonalCommentModel(json: json)
            if let reply = replyData {
                jsonArray = reply.ReplyData
            }
            return jsonArray
        }
        let memberID = YCAccountModel.getAccount()?.memid ?? ""
        let netResource = NetResource(path: "/MyInfo/MyReply",
                                      method: .post,
                                      parameters: ["MemberID":memberID],
                                      parse: parse)
        YCProvider.requestDecoded(netResource, completion: completion)
    }
    
    
    func PersonalDeleteComment(newsReplySeq: Int){
        
        let memberID = YCAccountModel.getAccount()?.memid ?? ""
        let parse: (JSONDictionary) -> JSONDictionary? = { json in
            return json
        }
        let requestParameters: [String:Any] = [
            "MemberID":memberID,
            "NewsReplySeq":newsReplySeq
        ]
        let netResource = NetResource(path: "/NewsView/DelNewsReply",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource) { (result) in
            
        }
    }

    
}
