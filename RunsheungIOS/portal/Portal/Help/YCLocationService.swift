//
//  YCLocationService.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/30.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftDate
import SwiftyJSON

final class YCLocationService:NSObject,CLLocationManagerDelegate{
    
    static let sharedManager = YCLocationService()
    
    class func turnOn(){
        if (CLLocationManager.locationServicesEnabled()){
            self.sharedManager.locationManager.startUpdatingLocation()
        }
    }
    
    class func turnoff(){
        self.sharedManager.locationManager.stopUpdatingLocation()
    }
    
    class func singleUpdate(_ success:((CLLocation)->Void)? = nil,_ failure:((Error)->Void)? = nil) {
        if (CLLocationManager.locationServicesEnabled()){
          self.sharedManager.locationManager.requestLocation()
          self.sharedManager.afterUpdatedLocationAction = success
          self.sharedManager.locationFail = failure
        }
    }
    
    var afterUpdatedLocationAction:((CLLocation) -> Void)?
    var locationFail:((Error) -> Void)?
    
    var currentLocation:CLLocation?{
        didSet{
        if let currentLocation = currentLocation{
            YCUserDefaults.userCoordinateLatitude.value = currentLocation.coordinate.latitude
            YCUserDefaults.userCoordinateLongtitude.value = currentLocation.coordinate.longitude
         }
       }
    }
    var address:String?
    var geocoder = CLGeocoder()
    
    func reverseGecodeLocation(_ location:CLLocation,finish:((_ address:String)->Void)? = nil){
        currentLocation = location
        geocoder.reverseGeocodeLocation(location, completionHandler:{ (placemarks , error) in
            if let error = error {
               print(error.localizedDescription)
            }else {
                if let placemarks = placemarks,let firstPlacemark = placemarks.first {
                       self.address = firstPlacemark.locality ?? (firstPlacemark.name ?? firstPlacemark.country)
                       YCUserDefaults.locationAddress.value = self.address
                       finish?(self.address!)
                }
            }
        })
     }
    
    func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation]){
        guard let newlocation = locations.last else { return }
        afterUpdatedLocationAction?(newlocation)
        reverseGecodeLocation(newlocation,finish:{ address in
            NotificationCenter.default.post(name: Notification.Name.addressUpdate, object: address)
         })
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationFail?(error)
        NotificationCenter.default.post(name: Notification.Name.addressUpdateFail, object: nil)
    }
    
    
    lazy var locationManager:CLLocationManager = {
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




class YCUpdateAddress:NSObject{
    
    static let shareManager = YCUpdateAddress()
    
    private override init() {
        super.init()
        timer.fire()
    }
    
    lazy var timer:Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(startLocation), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        return timer
    }()
    
    func startLocation(){
        if let lastUpdate =  YCUserDefaults.lastUpdateDate.value {
            if Calendar.current.isDate(Date(), inSameDayAs: lastUpdate) {
                 timer.invalidate()
            }else {
               YCLocationService.singleUpdate()
            }
        }else {
               YCLocationService.singleUpdate()
        }
      YCLocationService.sharedManager.afterUpdatedLocationAction = { location in
         self.beginUpdateToSorber(lonA: location.coordinate.longitude, latA: location.coordinate.latitude, failureHandler: { reason , errormessage in
          }, completion: {  jsonData in
            let json = JSON(jsonData!)
            if let status = json["status"].int, status == 1 {
                  YCUserDefaults.lastUpdateDate.value = Date()
                  self.timer.invalidate()
            }
        })
      }
    }
}

extension YCUpdateAddress{
    
    func beginUpdateToSorber(lonA:Double,latA:Double,failureHandler:FailureHandler?,completion:@escaping (JSONDictionary?) -> Void){
        
        let parse:(JSONDictionary) -> JSONDictionary = { json in
              return json
        }
        guard let memid = YCAccountModel.getAccount()?.memid else { return }
        let requestParameters: [String:Any] = [
            "memid":memid,
            "LonA":lonA,
            "LatA":latA
        ]
        let resource = AlmofireResource(Type: .PortalAddress,
                                        path: "/api/pl_CheckGeoFenceActivity",
                                        method: .post,
                                        requestParameters: requestParameters,
                                        parse: parse)
        AlamofireRequest(resource: resource, failure: failureHandler, completion: completion)
    }
}












