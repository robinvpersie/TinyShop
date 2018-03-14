//
//  DownloadADManager.swift
//  Portal
//
//  Created by PENG LIN on 2017/8/30.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Kingfisher

class DownloadADManager {
    
    public static let `default` = DownloadADManager(name: "adurl")
    let imageCache = ImageCache(name: "ycadvertise", path: nil)
    var fileManager:UserDefaults!
    var name:String!
    var ioqueue:DispatchQueue
    var lock:NSLock!
    
    public init(name:String){
        
        self.name = name
        lock = NSLock()
        
        let ioqueuename = "adurl"
        ioqueue = DispatchQueue(label: ioqueuename)
        ioqueue.sync {
            fileManager = UserDefaults()
        }
    }
    
    var showAdpath:String?{
        
         if let array:NSArray = fileManager.object(forKey: self.name) as? NSArray,
            let first = array[0] as? String {
             return first
         }else {
            return nil
         }
     }
    
        
    func download(urlArray:[URL]){
        for uri in urlArray {
           let iscached = imageCache.isImageCached(forKey: uri.absoluteString)
           if !iscached.cached {
                ImageDownloader.default.downloadImage(with: uri, options: nil, completionHandler: { image, error, uri, data in
                    if let data = data,let image = image,let uri = uri {
                        self.imageCache.store(image, original: data, forKey: uri.absoluteString, toDisk: true)
                        self.ioqueue.async {
                            self.lock.lock(); defer { self.lock.unlock() }
                            let array = self.fileManager.object(forKey: self.name)
                            if let newarray:NSArray = array as? NSArray {
                                let mutablearray:NSMutableArray = NSMutableArray(array: newarray)
                                mutablearray.insert(uri.absoluteString, at: 0)
                                self.fileManager.setValue(mutablearray, forKey: self.name)
                            }else {
                                let new = NSMutableArray(object: uri.absoluteString)
                                self.fileManager.setValue(new, forKey: self.name)
                            }
                         }
                    }
                 })
              }
         }
    }
}
