//
//  ArtworkView.swift
//  Portal
//
//  Created by 이정구 on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import MapKit

class ArtworkView: MKAnnotationView {
    
//    override var annotation: MKAnnotation? {
//        willSet {
//           
//            canShowCallout = false
//            image = UIImage(named: "icon_destination")
//        }
//    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = false
        image = UIImage(named: "icon_destination2")?.withRenderingMode(.alwaysOriginal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
