//
//  BaseController.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit


class BaseController: UIViewController {
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLanguage(_:)), name: NSNotification.Name.changeLanguage, object: nil)

    }
    
    @objc func refreshLanguage(_ noti:Notification){
        
    }
    
    @objc func didback(){
        if let navi = self.navigationController {
           navi.popViewController(animated: true)
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    override var shouldAutorotate: Bool{
       return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
