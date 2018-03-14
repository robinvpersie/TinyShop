//
//  YCImageCache.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/25.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import Kingfisher

/// cache with image ver
final class YCImageCache {
    
    static let sharedInstance = YCImageCache()
    let cacheAttachmentQueue = DispatchQueue(label: "imagecacheATTachmentQueue")
    typealias progressBlock = ((_ currentSize:Int64,_ totalSize:Int64) -> Void)?
    typealias completionBlock = ((_ url:URL?,_ image:UIImage?,_ CacheType:CacheType?) -> Void)?
    
    
    class func attachmentVerKeyWithUrlString(URLString:String?,ver:String) -> String {
          return (URLString ?? "") + ver
    }
    
    
    func imageOfURL(imageView:UIImageView,
                    url:URL?,
                    Ver:String,
                    placeHolder:UIImage? = nil,
                    options:KingfisherOptionsInfo? = nil,
                    progressBlock:progressBlock? = nil,
                    completion:completionBlock){
        
        let optionA:KingfisherOptionsInfo = [.callbackDispatchQueue(cacheAttachmentQueue)]
        let attachmentVerKey = YCImageCache.attachmentVerKeyWithUrlString(URLString: url?.absoluteString, ver: Ver)
        KingfisherManager.shared.cache.retrieveImage(forKey: attachmentVerKey, options: optionA, completionHandler: { (image,type) in
             if let image = image {
                DispatchQueue.main.async {
                    imageView.image = image
                    completion?(url, image, type)
                }
            } else {
                var optionsB = KingfisherOptionsInfo()
                if let options = options{
                    optionsB.append(contentsOf: options)
                 }
                optionsB.append(.forceRefresh)
                imageView.kf.setImage(with: url, placeholder: placeHolder, options: optionsB, progressBlock: progressBlock!, completionHandler: { (image, _, type, url) in
                    if let image = image {
                        KingfisherManager.shared.cache.store(image, forKey: attachmentVerKey)
                    }
                })
            }
        })
    }
}

extension UIImageView{
    
    func setImage(url:YCURLConvertible,
                  Ver:String,
                  placeholder:UIImage? = nil,
                  options:KingfisherOptionsInfo? = nil,
                  progressBlock:((_ currentsize:Int64,_ totalSize:Int64) -> ())? = nil,
                  completion:((_ url:URL?,_ image:UIImage?,_ CacheType:CacheType?) ->Void)? = nil)
    {
        
        YCImageCache.sharedInstance.imageOfURL(imageView:self,url: url.asURL(),
                                               Ver: Ver,
                                               placeHolder: placeholder,
                                               options:options,
                                               progressBlock: progressBlock,
                                               completion: completion)
    }
}

protocol YCURLConvertible {
    func asURL() -> URL?
}

extension URL:YCURLConvertible {
    public func asURL() -> URL? {
        return self
    }
}

extension String:YCURLConvertible {
    public func asURL() -> URL? {
        return URL(string: self)
    }
}










