//
//  CanteenHeaderPagerCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CanteenHeaderPagerCell: UITableViewCell {
    
    var pageView:FSPagerView!
    var pageController:UIPageControl!
    var modelArray = [Advertiselis](){
        didSet{
            pageView.reloadData()
        }
    }
    var selectAction:((_ index:Int) ->Void)?
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        
        pageView = FSPagerView(frame: CGRect.zero)
        contentView.addSubview(pageView)
        pageView.isInfinite = true
        pageView.automaticSlidingInterval = 5
        pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        pageView.delegate = self
        pageView.dataSource = self
        pageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        pageController = UIPageControl()
        contentView.addSubview(pageController)
        pageController.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(20)
        }
    }
    
    class func getHeight() -> CGFloat {
         return 150
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        pageView.transformer = FSPagerViewTransformer(type: .linear)
        pageView.itemSize = pageView.frame.size.applying(transform)
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

        // Configure the view for the selected state
    }

}

extension CanteenHeaderPagerCell:FSPagerViewDelegate {
   
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        selectAction?(index)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView){
         //pageController.currentPage = pageView.currentIndex
    }

}

extension CanteenHeaderPagerCell:FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return modelArray.isEmpty ? 1:modelArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        if !modelArray.isEmpty {
        cell.imageView?.kf.setImage(with: URL(string:modelArray[index].adImage), options: [.transition(.fade(0.6))])
        }
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
   
}
