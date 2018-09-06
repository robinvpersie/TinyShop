//
//  AdvertisementController.swift
//  Portal
//
//  Created by linpeng on 2016/11/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher

class AdvertisementController: UIViewController {
    
    var ClickImageView:(() -> Void)?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageView(tap:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    var dataModel: Bannerdatss? {
        didSet{
           self.dataSource = dataModel?.imgUrl
        }
    }
    
    var dataSource: String?{
        didSet{
            guard let urlstr = dataSource,
                let url = URL(string:urlstr) else {
                    return
                }
            let options: [KingfisherOptionsInfoItem] = [.transition(.fade(0.6))]
            self.imageView.kf.setImage(with:url, options: options)
        }
    }
    
    func tapImageView(tap: UITapGestureRecognizer) -> Void {
        if let _ = self.dataModel{
            self.ClickImageView!()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(imageView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
