//
//  OrderProfileController.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class OrderProfileController: UITableViewController {
    
    var divCode:String = "1"
    
    enum rowType:Int {
        case point
        case coupon
        case comment
        case collect
        case contact
       
        var image:UIImage?{
            switch self {
            case .comment:
                return UIImage(named: "icon_pjtb")
            case .collect:
                return UIImage(named: "icon_sctb")
            case .contact:
                return UIImage(named: "icon_lxkf")
            case .coupon:
                return UIImage(named: "icon_wdyhj")
            case .point:
                return UIImage(named: "icon_klds")
            }
        }
        var title:String {
            switch self {
            case .comment:
                return "我的评价".localized
            case .collect:
                return "我的收藏".localized
            case .contact:
                return "联系客服".localized
            case .coupon:
                return "我的优惠券".localized
            case .point:
                return "我的积分".localized
            }
        }
        
        init(indexpath:IndexPath){
            self.init(rawValue: indexpath.row)!
        }
    }
    
    private var avatarImgView:UIImageView!
    private var phonelb:UILabel!
    fileprivate var profileInfo:ProfileInfo?{
        didSet{
            if let _ = profileInfo {
              self.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
                if check.status == "1"{
                    self.GetProfile(memid:check.custom_code,token:check.newtoken)
                    self.GetInfo(memid:check.custom_code,token:check.newtoken)
                }else {
                   self.phonelb.text = "尚未登录".localized
                   self.avatarImgView.image = UIImage.YCAvatarPlaceHolderImage
                }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = HeaderView()
        tableView.registerClassOf(fuckingCell.self)
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 10
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        if let imagePath = YCAccountModel.getAccount()?.avatarPath,let imageUrl = URL(string: imagePath) {
            avatarImgView.kf.setImage(with: imageUrl)
        }
    }
    
    private func GetProfile(memid:String,token:String){
        
        PersonalGetProfileModel.Get(memberID:memid,token:token) { [weak self] result in
            guard let strongself = self else {  return }
            switch result {
            case .success(let jsonData):
                if let status = jsonData.status,status != "1" {
                   YCUserDefaults.accountModel.value = nil
                   strongself.goToLogin()
                   let msg = jsonData.msg
                   MBProgressHUD.hideAfterDelay(view: UIApplication.shared.keyWindow!, text: msg)
                }else {
                  let avatar = PlainAvatar(avatarURLString: jsonData.imagePath!, avatarStyle: miniAvatarStyle)
                  strongself.avatarImgView.navi_setAvatar(avatar)
                  strongself.phonelb.text = jsonData.nickName
                }
            case .failure(let error):
                strongself.showMessage(error.localizedDescription)
            }
          }
     }
    
    private func HeaderView() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.frame.size = CGSize(width: screenWidth, height: 200)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "grbg")
        headerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(headerView)
        }
        
        avatarImgView = UIImageView()
        headerView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView)
            make.top.equalTo(headerView).offset(60)
            make.width.height.equalTo(60)
        }
        avatarImgView.isUserInteractionEnabled = true
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.cornerRadius = 30
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OrderProfileController.didTap))
        avatarImgView.addGestureRecognizer(tapGesture)
        
        phonelb = UILabel()
        phonelb.textColor = UIColor.darkcolor
        phonelb.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(phonelb)
        phonelb.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView)
            make.top.equalTo(avatarImgView.snp.bottom).offset(10)
        }
        return headerView
    }
    
    @objc private func didTap(){
       if !YCAccountModel.islogin() {
           self.goToLogin()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = rowType(indexpath: indexPath)
        let cell:fuckingCell = tableView.dequeueReusableCell()
        cell.textLabel?.textColor = UIColor.darkcolor
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = type.title
        cell.imageView?.image = type.image
        cell.accessoryType = .disclosureIndicator
        if let pro =  self.profileInfo {
        switch type {
        case .point:
            cell.fuckinglable.text = "(\(String(describing: pro.points)))"
        case .comment:
            cell.fuckinglable.text = "(\(String(describing: pro.commentcount)))"
        case .collect:
            cell.fuckinglable.text = "(\(String(describing: pro.favoratecount)))"
        case .coupon:
            cell.fuckinglable.text = "(\(String(describing: pro.couponCount)))"
        default:
            break
        }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        func checkIsLogin(_ completion:@escaping (_ isloging:Bool)->Void){
            CheckToken.chekcTokenAPI { (result) in
                switch result {
                case .success(let check):
                    if check.status == "1" {
                        completion(true)
                    }else {
                       self.goToLogin()
                       completion(false)
                    }
                case .failure(let error):
                    self.showMessage(error.localizedDescription)
                    completion(false)
                }
            }
        }
        let rowtype = rowType(indexpath: indexPath)
        switch rowtype {
        case .collect:
            checkIsLogin({ islogin in
                if islogin {
                    let collect = OrderMyCollectController()
                   collect.hidesBottomBarWhenPushed = true
                   self.navigationController?.pushViewController(collect, animated: true)
                 }
            })
        case .comment:
             checkIsLogin({ islogin in
                if islogin {
                  let comment = OrderMyCommentController()
                  comment.divCode = self.divCode
                  comment.hidesBottomBarWhenPushed = true
                  self.navigationController!.pushViewController(comment, animated: true)
                }
           })
        case .contact:
            let request = URLRequest(url: URL(string: "http://ssadmin.gigawon.co.kr:8090/20_CM/cmList.aspx")!)
            let web = EatWebController(url: request)
            web.hidesBottomBarWhenPushed = true
            web.title = "联系客服".localized
            self.navigationController?.pushViewController(web, animated: true)
        case .coupon:
            YCAlert.alertSorry(message: "正在准备中", inViewController: self)
            return
//            if checkIsLogin() {
//            let myContainer = MyCouponContainer(type:.Profile)
//            myContainer.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(myContainer, animated: true)
//            }
        case .point:
            checkIsLogin({ islogin in
                if islogin {
                  let orderPoint = OrderPointContainer()
                  orderPoint.hidesBottomBarWhenPushed = true
                  self.navigationController?.pushViewController(orderPoint, animated: true)
                }
            })
        }

    }
}


extension OrderProfileController {
    
    func GetInfo(memid:String,token:String){
        
      let requestParameters:[String:Any] = [
          "userID":memid,
          "token":token
       ]
       let parse:(JSONDictionary) -> ProfileInfo? = { json in
            if let data = json["data"] as? JSONDictionary {
             let info = ProfileInfo(json: data)
             return info
            }
            return nil
        }
       let netReource = NetResource(baseURL: BaseType.canteen.URI,
                                      path: "/MyInfo",
                                      method: .post,
                                      parameters: requestParameters,
                                      parameterEncoding: URLEncoding(destination: .queryString),
                                      parse: parse)
        YCProvider.requestDecoded(netReource) { [weak self] result in
            guard let strongself = self else { return }
            switch result {
               case .success(let json):
                   strongself.profileInfo = json
               case .failure:
                break
            }
            
        }
     }
}


class fuckingCell:UITableViewCell {
    
    var fuckinglable:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fuckinglable = UILabel()
        fuckinglable.textColor = UIColor.navigationbarColor
        fuckinglable.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(fuckinglable)
        fuckinglable.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


fileprivate struct ProfileInfo {
    let points:Float
    let couponCount:String
    let commentcount:String
    let imgpath:String
    let favoratecount:String
    let nickName:String
    
    init(json:JSONDictionary) {
       self.points = json["POINTS"] as! Float
       self.couponCount = json["COUPONCOUNT"] as! String
       self.commentcount = json["COMMENTCOUNT"] as! String
       self.imgpath = json["IMG_PATH"] as! String
       self.favoratecount = json["FAVORATECOUNT"] as! String
       self.nickName = json["NICK_NAME"] as! String
    }

}
