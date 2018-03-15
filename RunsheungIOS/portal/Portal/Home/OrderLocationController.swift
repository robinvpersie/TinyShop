//
//  OrderLocationController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/2.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLocation


class OrderLocationController: UIViewController {
    
    typealias locationValueClosure = (_ string: String) -> Void

    enum locationState{
       case location(String)
       case locationSuccess(String)
       case locationFailure(String)
    }
    
   enum Section:Int{
    case header
    case location
    case city
    static let count = 3
    init(section:Int) {
        self.init(rawValue: section)!
    }
    
    init(indexPath:IndexPath){
        self.init(rawValue: indexPath.row)!
    }
    
    }
    //声明一个闭包
    var locationSuccessClosure: locationValueClosure?

    public var locationCityName:locationState = .location("正在定位")
    
    var availableCitys = [availableCity]()
    var orderInfo:OrderdivInfo?
    var currentCity:String?
    var zipCode:String?
    var divName:String?
    var collectionView:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "定位地区"
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkcolor
        view.backgroundColor = UIColor.BaseControllerBackgroundColor
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.BaseControllerBackgroundColor
        collectionView.registerClassOf(OrderLocationCell.self)
        collectionView.registerClassOf(OrderCurrentLocationCell.self)
        collectionView.registerHeaderClassOf(OrderHeaderReusableView.self)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        if let _ = YCUserDefaults.locationAddress.value {
            requestWithLon(lon: YCUserDefaults.userCoordinateLongtitude.value!,
                           lati: YCUserDefaults.userCoordinateLatitude.value!)
        }else {
            location()
        }
     }
    
    func getPlaceMarkWithLocation(_ location:CLLocation){
//        location.getPlacemark(forLocation: location, success: { [weak self] placemark in
//            guard let this = self else { return }
//            if let first = placemark.first,
//                let name = first.locality ?? first.subLocality ?? first.thoroughfare {
//                this.locationCityName = .locationSuccess(name)
//                this.locationSuccessClosure?(name)
//            }
//            this.collectionView.reloadData()
//        }) { [weak self] error in
//            guard let this = self else { return }
//            this.locationCityName = .locationFailure("获取失败")
//            this.collectionView.reloadData()
//        }
    }
    
    
    func location(){
//
//        location().getLocation(accuracy: .city,
//                              frequency: .oneShot,
//                              timeout: 40,
//                              cancelOnError: true,
//                              success:
//        { [weak self] request, location in
//            guard let this = self else { return }
//            this.getPlaceMarkWithLocation(location)
//            this.updateAddress(location)
//       }) { [weak self] (requeset, location, error) in
//            guard let this = self else { return }
//            this.locationCityName = .locationFailure("定位失败")
//            this.collectionView.reloadData()
//        }
    }
    
    
    private func requestWithLon(lon: Double, lati: Double){
        
        OrderLocationModel.GetWithCoordinate(lon: lon, lat: lati,completion: { [weak self] result in
            guard let strongself = self else { return }
            switch result {
            case .success(let json):
                strongself.availableCitys = json.availableCityList
                strongself.orderInfo = json.divInfo
                strongself.currentCity = json.currentCity
                strongself.locationCityName = .locationSuccess(json.currentCity)
            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
            strongself.collectionView.reloadData()
        })
     }
    
    private func updateAddress(_ location:CLLocation){
         let lati = location.coordinate.latitude
         let lon = location.coordinate.longitude
         requestWithLon(lon: lon, lati: lati)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OrderLocationController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let section = Section(indexPath: indexPath)
        switch section {
        case .header:
            return
        case .location:
            guard let _ = orderInfo else { return }
//            let order = OrderChooseMarketController(zipCode:zipCode ?? "", cityName: currentCity ?? "")
//            order.divName = divName ?? ""
//            navigationController?.pushViewController(order, animated: true)
        case .city:
            currentCity = availableCitys[indexPath.row].cityName
            zipCode = availableCitys[indexPath.row].cityZipcode
            locationCityName = .locationSuccess(availableCitys[indexPath.row].cityName)
        }
       
      
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = Section(indexPath: indexPath)
        switch section {
        case .header:
            let cell = cell as! OrderCurrentLocationCell
            if let orderinfo = orderInfo {
                cell.addressText = orderinfo.divName
            }
            cell.clickChangeAction = { [weak self] in
                guard let strongself = self else { return }
//                let order = OrderChooseMarketController(zipCode: strongself.zipCode ?? "",
//                                                        cityName: strongself.currentCity ?? "")
//                order.divName = strongself.divName ?? ""
//                strongself.navigationController?.pushViewController(order, animated: true)
            }
        case .location:
            let cell = cell as! OrderLocationCell
            switch locationCityName {
            case .location(let str):
                cell.cityName = str
            case .locationFailure(let failure):
                cell.cityName = failure
            case .locationSuccess(let address):
                cell.cityName = address
            }
        case .city:
            let cell = cell as! OrderLocationCell
            cell.cityName = availableCitys[indexPath.row].cityName
        }
    }

    
}

extension OrderLocationController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let section = Section(indexPath: indexPath)
            let header:OrderHeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, forIndexPath: indexPath)
            switch section {
            case .header:
                return header
            case .location:
                header.headerLable.text = "定位城市"
                return header
            case .city:
                header.headerLable.text = "已开通城市"
                return header
            }
        }else {
            let footer:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, forIndexPath: indexPath)
            return footer
        }
        
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(section: section)
        switch section {
        case .header:
            if let _ = self.orderInfo {
                return 1
            }else {
                return 0
            }
        case .location:
            return 1
        case .city:
            return availableCitys.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(indexPath: indexPath)
        switch section {
        case .header:
            let cell:OrderCurrentLocationCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        case .location:
            let cell:OrderLocationCell =  collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        case .city:
            let cell:OrderLocationCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            return cell
        }
    }
    
    
}

extension OrderLocationController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(indexPath: indexPath)
        switch section {
        case .header:
            return CGSize(width: screenWidth, height: 50)
        case .location:
            return CGSize(width: (screenWidth - 50)/3.0, height: 30)
        case .city:
            return CGSize(width: (screenWidth - 50)/3.0, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = Section(section: section)
        switch section {
        case .header:
            return CGSize(width: 0, height: 0)
        case .location:
            return CGSize(width: screenWidth, height: 40)
        case .city:
            if !availableCitys.isEmpty{
                return CGSize(width: screenWidth, height: 40)
            }else {
                return CGSize(width: 0, height: 0)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(section: section)
        switch section {
        case .header:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        default:
            return UIEdgeInsetsMake(0, 15, 0, 15)
        }
    }

}
