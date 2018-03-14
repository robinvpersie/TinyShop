//
//  YCSegmentView.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/1.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class YCSegmentView: UIView {
    
    var didselectItemAtIndexPath:((_ index:Int) -> Void)?
    var titleForIndex:((_ index:Int)->String)?
    
    var numberOfItems:(() -> Int)?{
        didSet{
            if numberOfItems!() == 0{
              self.UnderLineView.isHidden = true
            }else {
              self.UnderLineView.isHidden = false 
            }
          self.collectionView.reloadData()
        }
    }
    
    var collectionLayoutEdging:CGFloat = 0
    var progressHeight:CGFloat = 1 {
        didSet {
         self.UnderLineView.height = progressHeight
        }
    }
    var progressEdging:CGFloat = 0
    
    var progressWidth:CGFloat = 0 {
        didSet{
          self.UnderLineView.width = progressWidth
        }
    }
    var cellWidth:CGFloat = 0{
        didSet{
         let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
         layout!.itemSize = CGSize(width: cellWidth, height: self.frame.size.height)
        }
    }
    var cellSpacing:CGFloat = 0 {
        didSet{
          let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
          layout!.minimumLineSpacing = cellSpacing
        }
    }
    var cellEdge:CGFloat = 0
    var animationDuration:CGFloat = 0.25
    var selectedTextFont:UIFont = UIFont.systemFont(ofSize: 17)
    var normalTextFont:UIFont = UIFont.systemFont(ofSize: 15)
    var normalTextColor:UIColor = UIColor.darkcolor
    var SelectedTextColor:UIColor = UIColor.navigationbarColor
    var underlineColor:UIColor = UIColor.navigationbarColor{
        didSet{
          self.UnderLineView.backgroundColor = underlineColor
        }
    }
    var currentIndex:Int?{
        didSet{
        var toindexpath:IndexPath!
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
    
    lazy var UnderLineView:UIView = {
      let  UnderLineView = UIView()
      UnderLineView.backgroundColor = self.underlineColor
      return  UnderLineView
     }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = UIColor.clear
        collectionview.registerClassOf(YCSegMentTitleCell.self)
        return collectionview
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        self.backgroundColor = UIColor.clear
        collectionView.addSubview(UnderLineView)
    }
    
    fileprivate func setUnderLineFrameWithIndex(index:Int,animated:Bool){
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
    
    fileprivate func transitionFromCell(_ fromcell:YCSegMentTitleCell?,tocell:YCSegMentTitleCell?){
        if let fromcell = fromcell {
            fromcell.titleLabel.textColor = self.normalTextColor
            let scale = self.normalTextFont.pointSize / self.selectedTextFont.pointSize
            fromcell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
         if let tocell = tocell {
            tocell.titleLabel.textColor = self.SelectedTextColor
            tocell.transform = CGAffineTransform.identity
        }
        
    }
    
   public func reloadData(){
        collectionView.reloadData()
   }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension YCSegmentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = numberOfItems {
            return numberOfItems()
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:YCSegMentTitleCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        if let titleForIndex = titleForIndex {
            let title:String = titleForIndex(indexPath.item)
            cell.titleLabel.text = title
            cell.titleLabel.font = selectedTextFont
          }
        transitionFromCell(indexPath.item == currentIndex ? nil : cell, tocell: indexPath.item == currentIndex ? cell : nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? YCSegMentTitleCell
        if indexPath.row != currentIndex {
            cell?.titleLabel.textColor = self.normalTextColor
            let scale = self.normalTextFont.pointSize / self.selectedTextFont.pointSize
            cell?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }else {
            cell?.titleLabel.textColor = self.SelectedTextColor
            cell?.transform = CGAffineTransform.identity

        }
    }
}


extension YCSegmentView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let didselectItemAtIndexPath = didselectItemAtIndexPath {
            didselectItemAtIndexPath(indexPath.item)
        }
        currentIndex = indexPath.item
        
    }
}

extension YCSegmentView:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellWidth > 0 {
          return CGSize(width: cellWidth, height: self.height)
        }else {
            if let titleForIndex = titleForIndex{
                let title:String = titleForIndex(indexPath.item)
                let width = title.sizeforConstrainedSize(font: self.selectedTextFont, constrainedSize: CGSize(width: 300, height: 100)).width
                return CGSize(width: width + cellEdge * 2, height: self.height)
            }else {
              return CGSize.zero
            }
        }
    }
}
