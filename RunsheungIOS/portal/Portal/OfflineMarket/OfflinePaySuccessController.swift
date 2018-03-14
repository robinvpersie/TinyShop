//
//  OfflinePaySuccessController.swift
//  Portal
//
//  Created by PENG LIN on 2017/10/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class OfflinePaySuccessController: OfflineBaseController {

    var imgView:UIImageView!
    var moneylb:UILabel!
    var lb:UILabel!
    var backbtn:UIButton!
    var money:String?
    var backAction:(()->Void)?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "支付成功"
        
        view.backgroundColor = UIColor(hex: 0xf2f4f6)
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "successpay")
        view.addSubview(imgView)
        
        lb = UILabel()
        lb.text = "支付成功"
        lb.textColor = UIColor(hex: 0x09bb07)
        lb.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy)
        view.addSubview(lb)
        
        moneylb = UILabel()
        moneylb.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
        moneylb.text = money
        view.addSubview(moneylb)
        
        backbtn = UIButton(type: .custom)
        backbtn.setTitle("返回超市", for: .normal)
        backbtn.setTitleColor( UIColor(hex: 0x09bb07), for: .normal)
        backbtn.layer.borderWidth = 1
        backbtn.layer.backgroundColor = UIColor.clear.cgColor
        backbtn.layer.cornerRadius = 3
        backbtn.layer.borderColor = UIColor(hex: 0x09bb07).cgColor
        backbtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backbtn)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.height.equalTo(40)
            make.top.equalTo(view).offset(topLayoutGuide.length + 50)
        }
        
        lb.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        moneylb.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(lb.snp.bottom).offset(25)
        }
        
        backbtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(moneylb.snp.bottom).offset(50)
        }
        
    }
    
    func back(){
        backAction?()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
