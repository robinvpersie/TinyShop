//
//  YCUploadAttachmentOperation.swift
//  Portal
//
//  Created by PENG LIN on 2017/1/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate
import SwiftyJSON

final class UploadAttachmentOperation: ConcurrentOperation {
    
    fileprivate let uploadAttachment: UploadAttachment
    
    public enum result {
        case failed(errorMessage: String?)
        case success(attachment: Any)
    }
    public typealias Completion = (_ result: result) -> Void
    fileprivate let completion: Completion
    
    public init(uploadAttachment: UploadAttachment, completion: @escaping Completion) {
        self.uploadAttachment = uploadAttachment
        self.completion = completion
        super.init()
    }
    
    override func main() {
         tryUploadAttachment( uploadAttachment: uploadAttachment, failureHandler: { [weak self] reason , errormessage in
            guard let strongself = self else { return }
            defaultFailureHandler(reason,errormessage)
            strongself.completion(.failed(errorMessage: errormessage))
            strongself.state = .Finished
         }, completion: { [weak self] attachment in
               guard let strongself = self else { return }
               strongself.completion(.success(attachment: attachment))
               strongself.state = .Finished
        })
    }
}



public struct UploadAttachment {
    
    public enum UploadAttachmentType: String {
      case avatar = "avatar"
      case comment = "comment"
        
      var BaseUrl: String {
        switch self {
        case .avatar:
            return "http://portal.gigawon.co.kr:8488/Common/FileUploader.ashx"
        case .comment:
            return BaseType.PortalBase.baseURL + canteen_commentUploadPath
        }
      }
    }
    
    public enum source {
        case data(Data)
        case filePath(String)
    }
    
    public var fileName: String
    public var name: String
    public let AttType: UploadAttachmentType
    public let source: source
    public let fileExtension: FileExtension
    public let metaDataString: String?
    public init(attType: UploadAttachmentType = .avatar,
                source: source,
                fileExtension: FileExtension,
                metaDataString: String? = nil,
                fileName: String = "file",
                name: String = "MediaUploader/wsProfile"
    ){
        self.AttType = attType
        self.source = source
        self.fileExtension = fileExtension
        self.metaDataString = metaDataString
        self.fileName = fileName
        self.name = name
    }
}

public enum FileExtension: String {
    case jpeg = "jpeg"
    case png = "png"
    public var mimeType: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        }
    }
}



public func tryUploadAttachment(parameters: [String:Any]? = nil,
                                uploadAttachment: UploadAttachment,
                                failureHandler: FailureHandler?,
                                completion: @escaping (Any) -> Void)
{

    let fileName = uploadAttachment.fileName
    let mineType = uploadAttachment.fileExtension.mimeType
    let name = uploadAttachment.name
    
    Alamofire.upload(multipartFormData: { MultipartFormData in
        switch uploadAttachment.source {
        case .data(let data):
            switch uploadAttachment.AttType {
            case .avatar:
                MultipartFormData.append(data, withName: name, fileName: fileName, mimeType: mineType)
            case .comment:
                let imageName = Date().string(custom: "YYYY-MM-dd-hh-mm-ss") + ".jpg"
                MultipartFormData.append(data, withName: "file", fileName: imageName, mimeType: mineType)
            }
        case .filePath(let filePath):
            MultipartFormData.append( URL(fileURLWithPath: filePath), withName: name, fileName: fileName, mimeType: mineType)
        }
    }, to: uploadAttachment.AttType.BaseUrl) { encodingResult in
        switch encodingResult {
        case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
            upload.responseJSON(completionHandler: { response in
                let value = response.result
                switch value {
                case let .success(json):
                    switch uploadAttachment.AttType {
                    case .avatar:
                        completion(uploadAttachment)
                    case .comment:
                        let json = JSON(json)
                        let imageFileNameArray = json["UploadImageList"].arrayValue
                        let dic = imageFileNameArray[0].dictionaryValue
                        let imageFileName = dic["imageFileName"]?.stringValue
                        completion(imageFileName ?? "")
                     }
                case let .failure(error):
                    failureHandler?(.other(error),Reason.other(error).description)
                }
             })
        case let.failure(error):
            failureHandler?(.other(error),Reason.other(error).description)
        }
     }
    
}




