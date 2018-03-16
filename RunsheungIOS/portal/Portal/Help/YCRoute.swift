//
//  YCRoute.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

class YCRouteBox: NSObject {
    
    static let manager = YCRouteBox()
    
    var needPushUrl = URL(string: "http://hotel.dxbhtm.com:8863//NewsView/News?NewsSeq=121")

    @discardableResult
    func RouteWithUrl(_ url: URL) -> Bool {
      return true
    }
    
}
