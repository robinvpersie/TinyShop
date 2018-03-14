//
//  OrderCommentController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

struct CommentRounter:URLRequestConvertible {
    
    let divCode:String
    let orderNumber:String
    let saleCustomCode:String
    let customCode:String
    let content:String
    let score1:Int
    let score2:Int
    let score3:Int
    let Json:[[String:Any]]
    let token:String
    
    internal func asURLRequest() throws -> URLRequest {
        
        let requestParameter:[String:Any] = [
            "divCode":divCode,
            "orderNumber":orderNumber,
            "saleCustomCode":saleCustomCode,
            "customCode":customCode,
            "content":content,
            "score1":score1,
            "score2":score2,
            "score3":score3,
            "token":token
        ]

        let BaseUrl = URL(string: BaseType.canteen.baseURL)!
        var urlRequest = URLRequest(url: BaseUrl.appendingPathComponent(canteenAddCommentKey))
        urlRequest.httpMethod = "POST"
        do {
            let request = try URLEncoding(destination: .queryString).encode(urlRequest, with: requestParameter)
            let jsonEncodeRequest = try JSONEncoding.default.encode(request, withJSONObject: Json)
            return jsonEncodeRequest
        }catch let error {
            throw error
        }
        
    }
}


class OrderCommentController: CanteenBaseViewController {
    
    var orderRow:Int = 0
    var backAction: (()->Void)?
    var divCode:String!
    
    private enum UploadState {
        case Ready
        case Uploading
        case Failed(message: String)
        case Success
    }

    private var uploadState:UploadState = .Ready {
        willSet{
            switch newValue {
            case .Ready:
                break
            case .Uploading:
                break
            case .Failed(message: let message):
                if presentingViewController != nil {
                   YCAlert.alertSorry(message: message, inViewController: self, withDismissAction: { })
                }
            case .Success:
                break
            }
        }
    }
    
    fileprivate enum sectionType:Int {
        case comment
        case photo
    }
    
    fileprivate enum rowType:Int {
       case totalpoint
       case taste
       case text
    }
    
   private var tableView:UITableView!
   private var releaseBtn:UIButton!
   var reservelis:Reservelis!
   fileprivate var pickImageArray = [UIImage]()
   var averagePoint:Double = 0 {
        didSet {
         tableView.reloadRows(at: [IndexPath(row: rowType.totalpoint.rawValue, section: sectionType.comment.rawValue)], with: .none)
         }
    }
    var tastePoint:Double = 0
    var environmentPoint:Double = 0
    var servicePoint:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "评价"
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        view.addSubview(tableView)
        
