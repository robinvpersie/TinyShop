//
//  ShopActivityDetailController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SwiftyJSON

class shopActivityDetailController:ShopBaseViewController {
    
    var divCode:String!
    var activityId:String!
    var imgView:UIImageView!
    var detaillb:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "活动详情".localized
        
        imgView = UIImageView()
        view.addSubview(imgView)
        
        detaillb = UILabel()
        detaillb.font = UIFont.systemFont(ofSize: 20)
        detaillb.textColor = UIColor.darkText
        detaillb.numberOfLines = 0
        view.addSubview(detaillb)

        requestData()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view).offset(topLayoutGuide.length)
            make.height.equalTo(210)
        }
        
        detaillb.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.top.equalTo(imgView.snp.bottom).offset(15)
        }
    }
    
    func requestData(){
        ActivityDetailModel.getWith(divCode: divCode, activityId: activityId,completion: { result in
            switch result {
            case .success(let data):
                let json = JSON(data)
                if let imageurlString = json["image_url"].string,let url = URL(string: imageurlString) {
                    self.imgView.kf.setImage(with: url)
                }
                self.detaillb.text = json["detail"].string
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            case .tokenError:
                self.goToLogin()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
