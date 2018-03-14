//
//  YCFPSLabel.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

final class YCFPSLabel: UILabel {
    private var displayLink: CADisplayLink?
    private var lastTime: TimeInterval = 0
    private var count: Int = 0
    deinit {
        displayLink?.invalidate()
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame = CGRect(x: 15, y: 150, width: 40, height: 40)
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = UIColor.black
        textColor = UIColor.green
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 24)
        run()
    }
    
    func run() {
        displayLink = CADisplayLink(target: self, selector: #selector(YCFPSLabel.tick(displayLink:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc func tick(displayLink: CADisplayLink) {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
            return
        }
        count += 1
        let timeDelta = displayLink.timestamp - lastTime
        if timeDelta < 0.25 {
            return
        }
        lastTime = displayLink.timestamp
        let fps: Double = Double(count) / timeDelta
        count = 0
        text = String(format: "%.0f", fps)
        textColor = fps > 50 ? UIColor.green : UIColor.red
    }

}
