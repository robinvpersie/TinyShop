//
//  YCTabbarController.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class YCTabbarController: UITabBarController {
    
    enum Tab:Int{
        case Home
        case Messages
        case Service
        case Personal
        case More
        
        var descrition:String{
            switch self {
            case .Home:
                return "首页"
            case .Messages:
                return "消息"
            case .Service:
                return "服务"
            case .Personal:
                return "我的"
            case .More:
                return "更多"
            }
         }
    }
    
    private var previousTab: Tab = .Home
    
    var tab: Tab? {
        didSet {
            if let tab = tab {
                self.selectedIndex = tab.rawValue
            }
        }
    }
    private var checkDoubleTapOnFeedsTimer:Timer?
    
    @objc private var hasFirstTapOnHomeWhenItIsAtTop = false {
        willSet{
             checkDoubleTapOnFeedsTimer?.invalidate()
            if newValue{
            let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector( getter: YCTabbarController.hasFirstTapOnHomeWhenItIsAtTop), userInfo: nil, repeats: false)
             checkDoubleTapOnFeedsTimer = timer
            }
        }
    }
    
    
    func changeFirstTapOn(){
       self.hasFirstTapOnHomeWhenItIsAtTop = false
    }
    
    
    deinit {
        checkDoubleTapOnFeedsTimer?.invalidate()
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    var isTabBarVisible:Bool{
      return self.tabBar.frame.origin.y < view.frame.maxY
    }
    
    func  setTabBarHidder(hidden:Bool,animated:Bool)  {
        guard isTabBarVisible == hidden else {
           return
        }
        let height = self.tabBar.frame.size.height
        let offsetY = (hidden ? height : -height)
        let duration = (animated ? 0.25 : 0.0)
        UIView.animate(withDuration: duration, animations: {[weak self] in
            guard let strongself = self else {
               return
            }
           let frame = strongself.tabBar.frame
           strongself.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
        })
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
