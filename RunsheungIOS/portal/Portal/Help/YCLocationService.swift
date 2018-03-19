//
//  YCLocationService.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/30.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import CoreLocation

class YCLocationService: NSObject {
    
    typealias locationSuccess = ((CLLocation) -> Void)
    typealias locationFailure = ((Error) -> Void)
    
    static let sharedManager = YCLocationService()
    
    @objc (turnOn)
    class func turnOn() {
        if ( CLLocationManager.locationServicesEnabled()) {
            self.sharedManager.locationManager.startUpdatingLocation()
        }
    }
    
    @objc (turnOff)
    class func turnOff() {
        self.sharedManager.locationManager.stopUpdatingLocation()
    }
    
    @objc (singleUpdate:failure:)
    class func singleUpdate(_ success: locationSuccess?, failure: locationFailure?) {
        if (CLLocationManager.locationServicesEnabled()) {
          self.sharedManager.locationManager.requestLocation()
          self.sharedManager.afterUpdatedLocationAction = success
          self.sharedManager.locationFail = failure
        }
    }
    
    var afterUpdatedLocationAction: locationSuccess?
    var locationFail: locationFailure?
    

//    var address:String?
//    var geocoder = CLGeocoder()
    
//    func reverseGecodeLocation(_ location:CLLocation,finish:((_ address:String)->Void)? = nil){
//        currentLocation = location
//        geocoder.reverseGeocodeLocation(location, completionHandler:{ (placemarks , error) in
//            if let error = error {
//               print(error.localizedDescription)
//            }else {
//                if let placemarks = placemarks,let firstPlacemark = placemarks.first {
//                       self.address = firstPlacemark.locality ?? (firstPlacemark.name ?? firstPlacemark.country)
//                       YCUserDefaults.locationAddress.value = self.address
//                       finish?(self.address!)
//                }
//            }
//        })
//     }
    
//

    
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()

}

extension YCLocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newlocation = locations.last else {
            return
        }
        afterUpdatedLocationAction?(newlocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationFail?(error)
    }

}



















