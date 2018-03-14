//
//  OrderCanUseCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

private let OrdertoTopEdges:CGFloat = 10
private let lableHeight:CGFloat = 15
private let toLeftEdges:CGFloat = 15
private let lbTolbEdges:CGFloat = 10
private let btnHeight:CGFloat = 15
private let btnWidth:CGFloat = 70


public enum status:String {
    
    case needPay = "O"
    case alreadyOrder = "R"
    case alreadyChoose = "B"
    case isRefunding = "C"
    case refundFinish = "CF"
    case finishNeedComment = "F"
    case finishCheckComment = "S"
    
    var title:String {
        switch self {
        case .needPay:
            return "未付款"
        case .alreadyOrder:
            return "已预约"
        case .alreadyChoose:
            return "已点菜"
        case .isRefunding:
            return "退款中"
        case .refundFinish:
            return "退款完成"
        case .finishNeedComment:
            return "已完成"
        case .finishCheckComment:
            return "已完成"
        }
    }
    
    var detailImage:UIImage?{
        switch self {
         default:
            return UIImage(named: "icon_selected-s")
        }
    
    }
    
    var bottomtitle:String?{
        switch self {
        case .needPay:
            return "您的预定尚未支付,请尽快付款"
        case .alreadyOrder:
            return "您已预约成功,请及时前往餐厅就餐哦"
        case .alreadyChoose:
            return "到店后将订单出示给服务员下单"
        case .isRefunding:
            return nil
        case .refundFinish:
            return nil
        case .finishNeedComment:
            return nil
        case .finishCheckComment:
            return nil 
        }
    }
    
    var backGroundColor:UIColor{
        switch self {
        case .needPay:
            return UIColor.navigationbarColor
        case .alreadyChoose:
            return UIColor(red: 24/255, green: 205/255, blue: 191/255, alpha: 1)
        case .alreadyOrder,.refundFinish,.finishNeedComment,.finishCheckComment:
            return UIColor(red: CGFloat(123.0/255.0), green: CGFloat(177.0/255.0), blue: CGFloat(66.0/255.0),alpha:1)
        case .isRefunding:
            return UIColor(red: 255.0/255.0, green: 185.0/255.0, blue: 77.0/255.0,alpha:1)
        }
    }
}






class RefundingCell:UITableViewCell{
    
    var time:UILabel!
    var leftStackView:UIStackView!
    var rightStackView:UIStackView!
    var eattime:UILabel!
    var eatnum:UILabel!
    
    func updateWithModel(_ model:Reservelis){
        time.text = model.reserveDate
        eattime.text = "\(model.amount)"
        eatnum.text = model.date
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        time = UILabel()
        time.textColor = UIColor.YClightGrayColor
        time.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(contentView).offset(OrdertoTopEdges)
            make.height.equalTo(lableHeight)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .equalSpacing
        leftStackView.spacing = lbTolbEdges
        contentView.addSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(time.snp.bottom).offset(lbTolbEdges)
            make.height.equalTo(lableHeight*2+lbTolbEdges)
        }
        
        rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.distribution = .fillProportionally
        rightStackView.spacing = lbTolbEdges
        contentView.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing).offset(10)
            make.top.bottom.equalTo(leftStackView)
        }
        
        let timeDescription = UILabel()
        timeDescription.textAlignment = .left
        timeDescription.text = "退款金额".localized
        timeDescription.textColor = UIColor.YClightGrayColor
        timeDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(timeDescription)
        
        
        eattime = UILabel()
        eattime.textAlignment = .left
        eattime.textColor = UIColor.darkcolor
        eattime.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eattime)
        
        let eatNumDescription = UILabel()
        eatNumDescription.textAlignment = .left
        eatNumDescription.textColor = UIColor.YClightGrayColor
        eatNumDescription.text = "就餐时间".localized
        eatNumDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(eatNumDescription)
        
        eatnum = UILabel()
        eatnum.textAlignment = .left
        eatnum.textColor = UIColor.darkcolor
        eatnum.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eatnum)
    }
    
    class func getHeight() -> CGFloat{
        return OrdertoTopEdges*2 + lableHeight*3 + lbTolbEdges*2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







class AlreadyReadyCell:UITableViewCell{
    
    var time:UILabel!
    var leftStackView:UIStackView!
    var rightStackView:UIStackView!
    var eattime:UILabel!
    var eatnum:UILabel!

    func updateWithModel(_ model:Reservelis){
        time.text = model.reserveDate
        eattime.text = model.date
        eatnum.text = "\(model.personCount)"
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        time = UILabel()
        time.textColor = UIColor.YClightGrayColor
        time.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(contentView).offset(OrdertoTopEdges)
            make.height.equalTo(lableHeight)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .equalSpacing
        leftStackView.spacing = lbTolbEdges
        contentView.addSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(time.snp.bottom).offset(lbTolbEdges)
            make.height.equalTo(lableHeight*2+lbTolbEdges)
        }
        
        rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.spacing = lbTolbEdges
        rightStackView.distribution = .equalSpacing
        contentView.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing).offset(10)
            make.top.bottom.equalTo(leftStackView)
        }
        
        let timeDescription = UILabel()
        timeDescription.textAlignment = .left
        timeDescription.text = "就餐时间".localized
        timeDescription.textColor = UIColor.YClightGrayColor
        timeDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(timeDescription)
        
        
        eattime = UILabel()
        eattime.textAlignment = .left
        eattime.textColor = UIColor.darkcolor
        eattime.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eattime)
        
        let eatNumDescription = UILabel()
        eatNumDescription.textAlignment = .left
        eatNumDescription.textColor = UIColor.YClightGrayColor
        eatNumDescription.text = "就餐人数".localized
        eatNumDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(eatNumDescription)
        
        eatnum = UILabel()
        eatnum.textAlignment = .left
        eatnum.textColor = UIColor.darkcolor
        eatnum.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eatnum)
    }
    
    class func getHeight() -> CGFloat{
       return OrdertoTopEdges*2 + lableHeight*3 + lbTolbEdges*2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class OrderCanUseCell: UITableViewCell {
    
    var time:UILabel!
    var eattime:UILabel!
    var eatnum:UILabel!
    var eatInfo:UILabel!
    var leftStackView:UIStackView!
    var rightStackView:UIStackView!
    
    func updateWithModel(_ model:Reservelis){
        time.text = model.reserveDate
        eattime.text = model.date
        eatnum.text = "\(model.personCount)"
        eatInfo.text = model.orderMenu
    }


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        time = UILabel()
        time.textColor = UIColor.YClightGrayColor
        time.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(contentView).offset(OrdertoTopEdges)
            make.height.equalTo(lableHeight)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .equalSpacing
        leftStackView.spacing = lbTolbEdges
        contentView.addSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(time.snp.bottom).offset(lbTolbEdges)
            make.height.equalTo(lbTolbEdges*2+lableHeight*3)
        }
        
        rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.distribution = .equalSpacing
        rightStackView.spacing = lbTolbEdges
        contentView.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing).offset(10)
            make.top.bottom.equalTo(leftStackView)
        }
        
        let timeDescription = UILabel()
        timeDescription.text = "就餐时间".localized
        timeDescription.textAlignment = .left
        timeDescription.textColor = UIColor.YClightGrayColor
        timeDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(timeDescription)
        
        eattime = UILabel()
        eattime.textAlignment = .left
        eattime.textColor = UIColor.darkcolor
        eattime.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eattime)
        
        let eatNumDescription = UILabel()
        eatNumDescription.textAlignment = .left
        eatNumDescription.textColor = UIColor.YClightGrayColor
        eatNumDescription.text = "就餐人数".localized
        eatNumDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(eatNumDescription)
        
        eatnum = UILabel()
        eatnum.textAlignment = .left
        eatnum.textColor = UIColor.darkcolor
        eatnum.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eatnum)
        
        let orderInfo = UILabel()
        orderInfo.textAlignment = .left
        orderInfo.textColor = UIColor.YClightGrayColor
        orderInfo.text = "点菜详情".localized
        orderInfo.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(orderInfo)
        
        eatInfo = UILabel()
        eatInfo.textAlignment = .left
        eatInfo.textColor = UIColor.darkcolor
        eatInfo.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eatInfo)
        
    }
    
    class func getHeight() -> CGFloat {
       return OrdertoTopEdges * 2 + lableHeight * 4 + lbTolbEdges * 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}




class AlreadyChooseCell: UITableViewCell {
    var time:UILabel!
    var eattime:UILabel!
    var eatnum:UILabel!
    var eatInfo:UILabel!
    var price:UILabel!
    var leftStackView:UIStackView!
    var rightStackView:UIStackView!
    func updateWithModel(_ model:Reservelis){
      time.text = model.reserveDate
      eattime.text = model.date
      eatnum.text = "\(model.personCount)"
      eatInfo.text = model.orderMenu
      price.text = "\(model.amount)"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        time = UILabel()
        time.textColor = UIColor.YClightGrayColor
        time.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(contentView).offset(OrdertoTopEdges)
            make.height.equalTo(lableHeight)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .equalSpacing
        leftStackView.spacing = lbTolbEdges
        contentView.addSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(toLeftEdges)
            make.top.equalTo(time.snp.bottom).offset(lbTolbEdges)
            make.height.equalTo(lbTolbEdges*3+lableHeight*4)
        }
        
        rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.distribution = .equalSpacing
        rightStackView.spacing = lbTolbEdges
        contentView.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing).offset(10)
            make.top.equalTo(leftStackView)
            make.bottom.equalTo(leftStackView)
        }
        
        let priceDescription = UILabel()
        priceDescription.text = "订单金额".localized
        priceDescription.textAlignment = .left
        priceDescription.textColor = UIColor.YClightGrayColor
        priceDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(priceDescription)
        
        price = UILabel()
        price.textColor = UIColor.darkcolor
        price.font = UIFont.systemFont(ofSize: 13)
        price.textAlignment = .left
        rightStackView.addArrangedSubview(price)

        let timeDescription = UILabel()
        timeDescription.text = "就餐时间".localized
        timeDescription.textAlignment = .left
        timeDescription.textColor = UIColor.YClightGrayColor
        timeDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(timeDescription)
        
        eattime = UILabel()
        eattime.textAlignment = .left
        eattime.textColor = UIColor.darkcolor
        eattime.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eattime)
        
        let eatNumDescription = UILabel()
        eatNumDescription.textAlignment = .left
        eatNumDescription.textColor = UIColor.YClightGrayColor
        eatNumDescription.text = "就餐人数".localized
        eatNumDescription.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(eatNumDescription)
        
        eatnum = UILabel()
        eatnum.textColor = UIColor.darkcolor
        eatnum.textAlignment = .left
        eatnum.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eatnum)
        
        let orderInfo = UILabel()
        orderInfo.textAlignment = .left
        orderInfo.textColor = UIColor.YClightGrayColor
        orderInfo.text = "点菜详情".localized
        orderInfo.font = UIFont.systemFont(ofSize: 13)
        leftStackView.addArrangedSubview(orderInfo)
        
        eatInfo = UILabel()
        eatInfo.textAlignment = .left
        eatInfo.textColor = UIColor.darkcolor
        eatInfo.font = UIFont.systemFont(ofSize: 13)
        rightStackView.addArrangedSubview(eatInfo)
        
    }
    
    class func getHeight() -> CGFloat {
        return OrdertoTopEdges*2 + lableHeight*5 + lbTolbEdges*4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}









class OrderCanUseHeaderCell:UITableViewCell {
    
    var shopName:UILabel!
    var shopNameWidthConstraint:Constraint? = nil
    var shopStatus:UILabel!
    
    func updateWithModel(_ model:Reservelis){
        guard let status = status(rawValue: model.reserveStatus) else { return }
        var restaurantName:String = ""
       if model.groupYN == "Y" {
          restaurantName = model.restaurantName + "一起吃吧".localized
       }else {
          restaurantName = model.restaurantName
       }
       shopName.text = restaurantName

       shopStatus.text = status.title.localized
       shopStatus.backgroundColor = status.backGroundColor
       let width = status.title.localized.widthWithConstrainedWidth(height: 18, font:  UIFont.systemFont(ofSize: 12))
       shopNameWidthConstraint?.update(offset: width+10)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
          selectionStyle = .none
        
          shopName = UILabel()
          shopName.textColor = UIColor.darkcolor
          shopName.font = UIFont.systemFont(ofSize: 13)
          contentView.addSubview(shopName)
        
          shopStatus = UILabel()
          shopStatus.textColor = UIColor.white
          shopStatus.font = UIFont.systemFont(ofSize: 13)
          shopStatus.textAlignment = .center
          contentView.addSubview(shopStatus)
          makeConstraint()
    }
    
