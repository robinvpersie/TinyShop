//
//  ShopHomeCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import Kingfisher

class HomeScrollCell:UITableViewCell,FSPagerViewDataSource,FSPagerViewDelegate {
    
    fileprivate enum dataType {
       case shopBanner([Adinf])
        
    }
    
    fileprivate var dataSource:dataType = .shopBanner([])
    var selectIndex:((_ banner:Adinf) -> Void)?
    
     lazy var pager:FSPagerView = {
        let pager = FSPagerView(frame: .zero)
        pager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pager.itemSize = .zero
        pager.interitemSpacing = 0
        pager.isInfinite = true
        pager.automaticSlidingInterval = 5
        pager.delegate = self
        pager.dataSource = self
        return pager
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        
        self.contentView.addSubview(pager)
        pager.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit(){
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pager.itemSize = self.contentView.frame.size
    }
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        switch self.dataSource {
        case .shopBanner(let banner):
            return banner.isEmpty ? 1:banner.count
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        switch self.dataSource {
        case .shopBanner(let banner):
            if !banner.isEmpty{
              let uniqueBanner = banner[index]
              cell.imageView?.kf.setImage(with: uniqueBanner.adImage, options:[.transition(.fade(0.5))])
            }
        }
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        switch dataSource {
        case .shopBanner(let banner):
            if !banner.isEmpty {
            selectIndex?(banner[index])
            }
       }
    }
    
    func updateWithMallModel(_ model:ShopMallModel?){
        if let model = model {
            let banner = model.adinfo
            self.dataSource = .shopBanner(banner)
            self.pager.reloadData()
        }
    }
    
    
    func updateWithModel(_ model:ShopHomeModel){
        let banner = model.adInfo
        self.dataSource = .shopBanner(banner)
        self.pager.reloadData()
    }
    
    class func getHeight() -> CGFloat {
       return 150
    }
}




class ShopHomeoddCell:ShopHomeBasicCell{
    
    private lazy var fisrtImgView:UIButton = {
         let imgView = UIButton()
         imgView.backgroundColor = UIColor.white
         imgView.addTarget(self, action: #selector(clickfirst), for: .touchUpInside)
         return imgView
    }()
    
    private lazy var secondImgView:UIButton = {
        let imgView = UIButton()
        imgView.backgroundColor = UIColor.white
        imgView.addTarget(self, action: #selector(clicksecond), for: .touchUpInside)
        return imgView
    }()
    
    private lazy var thirdImgView:UIButton = {
        let imgView = UIButton()
        imgView.backgroundColor = UIColor.white
        imgView.addTarget(self, action: #selector(clickthird), for: .touchUpInside)
        return imgView
    }()
    
    private lazy var grayvertical:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    private lazy var grayhor:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    
    
    @objc private func clickthird(){
        self.btnAction?("d")
    }
    
    @objc private func clicksecond(){
        self.btnAction?("c")
    }
    
    @objc private func clickfirst(){
        self.btnAction?("b")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(self.fisrtImgView)
        contentView.addSubview(self.secondImgView)
        contentView.addSubview(self.thirdImgView)
        contentView.addSubview(self.grayvertical)
        contentView.addSubview(self.grayhor)
        makeConstraints()
    }
    
    private func makeConstraints(){
        
        self.fisrtImgView.snp.makeConstraints { (make) in
            make.leading.bottom.equalTo(contentView)
            make.top.equalTo(self.imgView.snp.bottom)
            make.width.equalTo(contentView).multipliedBy(1.0/2.0)
        }
        
        self.secondImgView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView)
            make.top.equalTo(self.imgView.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(contentView).multipliedBy(1.0/2.0)
        }
        
        self.thirdImgView.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(1.0/2.0)
            make.top.equalTo(self.secondImgView.snp.bottom)
        }
        
        self.grayvertical.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.width.equalTo(1)
            make.bottom.equalTo(contentView)
            make.top.equalTo(self.imgView.snp.bottom)
        }
        
        self.grayhor.snp.makeConstraints { (make) in
            make.leading.equalTo(self.grayvertical.snp.trailing)
            make.height.equalTo(1)
            make.trailing.equalTo(contentView)
            make.top.equalTo(self.secondImgView.snp.bottom)
        }
    
    }
    
