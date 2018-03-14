//
//  PlayDelegate.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PlayerControllerViewDelegate:class {
    @objc optional func controlView(_ controlView:UIView,backAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,closeAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,playAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,fullScreenAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,lockScreenAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,repeatPlayAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,centerPlayAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,failAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,downloadVideoAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,resolutionAction:UIButton)
    @objc optional func controlView(_ controlView:UIView,progressSliderTap:CGFloat)
    @objc optional func controlView(_ controlView:UIView,progressSliderTouchBegan:UISlider)
    @objc optional func controlView(_ controlView:UIView,progressSliderValueChanged:UISlider)
    @objc optional func controlView(_ controlView:UIView,progressSliderTouchEnded:UISlider)
}
