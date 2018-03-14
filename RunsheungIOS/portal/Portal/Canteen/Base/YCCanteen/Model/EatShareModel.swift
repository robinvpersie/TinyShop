//
//  EatShareModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/23.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import MBProgressHUD

struct eatShareModel {
    
    let actionType:String = "rsrestaurantshare"
    let type:String = "9"
    let phoneNumber:String
    let password:String
    let title:String
    let content:String
    let token:String
    let groupId:String
    let imageUrl:String
    let url:String
    let itemCode:String
    let groupName:String
    let roomId:String

    
    func Share(){
        let urlstr = "ycapp://" + "\(self.actionType)" + "$" + "\(self.phoneNumber)" + "$" + "\(self.password)" + "$" + "\(self.title)" + "$" + "\(self.content)" + "$" + "\(self.imageUrl)" + "$" + "\(self.type)" + "$" + "\(self.itemCode)" + "$" + "\(self.token)" + "$" + "\(self.url)" + "$" + "\(self.groupId)" + "$" + "\(self.groupName)" + "$" + "\(self.roomId)"
        print(urlstr)
        let utf8Str = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let utf8 = utf8Str,let url = URL(string: utf8), UIApplication.shared.canOpenURL(url) else {
            if let view = MBProgressHUD.getRootView() {
              MBProgressHUD.hideAfterDelay(view: view, text: "跳转的应用未安装")
            }
            return
        }
        UIApplication.shared.openURL(url)
     }
}
