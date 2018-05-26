//
//  Configuration.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

public struct PMKConfiguration {
    public var Q: (map: DispatchQueue?, return: DispatchQueue?) = (map: DispatchQueue.main, return: DispatchQueue.main)
    public var catchPolicy = CatchPolicy.allErrorsExceptCancellation
}

public var conf = PMKConfiguration()
