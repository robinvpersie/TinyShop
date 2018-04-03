//
//  BaseProtocol.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit

final class YCBox<Base> {
    let Base: Base
    init(_ base: Base) {
        self.Base = base
    }
}

protocol YCBaseCompatible{
    associatedtype BaseType
    var yc: BaseType { get }
}

extension YCBaseCompatible {
    var yc: YCBox<Self>{
        get {
            return YCBox(self)
        }
    }
}

extension UIImageView: YCBaseCompatible{ }
extension UIImage: YCBaseCompatible{ }





