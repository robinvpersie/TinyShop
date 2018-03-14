//
//  RecommendSearchPresent.swift
//  Portal
//
//  Created by linpeng on 2018/1/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class RecommendSearchPresent: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? RecommendSearchController,
              let fromVC = transitionContext.viewController(forKey: .from) else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.size.width, height: containerView.bounds.size.height)
        
        toVC.blacKContainerView.alpha = 0.0
        toVC.whiteContainerView.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            toVC.blacKContainerView.alpha = 0.6
            toVC.whiteContainerView.alpha = 1
        }) { (finish) in
            transitionContext.completeTransition(finish)
        }
    }
    
}
