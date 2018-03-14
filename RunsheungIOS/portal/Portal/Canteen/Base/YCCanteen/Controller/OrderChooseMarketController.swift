//
//  OrderChooseMarketController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

protocol UpdateDivCode:class {
    func updateWithDivCode(_ divCode:String,_ name:String)
}

class OrderChooseMarketController: CanteenBaseViewController {
    
    private var leftTableView:MarketLeftTableView!
    private var rightTableView:MarketRightTableView!
    private var zipCode:String
    private var cityName:String
    var divName:String = ""
    private var areaandsquares = [Areaandsquar](){
        didSet{
          leftTableView.areaandsquares = areaandsquares
          leftTableView.cityName = self.cityName
          if !areaandsquares.isEmpty{
            rightTableView.squarelist = areaandsquares[leftTableView.selectIndex].squareList
           }
        }
    }
    weak var Updatedelegate:UpdateDivCode?
    
    init(zipCode Code:String,cityName name:String){
        self.zipCode = Code
        self.cityName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraint(){
        
        leftTableView.snp.makeConstraints { (make) in
            make.leading.bottom.equalTo(view)
            make.top.equalTo(view).offset(topLayoutGuide.length)
            make.width.equalTo(view).multipliedBy(0.33333)
        }
        
        rightTableView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftTableView.snp.trailing)
            make.top.equalTo(view).offset(topLayoutGuide.length)
            make.bottom.trailing.equalTo(view)
        }


    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "选择商场"
        if #available(iOS 11.0, *) { } else {
         automaticallyAdjustsScrollViewInsets = false
        }
        leftTableView = MarketLeftTableView(frame: CGRect.zero, style: .plain)
        if #available(iOS 11.0, *) {
            leftTableView.contentInsetAdjustmentBehavior = .never
        }
        leftTableView.backgroundColor = UIColor.white
        view.addSubview(leftTableView)
        leftTableView.didSelectIndex = { [weak self] index in
            guard let strongself = self else {
                return
            }
            strongself.rightTableView.squarelist = strongself.areaandsquares[strongself.leftTableView.selectIndex].squareList
        }
        
        rightTableView = MarketRightTableView(zipCode: self.divName)
        if #available(iOS 11.0, *) {
            rightTableView.contentInsetAdjustmentBehavior = .never
        }
        rightTableView.backgroundColor = UIColor.BaseControllerBackgroundColor
        view.addSubview(rightTableView)
        rightTableView.selectIndexAction = { [weak self] index , square in
            guard let strongself = self else { return }
            YCUserDefaults.userCoordinateLongtitude.value = Double(square.lon)!
            YCUserDefaults.userCoordinateLatitude.value = Double(square.lat)!
            strongself.navigationController?.viewControllers.forEach({ vc in
                if vc is YCCanteenHomeController {
                    strongself.Updatedelegate = vc as! YCCanteenHomeController
                    strongself.Updatedelegate?.updateWithDivCode(square.divCode,square.divName)
                    strongself.navigationController?.popToViewController(vc, animated: true)
                }else if vc is YCHomeController {
                    strongself.Updatedelegate = vc as! YCHomeController
                    strongself.Updatedelegate?.updateWithDivCode(square.divCode, square.divName)
                    strongself.navigationController?.popToViewController(vc, animated: true)
                }else if vc is ShopHomeController {
                    strongself.Updatedelegate = vc as! ShopHomeController
                    strongself.Updatedelegate?.updateWithDivCode(square.divCode, square.divName)
                    strongself.navigationController?.popToViewController(vc, animated: true)
                }else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChooseDivCode"), object: [square.divCode,square.divName], userInfo: nil)
                    strongself.navigationController?.popToViewController(vc, animated: true)
                }
            })
        }
        
        OrderSquareModel.GetWithZipCode(zipCode, cityName: cityName, failureHandler: {[weak self] (reason, errormessage) in
            guard let strongself = self else {
                return
            }
            strongself.showMessage(errormessage)
        }) {[weak self] jsonData in
            guard let strongself = self else {
                return
            }
            if let json = jsonData {
              strongself.areaandsquares = json.areaAndSquare
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeConstraint()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


