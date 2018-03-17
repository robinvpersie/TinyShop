//
//  AroundMapController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import SwiftLocation

class AroundMapController: UIViewController {
    
    var mapView: MKMapView!

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
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
            UIView.animate(withDuration: 0.3,
                           delay: 0.2,
                           usingSpringWithDamping: 0,
                           initialSpringVelocity: 0,
                           options: UIViewAnimationOptions.transitionCrossDissolve,
                           animations: {
                              self?.mapView.setRegion(coordinateRegion, animated: true)
                            },
                           completion: nil)
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

        mapView = MKMapView()
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    @objc func didSearch() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AroundMapController: MKMapViewDelegate {
    
    
    
}
