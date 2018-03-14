//
//  ShopBaseViewController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopBaseViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        
        let back = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(popBack))
        back.tintColor = UIColor.darkcolor
        navigationItem.leftBarButtonItem = back
    }
    
    func popBack(){
        if let navi = self.navigationController {
            navi.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 19),NSForegroundColorAttributeName:UIColor.darkcolor]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
