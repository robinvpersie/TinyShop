//
//  OrderConfirmCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher

class OrderConfirmShopInfoCell:UITableViewCell{
   
    var shopImageView:UIImageView!
    var name:UILabel!
    var address:UILabel!
    var mobile:UILabel!
    var confirmModel:OrderConfirmModel?{
        didSet {
            guard let confirmModel = confirmModel else { return }
            shopImageView.kf.setImage(with: confirmModel.shopThumImage)
            name.text = confirmModel.restaurantName
            address.text = "餐厅地址".localized + ":" + confirmModel.address
            let phone = confirmModel.phone ?? "店铺没有留电话号码"
            mobile.text = "餐厅电话".localized + ":" + phone
        }
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        shopImageView = UIImageView()
        shopImageView.kf.indicatorType = .activity
        contentView.addSubview(shopImageView)
        shopImageView.snp.makeConstraints { (make) in
           make.leading.equalTo(contentView).offset(15)
           make.height.equalTo(contentView).multipliedBy(0.8)
           make.width.equalTo(shopImageView.snp.height)
           make.centerY.equalTo(contentView)
        }
        
        name = UILabel()
        name.textColor = UIColor.darkcolor
        name.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.leading.equalTo(shopImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(15)
            make.top.equalTo(shopImageView.snp.top)
        }
        
        address = UILabel()
        address.textColor = UIColor.darkcolor
        address.font = UIFont.systemFont(ofSize: 13)
        address.numberOfLines = 2
        contentView.addSubview(address)
        address.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.leading.equalTo(name.snp.leading)
        }
        
        mobile = UILabel()
        mobile.textColor = UIColor.darkcolor
        mobile.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(mobile)
        mobile.snp.makeConstraints { (make) in
            make.leading.equalTo(name.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.bottom.equalTo(shopImageView.snp.bottom)
        }
        
    }
    
    class func getHeight() -> CGFloat {
         return 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}






class GenericCell:UITableViewCell {
    
    private lazy var itemTableview:ItemsTableView<recentItem> = {
        let itemtable = ItemsTableView<recentItem>(cellDescriptor: { item in
            return item.cellDescriptor
        })
        itemtable.backgroundColor = UIColor.clear
        itemtable.showsVerticalScrollIndicator = false
        itemtable.showsHorizontalScrollIndicator = false
        itemtable.isScrollEnabled = false 
        return itemtable
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(itemTableview)
        itemTableview.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    class func getHeightWith( items:[recentItem]) -> CGFloat{
        
        var height:CGFloat = 0
        items.forEach { (item) in
            height += item.cellDescriptor.getHeight()
        }
        return height
    }
    
    func updateWithItems(_ items:[recentItem]){
        itemTableview.items = items
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class FoodMenulistCell:UITableViewCell,UITableViewDelegate,UITableViewDataSource{
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(OrderConfirmBodyfoodCell.self)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    var compareModelArray = [Orderitemlis](){
        didSet{
           tableView.reloadData()
        }
    }
    
    var model:Groupmemberlis!{
        didSet{
           tableView.reloadData()
        }
    }

    class func getHeightWithModel(_ model:Groupmemberlis) -> CGFloat{
        return OrderConfirmBodyfoodCell.getHeight() * CGFloat(model.OrderList.count)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(tableView)
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compareModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderConfirmBodyfoodCell = tableView.dequeueReusableCell()
        cell.modelArray = compareModelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrderConfirmBodyfoodCell.getHeight()
    }
    
    class func getHeightWithModel(_ model:[Orderitemlis]) -> CGFloat {
        return OrderConfirmBodyfoodCell.getHeight() * CGFloat(model.count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class OrderConfirmBodyfoodCell:UITableViewCell{
    
    var leadlable:UILabel!
    var trainglable:UILabel!
    var centerlable:UILabel!
    
    var modelArray:Orderitemlis?{
        didSet{
            guard let model = modelArray else { return }
            leadlable.text = model.itemName
            trainglable.text = "\(model.amount)元"
            centerlable.text = "x" + "\(model.quantity)"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        leadlable = UILabel()
        leadlable.textColor = UIColor.darkcolor
        leadlable.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(leadlable)
        leadlable.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        trainglable = UILabel()
        trainglable.textColor = UIColor.darkcolor
        trainglable.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(trainglable)
        trainglable.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        centerlable = UILabel()
        centerlable.textColor = UIColor.darkcolor
        centerlable.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(centerlable)
        centerlable.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-100)
        }
    }
    
    class func getHeight() -> CGFloat {
        return 40
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class OrderConfirmTimeNumCell:UITableViewCell{
    
    var time:UILabel!
    var num:UILabel!
    var stackView:UIStackView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        time = UILabel()
        time.textColor = UIColor.darkcolor
        time.font = UIFont.systemFont(ofSize: 13)
        stackView.addArrangedSubview(time)
        
        num = UILabel()
        num.textColor = UIColor.darkcolor
        num.font = UIFont.systemFont(ofSize: 13)
        stackView.addArrangedSubview(num)
        
        
    }
    
    class func getHeight() -> CGFloat {
        return 20 + 35
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class OrderConfirmPayCell:UITableViewCell{
    
    var payImageView:UIImageView!
    var payName:UILabel!
    var paySelected:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        payImageView = UIImageView()
        contentView.addSubview(payImageView)
       
        payName = UILabel()
        payName.textColor = UIColor.darkcolor
        payName.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(payName)
        
        paySelected = UIImageView()
        contentView.addSubview(paySelected)
        
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        payImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        payName.snp.makeConstraints { (make) in
            make.leading.equalTo(payImageView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        paySelected.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        paySelected.image = selected ? UIImage.selectedImage:UIImage.unselectedImage
    }
    
    class func getHeight() -> CGFloat {
        return 45
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class orderConfirmPointCell:UITableViewCell {
    
    var pointlb:UILabel!
    private var selectBtn:UIButton!
    var selectAction:(()->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        pointlb = UILabel()
        pointlb.textColor = UIColor.darkcolor
        pointlb.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(pointlb)
        pointlb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        selectBtn = UIButton(type: .custom)
        selectBtn.addTarget(self, action: #selector(didSelectBtn), for: .touchUpInside)
        contentView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(15)
        }
    }
    
    func updateWithSelected(_ selected:Bool){
        selectBtn.setImage(selected ? UIImage.selectedImage:UIImage.unselectedImage, for: .normal)
    }
    
    @objc private func didSelectBtn(){
        selectAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}