        releaseBtn = UIButton(type: .custom)
        releaseBtn.backgroundColor = UIColor.navigationbarColor
        releaseBtn.setTitle("立即发布", for: .normal)
        releaseBtn.titleLabel?.textColor = UIColor.white
        releaseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        releaseBtn.addTarget(self, action: #selector(releaseComment), for: .touchUpInside)
        view.addSubview(releaseBtn)
        
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 40, 0))
        }
        
        releaseBtn.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
        }
    }
    
    
    private func UploadComment(_ fileNames:[String]){
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1"{
                   doneWith(userId: check.custom_code, token: check.newtoken)
                }else {
                   self.hideLoading()
                   self.goToLogin()
                }
            case .failure(let error):
                self.hideLoading()
                self.showMessage(error.localizedDescription)
            }
        }
        
        
        func doneWith(userId:String,token:String){
           var jsonArray = [[String:Any]]()
           jsonArray = fileNames.map({
            var dic = [String:Any]()
            dic["fileName"] = $0
            return dic
           })
          let tastecell = tableView.cellForRow(at: IndexPath(row: rowType.taste.rawValue, section: sectionType.comment.rawValue)) as! CommentTasteCell
          let score1 = Int(tastecell.tasteStarView.rating) * 2
          let score2 = Int(tastecell.environmentStarView.rating) * 2
          let score3 = Int(tastecell.servicStarView.rating) * 2
          let textCell = tableView.cellForRow(at: IndexPath(row: rowType.text.rawValue, section: sectionType.comment.rawValue)) as! CommentTextCell
          let content = textCell.textView.text
          let commentRouter = CommentRounter(divCode: self.divCode,
                                           orderNumber: reservelis.orderNum,
                                           saleCustomCode: reservelis.restaurantCode,
                                           customCode: userId,
                                           content: content ?? "",
                                           score1: score1,
                                           score2: score2,
                                           score3: score3,
                                           Json: jsonArray,
                                           token: token)
        
            Alamofire.request(commentRouter).responseJSON { [weak self] response in
                guard let strongself = self else {
                    return
                }
                OperationQueue.main.addOperation {
                strongself.hideLoading()
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
                    if json["status"].intValue == 1 {
                        strongself.uploadState = .Success
                        strongself.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name.OrderRow, object: YCBox<Int>(strongself.orderRow))
                    }else if json["status"].intValue == -9001 {
                        strongself.goToLogin()
                    }else {
                        strongself.uploadState = .Failed(message: "发布评论失败")
                    }
                case .failure(let error):
                    strongself.uploadState = .Failed(message: error.localizedDescription)
                }
                }
            }
          }
       }
    
    
    
    @objc func releaseComment(){
        
        let textCell = tableView.cellForRow(at: IndexPath(row: rowType.text.rawValue, section: sectionType.comment.rawValue)) as! CommentTextCell
        let content = textCell.textView.text
        if content == nil || (content?.characters.isEmpty)! {
            YCAlert.alert(title: "请填写评论", message: nil, dismissTitle: "确定", inViewController: self, withDismissAction: nil)
            return
        }
        
        let uploadImagesQueue = OperationQueue()
        uploadImagesQueue.qualityOfService = .background
        var uploadAttachmentOperations = [UploadAttachmentOperation]()
        var fileNames = [String]()
        var uploadErrorMessage:String?
        showLoading()
        if pickImageArray.isEmpty {
            let uploadFinishOperation = BlockOperation(block: {
                self.UploadComment([])
            })
            uploadImagesQueue.addOperation(uploadFinishOperation)
            return
        }
        
        pickImageArray.forEach { image in
            var target:CGFloat = 0
               if let imageData = image.yc.compressionImageToDataTargetWH(targetWH: &target, maxFilesize: 1048576) {
                let source:UploadAttachment.source = .data(imageData)
                let uploadAttachment = UploadAttachment(attType: .comment, source: source, fileExtension: .jpeg)
                let operation = UploadAttachmentOperation(uploadAttachment: uploadAttachment, completion: { result in
                    switch result {
                    case .success(attachment:let fileName):
                        fileNames.append(fileName as! String)
                    case .failed(errorMessage:let errormessage):
                        uploadErrorMessage = errormessage
                    }
                })
                uploadAttachmentOperations.append(operation)
            }
        }
        
               if uploadAttachmentOperations.count > 1 {
                    for i in 1 ..< uploadAttachmentOperations.count {
                           let previousOperation = uploadAttachmentOperations[i-1]
                           let currentOperation = uploadAttachmentOperations[i]
                           currentOperation.addDependency(previousOperation)
                     }
                    }
                    let uploadFinishOperation = BlockOperation(block: {
                        guard fileNames.count == self.pickImageArray.count else {
                        let message = uploadErrorMessage ?? "uploadFailed"
                            DispatchQueue.main.safeAsync {
                                self.uploadState = .Failed(message: message)
                            }
                            return
                         }
                        self.UploadComment(fileNames)
                    })
        
        
        ///////////////////////create
                   if let lastUploadAttachmentOperation = uploadAttachmentOperations.last {
                        uploadFinishOperation.addDependency(lastUploadAttachmentOperation)
                    }
                    uploadImagesQueue.addOperations(uploadAttachmentOperations, waitUntilFinished: false)
                    uploadImagesQueue.addOperation(uploadFinishOperation)
                    //backAction?()

     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension OrderCommentController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil 
    }
    
}


extension OrderCommentController:UITableViewDataSource {

    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = sectionType(rawValue: section) else { return 0 }
        switch section {
        case .comment:
            return 0
        case .photo:
            return 10
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sectionType(rawValue: section) else { return 0 }
        switch section {
        case .comment:
            return 3
        case .photo:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = sectionType(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .comment:
            guard let rowType = rowType(rawValue: indexPath.row) else { return 0 }
            switch rowType {
            case .totalpoint:
                return TotalPointCell.getHeight()
            case .taste:
                return CommentTasteCell.getHeight()
            case .text:
                return CommentTextCell.getHeight()
            }
        case .photo:
            return UpdatePhotoCell.getHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .comment:
            guard let rowType = rowType(rawValue: indexPath.row) else { fatalError() }
            switch rowType {
            case .totalpoint:
                let cell:TotalPointCell = TotalPointCell(style: .default, reuseIdentifier: nil)
                cell.point = averagePoint
                return cell
            case .taste:
                let cell:CommentTasteCell = CommentTasteCell(style: .default, reuseIdentifier: nil)
                cell.callBackAction = { [weak self] averagePoint in
                    guard let strongself = self else {
                        return
                    }
                    strongself.averagePoint = averagePoint
                }
                cell.tastePoint = self.tastePoint
                cell.environmentPoint = self.environmentPoint
                cell.serviceStarPoint = self.servicePoint
                return cell
            case .text:
                let cell:CommentTextCell = CommentTextCell(style: .default, reuseIdentifier: nil)
                return cell 
            }
        case .photo:
            let cell:UpdatePhotoCell = UpdatePhotoCell(style: .default, reuseIdentifier: nil)
            cell.superController = self
            cell.choosePhotoAction = { [weak self] imageArray in
                guard let strongself = self else {
                    return
                }
                strongself.pickImageArray = imageArray
            }
            return cell
        }
    }
}

