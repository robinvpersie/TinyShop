//
//  StringExtension.swift
//  Portal
//
//  Created by linpeng on 2016/11/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate


public extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let bound = self.boundingRect(with: constraintRect,
                                      options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine],
                                      attributes: [NSAttributedStringKey.font: font],
                                      context: nil)
        return bound.height
    }
    
    func widthWithConstrainedWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width:CGFloat(MAXFLOAT) , height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading],
                                            attributes: [NSAttributedStringKey.font: font],
                                            context: nil).width
        return boundingBox
      }
    
    func sizeforConstrainedSize(font: UIFont, constrainedSize: CGSize) -> CGRect{
        let boundingBox = self.boundingRect(with: constrainedSize,
                                            options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedStringKey.font:font],
                                            context: nil)
        return boundingBox
    }
    
//    func fontHeight(font: UIFont, width: CGFloat? = 0.01) -> CGFloat {
//        let label = UILabel()
//        label.numberOfLines = 1
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = self
//        let newnameheight = label.sizeThatFits(CGSize(width: width!, height: CGFloat(MAXFLOAT))).height
//        return newnameheight
//    }
    
    
    /// 获得Url里面的对应的参数名字的值
    ///
    /// - Parameters:
    ///   - url: url
    ///   - param: param name
    /// - Returns: the value of the param
    func getQueryStringParameter(param: String) -> String? {
        var urlQueryItemArr = [URLQueryItem]()
        if let url = URLComponents(string: self),
            let queryItems = url.queryItems {
            urlQueryItemArr = queryItems.filter({
              $0.name == param
            })
        }
        return urlQueryItemArr.first?.value
     }
    
    //获得url里面对应的参数key数组
    func getQueryKey() -> [String] {
        var keyArray = [String]()
        if let url = URLComponents(string: self),
            let queryItem = url.queryItems {
            keyArray = queryItem.compactMap({ $0.name })
        }
        return keyArray
    }
    
    func getValurArray() -> [String] {
        var valueArray = [String]()
        if let url = URLComponents(string: self),
            let queryItem = url.queryItems {
            valueArray = queryItem.compactMap({ $0.value })
        }
        return valueArray
    }
    
    
    func toStringWithFormatterString(_ formatter: String) -> String{
        let swiftdate = NSDate.dateFromString(dateString: self, withFormat: formatter)
        return swiftdate.string(custom: formatter)
    }
    
    func utf8encodedString() -> String {
        var arr = [UInt8]()
        arr += self.utf8
        return String(bytes: arr,encoding: String.Encoding.utf8)!
    }

    var utf8Encoded: Data {
       return self.data(using: .utf8)!
    }
    
    var localized: String {
        return languageTool.shared.getString(self)
    }
}


public extension NSDate {
    
    public class func dateWithString(dateString: String?) -> Date {
        if var dateString = dateString {
            if dateString.hasSuffix("Z") {
                dateString = String(dateString.dropLast()).appending("-0000")
            }
            return dateFromString(dateString: dateString, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        }
        return Date()
    }
    
    class func dateFromString(dateString: String, withFormat dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
}

