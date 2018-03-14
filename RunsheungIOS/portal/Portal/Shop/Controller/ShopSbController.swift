//
//  ShopSbController.swift
//  Portal
//
//  Created by PENG LIN on 2017/7/25.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopSbController: ShopBaseViewController {
    
    var imageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "演艺中心简介"
        imageView = UIImageView()
        imageView.image = UIImage(named: "zsb")
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(64)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
