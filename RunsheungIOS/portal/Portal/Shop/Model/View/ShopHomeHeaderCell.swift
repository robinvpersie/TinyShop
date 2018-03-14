//
//  ShopHomeHeaderCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation


class ShopDescriptionCell:UICollectionViewCell {
    
    fileprivate lazy var descriptionlb:UILabel = {
        let lable = UILabel()
        lable.backgroundColor = UIColor.clear
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = UIColor.darkcolor
        lable.numberOfLines = 0
        return lable
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(descriptionlb)
        descriptionlb.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    func updateWithModel(_ floorModel:ShopFloorModel){
       self.descriptionlb.text = floorModel.floorMsg
    }
    
    class func GetSize(floorModel:ShopFloorModel) -> CGSize {
       let msg = floorModel.floorMsg
        if msg.characters.isEmpty {
           return CGSize.zero
        }
       let height = msg.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 12)) + 21
       return CGSize(width: screenWidth, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ShopHomeHeaderCell:UICollectionViewCell,FSPagerViewDelegate,FSPagerViewDataSource{
    
    fileprivate lazy var pager:FSPagerView = {
        let pager = FSPagerView(frame: .zero)
        pager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pager.isInfinite = true
        pager.automaticSlidingInterval = 5
        pager.interitemSpacing = 0
        pager.delegate = self
        pager.dataSource = self
        return pager
    }()
    
    
    var floorModel:ShopFloorModel!
    var selectIndex:((Adinf)->Void)?
    
    fileprivate func commonInit(){
        self.contentView.backgroundColor = UIColor.white
    }
    
    fileprivate var banner = [Adinf]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
        self.contentView.addSubview(pager)
        pager.snp.makeConstraints { make in
           make.edges.equalTo(self.contentView)
        }
        
    }
    
    func updateWithMainModel(floorModel:ShopFloorModel){
        self.floorModel = floorModel
        let bannder = floorModel.adInfo
        self.banner = bannder
        self.pager.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pager.itemSize = self.contentView.frame.size
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.banner.isEmpty ? 1:self.banner.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: banner[index].adImage)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        selectIndex?(banner[index])
        
    }
    
    class func GetSizeWithModel(_ floorModel:ShopFloorModel) -> CGSize{
           return CGSize(width: screenWidth, height: 150.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



/////segmentCell

class ShopHomeSegmentCell:UICollectionViewCell{
    
    fileprivate lazy var segmentView:YCSegmentView = {
        let segment = YCSegmentView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        segment.backgroundColor = UIColor.white
        segment.cellSpacing = 50
        segment.progressWidth = 40
        segment.progressHeight = 2
        return segment
    }()
    
    var selectIndex:((_ model:Floorbrandcategor,_ index:Int)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(segmentView)
    }
    
    func updateWithModel(_ mainModel:ShopFloorModel,offset:Int){
        
        self.segmentView.numberOfItems = {
           return mainModel.floorBrandCategory.count
        }
        self.segmentView.titleForIndex = { index in
           return mainModel.floorBrandCategory[index].adTypeName
        }
        self.segmentView.didselectItemAtIndexPath = { [weak self] index in
            guard let strongself = self else { return }
            strongself.selectIndex?(mainModel.floorBrandCategory[index],index)
        }
        if !mainModel.floorBrandCategory.isEmpty {
          self.segmentView.currentIndex = offset
        }
        
    }
    
    class func getSize() -> CGSize{
       return CGSize(width: screenWidth, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




