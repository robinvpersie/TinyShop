//
//  BaseViewController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/16.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
     }
    
    
    var pushAnimation: CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.autoreverses = false
        return transition
    }
    
    func pushAnimation( viewcontroller :UIViewController) {
        view.layer.add(pushAnimation, forKey: kCATransition)
    }
    
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag == false {
           super.present(viewControllerToPresent, animated: flag, completion: completion)
           pushAnimation(viewcontroller: viewControllerToPresent)
        }else {
           super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
