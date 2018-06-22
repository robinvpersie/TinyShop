//
//  Ruler.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit


private enum ScreenMode{
    case classic
    case bigger
    case biggerPlus
    case x
    ////iphonex width 375 height 812
}

private let screenModel: ScreenMode = {
    
     let screen = UIScreen.main
     let  nativeWidth = UIScreen.main.nativeBounds.size.width
      switch nativeWidth {
      case 2 * 320:
        return .classic
      case 2 * 375:
        return .bigger
      case 3 * 414,1080:
        return .biggerPlus
      case 3 * 375:
        return .x
      default:
        return .bigger
      }
}()

public enum Ruler<T>{
    case iPhoneHorizontal(T,T,T)
    case iPhoneVertical(T,T,T,T)
    
    public var value: T{
        switch self {
        case .iPhoneHorizontal(let classic,let bigger,let biggerPlus):
            switch screenModel {
            case .classic:
                return classic
            case .bigger:
                return bigger
            case .biggerPlus:
                return biggerPlus
            case .x:
                return bigger
            }
            
        case .iPhoneVertical(let x, let inch4, let bigger, let biggerPlus):
            switch screenModel {
            case .classic:
                return inch4
            case .bigger:
                return bigger
            case .biggerPlus:
                return biggerPlus
            case .x:
                return x
            }
        }
    }
}

















    

    





