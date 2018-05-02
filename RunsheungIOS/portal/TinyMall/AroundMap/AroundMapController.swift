//
//  AroundMapController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
//import SwiftLocation


let UserPOIflagTypeDefault: NMapPOIflagType = NMapPOIflagTypeReserved + 1
let UserPOIflagTypeInvisible: NMapPOIflagType = NMapPOIflagTypeReserved + 2

class AroundMapController: UIViewController {
    
    var mapView: NMapView?
    var topBtn: UIButton!
    enum State {
        case kDisabled
        case kTracking
        case kTrackingWithHeading
    }
    var currentState: State = .kDisabled
    
    lazy var shopDetailView = ShopInfoView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.viewDidDisappear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        Locator.requestAuthorizationIfNeeded(.whenInUse)
        makeUI()
        enableLocationUpdate()
        
//        location()
    }
    
//    func location() {
//        Locator.currentPosition(accuracy: .room,
//                                onSuccess:
//        { [weak self] location in
//            let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 1000, 1000)
//            self?.mapView.setRegion(coordinateRegion, animated: false)
//            self?.mapView.addAnnotations(self!.artworks)

//        }) { [weak self] error, location in
//            self?.showMessage(error.localizedDescription)
//        }
//    }
    
    func makeUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(yc_back))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_search")?.withRenderingMode(.alwaysOriginal),
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(didSearch))
        
        mapView = NMapView(frame: .zero)
        if let mapView = mapView {
            mapView.setClientId("DDs0cS8ZfU_oVMqjWJd6")
            mapView.delegate = self
            view.addSubview(mapView)
        }
        
        let container = UIView()
        container.backgroundColor = UIColor.white
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.height.equalTo(100)
        }
        
        topBtn = UIButton(type: .custom)
        topBtn.addTarget(self, action: #selector(didTop), for: .touchUpInside)
        topBtn.setTitleColor(UIColor.darkText, for: .normal)
        topBtn.backgroundColor = UIColor.white
        topBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        topBtn.setTitle("현재위치 표시 현재 위치의 주소 노출", for: .normal)
        container.addSubview(topBtn)
        topBtn.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(container)
            make.height.equalTo(40)
        }
        
        let searchAddressBtn = UIButton(type: .custom)
        searchAddressBtn.addTarget(self, action: #selector(searchAddress), for: .touchUpInside)
        searchAddressBtn.setTitleColor(UIColor.white, for: .normal)
        searchAddressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchAddressBtn.setTitle("주소검색 ", for: .normal)
        searchAddressBtn.backgroundColor = UIColor(hex: 0x22c67b)
        container.addSubview(searchAddressBtn)
        searchAddressBtn.snp.makeConstraints { (make) in
            make.top.equalTo(topBtn.snp.bottom).offset(10)
            make.centerX.equalTo(topBtn)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
//        let searchAreaBtn = UIButton(type: .custom)
//        searchAreaBtn.addTarget(self, action: #selector(searchArea), for: .touchUpInside)
//        searchAreaBtn.setTitleColor(UIColor.white, for: .normal)
//        searchAreaBtn.setTitle("지역검색", for: .normal)
//        searchAreaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        searchAreaBtn.backgroundColor = UIColor(hex: 0x53c9d7)
        
//        let stackView = UIStackView(arrangedSubviews: [searchAddressBtn, searchAreaBtn])
//        stackView.axis = .horizontal
//        stackView.spacing = 100
//        stackView.distribution = .fillEqually
//        container.addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.top.equalTo(topBtn.snp.bottom).offset(10)
//            make.leading.equalTo(container).offset(30)
//            make.trailing.equalTo(container).offset(-30)
//            make.height.equalTo(40)
//        }
    }
    
    @objc func didTop() {
        
    }
    
    @objc func searchAddress() {
        let searchList = SearchListController()
        navigationController?.pushViewController(searchList, animated: true)
    }
    
    @objc func searchArea() {
        let allAddress = AllAddressController()
        navigationController?.pushViewController(allAddress, animated: true)
    }
    
    func showMarkers() {
//        if let mapOverlayManager = mapView?.mapOverlayManager,
//            let poiDataOverlay = mapOverlayManager.newPOIdataOverlay()
//        {
//            poiDataOverlay.initPOIdata(3)
//            poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.979, latitude: 37.567), title: nil, type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
//        }
    }
    
    
    func stopLocationUpdating() {
        disableHeading()
        disableLocationUpdate()
    }
    
    func enableLocationUpdate() {
        let lm = NMapLocationManager.getSharedInstance()
        if lm?.locationServiceEnabled() == false {
            locationManager(lm, didFailWithError: NMapLocationManagerErrorType.denied)
            return
        }
        if lm?.isUpdateLocationStarted() == false {
            lm?.setDelegate(self)
            lm?.startContinuousLocationInfo()
        }
        
    }
    
    func disableLocationUpdate() {
        let lm = NMapLocationManager.getSharedInstance()
        if lm?.isUpdateLocationStarted() == true  {
            lm?.stopUpdateLocationInfo()
            lm?.setDelegate(nil)
        }
        mapView?.mapOverlayManager.clearOverlays()
    }
    
    func enableHeading() -> Bool {
        let lm = NMapLocationManager.getSharedInstance()
        if lm?.headingAvailable() == true {
            mapView?.setAutoRotateEnabled(true, animate: true)
            lm?.startUpdatingHeading()
        }else {
            return false
        }
        return true
    }
    
    func disableHeading() {
        let lm = NMapLocationManager.getSharedInstance()
        if lm?.headingAvailable() == true {
            lm?.stopUpdatingHeading()
        }
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    func setCompassHeadingValue(_ headingValue: Float) {
        if mapView?.isAutoRotateEnabled == true {
            mapView?.setRotateAngle(headingValue, animate: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width != view.frame.width {
            if mapView?.isAutoRotateEnabled == true {
                mapView?.setAutoRotateEnabled(false, animate: false)
                coordinator.animate(alongsideTransition: { [weak self] (context) in
                    self?.mapView?.setAutoRotateEnabled(true, animate: true)
                    }, completion: nil)
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if view.traitCollection.horizontalSizeClass != newCollection.horizontalSizeClass || view.traitCollection.verticalSizeClass != newCollection.verticalSizeClass {
            if mapView?.isAutoRotateEnabled == true {
                mapView?.setAutoRotateEnabled(false, animate: false)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if view.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass || view.traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass {
            if currentState == .kTrackingWithHeading {
                mapView?.setAutoRotateEnabled(true, animate: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            let y = view.safeAreaLayoutGuide.layoutFrame.minY + 100
            let rect = CGRect(x: 0, y: y , width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.maxY - y)
            mapView?.frame = rect
        } else {
            mapView?.frame = CGRect(x: 0, y: topLayoutGuide.length + 40, width: view.frame.width, height: view.frame.height - topLayoutGuide.length - bottomLayoutGuide.length)
        }
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
    }
    
}




extension AroundMapController: NMapViewDelegate {
    
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if error == nil {
            mapView.setMapCenter(NGeoPoint(longitude: 126.978371, latitude: 37.5666091), atLevel: 11)
            mapView.setMapEnlarged(true, mapHD: true)
            mapView.mapViewMode = .vector
        }
    }
    
    func onMapView(_ mapView: NMapView!, handleSingleTapGesture recogniser: UIGestureRecognizer!) {
        shopDetailView.hide()
    }
    
    
}

extension AroundMapController: NMapPOIdataOverlayDelegate {
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return UIImage(named: "icon_destination2")
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0.5, y: 0.0)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0.5, y: 0.0)
    }
    
    
}

extension AroundMapController: NMapLocationManagerDelegate {
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        let coordinate = location.coordinate
        let mylocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = location.horizontalAccuracy
        mapView?.mapOverlayManager.setMyLocation(mylocation, locationAccuracy: Float(locationAccuracy))
        mapView?.setMapCenter(mylocation)
        
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        var message: String?
        switch errorType {
        case .unknown, .canceled, .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시 할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다"
        }
        
        if message != nil {
            print(message!)
        }
        
        if mapView?.isAutoRotateEnabled == true {
            mapView?.setAutoRotateEnabled(false, animate: true)
        }
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        let headingValue: Double = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(Float(headingValue))
    }
    
}

