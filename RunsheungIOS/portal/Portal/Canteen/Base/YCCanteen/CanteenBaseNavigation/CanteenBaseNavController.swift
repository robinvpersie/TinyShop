//
//  CanteenBaseNavController.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//  jake test

import UIKit

class CanteenBaseNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationBar.barTintColor = UIColor.white
       navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 19),NSForegroundColorAttributeName:UIColor.darkcolor]
    }
    
    func goBack(){
        popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
       return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
