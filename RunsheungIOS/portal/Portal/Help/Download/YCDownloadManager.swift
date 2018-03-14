//
//  YCDownloadManager.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire

class YCDownloadManager:NSObject {
    var maxCount:Int?
    var count:Int = 0
    var finishedlist = [YCFileModel]()
    var downinglist = [Any]()
    var filelist = [YCFileModel]()
    let Base = "YCDownload"
    let cacheString:String? = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
    
    static let `default` = YCDownloadManager()
    private override init(){
        super.init()
        var max:Int
        if let maxCount = YCUserDefaults.KLMaxRequestCount.value {
           max = maxCount
        }else {
           max = 3
           YCUserDefaults.KLMaxRequestCount.value = max
        }
        loadFinshedFiles()
    }
    
    func loadFinshedFiles(){
        let plistPath = Base + cacheString! + "/FinishedPlist.plist"
        
        if FileManager.default.fileExists(atPath: plistPath) {
            let finishArr = NSMutableArray(contentsOfFile: plistPath)
            for dic in finishArr! {
                let model = YCFileModel()
                finishedlist.append(model)
           }
        }
    }
    
    
    func loadTempfiles(){
//            Alamofire.download(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>, to: <#T##DownloadRequest.DownloadFileDestination?##DownloadRequest.DownloadFileDestination?##(URL, HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions)#>)
     }
}