    override func updateWithModel(_ model:ShopCategor){
        super.updateWithModel(model)
        let data:[UniqueFloor] = model.data
        data.forEach { (uniqueFloor) in
            if let evenImg = uniqueFloor.eventImage.first{
                let characters = evenImg.displayNum.characters
                if characters.contains("a"){
                    self.imgView.kf.setImage(with: evenImg.imageUrl)
                }else if characters.contains("b"){
                    self.fisrtImgView.kf.setImage(with: evenImg.imageUrl, for: .normal,options:[.processor(ResizingImageProcessor(targetSize:self.fisrtImgView.frame.size))])
                }else if characters.contains("c"){
                    self.secondImgView.kf.setImage(with: evenImg.imageUrl, for: .normal,options:[.processor(ResizingImageProcessor(targetSize:self.secondImgView.frame.size))])
                }else {
                    self.thirdImgView.kf.setImage(with: evenImg.imageUrl, for: .normal,options:[.processor(ResizingImageProcessor(targetSize:self.thirdImgView.frame.size))])
                }
            }
        }
    }

    
    override class func getHeight() -> CGFloat {
        return super.getHeight() + 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ShopHomeevenCell:ShopHomeBasicCell{
    
    private lazy var stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 0.5
        return stackView
    }()
    
    private lazy var fisrtImgView:UIButton = {
        let imgView = UIButton(type: .custom)
        imgView.addTarget(self, action: #selector(clickfirst), for: .touchUpInside)
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    private lazy var secondImgView:UIButton = {
        let imgView = UIButton(type: .custom)
        imgView.addTarget(self, action: #selector(clicksecond), for: .touchUpInside)
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    private lazy var thirdImgView:UIButton = {
        let imgView = UIButton(type: .custom)
        imgView.addTarget(self, action: #selector(clickthird), for: .touchUpInside)
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    @objc private func clickfirst(){
        self.btnAction?("b")
    }
    
    @objc private func clicksecond(){
        self.btnAction?("c")
    }
    
    @objc private func clickthird(){
        self.btnAction?("d")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(contentView)
            make.top.equalTo(self.imgView.snp.bottom)
        }
        self.stackView.addArrangedSubview(self.fisrtImgView)
        self.stackView.addArrangedSubview(self.secondImgView)
        self.stackView.addArrangedSubview(self.thirdImgView)
        self.fisrtImgView.snp.makeConstraints { (make) in
            make.width.equalTo((screenWidth - 1*2)/3.0)
            make.width.equalTo(secondImgView)
            make.width.equalTo(thirdImgView)
        }
        
    }
    
    override func updateWithModel(_ model:ShopCategor){
        super.updateWithModel(model)
        let data:[UniqueFloor] = model.data
        data.forEach { (uniqueFloor) in
            if let evenImg = uniqueFloor.eventImage.first{
                let characters = evenImg.displayNum.characters
                if characters.contains("a"){
                   // self.imgView.kf.setImage(with: evenImg.imageUrl, for: .normal)
                    self.imgView.kf.setImage(with: evenImg.imageUrl)
                  }else if characters.contains("b"){
                    self.fisrtImgView.kf.setImage(with: evenImg.imageUrl, for: .normal,options:[.processor(ResizingImageProcessor(targetSize:self.fisrtImgView.frame.size))])
                }else if characters.contains("c"){
                    self.secondImgView.kf.setImage(with: evenImg.imageUrl, for: .normal,options:[.processor(ResizingImageProcessor(targetSize:self.secondImgView.frame.size))])
                }else {
                    self.thirdImgView.kf.setImage(with: evenImg.imageUrl, for: .normal,options:[.processor(ResizingImageProcessor(targetSize:self.thirdImgView.frame.size))])
                }
            }
        }
    }
    
    override class func getHeight() -> CGFloat {
       return super.getHeight() + 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}







class ShopHomeBasicCell:UITableViewCell {
    
    fileprivate lazy var floorlb:UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor = UIColor(hex: 0xf03468)
        return lable
    }()
    
    fileprivate lazy var goodslb:UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = UIColor.darkcolor
        return lable
    }()
    
    fileprivate lazy var arrorBtn:UIButton = {
        let arror = UIButton(type: .custom)
        arror.addTarget(self, action: #selector(didArror), for: .touchUpInside)
        arror.setTitle(">", for: .normal)
        arror.setTitleColor(UIColor.YClightGrayColor, for: .normal)
        arror.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        return arror
    }()
    
    
    lazy var imgView:UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true 
        return img
    }()
    
    var arrorAction:(()->Void)?
    var btnAction:((_ index:String)->Void)?
    
    
    @objc fileprivate func didArror(){
        arrorAction?()
    }
    
    @objc fileprivate func clickTop(){
        btnAction?("a")
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        
        let topGrayView = UIView()
        topGrayView.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(topGrayView)
        topGrayView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        let topContainerView = UIView()
        topContainerView.backgroundColor = UIColor.white
        contentView.addSubview(topContainerView)
        topContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(topGrayView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(48)
        }
        
        topContainerView.addSubview(floorlb)
        floorlb.snp.makeConstraints { (make) in
            make.leading.equalTo(topContainerView).offset(15)
            make.centerY.equalTo(topContainerView)
        }
        
        topContainerView.addSubview(goodslb)
        goodslb.snp.makeConstraints { (make) in
            make.leading.equalTo(floorlb.snp.trailing).offset(10)
            make.centerY.equalTo(topContainerView)
        }
        
        topContainerView.addSubview(arrorBtn)
        arrorBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(topContainerView).offset(-15)
            make.centerY.equalTo(topContainerView)
        }
        
        contentView.addSubview(imgView)
        
        let getsture = UITapGestureRecognizer(target: self, action: #selector(clickTop))
        imgView.addGestureRecognizer(getsture)
        
        imgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(topContainerView.snp.bottom)
            make.height.equalTo(120)
        }
    }
    
    func commonInit(){
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
    }
    
    func updateWithModel(_ model:ShopCategor){
        self.floorlb.text = model.floorNum + "F"
        self.goodslb.text = model.levelName
    }
    
    class func getHeight()->CGFloat{
       return 178
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}








