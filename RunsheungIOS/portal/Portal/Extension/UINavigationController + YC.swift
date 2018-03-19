//
//  UINavigationController + YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/12.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation


extension UINavigationController{
    
    var popAnimation: CATransition{
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.autoreverses = false
        return transition
    }
    
    var pushAnimation: CATransition{
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromBottom
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.autoreverses = false
        return transition
    }
    
    open override var shouldAutorotate: Bool{
        guard let visible = self.visibleViewController else {
            return super.shouldAutorotate
        }
        return visible.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        guard let visible = self.visibleViewController else {
            return super.supportedInterfaceOrientations
        }
        return visible.supportedInterfaceOrientations
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        guard let visible = self.visibleViewController else {
            return super.preferredInterfaceOrientationForPresentation
        }
        return visible.preferredInterfaceOrientationForPresentation
    }
    
}

extension UITabBarController {
    
    open override var shouldAutorotate: Bool{
        guard let vc = viewControllers?[selectedIndex] else {
            return super.shouldAutorotate
        }
        if vc is UINavigationController {
           let vc = vc as! UINavigationController
           return vc.shouldAutorotate
        }else {
           return vc.shouldAutorotate
        }
    }
    

    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        guard let vc = self.viewControllers?[self.selectedIndex] else { return super.preferredInterfaceOrientationForPresentation }
        if vc is UINavigationController {
           let nav = vc as! UINavigationController
            guard let top = nav.topViewController else { return super.preferredInterfaceOrientationForPresentation }
           return top.preferredInterfaceOrientationForPresentation
        }else {
           return vc.preferredInterfaceOrientationForPresentation
        }
    }
    
}

