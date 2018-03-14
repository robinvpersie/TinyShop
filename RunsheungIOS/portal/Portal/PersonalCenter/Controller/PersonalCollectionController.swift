//
//  PersonalCollectionController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON


class PersonalCollectionController: YCBaseTableViewController {
    

    var scrabArray = [PersonalMyScrab]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的收藏".localized
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(popBack))
        tableView.registerNibOf(PersonalCollectionCell.self)
        tableView.backgroundColor = UIColor.BaseControllerBackgroundColor
        tableView.rowHeight = PersonalCollectionCell.getHeight()
        tableView.tableFooterView = UIView()
        
        updateMainData(mode: .Static)
                
      }
    
    override func pullRefresher(sender: UIRefreshControl) {
        updateMainData(mode: .TopRefresh,finish:{
            sender.endRefreshing()
        })
    }
    
    override func fetchAgain() {
         updateMainData(mode: .Static) { }
    }
    
    
    fileprivate func updateMainData(mode:UpdateMode,finish:(()->Void)? = nil){
        if isFetching {
            finish?()
            return
        }
        isFetching = true
        PersonalMyScrab.Get { [weak self] result in
            guard let strongself = self else { return }
            strongself.isloading = false
            strongself.isFetching = false
            switch result {
            case .success(let json):
                strongself.scrabArray = json
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
            finish?()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scrabArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = scrabArray[indexPath.row]
        guard let url = URL(string: news.scrabUrl) else { return }
        let webview = YCWebViewController(url: url)
        navigationController?.pushViewController(webview, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PersonalCollectionCell = tableView.dequeueReusableCell()
        cell.updateWithModel(model:scrabArray[indexPath.row])
        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt  indexPath: IndexPath) {
            tableView.beginUpdates()
            PersonalDeleteScrabInfo(newsSeq: scrabArray[indexPath.row].bannerSeq)
            scrabArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
    }
    
}

extension PersonalCollectionController {
    
    public func PersonalDeleteScrabInfo(newsSeq:Int){
        
        let parse:(JSONDictionary) -> JSONDictionary = { json in
            return json
        }
        let memberID:String = YCAccountModel.getAccount()?.memid ?? ""
        let requestParameters:[String:Any] = [
            "MemberID":memberID,
            "NewsSeq":newsSeq
        ]
        let netResource = NetResource(path: "/NewsView/SetScrab",
                                      method: .post,
                                      parameters: requestParameters,
                                      parse: parse)
        YCProvider.requestDecoded(netResource) { result in
            
        }
    }


}
