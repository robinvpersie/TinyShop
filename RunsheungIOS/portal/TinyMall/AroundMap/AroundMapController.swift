//
//  AroundMapController.swift
//  Portal
//
//  Created by 이정구 on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import SwiftLocation


class AroundMapController: UIViewController {
    
    var mapView: MKMapView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        location()

    }
    

    func makeUI() {
        
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(yc_back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkText
        
        mapView = MKMapView()
        mapView.userTrackingMode = .followWithHeading
        mapView.mapType = .standard
        mapView.showsTraffic = false
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    
    }
    
    func location() {
        Locator.subscribeSignificantLocations(onUpdate: { [weak self] location in
            guard let this = self else { return }
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0)
            MKMapView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                this.mapView.setRegion(region, animated: true)
            }, completion: { finish in
                if finish {
                    
                }
            })
        }) { error, location in
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
}

extension AroundMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        
    }
    
}







