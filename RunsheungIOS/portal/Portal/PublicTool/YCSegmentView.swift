//
//  YCSegmentView.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/1.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class YCSegmentView: UIView {
    
    var didselectItemAtIndexPath:((_ index: Int) -> Void)?
    var titleForIndex:((_ index: Int) -> String?)?
    
    var numberOfItems:(() -> Int)? {
        didSet{
            if let numberOfItems = numberOfItems?(), numberOfItems == 0 {
              self.UnderLineView.isHidden = true
            }else {
              self.UnderLineView.isHidden = false 
            }
            self.collectionView.reloadData()
        }
    }
    
    var collectionLayoutEdging: CGFloat = 0
    var progressHeight: CGFloat = 1 {
        didSet {
         self.UnderLineView.height = progressHeight
        }
    }
    var progressEdging: CGFloat = 0
    
    var progressWidth: CGFloat = 0 {
        didSet{
          self.UnderLineView.width = progressWidth
        }
    }
    var cellWidth: CGFloat = 0{
        didSet{
         let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
         layout?.itemSize = CGSize(width: cellWidth, height: self.frame.size.height)
        }
    }
    var cellSpacing: CGFloat = 0 {
        didSet{
          let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
          layout?.minimumLineSpacing = cellSpacing
        }
    }
    var cellEdge: CGFloat = 0
    var animationDuration: CGFloat = 0.25
    var selectedTextFont = UIFont.systemFont(ofSize: 17)
    var normalTextFont = UIFont.systemFont(ofSize: 15)
    var normalTextColor = UIColor.darkcolor
    var selectedTextColor = UIColor.navigationbarColor
    var selectBackgroundColor = UIColor.white
    var normalBackgroundColor = UIColor.white
    var underlineColor = UIColor.navigationbarColor {
        didSet{
          self.UnderLineView.backgroundColor = underlineColor
        }
    }
    var currentIndex: Int?{
        didSet{
          var toindexpath: IndexPath!
          if let newValue = currentIndex {
              toindexpath = IndexPath(item: newValue, section: 0)
              if let oldValue = oldValue {
                 self.collectionView.scrollToItem(at: toindexpath!, at: .centeredHorizontally, animated: true)
                 self.transitionFromIndex(oldValue, toIndex: newValue, animated: true)
              }else {
                 setUnderLineFrameWithIndex(index: newValue, animated: false)
              }
        }
       }
    }
    
    lazy var UnderLineView: UIView = {
       let underLineView = UIView()
       underLineView.backgroundColor = self.underlineColor
       return underLineView
    }()
    
    var collectionView: UICollectionView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.registerClassOf(YCSegMentTitleCell.self)
        addSubview(collectionView)
        
        collectionView.addSubview(UnderLineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    fileprivate func setUnderLineFrameWithIndex(index: Int, animated: Bool){
        if let numberOfItems = numberOfItems {
            if numberOfItems() == 0 {
                UnderLineView.frame = CGRect.zero
                return
            }
        }
        let cellFrame = cellFrameWithIndex(index: index)
        let progressEdging = progressWidth > 0 ? (cellFrame.size.width - progressWidth)/2 : self.progressEdging
        let progressX = cellFrame.origin.x + progressEdging
        let progressY = cellFrame.size.height - progressHeight
        let width = cellFrame.size.width - 2 * progressEdging
        
        if animated {
          UIView.animate(withDuration: TimeInterval(animationDuration), animations: { 
            self.UnderLineView.frame = CGRect(x: progressX, y: progressY, width: width, height: self.progressHeight)
          })
        }else {
           self.UnderLineView.frame = CGRect(x: progressX, y: progressY, width: width, height: self.progressHeight)
        }
    }
    
    
    fileprivate func cellFrameWithIndex(index:Int) -> CGRect{
        
        if let numberOfItems = numberOfItems {
            if index >= numberOfItems() {
              return CGRect.zero
            }
        }
        let cellAttrs = collectionView.layoutAttributesForItem(at: IndexPath(item: index, section: 0))
        return cellAttrs!.frame
    }
    
    fileprivate func transitionFromIndex(_ fromIndex:Int,toIndex:Int,animated:Bool){
         let fromCell = cellForIndex(fromIndex)
         let toCell = cellForIndex(toIndex)
        transitionFromCell(fromCell as? YCSegMentTitleCell, tocell: toCell as? YCSegMentTitleCell)
        setUnderLineFrameWithIndex(index: toIndex, animated: (fromCell != nil) && animated ? animated:false)
        collectionView.scrollToItem(at: IndexPath(item: toIndex, section: 0) , at: .centeredHorizontally, animated: (toCell != nil) ? true : ((fromCell != nil) && animated) ? animated : false)
    }
    
    
    fileprivate func cellForIndex(_ index:Int) -> UICollectionViewCell?{
        if index >= numberOfItems!() {
            return nil
        }
        return collectionView.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    fileprivate func transitionFromCell(_ fromcell: YCSegMentTitleCell?, tocell: YCSegMentTitleCell?){
        if let fromcell = fromcell {
            fromcell.titleLabel.textColor = normalTextColor
            fromcell.backgroundColor = normalBackgroundColor
            let scale = normalTextFont.pointSize / selectedTextFont.pointSize
            fromcell.transform = CGAffineTransform(scaleX: scale, y: scale)
         }
         if let tocell = tocell {
            tocell.titleLabel.textColor = selectedTextColor
            tocell.transform = CGAffineTransform.identity
            tocell.backgroundColor = selectBackgroundColor
        }
        
    }
    
   public func reloadData(){
        collectionView.reloadData()
   }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension YCSegmentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return numberOfItems?() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: YCSegMentTitleCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        cell.titleLabel.text = titleForIndex?(indexPath.item)
        cell.titleLabel.font = selectedTextFont
        transitionFromCell(indexPath.item == currentIndex ? nil : cell, tocell: indexPath.item == currentIndex ? cell : nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? YCSegMentTitleCell
        if indexPath.row != currentIndex {
            cell?.titleLabel.textColor = normalTextColor
            let scale = normalTextFont.pointSize / selectedTextFont.pointSize
            cell?.transform = CGAffineTransform(scaleX: scale, y: scale)
            cell?.backgroundColor = normalBackgroundColor
        }else {
            cell?.titleLabel.textColor = selectedTextColor
            cell?.transform = CGAffineTransform.identity
            cell?.backgroundColor = selectBackgroundColor
        }
    }
}


extension YCSegmentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didselectItemAtIndexPath?(indexPath.item)
        currentIndex = indexPath.item
    }
}

extension YCSegmentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellWidth > 0 {
          return CGSize(width: cellWidth, height: height)
        }else {
            if let titleForIndex = titleForIndex,
                let title = titleForIndex(indexPath.item) {
                let width = title.sizeforConstrainedSize(font: selectedTextFont, constrainedSize: CGSize(width: 300, height: 100)).width
                return CGSize(width: width + cellEdge * 2, height: height)
            }else {
                return CGSize.zero
            }
        }
    }
}
