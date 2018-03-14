//
//  UpdatePhotoCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class UpdatePhotoCell: UITableViewCell {
    
    var collectionView:UICollectionView!
    var pickImageArray = [UIImage]()
    var choosePhotoAction:(([UIImage]) -> Void)?
    var superController:UIViewController?
    enum sectionType:Int{
       case photo
       case choosePhoto
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let flowlayOut = UICollectionViewFlowLayout()
        flowlayOut.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayOut)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClassOf(UpdatePhotoCollectionCell.self)
        collectionView.registerClassOf(KLProjectDetailCollectionCell.self)
        collectionView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    
    class func getHeight() -> CGFloat {
        return 80
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension UpdatePhotoCell:TZImagePickerControllerDelegate {
   
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
          let oldCount = pickImageArray.count
          pickImageArray.append(contentsOf: photos)
          let newCount = pickImageArray.count
          let indexPaths = Array(oldCount..<newCount).map({
             IndexPath(item: $0, section: sectionType.photo.rawValue)
          })
          let waytoUpdate:UICollectionView.WayToUpdate = .insert(indexPaths)
          waytoUpdate.performWithCollectionView(collectionview: collectionView)
          choosePhotoAction?(pickImageArray)
    }
}

extension UpdatePhotoCell:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .choosePhoto:
            guard let weaksuperView = superController else { return }
            if pickImageArray.count >= 5 {
               YCAlert.alert(title: "最多只能传5张图片", message: nil, dismissTitle: "确定", inViewController: weaksuperView, withDismissAction: nil)
                return
            }
            let maxImagesCount = 5 - pickImageArray.count
            let imagePickerVC = TZImagePickerController(maxImagesCount: maxImagesCount, delegate: self)
            weaksuperView.present(imagePickerVC!, animated: true, completion: nil)
        case .photo:
            let browser = SDPhotoBrowser()
            browser.sourceImagesContainerView = collectionView
            browser.currentImageIndex = indexPath.row
            browser.imageCount = pickImageArray.count
            browser.delegate = self
            browser.show()
          }
    }
}

extension UpdatePhotoCell:SDPhotoBrowserDelegate {
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        
        return pickImageArray[index]
    }
}


extension UpdatePhotoCell:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = sectionType(rawValue: section) else { return 0 }
        switch section {
        case .choosePhoto:
            return 1
        case .photo:
            return pickImageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .choosePhoto:
            let cell:KLProjectDetailCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            cell.imageView.image = UIImage(named: "Iocn_xj")
            return cell
        case .photo:
            let cell:UpdatePhotoCollectionCell = collectionView.dequeueReusableCell(indexpath: indexPath)
            cell.imageView.image = pickImageArray[indexPath.row]
            cell.deleteAction = { [weak cell] in
                guard let strongcell = cell else {
                    return
                }
                let nowIndex = collectionView.indexPath(for: strongcell)
                self.pickImageArray.remove(at: nowIndex!.item)
                collectionView.deleteItems(at: [nowIndex!])
                self.choosePhotoAction?(self.pickImageArray)
            }
            return cell
         }
    }
}

extension UpdatePhotoCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        guard let section = sectionType(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .choosePhoto:
            if pickImageArray.isEmpty {
              return UIEdgeInsetsMake(0, 0, 0, 15)
            }else {
              return UIEdgeInsetsMake(0, 15, 0, 15)
            }
        case .photo:
            return UIEdgeInsetsMake(0, 15, 0, 0)
        }

    }
}


class UpdatePhotoCollectionCell:UICollectionViewCell {
    
    var imageView:UIImageView!
    private var longPress:UILongPressGestureRecognizer!
    var deleteAction:(()->Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        contentView.addSubview(imageView)
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteImage))
        contentView.addGestureRecognizer(longPress)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func deleteImage(){
       deleteAction?()
       deleteAction = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
