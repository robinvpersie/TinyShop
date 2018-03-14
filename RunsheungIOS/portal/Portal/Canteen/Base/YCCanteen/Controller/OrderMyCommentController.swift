//
//  OrderMyCommentController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderMyCommentController: CanteenBaseTableViewController {
    
    var commentModel:CanteenCommentModel?
    var List = [CommentLis]()
    var divCode:String = "1"
    fileprivate var preViewRefrences:[Reference?]?
    fileprivate var previewAttachmentPhotos: [PreviewAttachmentPhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的评论".localized
        tableView.registerClassOf(CommentMerchantCell.self)
        tableView.mj_footer.removeFromSuperview()
        requestWithModel(.Static)
    }
    
    override func topRefresh() {
        
        requestWithModel(.TopRefresh){
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    
    override func loadMore() {
        return 
    }
    
    override func fetchAgain() {
        requestWithModel(.Static)
    }
    
    private func requestWithModel(_ UpdateMode:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching {
           finish?()
           return
        }
        if case .LoadMore = UpdateMode {
            if self.nextPage == 0 {
              finish?()
              return
            }
        }
        if case .TopRefresh = UpdateMode {
            self.nextPage = 0
        }
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1" {
                  doneWithMemid(check.custom_code, token: check.token)
                }else {
                    self.isFetching = false
                    self.isloading = false
                    finish?()
                }
            case .failure(let error):
                self.isFetching = false
                self.isloading = false
                finish?()
            }
        }
        
        func doneWithMemid(_ memid:String,token:String){
          isFetching = true
          CanComment.GetWithDivCode(self.divCode,
                                  currentPage: self.nextPage,
                                  memberId: memid,
                                  token:token,
                                  failureHandler:
         { [weak self] reason, errormessage in
            guard let strongself = self else {
                return
            }
            strongself.isFetching = false
            strongself.isloading = false
            strongself.showMessage(errormessage)
            let waytoUpdate:UITableView.WayToUpdate = .reloadData
            waytoUpdate.performWithTableView(tableview: strongself.tableView)
            finish?()
         }) { [weak self] jsonModel in
            guard let strongself = self else {
                return
            }
            strongself.isFetching = false
            strongself.isloading = false
            var waytoUpdate:UITableView.WayToUpdate = .none
            if let json = jsonModel{
                if json.status == -9001 {
                    strongself.goToLogin(completion: { 
                        if UpdateMode == .Static || UpdateMode == .TopRefresh {
                           strongself.fetchAgain()
                        }
                    })
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                    finish?()
                    return
                }
                
                guard let data = json.data else {
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                    return
                }
                if UpdateMode == .Static || UpdateMode == .TopRefresh {
                   strongself.List = data.List
                   waytoUpdate = .reloadData
                   waytoUpdate.performWithTableView(tableview: strongself.tableView)
                   finish?()
                }else{
                   let oldListCount = strongself.List.count
                   strongself.List.append(contentsOf: data.List)
                   let newListCount = strongself.List.count
                   let indexPathsArray = Array(oldListCount..<newListCount)
                   let indexPaths = indexPathsArray.map({ row -> IndexPath in
                        let indexpath = IndexPath(row: row, section: 0)
                        return indexpath
                    })
                   waytoUpdate = .insert(indexPaths)
                   waytoUpdate.performWithTableView(tableview: strongself.tableView)
                   finish?()
                }
              
            }else {
                if UpdateMode == .Static || UpdateMode == .TopRefresh {
                   strongself.commentModel = nil
                   waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
                finish?()
            }
          }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CommentMerchantCell
        cell.updateWithCommentModel(List[indexPath.row])
        cell.FeedTapImagesAction = { [weak self] transitionViews,urls,image,index in
            guard let strongself = self else { return }
            strongself.preViewRefrences = transitionViews
            let previewAttachmentPhotos = urls.map({
                PreviewAttachmentPhoto(url: $0)
            })
            strongself.previewAttachmentPhotos = previewAttachmentPhotos
            let photos:[Photo] = previewAttachmentPhotos.map({ $0 })
            let initialPhoto = photos[index]
            
            let photosViewController = PhotosViewController(photos: photos, initialPhoto: initialPhoto, delegate: strongself)
            strongself.present(photosViewController, animated: true, completion: nil)
            
        }

        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentMerchantCell = tableView.dequeueReusableCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentMerchantCell.getHeightWithCommentModel(List[indexPath.row])
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
    }

    
}


extension OrderMyCommentController:PhotosViewControllerDelegate {
    
    func photosViewController(_ vc: PhotosViewController, referenceForPhoto photo: Photo) -> Reference? {
        if let previewAttachmentPhoto = photo as? PreviewAttachmentPhoto {
            if let index = previewAttachmentPhotos.index(of: previewAttachmentPhoto) {
                return preViewRefrences?[index]
            }
        }
        return nil
    }
    
    func photosViewController(_ vc: PhotosViewController, didNavigateToPhoto photo: Photo, atIndex index: Int) {
        
    }
    
    func photosViewControllerWillDismiss(_ vc: PhotosViewController) {
        
    }
    
    func photosViewControllerDidDismiss(_ vc: PhotosViewController) {
        preViewRefrences = nil
        previewAttachmentPhotos = []
    }
    
}

