//
//  ViewController.swift
//  Portal
//
//  Created by linpeng on 2016/11/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIPageViewController {
    
    var pushToMain: ((dataModel?) -> Void)?
    var model: dataModel?
    fileprivate var ControllerArray = [UIViewController]()
    private var skipBtn: UIButton!
    private var timer: Timer?
    private var totaltime: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requetData()
        dataSource = self
        view.backgroundColor = UIColor.white
        
        skipBtn = UIButton(type: .custom)
        skipBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        skipBtn.layer.cornerRadius = 4
        skipBtn.setTitle("跳过\(totaltime)", for: .normal)
        skipBtn.titleLabel?.textColor = UIColor.white
        skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        skipBtn.alpha = 0.92
        skipBtn.clipsToBounds = true
        view.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(20)
            make.top.equalTo(view).offset(30)
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        skipBtn.addTarget(self, action: #selector(push), for: .touchUpInside)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    @objc  func countDown(){
        totaltime -= 1
        if totaltime <= 0 {
           timer?.invalidate()
           pushToMain?(model)
        }
        skipBtn.setTitle("跳过\(totaltime)", for: .normal)
    }
    
    @objc func push(){
       timer?.invalidate()
       self.pushToMain?(self.model)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    
    private func requetData(){
        
//        self.showLoading()
//        dataModel.intro( { [weak self] reason, errormessage in
//            guard let strongself = self else { return }
//            strongself.hideLoading()
//            strongself.showMessage(errormessage)
//        }) { [weak self] model in
//            guard let strongself = self else { return }
//            strongself.hideLoading()
//            strongself.model = model
//            guard let model = model else { return }
//            if let account = YCAccountModel.getAccount() {
//               account.token = model.token
//               let objectTodata = NSKeyedArchiver.archivedData(withRootObject: account)
//               YCUserDefaults.accountModel.value = objectTodata
//            }
//            
//            for Uniquemodel in model.bannerData {
//                let advertisement = AdvertisementController()
//                advertisement.ClickImageView = { [weak self] in
//                  guard let strongself = self else { return }
//                    strongself.timer?.invalidate()
//                    strongself.pushToMain?(model)
//                   }
//                  advertisement.dataModel = Uniquemodel
//                  strongself.ControllerArray.append(advertisement)
//            }
//            
//            if !strongself.ControllerArray.isEmpty{
//              strongself.setViewControllers([(strongself.ControllerArray[0])], direction: .forward, animated:true, completion: nil)
//            }
//            
//            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//            let appVersionNum:Int = Int(appVersion.replacingOccurrences(of: ".", with: ""))!
//            
//            if let forceVersion = model.iphoneForceVersion {
//        
//               let forceVersionNum:Int = Int(forceVersion.replacingOccurrences(of: ".", with: ""))!
//            
//               if appVersionNum > forceVersionNum {
//                  print("当前版本大于最低版本,不需要更新")
//               } else {
//                print("当前版本小于最低版本,需要更新")
//                let updateAction = UIAlertAction.init(title: "前往更新", style: .default, handler: { (action) in
//                    let url : URL = URL.init(string: "itms-apps://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8")!
//                    UIApplication.shared.openURL(url)
//                })
//                let alert = UIAlertController.init(title: "提示", message: "有新版本,请前往更新", preferredStyle: .alert)
//                alert.addAction(updateAction)
//                self?.present(alert, animated: true, completion: nil)
//                return
//              }
//            }
//            
//            if let notice = model.notice {
//                let noticeVersion = model.noticeVersion
//                if notice.characters.count > 0 {
//                let notShowAnymore = UIAlertAction.init(title: "不再提示", style: .default, handler: { (action) in
//                    UserDefaults.standard.set(noticeVersion, forKey: "NoticeVersion")
//                })
//                
//                let ok = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
//                
//                let alert = UIAlertController.init(title: "公告", message: notice, preferredStyle: .alert)
//                alert.addAction(notShowAnymore)
//                alert.addAction(ok)
//                
//                let localNoticeVersion = UserDefaults.standard.object(forKey: "NoticeVersion") as? String
//                
//                if localNoticeVersion == noticeVersion {
//                    
//                } else {
//                   self?.present(alert, animated: true, completion: nil)
//                }
//              }
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


extension WelcomeViewController:UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        guard let index = ControllerArray.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard  previousIndex >= 0 else {
            return nil
        }
        guard ControllerArray.count > previousIndex else {
            return nil
        }
        return ControllerArray[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        guard let index = ControllerArray.index(of: viewController) else {
            return nil
        }
        let afterIndex = index + 1
        guard afterIndex != ControllerArray.count else {
            return nil
        }
        guard afterIndex < ControllerArray.count else {
            return nil
        }
        return ControllerArray[afterIndex]
   
    }
}


