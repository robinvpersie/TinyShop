//
//  PreviewViewController.swift
//  Portal
//
//  Created by PENG LIN on 2017/6/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewViewController: UIViewController {
    
    var imageView = UIImageView()
    var image:UIImage? {
        didSet{
           imageView.image = image
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.image = image?.yc.resizeToTargetSize(targetSize: self.view.bounds.size)
        imageView.frame = self.view.bounds

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}




class PreviewAttachmentPhoto:NSObject,Photo {
    
    var image:UIImage? {
        didSet{
            self.updatedImage?(image)
        }
    }
    
    var updatedImage: ((_ image:UIImage?) -> Void)?
    
    init(url:URL) {
        super.init()
        
        let isCached = KingfisherManager.shared.cache.isImageCached(forKey: url.absoluteString)
        if isCached.cached {
            
            let image = ImageCache.default.retrieveImageInDiskCache(forKey: url.absoluteString)
            self.image = image
            
        }else {
            
            KingfisherManager.shared.downloader.downloadImage(with: url, options: nil, progressBlock: nil) { [weak self] image, error, url, data in
                if let image = image {
                    self?.image = image
                    ImageCache.default.store(image, forKey: url!.absoluteString)
                }
            }
        }
    }
    
}

