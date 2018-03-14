//
//  OrderNumberCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class OrderNumberCell: UITableViewCell {
    
    var numberImageView:UIImageView!
    var alertLable:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        numberImageView = UIImageView()
        contentView.addSubview(numberImageView)
        numberImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(15)
            make.width.height.equalTo(15)
        }
        alertLable = UILabel()
        alertLable.font = UIFont.systemFont(ofSize: 13)
        alertLable.textColor = UIColor.darkcolor
        contentView.addSubview(alertLable)
        alertLable.snp.makeConstraints { (make) in
            make.leading.equalTo(numberImageView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-15)
        }
    }
    
    func updateWithModel(_ model:OrderReserveModel){
        guard let status = status(rawValue: model.reserveStatus) else { return }
        numberImageView.image = status.detailImage
        alertLable.text = "预约成功".localized
        switch status {
        case .alreadyChoose:
            numberImageView.image = UIImage(named: "icon_selected-s")
            alertLable.text = "下单成功".localized
        default:
            break
        }
    }
    
    func updateWithAddress(_ model:OrderReserveModel){
        numberImageView.image = UIImage(named: "icon_dt")
        alertLable.text = model.address
    }
    
    class func getHeight() -> CGFloat {
        return 40
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



class OrderShopDetailCell:UITableViewCell{
    
    var avatarImage:UIImageView!
    var name:UILabel!
    var cosmosView:CosmosView!
    var price:UILabel!
    var type:UILabel!
    var distance:UILabel!
    private let leftEdge:CGFloat = 15
    private let rightEdge:CGFloat = 15
    private let imagetolableEdge:CGFloat = 10
    private let topEdge:CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        avatarImage = UIImageView()
        avatarImage.kf.indicatorType = .activity
        contentView.addSubview(avatarImage)
        
        name = UILabel()
        name.textColor = UIColor.darkcolor
        name.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(name)
        
        cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.starSize = 15
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.starMargin = 1
        cosmosView.settings.filledColor = UIColor.orange
        cosmosView.settings.emptyBorderColor = UIColor.orange
        cosmosView.settings.filledBorderColor = UIColor.orange
        contentView.addSubview(cosmosView)
        
        
        price = UILabel()
        price.font = UIFont.systemFont(ofSize: 13)
        price.textColor = UIColor.darkcolor
        contentView.addSubview(price)
        
        distance = UILabel()
        distance.textColor = UIColor.YClightGrayColor
        distance.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(distance)
        
        makeConstraint()
        
      }
    
    private func makeConstraint(){
      
        avatarImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.height.equalTo(70)
            make.width.equalTo(70)
            make.leading.equalTo(contentView).offset(15)
        }
        
        name.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImage)
            make.leading.equalTo(avatarImage.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        cosmosView.snp.makeConstraints { (make) in
            make.leading.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(80)
        }
        
        price.snp.makeConstraints { (make) in
            make.leading.equalTo(cosmosView.snp.trailing).offset(10)
            make.centerY.equalTo(cosmosView)
        }
        
        distance.snp.makeConstraints { (make) in
            make.leading.equalTo(name)
            make.bottom.equalTo(avatarImage)
        }
        
    }
    
    func updateWithModel(_ model:OrderReserveModel){
        avatarImage.kf.setImage(with: model.shopThumImage, options: [.transition(.fade(0.6))])
        name.text = model.restaurantName
        price.text = "￥\(model.averagePay)"
        distance.text = model.distance
        if let scoreFloat = Double(model.averagePay){
            cosmosView.rating = scoreFloat/2
        }
    }
    
    class func getHeight() -> CGFloat{
        return 90
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class OrderOtherInfoCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    var otherTableView:UITableView!
    var modelArray = [(left:String,right:String)](){
        didSet{
          otherTableView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        otherTableView = UITableView(frame: CGRect.zero, style: .plain)
        otherTableView.delegate = self
        otherTableView.dataSource = self
        otherTableView.showsVerticalScrollIndicator = false
        otherTableView.showsHorizontalScrollIndicator = false
        otherTableView.isScrollEnabled = false
        otherTableView.registerClassOf(OtherInfolittleCell.self)
        otherTableView.separatorStyle = .none
        otherTableView.tableFooterView = UIView()
        contentView.addSubview(otherTableView)
        otherTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func updateWithModel(_ model:OrderReserveModel){
        guard let status = status(rawValue: model.reserveStatus) else { return }
        var temporyArray = [(String,String)]()
        temporyArray.append(("订单编号".localized,model.reserveId))
        temporyArray.append(("就餐时间".localized,model.reserveDate))
        let peopleCount = model.personCnt
        temporyArray.append(("就餐人数".localized,peopleCount))
        var info:String
        let phone = model.phone ?? "没有留电话号码".localized
        if let name = model.name {
           info = name + "  " + phone
        }else {
           info = phone
        }
        temporyArray.append(("顾客信息".localized,info))
        switch status {
        case .finishCheckComment,.finishNeedComment:
            let payType = model.payType
            temporyArray.append(("顾客信息".localized,payType))
        default:
            break
        }
        modelArray = temporyArray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OtherInfolittleCell = tableView.dequeueReusableCell()
        cell.updateWithModel(modelArray[indexPath.row])
        return cell
    }
    
    class func getHeightWithModel(_ model:OrderReserveModel) -> CGFloat {
        
        guard let status = status(rawValue: model.reserveStatus) else { return 0 }
        switch status {
        case .finishCheckComment,.finishNeedComment:
            return 5 * 25
        default:
            return 4 * 25
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class OtherInfolittleCell:UITableViewCell{
    
    var leftlable:UILabel!
    var rightlable:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        leftlable = UILabel()
        leftlable.textColor = UIColor.YClightGrayColor
        leftlable.font = UIFont.systemFont(ofSize: 13)
        leftlable.text = "订单金额".localized
        contentView.addSubview(leftlable)
        leftlable.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        rightlable = UILabel()
        rightlable.textColor = UIColor.darkcolor
        rightlable.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(rightlable)
        rightlable.snp.makeConstraints { (make) in
            make.leading.equalTo(leftlable.snp.trailing).offset(15)
            make.centerY.equalTo(contentView)
        }
    }
    
    func updateWithModel(_ model:(left:String,right:String)){
        //rightlable.text = "￥\(model.totalAmount)"
        leftlable.text = model.left
        rightlable.text = model.right
    }
    
    class func getHeight() -> CGFloat {
       return 30
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class OrderleadTrailCell:UITableViewCell {
    
    lazy var leadlable:UILabel = {
        let lead = UILabel()
        lead.textColor = UIColor.YClightGrayColor
        lead.font = UIFont.systemFont(ofSize: 14)
        return lead
    }()
    
    lazy var traillable:UILabel = {
        let trail = UILabel()
        trail.textColor = UIColor.darkcolor
        trail.font = UIFont.systemFont(ofSize: 14)
        return trail
    }()
    
    var model:(lead:String,trail:String)?{
        didSet{
            if let model = model {
                self.leadlable.text = model.lead
                self.traillable.text = model.trail
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(leadlable)
        contentView.addSubview(traillable)
        makeConstraint()
    }
    
    func updateWithModel(_ model:OrderReserveModel){
        leadlable.text = "订单金额".localized
        traillable.text = "￥\(model.totalAmount)"
    }
    
    
    private func makeConstraint(){
        leadlable.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        traillable.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class OrderFoodContainerCell:UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderFoodStyleCell.self)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        return tableView
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    var reserveModelArray = [ReserveMen](){
        didSet{
          tableView.reloadData()
        }
    }
    
    
    class func getHeightWithModelArray(_ modelArray:[ReserveMen]) -> CGFloat{
        return CGFloat(modelArray.count)*OrderFoodStyleCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserveModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderFoodStyleCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! OrderFoodStyleCell
        cell.updateWithModel(reserveModelArray[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrderFoodStyleCell.getHeight()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class OrderFoodStyleCell:UITableViewCell {
    
    var name:UILabel!
    var num:UILabel!
    var price:UILabel!
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        name = UILabel()
        name.font = UIFont.systemFont(ofSize: 13)
        name.textColor = UIColor.darkcolor
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
           make.leading.equalTo(contentView).offset(15)
           make.centerY.equalTo(contentView)
        }
        
        price = UILabel()
        price.font = UIFont.systemFont(ofSize: 13)
        price.textColor = UIColor.darkcolor
        contentView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
        num = UILabel()
        num.font = UIFont.systemFont(ofSize: 13)
        num.textColor = UIColor.darkcolor
        contentView.addSubview(num)
        num.snp.makeConstraints { (make) in
            make.trailing.equalTo(price.snp.leading).offset(-40)
            make.centerY.equalTo(contentView)
        }
    }
    
    func updateWithModel(_ model:ReserveMen){
        name.text = model.itemName
        price.text = "￥\(model.amount)"
        num.text = "\(model.quantity)份"
        
    }
    
    class func getHeight() -> CGFloat{
         return 40
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}





class OrderPriceBodyCell:UITableViewCell{
    
    var price:UILabel!
    var ordertime:UILabel!
    var topStackView:UIStackView!
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        topStackView = UIStackView()
        topStackView.alignment = .trailing
        topStackView.axis = .vertical
        topStackView.distribution = .equalSpacing
        contentView.addSubview(topStackView)
        topStackView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-15)
            make.leading.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        price = UILabel()
        price.textColor = UIColor.navigationbarColor
        price.font = UIFont.systemFont(ofSize: 15)
        topStackView.addArrangedSubview(price)
        
        ordertime = UILabel()
        ordertime.textColor = UIColor.YClightGrayColor
        ordertime.font = UIFont.systemFont(ofSize: 13)
        topStackView.addArrangedSubview(ordertime)
     }
    
    func updateWithModel(_ model:OrderReserveModel){
         ordertime.text = "下单时间".localized + ":" + model.date
        let mutableAttributeStr = NSMutableAttributedString()
        let needPaystr = NSAttributedString(string: "实付款".localized + ":", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName:UIColor.darkcolor])
          mutableAttributeStr.append(needPaystr)
        let pricestr = NSAttributedString(string: "￥\(model.actualTotalAmount)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.navigationbarColor])
        mutableAttributeStr.append(pricestr)
        price.attributedText = mutableAttributeStr
        
    }
    
    
    class func getHeight() -> CGFloat {
        return 10*2 + 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}



class OrderPriceBottomCell:UITableViewCell {
    
    lazy var orderAgainBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.YClightGrayColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("再次点餐".localized, for: .normal)
        btn.setTitleColor(UIColor.darkcolor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(orderAgain), for: .touchUpInside)
        return btn
    }()
    
    lazy var refundBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.YClightGrayColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("我要退款".localized, for: .normal)
        btn.setTitleColor(UIColor.darkcolor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(refundOrder), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.YClightGrayColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("删除订单".localized, for: .normal)
        btn.setTitleColor(UIColor.darkcolor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        return btn
    }()
    
    var deleteAction:(()->Void)?
    var refundAction:(()->Void)?
    var againAction:(()->Void)?
    
    func deleteOrder(){
      deleteAction?()
    }
    
    func refundOrder(){
       refundAction?()
    }
    
    func orderAgain(){
       againAction?()
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(deleteBtn)
        contentView.addSubview(orderAgainBtn)
        contentView.addSubview(refundBtn)
        
        deleteBtn.isHidden = true
        orderAgainBtn.isHidden = true
        
        makeConstraint()
    }
    
    class func getHeight() -> CGFloat{
        return 50
    }
    
    private func makeConstraint(){
       
        deleteBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        orderAgainBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        refundBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(orderAgainBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}















