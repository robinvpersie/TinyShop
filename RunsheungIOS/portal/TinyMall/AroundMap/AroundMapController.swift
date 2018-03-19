//
//  AroundMapController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import SwiftLocation


let UserPOIflagTypeDefault: NMapPOIflagType = NMapPOIflagTypeReserved + 1
let UserPOIflagTypeInvisible: NMapPOIflagType = NMapPOIflagTypeReserved + 2

class AroundMapController: UIViewController {
    
    var mapView: NMapView?
    var artworks = [Artwork]()
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
        
        Locator.requestAuthorizationIfNeeded(.whenInUse)
        makeUI()
        
        location()
    }
    
    func location() {
        Locator.currentPosition(accuracy: .room,
                                onSuccess:
        { [weak self] location in
//            let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 1000, 1000)
//            self?.mapView.setRegion(coordinateRegion, animated: false)
//            self?.mapView.addAnnotations(self!.artworks)

        }) { [weak self] error, location in
            self?.showMessage(error.localizedDescription)
        }
    }
    
    func makeUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(yc_back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_search")?.withRenderingMode(.alwaysOriginal),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSearch))
        
        mapView = NMapView(frame: .zero)
        if let mapView = mapView {
            mapView.setClientId("DDs0cS8ZfU_oVMqjWJd6")
            mapView.delegate = self
            view.addSubview(mapView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didUnitTap))
            tap.delegate = self
            mapView.addGestureRecognizer(tap)
        }
        
       
    }
    
    func showMarkers() {
        if let mapOverlayManager = mapView?.mapOverlayManager,
            let poiDataOverlay = mapOverlayManager.newPOIdataOverlay()
        {
            poiDataOverlay.initPOIdata(3)
            poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.979, latitude: 37.567), title: nil, type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
        }
    }
    
    
    
    @objc func didUnitTap() {
        shopDetailView.hide()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            mapView?.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            mapView?.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: view.frame.height)
        }
    }
    
    @objc func didSearch() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
    }
    
}


extension AroundMapController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
