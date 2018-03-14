//
//  PlayControlView.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

fileprivate let PlayerAnimationTimeInterval:CGFloat = 7
fileprivate let PlayerControlBarAutoFadeOutTimeInterval = 0.35

class PlayControlView: UIView,UIGestureRecognizerDelegate {
    
    weak var delegate:PlayerControllerViewDelegate?
    
    private lazy var titleLabel:UILabel = {
         let title = UILabel()
         title.textColor = UIColor.white
         title.font = UIFont.systemFont(ofSize: 15)
         return title
    }()
    
    private lazy var starBtn:UIButton = {
         let star = UIButton(type: .custom)
         star.setImage(UIImage(named: "ZFPlayer_play"), for: .normal)
         star.setImage(UIImage(named:"ZFPlayer_pause"), for: .selected)
         star.addTarget(self, action: #selector(playBtnClick(sender:)), for: .touchUpInside)
         return star
    }()
    
    private lazy var currentTimelabel:UILabel = {
        let current = UILabel()
        current.textColor = UIColor.white
        current.font = UIFont.systemFont(ofSize: 12)
        current.textAlignment = .center
        return current
    }()
    
    private lazy var totalTimelabel:UILabel = {
        let total = UILabel()
        total.textColor = UIColor.white
        total.font = UIFont.systemFont(ofSize: 12)
        total.textAlignment = .center
        return total
    }()
    
    private lazy var progressview:UIProgressView = {
         let progress = UIProgressView(progressViewStyle: .default)
         progress.progressTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
         progress.trackTintColor = UIColor.clear
         return progress
    }()
    
    private lazy var videoSlider:ASValueTrackingSlider = {
        
        let silder = ASValueTrackingSlider()
        silder.popUpViewCornerRadius = 0
        silder.popUpViewColor = UIColor(red: 19/255, green: 19/255, blue: 9/255, alpha: 1)
        silder.popUpViewArrowLength = 8
        silder.setThumbImage(UIImage(named: "ZFPlayer_slider"), for: .normal)
        silder.maximumValue = 1
        silder.minimumTrackTintColor = UIColor.white
        silder.maximumTrackTintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        silder.addTarget(self, action: #selector(progressSliderTouchBegan(_:)), for: .touchDown)
        silder.addTarget(self, action: #selector(progressSliderTouchValueChanged(_:)), for: .valueChanged)
        silder.addTarget(self, action: #selector(progressSliderTouchEnded(_:)), for: [.touchUpInside,.touchCancel,.touchUpOutside])
        let sliderTap = UITapGestureRecognizer(target: self, action: #selector(tapsliderAction(_:)))
        silder.addGestureRecognizer(sliderTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer(_:)))
        pan.delegate = self
        pan.maximumNumberOfTouches = 1
        pan.delaysTouchesBegan = true
        pan.delaysTouchesEnded = true
        pan.cancelsTouchesInView = true
        silder.addGestureRecognizer(pan)
        
        return silder
    }()
    
    
    private lazy var fullscreenBtn:UIButton = {
        let full = UIButton(type: .custom)
        full.setImage(UIImage(named: "ZFPlayer_fullscreen"), for: .normal)
        full.setImage(UIImage(named: "ZFPlayer_shrinkscreen"), for: .selected)
        full.addTarget(self, action:#selector(fullScreenBtnClick(_:)), for: .touchUpInside)
        return full
    }()
    
    
    private lazy var lockBtn:UIButton = {
        let lock = UIButton(type: .custom)
        lock.setImage(UIImage(named:""), for: .normal)
        lock.setImage(UIImage(named:""), for: .selected)
        lock.addTarget(self, action: #selector(lockScreenBtnClick(_:)), for: .touchUpInside)
        return lock
    }()
    
    
    private lazy var activity:MMMaterialDesignSpinner = {
        let activity = MMMaterialDesignSpinner()
        activity.lineWidth = 1
        activity.duration = 2
        activity.tintColor = UIColor.white
        return activity
    }()
    
    private lazy var backbtn:UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named:""), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(_:)), for: .touchUpInside)
        return backBtn
    }()
    
    
    private lazy var closebtn:UIButton = {
        let close = UIButton(type: .custom)
        close.setImage(UIImage(named: "ZFPlayer_close"), for: .normal)
        close.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        return close
    }()
    
    
    private lazy var repeatbtn:UIButton = {
        let repeatbtn = UIButton(type: .custom)
        repeatbtn.setImage(UIImage(named: "ZFPlayer_repeat_video"), for: .normal)
        repeatbtn.addTarget(self, action: #selector(repeateBtnClick(_:)), for: .touchUpInside)
        return repeatbtn
    }()
    
    
    private lazy var bottomImageView:UIImageView = {
          let bottom = UIImageView()
          bottom.isUserInteractionEnabled = true
          bottom.image = UIImage(named: "ZFPlayer_bottom_shadow")
          return bottom
    }()
    
    private lazy var topImageView:UIImageView = {
         let topimageview = UIImageView()
         topimageview.isUserInteractionEnabled = true
         topimageview.image = UIImage(named: "ZFPlayer_top_shadow")
         return topimageview
    }()
    
    private lazy var downloadBtn:UIButton = {
         let download = UIButton(type: .custom)
         download.setImage(UIImage(named: "ZFPlayer_download"), for: .normal)
         download.setImage(UIImage(named: "ZFPlayer_not_download"), for: .disabled)
         download.addTarget(self, action: #selector(downloadBtnClick(_:)), for: .touchUpInside)
         return download
    }()
    
    
    private lazy var resolutionBtn:UIButton = {
        let resolution = UIButton(type: .custom)
        resolution.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        resolution.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        resolution.addTarget(self, action: #selector(resolutionBtnClick(_:)), for: .touchUpInside)
        return resolution
    }()
    
    
    private lazy var playBtn:UIButton = {
       let play = UIButton(type: .custom)
       play.setImage(UIImage(named: "ZFPlayer_play_btn"), for: .normal)
       play.addTarget(self, action: #selector(centerPlayBtnClick(_:)), for: .touchUpInside)
       return play
    }()
    
    
    private lazy var failBtn:UIButton = {
        let fail = UIButton(type: .custom)
        fail.setTitle("加载失败，点击重试", for: .normal)
        fail.setTitleColor(UIColor.white, for: .normal)
        fail.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        fail.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        fail.addTarget(self, action: #selector(failBtnClick(_:)), for: .touchUpInside)
        return fail
    }()
    
    
    private lazy var fastView:UIView = {
        let fast = UIView()
        fast.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        fast.layer.cornerRadius = 4
        fast.layer.masksToBounds = true
        return fast
    }()
    
    private lazy var fastProgressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.white
        let color = UIColor.lightGray.withAlphaComponent(0.4)
        progress.trackTintColor = color
        return progress
    }()
    
    private lazy var fastTimeLabel:UILabel = {
        let fasttime = UILabel()
        fasttime.textColor = UIColor.white
        fasttime.textAlignment = .center
        fasttime.font = UIFont.systemFont(ofSize: 14)
        return fasttime
    }()
    
    private lazy var fastImageView:UIImageView = {
        let fast = UIImageView()
        return fast
    }()
    
    private var resoultionCurrentBtn:UIButton!
    
    private lazy var placeholderImageView:UIImageView = {
       let placeHolder = UIImageView()
       placeHolder.isUserInteractionEnabled = true
       return placeHolder
    }()
    
    private lazy var bottomProgressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.white
        progress.trackTintColor = UIColor.clear
        return progress
    }()
    
    private var resolutionArray = [UIView]()
    private var showing:Bool = false
    private var shrink:Bool = false
    private var cellVideo:Bool = false
    private var dragged:Bool = false
    private var playeEnd:Bool = false
    private var fullScreen:Bool = false
    
    
    convenience init() {
      self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(placeholderImageView)
        addSubview(topImageView)
        addSubview(bottomImageView)
        bottomImageView.addSubview(starBtn)
        bottomImageView.addSubview(currentTimelabel)
        bottomImageView.addSubview(progressview)
        bottomImageView.addSubview(videoSlider)
        bottomImageView.addSubview(fullscreenBtn)
        bottomImageView.addSubview(totalTimelabel)
        
        topImageView.addSubview(downloadBtn)
        addSubview(lockBtn)
        topImageView.addSubview(backbtn)
        addSubview(activity)
        addSubview(repeatbtn)
        addSubview(playBtn)
        addSubview(failBtn)
        addSubview(fastView)
        fastView.addSubview(fastImageView)
        fastView.addSubview(fastTimeLabel)
        fastView.addSubview(fastProgressView)
        
        topImageView.addSubview(resolutionBtn)
        topImageView.addSubview(titleLabel)
        
        addSubview(closebtn)
        addSubview(bottomProgressView)
        
        makeConstraint()
        
        downloadBtn.isHidden = true
        resolutionBtn.isHidden = true
        
        playerResetControlView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterPlayground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        listeningRotating()
        deviceOrientationChange()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    private func listeningRotating(){
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    @objc private func deviceOrientationChange(){
        if BrightnessView.share.isLockScreen { return }
        lockBtn.isHidden = !fullScreen
        fullscreenBtn.isSelected = fullScreen
        let orientation = UIDevice.current.orientation
        if orientation == .faceUp || orientation == .faceDown || orientation == .unknown || orientation == .portraitUpsideDown {  return  }
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
           
        }else {
         
        }
        self.layoutIfNeeded()
    }
    
    @objc private func failBtnClick(_ sender:UIButton){
        
    }

    
    @objc private func playBtnClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        delegate?.controlView?(self, playAction: sender)
    }

    @objc private func fullScreenBtnClick(_ sender:UIButton){
        
    }
    
    @objc private func downloadBtnClick(_ sender:UIButton){
        
    }

    @objc private func appEnterBackground(){
        
    }
    
    @objc private func appEnterPlayground(){
    
    }
    
    @objc private func centerPlayBtnClick(_ sender:UIButton){
        
    }
    
    @objc private func repeateBtnClick(_ sender:UIButton){
        
    }

    @objc private func closeBtnClick(_ sender:UIButton){
        
    }
    
    @objc private func lockScreenBtnClick(_ sender:UIButton){
        
    }
    
    @objc private func backBtnClick(_ sender:UIButton){
        
    }

    @objc private func resolutionBtnClick(_ sender:UIButton){
        
    }
    
    @objc private func panRecognizer(_ gesture:UIPanGestureRecognizer){
        
    }
    
    @objc private func tapsliderAction(_ gesture:UITapGestureRecognizer){
        
    }
    
    @objc private func progressSliderTouchEnded(_ slider:ASValueTrackingSlider){
        
    }
    
    @objc private func progressSliderTouchValueChanged(_ slider:ASValueTrackingSlider){
        
    }
    
    @objc private func progressSliderTouchBegan(_ slider:ASValueTrackingSlider) {
        
    }


    private func playerResetControlView(){
        
        activity.stopAnimating()
        videoSlider.value = 0
        bottomProgressView.progress = 0
        progressview.progress = 0
        currentTimelabel.text = "00:00"
        totalTimelabel.text = "00:00"
        fastView.isHidden = true
        repeatbtn.isHidden = true
        playBtn.isHidden = true
        failBtn.isHidden = true
        backgroundColor = UIColor.clear
        downloadBtn.isEnabled = true
        shrink = false
        showing = false
        playeEnd = false
        lockBtn.isHidden = !fullScreen
        failBtn.isHidden = true
        placeholderImageView.alpha = 1
    }
    
    private func makeConstraint(){
        
        placeholderImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        closebtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(7)
            make.top.equalTo(self).offset(7)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        topImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(50)
        }
        
        backbtn.snp.makeConstraints { (make) in
            make.leading.equalTo(topImageView).offset(10)
            make.top.equalTo(topImageView).offset(7)
            make.width.height.equalTo(30)
        }
        
        downloadBtn.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(49)
            make.trailing.equalTo(topImageView).offset(-10)
            make.centerY.equalTo(backbtn)
        }
        
        resolutionBtn.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(25)
            make.trailing.equalTo(downloadBtn.snp.leading).offset(-10)
            make.centerY.equalTo(backbtn)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(backbtn.snp.trailing).offset(5)
            make.centerY.equalTo(backbtn)
            make.trailing.equalTo(resolutionBtn.snp.leading).offset(-10)
        }
        
        bottomImageView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        
        starBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(bottomImageView).offset(5)
            make.bottom.equalTo(bottomImageView).offset(-5)
            make.width.height.equalTo(30)
        }
        
        currentTimelabel.snp.makeConstraints { (make) in
            make.leading.equalTo(starBtn.snp.trailing).offset(-3)
            make.centerY.equalTo(starBtn)
            make.width.equalTo(43)
        }
        
        fullscreenBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.trailing.equalTo(bottomImageView).offset(-5)
            make.centerY.equalTo(starBtn)
        }
        
        totalTimelabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(fullscreenBtn.snp.leading).offset(3)
            make.centerY.equalTo(starBtn)
            make.width.equalTo(43)
        }
        
