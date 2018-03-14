//
//  AdvertisingController.swift
//  Portal
//
//  Created by PENG LIN on 2017/8/30.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class AdvertisingController: UIViewController {
    
    var advertiseImageView:UIImageView!
    var loadScreenImageView:UIImageView!
    var activityIndicator:UIActivityIndicatorView!
    lazy var timer:Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    var totaltime:Int = 5
    var skipBtn:UIButton!
    var pushToMain: (() -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadScreenImageView = UIImageView()
        loadScreenImageView.image = UIImage.LaunchImage
        loadScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadScreenImageView)
        loadScreenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadScreenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadScreenImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadScreenImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       advertiseImageView = UIImageView()
       advertiseImageView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(advertiseImageView)
       advertiseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
       advertiseImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       advertiseImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
       advertiseImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
       activityIndicator.hidesWhenStopped = true
       activityIndicator.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(activityIndicator)
       activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:-40).isActive = true
        
       skipBtn = UIButton(type: .custom)
       skipBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
       skipBtn.layer.cornerRadius = 4
       skipBtn.setTitle("跳过\(totaltime)", for: .normal)
       skipBtn.titleLabel?.textColor = UIColor.white
       skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
       skipBtn.alpha = 0.92
       skipBtn.clipsToBounds = true
       skipBtn.addTarget(self, action: #selector(push), for: .touchUpInside)
       skipBtn.isHidden = true
       skipBtn.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(skipBtn)
       skipBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:20).isActive = true
        if #available(iOS 11.0, *) {
            skipBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            skipBtn.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true 
        }
       skipBtn.widthAnchor.constraint(equalToConstant: 65).isActive = true
       skipBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
       showAdvertise()
        
    }
    
    
    func countDown(){
        totaltime -= 1
        if totaltime <= 0 {
           push()
        }
        skipBtn.setTitle("跳过\(totaltime)", for: .normal)
 
    }
    
    func push(){
       timer.invalidate()
       pushToMain?()
    }
    
    deinit {
        timer.invalidate()
    }
    
    func showAdvertise(){
        if let showPath = DownloadADManager.default.showAdpath {
             advertiseImageView.kf.setImage(with: URL(string: showPath), options:  [.targetCache(DownloadADManager.default.imageCache)], completionHandler: { [weak self] image, error, _, _ in
                   guard let this = self else { return }
                   OperationQueue.main.addOperation {
                     if image != nil {
                         this.skipBtn.isHidden = false
                         this.timer.fire()
                     }else {
                        this.push()
                     }
                  }
              })
        }else {
            push()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


