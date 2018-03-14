//
//  BaseProtocol.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit

public final class YCBox<Base> {
    public let Base: Base
    public init(_ base: Base) {
        self.Base = base
    }
}

public protocol YCBaseCompatible{
      associatedtype BaseType
      var yc: BaseType {get}
}

public extension YCBaseCompatible{
    public var yc: YCBox<Self>{
        get {
            return YCBox(self)
        }
    }
}

extension UIImageView:YCBaseCompatible{}
extension UIImage:YCBaseCompatible{}





