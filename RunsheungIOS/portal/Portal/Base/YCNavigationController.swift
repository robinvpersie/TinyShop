//
//  YCNavigationController.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class YCNavigationController: UINavigationController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 19),NSForegroundColorAttributeName:UIColor.darkText]
        

    }
   
    func pushViewController(viewController:UIViewController,backTitle:String?,backAction:(() -> Void)?,animated:Bool?){
        if let backTitle = backTitle {
           let backitem = UIBarButtonItem()
           backitem.title = backTitle
        }
        
        if let animated = animated {
           super.pushViewController(viewController, animated: animated)
           return
        }
        
        if let pushv = self.topViewController{
            if pushv.responds(to:#selector(YCNavigationController.pushAnimation(viewcontroller:))){
            pushv.perform(#selector(YCNavigationController.pushAnimation(viewcontroller:)), with: viewController)
            }
            else {
             super.pushViewController(viewController, animated: false)
             self.pushAnimation(viewcontroller: viewController)
            }
        }
    }
    
  
    override func popViewController(animated: Bool) -> UIViewController? {
        
//       self.dismiss(animated: true, completion: nil)
        if animated {
          return super.popViewController(animated: animated)
        }
        if let popV = self.topViewController {
            if popV.responds(to: #selector(YCNavigationController.popAnimation(viewController:))){
                popV.perform(#selector(YCNavigationController.popAnimation(viewController:)), with: popV)
                return super.popViewController(animated: false)
            }else {
              self.popAnimation(viewController: popV)
                return super.popViewController(animated: false)
            }
        }else {
          return super.popViewController(animated: false)
        }
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        
        if animated{
           return super.popToViewController(viewController, animated: animated)
        }
        
        guard let popv = self.topViewController else {
            return super.popToViewController(viewController, animated: animated)
        }
        if popv.responds(to: #selector(YCNavigationController.popAnimation(viewController:))){
            popv.perform(#selector(YCNavigationController.popAnimation(viewController:)), with: popv)
            return super.popToViewController(viewController, animated: false)
        }else {
           self.popAnimation(viewController: popv)
            return super.popToViewController(viewController, animated: false)
        }
    }
    
    @objc func pushAnimation(viewcontroller:UIViewController){
        self.view.layer.add(self.pushAnimation, forKey: kCATransition)
    }
    
    @objc func popAnimation(viewController:UIViewController){
        self.view.layer.add(self.popAnimation, forKey: kCATransition)
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController?{
        return self.topViewController
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

