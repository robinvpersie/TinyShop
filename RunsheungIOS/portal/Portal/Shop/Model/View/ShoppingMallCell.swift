//
//  ShoppingMallCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/16.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher

class MallShoppeCell:UITableViewCell{
    
    private lazy var firstBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 0
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var secondBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.tag = 1
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var thirdBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 2
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var forthBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 3
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var fifthBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 4
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sixthBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 5
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var clickAction:((_ index:String)->Void)?
    
    @objc private func didBtn(sender:UIButton){
        var cha:String
        switch sender.tag {
        case 0:
            cha = "a"
        case 1:
            cha = "b"
        case 2:
            cha = "c"
        case 3:
            cha = "d"
        case 4:
            cha = "e"
        case 5:
            cha = "f"
        default:
            cha = ""
        }
        clickAction?(cha)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.contentView.addSubview(self.firstBtn)
        self.contentView.addSubview(self.secondBtn)
        self.contentView.addSubview(self.thirdBtn)
        self.contentView.addSubview(self.forthBtn)
        self.contentView.addSubview(self.fifthBtn)
        self.contentView.addSubview(self.sixthBtn)
        self.makeConstraint()
    }
    
    private func commonInit(){
       self.selectionStyle = .none
       self.contentView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    @objc private func makeConstraint(){
        
        self.firstBtn.snp.makeConstraints { (make) in
            make.width.equalTo((screenWidth-1.0)/2.0)
            make.leading.top.equalTo(self.contentView)
            make.height.equalTo(100)
        }
        self.secondBtn.snp.makeConstraints { (make) in
            make.width.equalTo(self.firstBtn)
            make.top.trailing.equalTo(self.contentView)
            make.height.equalTo((100.0-1.0)/2.0)
        }
        self.thirdBtn.snp.makeConstraints { (make) in
            make.width.height.trailing.equalTo(self.secondBtn)
            make.top.equalTo(self.secondBtn.snp.bottom).offset(1)
        }
        self.forthBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.firstBtn.snp.bottom).offset(1)
            make.leading.equalTo(self.contentView)
            make.width.equalTo((screenWidth-2.0)/3.0)
            make.height.equalTo(100)
        }
        self.fifthBtn.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.forthBtn)
            make.leading.equalTo(self.forthBtn.snp.trailing).offset(1)
        }
        self.sixthBtn.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.fifthBtn)
            make.trailing.equalTo(self.contentView)
        }
    }
    
    func updateWithArray(_ array:[MallGoods1]){
         array.forEach { (mallGoods1) in
            let displayNum = mallGoods1.displayNum
            let imgUrl = mallGoods1.imageUrl
            if displayNum.contains("a"){
              self.firstBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("b"){
              self.secondBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("c"){
              self.thirdBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("d"){
              self.forthBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("e"){
              self.fifthBtn.kf.setImage(with: imgUrl, for: .normal)
            }else {
              self.sixthBtn.kf.setImage(with: imgUrl, for: .normal)
            }
        }
    }
    
    class func getHeight() -> CGFloat {
         return 201
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class MallHotCell:UITableViewCell {
    
    private lazy var firstBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 0
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var secondBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.tag = 1
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var thirdBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 2
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var forthBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 3
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var fifthBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 4
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sixthBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 5
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(didBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var clickAction:((_ index:String)->Void)?
    
    @objc private func didBtn(sender:UIButton){
        var cha:String
        switch sender.tag {
        case 0:
            cha = "a"
        case 1:
            cha = "b"
        case 2:
            cha = "c"
        case 3:
            cha = "d"
        case 4:
            cha = "e"
        case 5:
            cha = "f"
        default:
            cha = ""
        }
        clickAction?(cha)
    }
    
    private func commonInit(){
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        self.contentView.addSubview(self.firstBtn)
        self.contentView.addSubview(self.secondBtn)
        self.contentView.addSubview(self.thirdBtn)
        self.contentView.addSubview(self.forthBtn)
        self.contentView.addSubview(self.fifthBtn)
        self.contentView.addSubview(self.sixthBtn)
        self.makeConstraint()

    }
    
    @objc private func makeConstraint(){
        
        self.firstBtn.snp.makeConstraints { (make) in
            make.width.equalTo((screenWidth-1.0)/2.0)
            make.leading.top.equalTo(self.contentView)
            make.height.equalTo(100)
        }
        self.secondBtn.snp.makeConstraints { (make) in
            make.width.equalTo(self.firstBtn)
            make.top.trailing.equalTo(self.contentView)
            make.height.equalTo(self.firstBtn)
        }
        self.thirdBtn.snp.makeConstraints { (make) in
            make.height.leading.equalTo(self.firstBtn)
            make.top.equalTo(self.firstBtn.snp.bottom).offset(1)
            make.width.equalTo((screenWidth - 3.0*1.0)/4.0)
        }
        self.forthBtn.snp.makeConstraints { (make) in
            make.top.width.bottom.equalTo(self.thirdBtn)
            make.leading.equalTo(thirdBtn.snp.trailing).offset(1)
        }
        self.fifthBtn.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.forthBtn)
            make.leading.equalTo(self.forthBtn.snp.trailing).offset(1)
        }
        self.sixthBtn.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.fifthBtn)
            make.trailing.equalTo(self.contentView)
        }
    }
    
    func updateWithArray(_ array:[MallGoods2]){
        
        array.forEach { (mallGoods) in
            let displayNum = mallGoods.displayNum
            let imgUrl = mallGoods.imageUrl
            if displayNum.contains("a"){
                self.firstBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("b"){
                self.secondBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("c"){
                self.thirdBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("d"){
                self.forthBtn.kf.setImage(with: imgUrl, for: .normal)
            }else if displayNum.contains("e"){
                self.fifthBtn.kf.setImage(with: imgUrl, for: .normal)
            }else {
                self.sixthBtn.kf.setImage(with: imgUrl, for: .normal)
            }
        }
    }
    
    class func getHeight() -> CGFloat {
        return 201
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




/////////
class MallSpecialCell:UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    private lazy var collectionView:UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.itemSize = ShopBrandFilterCell.getSize()
        flowlayout.minimumInteritemSpacing = 1
        flowlayout.minimumLineSpacing = 1
        flowlayout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        collectionView.registerClassOf(ShopBrandFilterCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        return collectionView
    }()
    
    fileprivate var dataSource = [MallGoods3]()
    var itemAction:((MallGoods3)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count > 4 ? 4:self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShopBrandFilterCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? ShopBrandFilterCell
        cell?.updateWithMall(self.dataSource[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemAction?(self.dataSource[indexPath.row])
    }
    
    func updateWithArray(_ array:[MallGoods3]){
        self.dataSource = array
        let waytoUpdate:UICollectionView.WayToUpdate = .reloadData
        waytoUpdate.performWithCollectionView(collectionview: self.collectionView)
    }
    
    class func getHeight() -> CGFloat {
       
        let height = ShopBrandFilterCell.getSize().height * 2.0 + 1.0
        return height
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
