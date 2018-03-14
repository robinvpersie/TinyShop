//
//  OfflineBaseController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

public class OfflineBaseController: UIViewController {
    
    override public func viewWillAppear(_ animated: Bool) {
        let back = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(yc_back))
        back.tintColor = UIColor.darkcolor
        navigationItem.leftBarButtonItem = back
    }


    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 19),NSForegroundColorAttributeName:UIColor.darkcolor]

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
