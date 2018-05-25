//
//  SelectModel.swift
//  Portal
//
//  Created by 이정구 on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

struct SelectModel: Hashable {
    var indexPath: IndexPath
    var itemCode: String
    
    init(indexPath: IndexPath, itemCode: String) {
        self.indexPath = indexPath
        self.itemCode = itemCode
    }
}
