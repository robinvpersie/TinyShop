//
//  YCIndicator.swift
//  Portal
//
//  Created by PENG LIN on 2017/6/22.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation

public enum YCIndicatorType{
    case none
    case activity
    case custom(indicator:YCIndicator)
}

public protocol YCIndicator {
    func startAnimating()
    func stopAnimating()
    var viewCenter:CGPoint { get set }
    var view:UIView { get }
    var hiddenWhenStoped:Bool { get set }
}

extension YCIndicator {
    public var viewCenter:CGPoint {
        get {
          return view.center
        }
        set {
          view.center = newValue
        }
    }
}

struct YCActivityIndicator:YCIndicator {
    private let activityView: UIActivityIndicatorView
    var hiddenWhenStoped:Bool = true
    var view: UIView{
      return activityView
    }
    func startAnimating() {
        activityView.startAnimating()
    }
    func stopAnimating() {
        activityView.stopAnimating()
        if hiddenWhenStoped {
          activityView.isHidden = true
        }
    }
    init() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
    }
}
