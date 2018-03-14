//
//  OrderPageCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/2/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class OrderPageCell: UITableViewCell {
    
    var pageView:FSPagerView!
    var foodModel:OrderFoodModel? {
        didSet{
            if let model = foodModel{
               self.images = model.data.images
            }
        }
    }
    
    var images = [OrderPagerImage](){
        didSet {
           self.pageController.numberOfPages = images.count
           self.pageController.currentPage = 0
           self.fsPagerView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var fsPagerView:FSPagerView = {
        let fsPagerView = FSPagerView(frame: CGRect.zero)
        fsPagerView.backgroundColor = UIColor.clear
        fsPagerView.delegate = self
        fsPagerView.dataSource = self
        fsPagerView.isInfinite = true
        fsPagerView.automaticSlidingInterval = 5
        fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        return fsPagerView
    }()
    
    lazy var pageController:UIPageControl = {
        let pageController = UIPageControl(frame: CGRect.zero)
        return pageController
    }()
    
    class func getHeight() -> CGFloat {
        return 150
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(fsPagerView)
        fsPagerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        contentView.addSubview(pageController)
        pageController.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.height.equalTo(25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        fsPagerView.transformer = FSPagerViewTransformer(type: .linear)
        fsPagerView.itemSize = fsPagerView.frame.size.applying(transform)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OrderPageCell:FSPagerViewDelegate{
    
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
         pageController.currentPage = pagerView.currentIndex
    }
}

extension OrderPageCell:FSPagerViewDataSource{
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
         return self.images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cell.imageView?.kf.setImage(with: self.images[index].imgUrl, options: [.transition(.fade(0.6))])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }

}