        progressview.snp.makeConstraints { (make) in
            make.leading.equalTo(currentTimelabel.snp.trailing).offset(4)
            make.trailing.equalTo(totalTimelabel.snp.leading).offset(-4)
            make.centerY.equalTo(starBtn)
        }
        
        videoSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(currentTimelabel.snp.trailing).offset(4)
            make.trailing.equalTo(totalTimelabel.snp.leading).offset(-4)
            make.centerY.equalTo(currentTimelabel).offset(-1)
            make.height.equalTo(30)
        }
        
        lockBtn.snp.makeConstraints { (make) in
            make.leading.centerY.equalTo(self)
            make.width.height.equalTo(32)
        }
        
        repeatbtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        playBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        }
        
        activity.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(130)
            make.height.equalTo(33)
        }
        
        failBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(130)
            make.height.equalTo(33)
        }
        
        fastView.snp.makeConstraints { (make) in
            make.width.equalTo(125)
            make.height.equalTo(80)
            make.center.equalTo(self)
        }
        
        fastImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(32)
            make.top.equalTo(fastView).offset(5)
            make.centerX.equalTo(fastView)
        }
        
        fastTimeLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(fastView)
            make.top.equalTo(fastImageView.snp.bottom).offset(2)
        }
        
        fastProgressView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(fastTimeLabel.snp.bottom).offset(10)
        }
        
        bottomProgressView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
