//
//  OrderMenuBottomView.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/4.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

enum actionType {
    case add
    case sub
}

class OrderMenuBottomView: UIView {

    private var priceLable:UILabel!
    private var alrightBtn:UIButton!
    private var backGroundView:UIView!
    var carBackgroundView:shopCarView!
    var numlable:UILabel!
    var backBtn:UIView!
    private var pushBtn:UIButton!
    private var ispush = false
    enum pushType{
       case up
       case down
    }
    var badgeValue:Int = 0 {
        didSet{
            if badgeValue > 0 {
              self.alrightBtn.backgroundColor = UIColor.navigationbarColor
            }else {
               self.alrightBtn.backgroundColor = UIColor.clear
            }
            backBtn.showBadge(with: .number, value: badgeValue, animationType: .none)
        }
    }
    var totalPrice:Float = 0 {
        didSet{
            if totalPrice > 0 {
               priceLable.text = "共\(totalPrice)"
            }else {
               priceLable.text = "购物车为空".localized
            }
        }
    }
    var payAction:(()->Void)?
    var pushAction:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backGroundView = UIView()
        addSubview(backGroundView)
        backGroundView.backgroundColor = UIColor.darkcolor
        backGroundView.alpha = 0.95
        
        alrightBtn = UIButton(type: .custom)
        alrightBtn.addTarget(self, action: #selector(goAlright), for: .touchUpInside)
        alrightBtn.setTitle("选好了".localized, for: .normal)
        alrightBtn.backgroundColor = UIColor.clear
        backGroundView.addSubview(alrightBtn)
        
        priceLable = UILabel()
        priceLable.numberOfLines = 1
        priceLable.font = UIFont.systemFont(ofSize: 15)
        priceLable.textColor = UIColor.white
        priceLable.text = "购物车为空".localized
        backGroundView.addSubview(priceLable)
        
        backBtn = UIView()
        backBtn.badgeCenterOffset = CGPoint(x: -8, y: 10)
        backBtn.backgroundColor = UIColor.clear
        addSubview(backBtn)
        
        carBackgroundView = shopCarView()
        backBtn.addSubview(carBackgroundView)
        pushBtn = UIButton(type: .custom)
        pushBtn.addTarget(self, action: #selector(push), for: .touchUpInside)
        pushBtn.backgroundColor = UIColor.clear
        backGroundView.addSubview(pushBtn)
        makeConstraint()
    }
    
    private func makeConstraint(){
        backGroundView.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        alrightBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(backGroundView)
            make.top.equalTo(backGroundView)
            make.bottom.equalTo(backGroundView)
            make.width.equalTo(100)
        }
        
        priceLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(backGroundView)
            make.leading.equalTo(backGroundView).offset(100)
        }

        backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        carBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(backBtn)
        }
        pushBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(backGroundView)
            make.top.equalTo(backGroundView)
            make.bottom.equalTo(backGroundView)
            make.trailing.equalTo(alrightBtn.snp.leading)
        }

    }
    
    func push(){
        pushAction?()
    }
    
    func goAlright(){
       payAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class shopCarView:UIView{
    
    private lazy var carImageView:UIImageView = {
       let car = UIImageView()
        car.image = UIImage(named:"icon_ggcg")
       return car
    }()
    
    var carImage:UIImage?{
        didSet{
          carImageView.image = carImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 30
        layer.backgroundColor = UIColor.darkcolor.cgColor
        addSubview(carImageView)
        carImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(30)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}



/////////////////////////////////
class OrderMenuPushView:UIView,UITableViewDelegate,UITableViewDataSource{
    
    lazy var containerView:UIButton = {
       let view = UIButton(type: .custom)
       view.addTarget(self, action: #selector(hide), for: .touchUpInside)
       view.backgroundColor = UIColor.black
       view.alpha = 0.6
       return view
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderMenuPushCell.self)
        tableView.registerClassOf(UITableViewCell.self)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var backContainer:UIView = {
        let backContainer = UIView()
        backContainer.backgroundColor = UIColor.classBackGroundColor
        return backContainer
    }()
    
    var heightConstraint:Constraint? = nil
    var bottomConstaint:Constraint? = nil
    var backHeightConstraint:Constraint? = nil
    var menulisArray = [[compareMenuModel]](){
        didSet{
           tableView.reloadData()
        }
    }

    enum sectionType:Int {
      case header
      case menu
    }
    
    var deleteAllAction:((_ array:[[compareMenuModel]])->Void)?
    var callback: ((_ array:[[compareMenuModel]],_ uniqueModel:compareMenuModel,_ actionType:actionType) -> Void)?
    var hideAction:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubview(containerView)
        addSubview(backContainer)
        backContainer.addSubview(tableView)
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        backContainer.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            self.backHeightConstraint = make.height.equalTo(0).constraint
        }
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(backContainer)
            self.heightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    func showWithModel(_ modelDic:[[compareMenuModel]]){
         menulisArray = modelDic
         let tableHeight = modelDic.count >= 4 ? 5*45:(modelDic.count+1)*45
         self.heightConstraint?.update(offset: tableHeight)
         isHidden = false
         UIView.animate(withDuration: 0.3) {
            self.backHeightConstraint?.update(offset: tableHeight + 70)
            self.layoutIfNeeded()
        }
    }
    
    func hide(){
    
        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstraint?.update(offset: 0)
            self.backHeightConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }) { (finish) in
            if finish{
            self.isHidden = true
            self.hideAction?()
            }
        }
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = sectionType(rawValue: section) else { fatalError() }
        switch sectionType {
        case .header:
            return 1
        case .menu:
            return menulisArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch sectionType {
        case .header:
            let cell = tableView.dequeueReusableCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = "清空购物车".localized
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = UIColor.YClightGrayColor
            cell.textLabel?.textAlignment = .center
            return cell
        case .menu:
            let cell:OrderMenuPushCell = tableView.dequeueReusableCell()
            cell.ActionBlock = { [weak self] type , num in
                guard let strongself = self else { return }
                switch type {
                case .add:
                    guard let menu = strongself.menulisArray[indexPath.row].first else { return }
                    strongself.menulisArray[indexPath.row].append(menu)
                    strongself.callback?(strongself.menulisArray,menu,type)
                case .sub:
                    if num == 0 {
                       guard let menu = strongself.menulisArray[indexPath.row].last else { return }
                       strongself.menulisArray.remove(at: indexPath.row)
                       strongself.callback?(strongself.menulisArray,menu,type)
                       if strongself.menulisArray.isEmpty{
                           strongself.hide()
                       }
                    }else {
                        guard let menu = strongself.menulisArray[indexPath.row].last else { return }
                        strongself.menulisArray[indexPath.row].removeLast()
                        strongself.callback?(strongself.menulisArray,menu,type)
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch sectionType {
        case .header:
            break
        case .menu:
            let cell = cell as! OrderMenuPushCell
            cell.modelArray = menulisArray[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch sectionType {
        case .header:
            return 45
        case .menu:
            return OrderMenuPushCell.getHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch sectionType {
        case .header:
            menulisArray.removeAll()
            deleteAllAction?(menulisArray)
            hide()
        case .menu:
             break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




/////////
class OrderMenuPushCell:UITableViewCell {
    
    private var leadlb:UILabel!
    private var pricelb:UILabel!
    private var addbtn:UIButton!
    private var subBtn:UIButton!
    private var numlb:UILabel!
    var totalNum = 0 {
        didSet{
          numlb.text = "\(totalNum)"
        }
    }
    var ActionBlock:((_ actionType:actionType,_ num:Int)->Void)?
    var modelArray = [compareMenuModel](){
        didSet{
            totalNum = modelArray.count
            let attributeStr = NSMutableAttributedString()
            let attributePirce = NSAttributedString(string:"￥\(modelArray[0].menulis.itemAmount)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.navigationbarColor])
            attributeStr.append(attributePirce)
            let attributefen = NSAttributedString(string: "/份", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName:UIColor.YClightGrayColor])
            attributeStr.append(attributefen)
            pricelb.attributedText = attributeStr
            leadlb.text = modelArray[0].menulis.itemName
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        leadlb = UILabel()
        leadlb.textColor = UIColor.darkcolor
        leadlb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(leadlb)
        
        addbtn = UIButton(type: .custom)
        addbtn.addTarget(self, action: #selector(didAdd), for: .touchUpInside)
        addbtn.backgroundColor = UIColor.navigationbarColor
        addbtn.layer.masksToBounds = true
        addbtn.layer.cornerRadius = 15
        addbtn.setTitle("+", for: .normal)
        addbtn.setTitleColor(UIColor.white, for: .normal)
        addbtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(addbtn)
        
        numlb = UILabel()
        numlb.textColor = UIColor.darkcolor
        numlb.font = UIFont.systemFont(ofSize: 14)
        numlb.textAlignment = .center
        contentView.addSubview(numlb)
        
        subBtn = UIButton(type: .custom)
        subBtn.addTarget(self, action: #selector(didSub), for: .touchUpInside)
        subBtn.backgroundColor = UIColor.white
        subBtn.layer.masksToBounds = true
        subBtn.layer.cornerRadius = 15
        subBtn.layer.borderColor = UIColor.classBackGroundColor.cgColor
        subBtn.layer.borderWidth = 1
        subBtn.setTitle("-", for: .normal)
        subBtn.setTitleColor(UIColor.navigationbarColor, for: .normal)
        subBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(subBtn)
        
        pricelb = UILabel()
        pricelb.textColor = UIColor.navigationbarColor
        pricelb.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(pricelb)
        
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        leadlb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        addbtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        numlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(addbtn.snp.leading)
            make.centerY.equalTo(addbtn.snp.centerY)
            make.width.equalTo(50)
            make.height.equalTo(18)
        }
        
        subBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(numlb.snp.leading)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        pricelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(subBtn.snp.leading).offset(-10)
            make.centerY.equalTo(contentView)
        }
    }
    
    @objc private func didSub(){
      if totalNum == 0 { return }
         totalNum -= 1
         ActionBlock?(.sub,totalNum)
    }
    
    @objc private func didAdd(){
       totalNum += 1
       ActionBlock?(.add,totalNum)
    }
    
    class func getHeight() -> CGFloat {
       return 45
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}







