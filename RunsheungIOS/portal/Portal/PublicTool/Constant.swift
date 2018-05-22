//
//  Constant.swift
//  Portal
//
//  Created by 이정구 on 2018/4/11.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import RxSwift

public protocol ConstantTarget {
    func translate() -> CGFloat
}

extension CGFloat: ConstantTarget {
    public func translate() -> CGFloat {
        return self
    }
}

extension Int: ConstantTarget {
    public func translate() -> CGFloat {
        return CGFloat(self)
    }
}

public func ratioWidth<T>(_ width: T) -> CGFloat where T: ConstantTarget {
    return width.translate() / 375.0 * screenWidth
}

public func ratioHeight<T>(_ height: T) -> CGFloat where T: ConstantTarget {
    return height.translate() / 667.0 * screenHeight
}

struct Constant {
    
    static let dispose = DisposeBag()
    
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenWidth = UIScreen.main.bounds.size.width
    
}
