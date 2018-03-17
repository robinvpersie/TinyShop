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
    var artworks = [Artwork]()
    lazy var shopDetailView = ShopInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Locator.requestAuthorizationIfNeeded(.whenInUse)
        makeUI()
        loadInitialData()
        location()
    }
    
    func location() {
        Locator.currentPosition(accuracy: .room,
                                onSuccess:
        { [weak self] location in
            let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 1000, 1000)
            self?.mapView.setRegion(coordinateRegion, animated: false)
            self?.mapView.addAnnotations(self!.artworks)
//            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
//            UIView.animate(withDuration: 0.3,
//                           delay: 0.2,
//                           usingSpringWithDamping: 0,
//                           initialSpringVelocity: 0,
//                           options: UIViewAnimationOptions.transitionCrossDissolve,
//                           animations: {
//                              self?.mapView.setRegion(coordinateRegion, animated: true)
//                            },
//                           completion: nil)
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
        if #available(iOS 11.0, *) {
            mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
//            mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.leading.trailing.bottom.equalTo(view)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didUnitTap))
        tap.delegate = self
        mapView.addGestureRecognizer(tap)
    }
    
    @objc func didUnitTap() {
        shopDetailView.hide()
    }
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json") else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard let data = optionalData,
        let json = try? JSONSerialization.jsonObject(with: data),
        let dictionary = json as? [String : Any],
        let works = dictionary["data"] as? [[Any]] else { return }
        let validWorks = works.flatMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
    @objc func didSearch() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AroundMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ArtworkView
        dequeuedView?.annotation = annotation
        return dequeuedView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        shopDetailView.showInView(self.view)
    }
    
}

extension AroundMapController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
  
    
}
