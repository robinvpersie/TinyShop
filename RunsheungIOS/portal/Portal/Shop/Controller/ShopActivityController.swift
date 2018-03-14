//
//  ShopActivityController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShopActivityController:ShopTableViewController {
    
    var divCode:String!
    var progress:Int!
    var dataSource = [ActivityModel](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNeedLoadMore = false
        isNeedTopRefresh = false
        tableView.registerClassOf(ShopActivityCell.self)
        requestData()
    }
    
    func requestData(){
        
        ActivityModel.requestData(currentPage:nextPage,divCode:divCode,progress: progress) { (result) in
            switch result {
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            case .success(let json):
                let newjson = JSON(json)
                if newjson["status"].string == "1" {
                    let listActivity = newjson["listActivity"].arrayValue
                    self.dataSource = listActivity.map({ ActivityModel(json: $0) })
                }else {
                    self.showMessage(newjson["msg"].string)
                }
            case .tokenError:
                self.goToLogin(completion: { })
            }
        }

    }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ShopActivityCell.getHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ShopActivityCell = tableView.dequeueReusableCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = shopActivityDetailController()
        controller.divCode = divCode
        controller.activityId = dataSource[indexPath.row].activityid
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? ShopActivityCell
        cell?.model = dataSource[indexPath.row]
    }
    
    override func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "暂无活动")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


fileprivate class ShopActivityCell:UITableViewCell {
    
    lazy var imgView:UIImageView = UIImageView()
    
    var model:ActivityModel!{
        didSet{
            if let url = model.imageUrl {
              imgView.kf.setImage(with: url)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
   }
    
    class func getHeight()->CGFloat {
        return 150
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



