//
//  SLFirstView.swift
//  Portal
//
//  Created by PENG LIN on 2017/6/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit


fileprivate let itemheight:CGFloat = Ruler.iPhoneVertical(140, 140, 150, 160).value

class SLFirstView: UIView {
    
    var containerView:UIView!
    var topleftlb:UILabel!
    var toprightlb:UILabel!
    var topleftImgView:UIImageView!
    var toprightImgView:UIImageView!
    var centerlb:UILabel!
    var centerImgView:UIImageView!
    var borderImgView:UIImageView!
    var ver:String?
    var state:String?
    var btn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    convenience init(_ ver:String?,_ state:String?){
        self.init(frame: CGRect.zero)
        self.ver = ver
        self.state = state
    }
    

    
    private func makeUI(){
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.alpha = 0.3
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        topleftImgView = UIImageView()
        topleftImgView.image = UIImage(named: "img_arrow_01")
        addSubview(topleftImgView)
        topleftImgView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self).offset(60)
            make.width.height.equalTo(40)
            
        }
        
        topleftlb = UILabel()
        topleftlb.textColor = UIColor.white
        topleftlb.text = "请在这里选择门店"
        topleftlb.font = UIFont.systemFont(ofSize: 12)
        addSubview(topleftlb)
        topleftlb.snp.makeConstraints { (make) in
            make.leading.equalTo(topleftImgView.snp.trailing).offset(5)
            make.bottom.equalTo(topleftImgView)
            
        }
        
        toprightImgView = UIImageView()
        toprightImgView.image = UIImage(named: "img_arrow_02")
        addSubview(toprightImgView)
        toprightImgView.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(60)
            make.width.height.equalTo(40)
        }
        
        toprightlb = UILabel()
        toprightlb.textColor = UIColor.white
        toprightlb.font = UIFont.systemFont(ofSize: 12)
        toprightlb.text = "请在这里登录"
        addSubview(toprightlb)
        toprightlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(toprightImgView.snp.leading).offset(-5)
            make.bottom.equalTo(toprightImgView.snp.bottom)
        }
        
        borderImgView = UIImageView()
        borderImgView.image = UIImage(named: "img_border")
        addSubview(borderImgView)
        borderImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(itemheight + 64.0)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(self.GetHeight(self.ver, self.state))
        }
        
        centerImgView = UIImageView()
        centerImgView.image = UIImage(named: "img_arrow_02")
        addSubview(centerImgView)
        centerImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(itemheight + 64.0 + self.GetHeight(self.ver, self.state)/2.0)
            make.centerX.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        centerlb = UILabel()
        centerlb.text = "这里是主功能区"
        centerlb.textColor = UIColor.white
        addSubview(centerlb)
        centerlb.snp.makeConstraints { (make) in
            make.top.equalTo(centerImgView.snp.bottom).offset(5)
            make.centerX.equalTo(self)
        }
        
        btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func showInView(_ view:UIView,ver:String?,state:String?){
        self.ver = ver
        self.state = state
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func hide(){
        self.removeFromSuperview()
    }
    
    private func GetHeight(_ ver:String?,_ state:String?) -> CGFloat {
         return 0
//        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        if ver == appVersion && state == "0" {
//            return (screenWidth - 2 * CellviewMargin - 2 * collectionviweMargin)/4  +  collectionviweMargin * 2 + CellviewMargin * 2
//        }
//        return collectionviweMargin * 2 + CellviewMargin * 2 + (screenWidth - 2 * CellviewMargin - 2 * collectionviweMargin)/2 + minimumLineSpacing
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
