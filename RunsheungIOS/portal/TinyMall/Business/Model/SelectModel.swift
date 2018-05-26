//
//  SelectModel.swift
//  Portal
//
//  Created by 이정구 on 2018/5/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation

struct SelectModel: Hashable {
    var itemCode: String
    var name: String
    var itemP: Float
    
    init(itemCode: String, name: String, itemp: Float) {
        self.itemCode = itemCode
        self.name = name
        self.itemP = itemp
    }
}