    private func makeConstraint(){
        
        shopName.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.height.equalTo(30)
            make.centerY.equalTo(contentView)
        }
        shopStatus.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.height.equalTo(20)
            make.centerY.equalTo(contentView)
            shopNameWidthConstraint = make.width.equalTo(0).constraint
        }

    }
    

    class func getHeight() -> CGFloat {
         return 40
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






class OrderCanUseBottomBasicCell:UITableViewCell{
    
    var statusLabel:UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        statusLabel = UILabel()
        statusLabel.textColor = UIColor.darkText
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-80)
            make.centerY.equalTo(contentView)
        }
     }
    
    func updateWithModel(_ model:Reservelis){
        guard let stauts = status(rawValue: model.reserveStatus) else {
            return
        }
        statusLabel.text = stauts.bottomtitle?.localized
    }
    
    class func getHeight() -> CGFloat {
       return 35
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






class OrderNeedPayBottomCell:OrderCanUseBottomBasicCell{
    
    var payBtn:UIButton!
    var payAction:(()->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        payBtn = UIButton(type: .custom)
        payBtn.setTitle("去付款".localized, for: .normal)
        payBtn.setTitleColor(UIColor.navigationbarColor, for: .normal)
        payBtn.layer.borderColor = UIColor.navigationbarColor.cgColor
        payBtn.layer.borderWidth = 0.8
        payBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        payBtn.addTarget(self, action: #selector(didPay), for: .touchUpInside)
        contentView.addSubview(payBtn)
        payBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.width.equalTo(btnWidth)
            make.height.equalTo(contentView).multipliedBy(0.8)
            make.trailing.equalTo(contentView).offset(-15)
        }

        
      
    }
    
    func didPay(){
       payAction?()
    }
    
    override func updateWithModel(_ model:Reservelis){
        let totalPrice = model.realAmount
        let menu = model.orderMenu.components(separatedBy: ",").count
        statusLabel.text = "共\(menu)个菜  总计：￥\(totalPrice)"
    }
    
    
    override class func getHeight() -> CGFloat {
        return super.getHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class OrderCommentBottomCell:UITableViewCell {
    
    var orderAgainBtn:UIButton!
    var goComment:UIButton!
    var deleteOrder:UIButton!
    var stackView:UIStackView!
    var deleteAction:(()->Void)?
    var againAction:(()->Void)?
    var commentAction: ((_ type:CommentType)->Void)?
    
    enum CommentType{
       case check
       case comment
    }
    
    var celltype:CommentType = .comment{
        didSet{
            switch celltype {
            case .check:
                goComment.setTitle("查看评价".localized, for: .normal)
                goComment.layer.borderColor = UIColor.YClightGrayColor.cgColor
                goComment.setTitleColor(UIColor.darkcolor, for: .normal)
            case .comment:
                goComment.setTitle("去评价".localized, for: .normal)
                goComment.layer.borderColor = UIColor.navigationbarColor.cgColor
                goComment.setTitleColor(UIColor.navigationbarColor, for: .normal)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.height.equalTo(contentView).multipliedBy(0.8)
            make.width.equalTo(btnWidth)
            make.centerY.equalTo(contentView)
        }
        
        goComment = UIButton(type: .custom)
        goComment.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        goComment.setTitleColor(UIColor.navigationbarColor, for: .normal)
        goComment.setTitle("去评价".localized, for: .normal)
        goComment.layer.borderWidth = 0.8
        goComment.layer.borderColor = UIColor.navigationbarColor.cgColor
        goComment.addTarget(self, action: #selector(didComment), for: .touchUpInside)
        stackView.addArrangedSubview(goComment)
    }
    
    func didComment(){
       commentAction?(celltype)
    }
    
    func didDelete(){
       deleteAction?()
    }
    
    func didAgain(){
       againAction?()
    }
    
    class func getHeight() -> CGFloat {
        return 35
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class OrderRefundBottomCell:UITableViewCell {
    
    var orderAgainBtn:UIButton!
    var deleteOrder:UIButton!
    var stackView:UIStackView!
    var deleteAction:(()->Void)?
    var againAction:(()->Void)?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.height.equalTo(contentView).multipliedBy(0.8)
            make.width.equalTo(btnWidth*2 + 10)
            make.centerY.equalTo(contentView)
         }
        
        orderAgainBtn = UIButton(type: .custom)
        orderAgainBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        orderAgainBtn.setTitle("再次点餐".localized, for: .normal)
        orderAgainBtn.setTitleColor(UIColor.darkcolor, for: .normal)
        orderAgainBtn.layer.borderColor = UIColor.YClightGrayColor.cgColor
        orderAgainBtn.layer.borderWidth = 0.8
        orderAgainBtn.addTarget(self, action: #selector(didAgain), for: .touchUpInside)
        stackView.addArrangedSubview(orderAgainBtn)
        
        deleteOrder = UIButton(type: .custom)
        deleteOrder.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deleteOrder.setTitle("删除订单".localized, for: .normal)
        deleteOrder.setTitleColor(UIColor.darkcolor, for: .normal)
        deleteOrder.layer.borderColor = UIColor.YClightGrayColor.cgColor
        deleteOrder.layer.borderWidth = 0.8
        deleteOrder.addTarget(self, action: #selector(didDelete), for: .touchUpInside)
        stackView.addArrangedSubview(deleteOrder)
    }
    
    func didAgain(){
       againAction?()
    }
    
    func didDelete(){
       deleteAction?()
    }
    
    class func getHeight() -> CGFloat {
        return 35
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}







