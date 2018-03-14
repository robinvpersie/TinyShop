//
//  YCLoginContainerController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/1.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit


public let segmentheight:CGFloat = 45
public let segmentEdges:CGFloat = 70

class YCLoginContainerController: CanteenBaseViewController {
    
    var isChattingLogin:Bool? = false
    var longinSuccess:(() -> Void)?
    lazy var ControllerArray:[UIViewController] = [self.loginviewcontroller,self.newMember]
    lazy var loginviewcontroller:YCLoginViewController = {
        let login = YCLoginViewController()
        login.loginSuccessCallBack = { [weak self] in
            guard let strongself = self else { return }
            strongself.longinSuccess?()
            strongself.dismiss(animated: true, completion: nil)
        }
        return login
    }()
    
    lazy var newMember:YCNewMemberController = {
       let newMember = YCNewMemberController()
       newMember.AddmemberSuccessCallBack = { [weak self] in
          self?.tab.moveToController(at: 0, animated: true)
          self?.showMessage("加入会员成功")
         }
         return newMember
      }()
    
    var tab:TYTabButtonPagerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登录".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(popBack))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkcolor
        view.backgroundColor = UIColor.groupTableViewBackground
        
        tab = TYTabButtonPagerController()
        tab.collectionViewBarColor = UIColor.groupTableViewBackground
        tab.showbadge = false
        tab.dataSource = self
        tab.delegate = self
        tab.adjustStatusBarHeight = true
        tab.barStyle = .progressView
        tab.cellSpacing = 0
        tab.progressWidth = 36
        tab.cellWidth = screenWidth/2
        tab.normalTextColor = UIColor.darkcolor
        tab.selectedTextColor = UIColor.navigationbarColor
        tab.progressColor = UIColor.navigationbarColor
        addChildViewController(tab)
        view.addSubview(tab.view)

    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         tab.view.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.width, height: view.height - topLayoutGuide.length)

    }
    

    @objc override func popBack() {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension YCLoginContainerController:TYPagerControllerDataSource{
    func numberOfControllersInPagerController() -> Int {
        return 2
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
         return ControllerArray[index]
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        if index == 0 {
            return "登录".localized
        }else {
            return "新用户".localized
        }
    }

}

extension YCLoginContainerController:TYTabPagerControllerDelegate {

}








