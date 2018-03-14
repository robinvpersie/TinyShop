//
//  YCFileModel.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class YCFileModel: NSObject {
    
    enum YCDownloadState:Int{
        case isloading
        case willDownload
        case stopDownload
    }
    var fileName:String!
    var fileSize:String!
    var fileType:String!
    var isFirstReceived:Bool!
    var fileReceivedSize:String!
    var fileReceivedData:Data!
    var fileUrl:String!
    var time:String!
    var tempPath:String!
    var downloadState:YCDownloadState!
    var error:Error!
    var md5:String!
    var fileImage:UIImage!
    
}
