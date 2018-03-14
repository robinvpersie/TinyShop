//
//  YCInfiniteScrollView.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

struct YCInfiniteItem {
    var imageUrl:URL
    var imageVer:String
}


class YCInfiniteScrollView: UIView {
    
    var autoscroll:Bool = true {
        didSet{
            invalidateTimer()
            if autoscroll == true {
               setUpTimer()
            }
        }
    }
    
    var timeInterval:TimeInterval = 5{
        didSet{
            setAutoScroll()
        }
    }
    
    
    fileprivate func setAutoScroll(){
        invalidateTimer()
        if autoscroll == true {
           setUpTimer()
        }
    }

    var scrollViewItem = [YCInfiniteItem](){
        didSet{
            invalidateTimer()
            TotalPageCount = scrollViewItem.count * 100
            setAutoScroll()
            collectionView.reloadData()
        }
    }
    
    var TotalPageCount = 0
    var didSelectItemAtIndex: ((_ index:Int) -> Void)?
    var collectionView:UICollectionView!
    var timer:Timer?
    var collectionViewLayout:UICollectionViewFlowLayout?
    lazy var backGroundImageView:UIImageView = UIImageView()
    
    lazy var backGroundEffectBlurView:UIVisualEffectView = {
         let effectView = UIVisualEffectView()
         effectView.effect = UIVisualEffect()
         return effectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backGroundImageView)
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout?.scrollDirection = .horizontal
        collectionViewLayout?.minimumLineSpacing = 0
        collectionViewLayout?.minimumInteritemSpacing = 0
        collectionView =  UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout!)
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate =  UIScrollViewDecelerationRateFast
        collectionView.registerClassOf(YCInfiniteCollectionCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewLayout?.itemSize = frame.size
        backGroundImageView.frame = bounds
        collectionView.frame = bounds
       if (collectionView.contentOffset.x == 0 && TotalPageCount>0){
           let targetIndex = TotalPageCount/2
           collectionView.scrollToItem(at: IndexPath(row: targetIndex, section: 0), at: .init(rawValue: 0), animated: false)
        }
    }
    
   fileprivate func setUpTimer(){
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timeFire(timer:)), userInfo: nil, repeats: true)
         RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    
    fileprivate func invalidateTimer(){
        if let timer = timer {
           timer.invalidate()
        }
        timer = nil
    }
    
    @objc fileprivate func timeFire(timer:Timer) {
        if TotalPageCount == 0 {
            return
        }
        let currentIndex = self.currentIndex()
        let targetIndex = currentIndex + 1
        scrollToIndex(targetIndex)
    }
    
    func scrollToIndex(_ targetIndex:Int){
        var targetIndex = targetIndex
        if targetIndex >= TotalPageCount {
            targetIndex = Int(TotalPageCount/2)
            let indexpath = IndexPath(item: targetIndex, section: 0)
            collectionView.scrollToItem(at:indexpath , at: .init(rawValue: 0), animated: false)
            return
        }
        collectionView.scrollToItem(at: IndexPath(item:targetIndex,section:0), at: .init(rawValue: 0), animated: true)
    }
    
    func currentIndex() -> Int {
        if collectionView.width == 0 || collectionView.height == 0 {
           return 0
        }
        var index = 0
        if collectionViewLayout?.scrollDirection == .horizontal {
         index = Int((collectionView.contentOffset.x + (collectionViewLayout?.itemSize.width)! * 0.5) / (collectionViewLayout?.itemSize.width)!)
        }else {
           index = Int((collectionView.contentOffset.y + (collectionViewLayout?.itemSize.height)! * 0.5 ) / (collectionViewLayout?.itemSize.height)!)
        }
        return max(0, index)
     }
    
    
    
    func adjustWhenControllerViewWillAppear(){
        let targetIndex = currentIndex()
        if targetIndex < TotalPageCount {
            let indexpath = IndexPath(row: targetIndex, section: 0)
            collectionView.scrollToItem(at: indexpath, at: .init(rawValue: 0), animated: false)
        }
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if (newSuperview == nil) {
           invalidateTimer()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




extension YCInfiniteScrollView:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let didselect = didSelectItemAtIndex{
            didselect(indexPath.item % self.scrollViewItem.count)
        }
    }
    
}

extension YCInfiniteScrollView:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TotalPageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:YCInfiniteCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! YCInfiniteCollectionCell
        let index = indexPath.row % scrollViewItem.count
        let item = scrollViewItem[index]
        cell.imageUrl = item.imageUrl

        
    }
}

extension YCInfiniteScrollView:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoscroll {
           invalidateTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoscroll {
            setUpTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(collectionView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollViewItem.count == 0 {
            return
        }
        
    }
    
}



class YCInfiniteCollectionCell:UICollectionViewCell{
    
    var imageUrl:URL!{
       didSet{
        let options:[KingfisherOptionsInfoItem] = [.transition(.fade(0.3))]
        self.imageView.kf.setImage(with: imageUrl , options: options)
       }
    }
    
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        imageView = UIImageView(frame: CGRect.zero)
        imageView.kf.indicatorType = .activity
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class YCInfiniteCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var layoutAttribute:UICollectionViewLayoutAttributes
        let proposedContentOffsetCenterX:CGFloat = proposedContentOffset.x + collectionView!.bounds.size.width * 0.5
        guard let layoutAttributesForElements = layoutAttributesForElements(in: collectionView!.bounds),
              let layoutAttributes = layoutAttributesForElements.first  else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        layoutAttribute = layoutAttributes
        for layoutAttributesForElement in layoutAttributesForElements {
            if layoutAttributesForElement.representedElementCategory != .cell {
                continue;
            }
            let distance1 = layoutAttributesForElement.center.x - proposedContentOffsetCenterX
            let distance2 = layoutAttribute.center.x - proposedContentOffsetCenterX
            if fabs(distance1) < fabs(distance2) {
               layoutAttribute = layoutAttributesForElement
            }
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}
