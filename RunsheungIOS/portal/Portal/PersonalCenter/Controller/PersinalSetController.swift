//
//  PersinalSetController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Proposer
import SwiftDate
import Alamofire
import Kingfisher
import AdSupport

class PersinalSetController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var showflag:Float = 0
    
    lazy var imagePicker:UIImagePickerController = {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.allowsEditing = true
          return imagePicker
    }()
    
    enum sectionType:Int {
        case avatar
        case sexAndNickName
        case changePassword
        case clearCache
        case changeLanguage
        case logOut
        
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.section)!
        }
        
        init(section:Int){
            self.init(rawValue: section)!
        }
        
        static let count = 6
        
        var numberOfRows: Int {
            switch self {
            case .sexAndNickName:
                return 2
            default:
                return 1
            }
        }
        
        var heightForRowInSection: CGFloat {
            switch self {
            case .avatar:
                return 75
            default:
                return 40
            }
        }
        
        var heightForHeader: CGFloat {
            switch self {
            case .avatar:
                return 0.01
            default:
                return 10
            }
        }
    }
    
    var NickName:String?
    var Sex:String?
    var avatarString:String?
    var token:String?
    var operationQue = OperationQueue()
    
    func getAccountAvatarString() -> String? {
        
        return YCAccountModel.getAccount()?.avatarPath
    }
    
    func getAccountNickName() -> String {
        return YCAccountModel.getAccount()?.userName ?? "您还没有设置昵称".localized
    }
    
    
    func getAccountToken() -> String {
        let models = YCAccountModel.getAccount()
        let tokens = models?.token ?? "ttttt".localized
        let tokenstr = tokens + "|" + models!.ssoId! + "|" + models!.customCode + "|" + models!.pointCardNo!
        return tokenstr
    }
    
    func getAccountSex() -> String{
        if let sex = YCAccountModel.getAccount()?.usersex {
            return sex.rawValue.localized
        }else {
            return "您还没有设置性别".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLanguage(_:)),
                                               name: NSNotification.Name.changeLanguage,
                                               object: nil)
        title = "设置".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(yc_back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkText
        view.backgroundColor = UIColor.BaseControllerBackgroundColor
        
        tableView.tableFooterView = UIView()
        tableView.registerNibOf(PersonalHeaderCell.self)
        tableView.registerClassOf(UITableViewCell.self)
        tableView.registerNibOf(PersonalSexCell.self)
        tableView.registerNibOf(PersonalCleanCell.self)
        tableView.backgroundColor = UIColor.BaseControllerBackgroundColor
        Sex = getAccountSex()
        NickName = getAccountNickName()
        avatarString = getAccountAvatarString()
        token = getAccountToken()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshLanguage(_ noti:Notification){
        tableView.reloadData()
        if showflag == 1 {
            title = "个人信息".localized
        }
        title = "设置".localized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        if showflag == 1 {
            return 3
        }
         return sectionType.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectiontype = sectionType(section: section)
        return sectiontype.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectiontype = sectionType(indexPath: indexPath)
        return sectiontype.heightForRowInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectiontype = sectionType(indexPath: indexPath)
        if sectiontype == .avatar  {
            let cell:PersonalHeaderCell = tableView.dequeueReusableCell()
            cell.descriptionlb.text = "更换头像".localized
            let avatarSize =  PersonalCenterAvatarSize
            let avatarStyle:AvatarStyle = .roundedRectangle(size: CGSize(width:avatarSize,height:avatarSize),
                                                            cornerRadius: avatarSize * 0.5,
                                                            borderWidth: 0)
            let plainAvatar = PlainAvatar(avatarURLString: avatarString ?? "", avatarStyle: avatarStyle)
            cell.avatarImageView.navi_setAvatar(plainAvatar)
            cell.clickImage = { [weak self] in
                guard let strongself = self else { return }
                strongself.choosePhoto(cell: cell)
             }
            return cell
        }else if sectiontype == .sexAndNickName {
            let cell:PersonalSexCell = tableView.dequeueReusableCell()
            if indexPath.row == 0{
               cell.sex.text = "性别".localized
               cell.detail.text = Sex
            }else if indexPath.row == 1 {
               cell.sex.text = "昵称".localized
               cell.detail.text = NickName
            }
            return cell
        }else if sectiontype == .changePassword {
            let cell:PersonalSexCell = tableView.dequeueReusableCell()
            cell.sex.text = "修改密码".localized
            cell.detail.text = nil
            cell.accessoryType = .disclosureIndicator
            return cell
        }else if sectiontype == .clearCache {
            let cell:PersonalCleanCell = tableView.dequeueReusableCell()
            cell.descritionlb.text = "清理缓存".localized
            KingfisherManager.shared.cache.calculateDiskCacheSize(completion: { size in
                let floatSize = CGFloat(size/1024/1024)
                let cacheSize = String(format: "%.1f", floatSize)
                cell.cachesize.text = "\(cacheSize)MB"
            })
            return cell
        }else if sectiontype == .changeLanguage {
            let cell:UITableViewCell = tableView.dequeueReusableCell()
            cell.textLabel?.textColor = UIColor.darkcolor
            cell.textLabel?.text = "修改语言".localized
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textAlignment = .left
            return cell
        }else {
            
            let cell:UITableViewCell = tableView.dequeueReusableCell()
            cell.textLabel?.textColor = UIColor.navigationbarColor
            cell.textLabel?.text = "退出账号".localized
            cell.textLabel?.textAlignment = .center
            return cell
         }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectiontype = sectionType(section: section)
        return sectiontype.heightForHeader
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectiontype = sectionType(indexPath: indexPath)
        switch sectiontype {
        case .logOut:
            YCAlert.confirmOrCancel(title: "提示".localized,
                                    message: "确定要退出账号吗？".localized,
                                    confirmTitle: "确定".localized,
                                    cancelTitle: "取消".localized,
                                    inViewController: self,
                                    withConfirmAction:
            { [weak self] in
                guard let strongself = self else { return }
                strongself.logout()
            })
        case .sexAndNickName:
            if indexPath.row == 0 {
                let alertActionBoy = AlertActionModel(title: "男".localized, action: { [weak self] (action) in
                    guard let strongself = self else { return }
                    strongself.Sex = "男".localized
                    strongself.tableView.reloadSections([1], with: .automatic)
                    strongself.setUserAccount(nickname: strongself.NickName,
                                              gender: "f",
                                              token: strongself.token,
                                              imagePath:strongself.avatarString)
                })
                let alerActionGirl = AlertActionModel(title: "女".localized, action: { [weak self] (action) in
                    guard let strongself = self else { return }
                    strongself.Sex = "女".localized
                    strongself.tableView.reloadSections([1], with: .automatic)
                    strongself.setUserAccount(nickname: strongself.NickName,
                                              gender: "m",
                                              token: strongself.token,
                                              imagePath: strongself.avatarString)
                })
                YCAlert.alertWithModelArray([alertActionBoy,alerActionGirl],
                                            title: "选择性别",
                                            message: nil,
                                            style: .actionSheet,
                                            viewController: self)
            }else {
                YCAlert.textInput(title:"更改昵称".localized,
                                  placeholder: "输入昵称".localized,
                                  oldText: nil,
                                  dismissTitle: "确定".localized,
                                  inViewController: self,
                                  withFinishedAction:
                    { [weak self] str in
                     guard let strongself = self,!str.isEmpty else {
                         self?.showMessage("昵称不能为空")
                         return
                     }
                     strongself.NickName = str
                     tableView.reloadSections([sectiontype.rawValue], with: .automatic)
                     var genderString:String?
                     if strongself.Sex == "男".localized {
                        genderString = "f"
                     }else if strongself.Sex == "女".localized {
                        genderString = "m"
                     }else {
                        genderString = nil
                     }
                    strongself.setUserAccount(nickname: str,
                                              gender: genderString,
                                              token: strongself.token,
                                              imagePath:strongself.avatarString)
                })
            }
        case .clearCache:
            KingfisherManager.shared.cache.clearDiskCache()
            showMessage("删除缓存成功".localized)
            tableView.reloadSections([sectiontype.rawValue], with: .automatic)
        case .changePassword:
            let changePassword = ChangePassWordController()
            navigationController?.pushViewController(changePassword, animated: true)
        case .changeLanguage:
            let language = SetLanguageController()
            navigationController?.pushViewController(language, animated: true)
        default:
            break
        }
    }
    
    
    func setUserAccount(nickname:String?,
                        gender:String?,
                        token:String?,
                        imagePath:String? = nil)
    {
        
        CheckToken.chekcTokenAPI { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let check):
                if check.status == "1" {
                    setAccount(memberId: check.custom_code)
                }else {
                    YCUserDefaults.accountModel.value = nil
                    this.goToLogin()
                }
            case .failure(let error):
                this.showMessage(error.localizedDescription)
            }
        }
        
        func setAccount(memberId:String){
            showLoading()
            KLHttpTool.rsSetPersonalInfomationwithMemberId(memberId,
                                                           withNickName: nickname,
                                                           withImagePath: imagePath,
                                                           withGender: gender,
                                                           withToken: token,
                                                           success:
            { [weak self] result in
                guard let this = self else { return }
                this.hideLoading()
            }) { (error) in
                
            }
//            PersonalSetMemberProfile(memberId: memberId,nickName: nickname, imagePath: imagePath, gender: gender,token:token, completion: { [weak self] result  in
//               guard let strongself = self else { return }
//               strongself.hideLoading()
//            })
        }
    }
    
    
    func choosePhoto(cell:PersonalHeaderCell){
        
        let alertController = UIAlertController(title: "选择照片".localized, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消".localized, style: .cancel) {_ in}
        alertController.addAction(cancelAction)
        let CameroAction = UIAlertAction(title: "拍照".localized, style: .default) { action in
            proposeToAccess(.camera, agreed: { [weak self] in
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
                if let strongself = self {
                   strongself.imagePicker.sourceType = .camera
                   strongself.present(strongself.imagePicker, animated: true, completion: nil)
                }
            }, rejected: {})
        }
        alertController.addAction(CameroAction)
        let AlbumAction = UIAlertAction(title: "相册".localized, style: .default, handler: { action in
            proposeToAccess(.photos, agreed: { [weak self] in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
                if let strongself = self {
                    strongself.imagePicker.sourceType = .photoLibrary
                    strongself.present(strongself.imagePicker, animated: true, completion: nil)
                }}, rejected: {})
        })
        alertController.addAction(AlbumAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func logout(){
      showLoading()
      logOut { [weak self] result in
        guard let strongself = self else { return }
        strongself.hideLoading()
        switch result {
        case .success(let data):
            let json = JSON(data)
            let status = json["status"].string
            if status == "1" {
               YCUserDefaults.accountModel.value = nil
               strongself.navigationController?.viewControllers.forEach({ x in
                if x is YCHomeController {
                  strongself.navigationController?.popToViewController(x, animated: true)
                }
               })
            }
        case .failure(let error):
            strongself.showMessage(error.localizedDescription)
        }
      }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        if let Image = info[UIImagePickerControllerEditedImage] as? UIImage {
         let imageData = UIImageJPEGRepresentation(Image, 1)!
         let currentDateStr = "WPortal" +  Date().string(custom: "YYYYMMddhhmmss") + ".jpg"
         let uploadAttachment = UploadAttachment(attType: .avatar,
                                                 source: .data(imageData),
                                                 fileExtension: .jpeg,
                                                 fileName: currentDateStr)
         showLoading()
         let uploadOperation = UploadAttachmentOperation(uploadAttachment: uploadAttachment,
                                                         completion:
            {  [weak self] result in
                guard let this = self else { return }
                this.hideLoading()
                switch result {
                   case .success:
                    var genderString:String?
                    var imagepath:String?
                    if this.Sex == "男".localized {
                        genderString = "F"
                    }else if this.Sex == "女".localized {
                        genderString = "M"
                    }
                    imagepath = BaseType.PortalBase.baseURL + "/MediaUploader/wsProfile/" + currentDateStr
                    KingfisherManager.shared.cache.store(Image, original: imageData,
                                                         forKey: imagepath!,
                                                         toDisk: true,
                                                         completionHandler: nil)
                    this.setUserAccount(nickname: this.NickName,
                                        gender: genderString,
                                        token: this.token,
                                        imagePath: imagepath)
                  
                   case .failed(errorMessage: let errormessage):
                    this.showMessage(errormessage)
                }
             })
            operationQue.addOperation(uploadOperation)
            let  EditedImage = Image.yc.resizeToTargetSize(targetSize: CGSize(width: 45, height: 45))
            let indexpath = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexpath) as? PersonalHeaderCell
                cell?.avatarImageView.image = EditedImage
        } else {
           print("image has no CGImageRef or invalid bitmap format")
        }
    }
}


extension PersinalSetController {
    
    public func PersonalSetMemberProfile(memberId:String,
                                         nickName:String?,
                                         imagePath:String?,
                                         gender:String?,
                                         token:String?,
                                         completion:@escaping (NetWorkResult<JSONDictionary>) -> Void)
    {
          var requestParameters:[String:Any] = [:]
          requestParameters["memberID"] = memberId
          if let nickName = nickName {
              requestParameters["nickName"] = nickName
          }
          if let gender = gender {
             requestParameters["gender"] = gender
          }
          if let imagePath = imagePath {
             requestParameters["imagePath"] = imagePath
          }
          if let token = token {
            requestParameters["token"] = token
          }
        
          let parse:(JSONDictionary) -> JSONDictionary = { json in
            let jsonData = JSON(json)
            let resultCode = jsonData["ResultCode"].intValue
            
            func setAccount(_ account:YCAccountModel){
                account.userName = nickName ?? ""
                account.avatarPath = imagePath ?? ""
                if gender == "M" {
                    account.usersex = YCAccountModel.userSex.girl
                }else if gender == "F"{
                    account.usersex = YCAccountModel.userSex.boy
                }
                let objectTodata = NSKeyedArchiver.archivedData(withRootObject: account)
                YCUserDefaults.accountModel.value = objectTodata
            }
            
            if resultCode == 0 {
                if let account = YCAccountModel.getAccount() {
                    setAccount(account)
                }else {
                    let account = YCAccountModel()
                    setAccount(account)
                }
            }
            return json
        }
        let rsResource = RSEditProfileResource(path: "/api/member/editProfile",
                                               method: .post,
                                               parameters: requestParameters,
                                               parse: parse)
        
        YCProvider.requestDecoded(rsResource, completion: completion)
    }
    
    func logOut(completion:@escaping (NetWorkResult<JSONDictionary>) -> Void) {
        
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                log(memid: check.custom_code)
            case .failure(let error):
                break
            }
        }
        
        func log(memid:String){
            
          let parse:(JSONDictionary) -> JSONDictionary? = { Data in
             return Data
          }
          var idfa:String = ""
          if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          }

          let requestParameters: [String:Any] = [
             "id":memid,
             "siteCode":"yc",
             "deviceNo":idfa
          ]
          
            let netResource =  NetResource(baseURL:BaseType.cancle.URI,
                                       path: "/api/apiSSO/setLogout",
                                       method: .post,
                                       parameters: requestParameters,
                                       parameterEncoding:JSONEncoding(),
                                       parse: parse)
           YCProvider.requestDecoded(netResource, completion: completion)
        }
    }

}
