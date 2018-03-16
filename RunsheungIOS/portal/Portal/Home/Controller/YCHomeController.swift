//
//  YCHomeController.swift
//  Portal
//
//  Created by linpeng on 2016/11/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import CryptoSwift
import MJRefresh

class YCHomeController: UIViewController {
    
    enum Section:Int {
        case news
        static let count = 1
        init(indexPath:IndexPath){
           self.init(rawValue: indexPath.section)!
        }
        init(section:Int){
           self.init(rawValue: section)!
        }
    }

    enum UpdateMode{
        case TopRefresh
        case LoadMore
    }
    var itemHeight: Ruler = .iPhoneVertical(140, 140, 150, 160)
    var BannerData = [Bannerdat]()
    var newsData = [Newsdat]()
    var currentPageIndex: Int = 1
    var nextPageIndex: Int?
    var isFetching = false
    var currentVersion: String?
    var currentState: String?
    var divCode: String = "2"
    var needLoadMore: Bool? = true
    var divName: String = "威海市"
    var tableview: UITableView!

    lazy var tableViewHeaderView:YCInfiniteScrollView = {
        let infiniteView = YCInfiniteScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(self.itemHeight.value)))
            infiniteView.didSelectItemAtIndex = { [weak self] index in
                 guard let strongself = self,
                    let url = URL(string:strongself.BannerData[index].url) else { return }
                 let webview = YCWebViewController(url: url)
                 strongself.navigationController?.pushViewController(webview,animated:true)
            }
            infiniteView.timeInterval = 5
            return infiniteView
     }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UIImageView()
        titleView.image = UIImage(named:"img_logo")
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        navigationItem.titleView = titleView
        
        let mineBtn = UIButton(type: .custom)
        mineBtn.setImage(UIImage(named: "icon_topbar_mine")?.withRenderingMode(.alwaysOriginal), for: .normal)
        mineBtn.addTarget(self, action: #selector(clickRightBarItem), for: .touchUpInside)
        mineBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        let rightmineBarItem = UIBarButtonItem(customView: mineBtn)
        
        let qrBtn = UIButton(type: .custom)
        qrBtn.setImage(UIImage(named: "icon_topbar_qr")?.withRenderingMode(.alwaysOriginal), for: .normal)
        qrBtn.addTarget(self, action: #selector(clickQrCodeItem), for: .touchUpInside)
        qrBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        let rightQRItem = UIBarButtonItem(customView: qrBtn)
        
        let rightSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpaceItem.width = -15
        navigationItem.rightBarButtonItems = [rightSpaceItem,rightmineBarItem,rightQRItem]
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.addTarget(self, action: #selector(showBranch), for: .touchUpInside)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leftBtn.setTitleColor(UIColor.darkText, for: .normal)
        leftBtn.setAttributedTitle(combineWith(nil), for: .normal)
        if #available(iOS 11.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        }else {
            leftBtn.contentHorizontalAlignment = .left
            leftBtn.frame = CGRect(x: 0, y: 0, width: Ruler.iPhoneHorizontal(90, 90, 100).value, height: 44)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        }
        
        tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.clear
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let this = self else { return }
            this.updateMainData(mode: .TopRefresh, finish: {
                this.tableview.mj_header.endRefreshing()
                this.tableview.mj_footer.resetNoMoreData()
            })
        })
        tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            guard let this = self else { return }
            this.updateMainData(mode: .LoadMore, finish: {
                if  this.needLoadMore != true {
                    this.tableview.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    this.tableview.mj_footer.endRefreshing()
                }
            })
        })
        tableview.regisiterHeaderFooterClassOf(YCHomeBusinessHeader.self)
        tableview.registerClassOf(YCHomeNewsCell.self)
        tableview.registerNibOf(YCLoadMoreCell.self)
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false 
        }
        tableview.separatorStyle = .none
        view.addSubview(tableview)
        tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableview.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            tableview.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        }
        
        let items:[YCInfiniteItem] = BannerData.map({
            YCInfiniteItem(imageUrl: URL(string:$0.imgUrl)!, imageVer: $0.ver)
        })
        if items.isEmpty {
            tableview.tableHeaderView = nil
        }else {
            tableview.tableHeaderView = tableViewHeaderView
            tableViewHeaderView.scrollViewItem = items
        }

        tableview.mj_header.beginRefreshing()
    }


    func combineWith(_ address: String?) -> NSMutableAttributedString {
        let attritbuteString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        let originalImage = UIImage(named: "icon_topbar_location")?.withRenderingMode(.alwaysOriginal)
        imageAttachment.image = originalImage
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: originalImage!.size.width, height: originalImage!.size.height)
        let imageAttachmentString = NSAttributedString(attachment: imageAttachment)
        attritbuteString.append(imageAttachmentString)
        if let address = address {
            let addressString = NSAttributedString(string: address)
            attritbuteString.append(addressString)
        }
        return attritbuteString
    }
    
    func pushToAppWithSchem(_ schem: String){
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            showLoading()
            CheckToken.chekcTokenAPI { (result) in
                self.hideLoading()
                switch result {
                case .success(let check):
                    if check.status == "1"{
                        let urlstr = "ycapp://\(schem)$\(check.custom_code)$$\(check.newtoken)"
                        let utf8Str = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        guard let utf8 = utf8Str,
                            let url = URL(string: utf8),UIApplication.shared.canOpenURL(url)
                        else {
                            if self.currentVersion == appVersion && self.currentState == "0" {
                                return
                            } else {
                                 YCAlert.confirmOrCancel(title: "提示",
                                                         message: "龙聊暂未安装，是否前往AppStore下载？",
                                                         confirmTitle: "确定",
                                                         cancelTitle: "取消",
                                                         inViewController: self,
                                                         withConfirmAction:
                                    {
                                        let url : URL = URL(string: "itms-apps://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8")!
                                        UIApplication.shared.openURL(url)
                                    })
                                return
                              }
                            }
                       UIApplication.shared.openURL(url)
                    }else {
                      self.goToLogin()
                    }
                case .failure(let error):
                    self.showMessage(error.localizedDescription)
                }
            }
        }
    
    
    func showBranch(){
//        let orderLocation = OrderLocationController()
//        orderLocation.divName = divName
//        self.navigationController?.pushViewController(orderLocation, animated: true)
    }
    
    func updateMainData(mode:UpdateMode,finish:(() -> Void)? = nil){
        
        if isFetching {
            needLoadMore = nil
            finish?()
            return
        }
        
        if case .LoadMore = mode {
         if nextPageIndex == 0 || nextPageIndex == nil{
              needLoadMore = false
              finish?()
              return
            }
         }
        
        if mode == .TopRefresh {
            currentPageIndex = 1
            nextPageIndex = 1
        }
        isFetching = true 
        MainModel.mainHome(place: divCode, bannerType: 1, currentPage: currentPageIndex) { [weak self] result in
            guard let strongself = self else { return }
            strongself.isFetching = false
            switch result {
            case .success(let dataModel):
                strongself.currentPageIndex = dataModel.newsNextPage
                strongself.nextPageIndex = dataModel.newsNextPage
                strongself.currentVersion = dataModel.currentVersion
                strongself.currentState = dataModel.currentState
                var waytoupdate:UITableView.WayToUpdate = .none
                if case .LoadMore = mode {
                    let oldnewsCount = strongself.newsData.count
                    strongself.newsData.append(contentsOf: dataModel.newsData)
                    let newnewsCount = strongself.newsData.count
                    let indexpaths = Array(oldnewsCount..<newnewsCount).map({
                        IndexPath(item: $0, section: Section.news.rawValue)
                    })
                    strongself.tableview.beginUpdates()
                    strongself.tableview.insertRows(at: indexpaths, with: .automatic)
                    strongself.tableview.endUpdates()
                    strongself.needLoadMore = dataModel.newsData.isEmpty ? false : true
                    
                }else {
                    strongself.newsData = dataModel.newsData
                    strongself.BannerData = dataModel.bannerData
                    let items:[YCInfiniteItem] = dataModel.bannerData.map({
                        YCInfiniteItem(imageUrl: URL(string:$0.imgUrl)!, imageVer: $0.ver)
                    })
                    if items.isEmpty {
                        strongself.tableview.tableHeaderView = nil
                    }else {
                        strongself.tableview.tableHeaderView = strongself.tableViewHeaderView
                        strongself.tableViewHeaderView.scrollViewItem = items
                    }
                    waytoupdate = .reloadData
                    waytoupdate.performWithTableView(tableview: strongself.tableview)
                    strongself.needLoadMore = nil
                }
                finish?()
            case .failure:
                strongself.needLoadMore = nil
                finish?()
            }
            
        }
    }
    
    
    @objc func clickQrCodeItem() -> Void{
          let scanController = ZFScanViewController()
          scanController.returnScanBarCodeValue = { result in
            YCScanManager.share.managerWith(didScanResult: result, inController: self)
          }
          present(scanController, animated: true, completion: nil)
     }



    @objc func clickRightBarItem() -> Void {
        showLoading()
        CheckToken.chekcTokenAPI { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let checktoken):
                this.hideLoading()
                if checktoken.status == "1" {
                   let profile = PersonalCenterController()
                   this.navigationController?.pushViewController(profile, animated: true)
                }else {
                   this.goToLogin()
                }
            case .failure:
                this.hideLoading()
            }
        }
    }



   override var preferredStatusBarStyle: UIStatusBarStyle{
         return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}


//extension YCHomeController:UpdateDivCode{
//
//    func updateWithDivCode(_ divCode: String, _ name: String) {
//         self.divCode = divCode
//         self.divName = name
//         YCUserDefaults.HomeDivCode.value = divCode
//         YCUserDefaults.HomeDicName.value = name
//         updateMainData(mode: .TopRefresh)
//    }
//}



extension YCHomeController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(indexPath: indexPath)
        if section == .news{
            let news = newsData[indexPath.row]
            let url = news.url
            let webview = YCWebViewController(url: url)
            self.navigationController?.pushViewController(webview, animated: true)
        }
     }
}


extension YCHomeController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section(section: section)
        switch section {
        case .news:
            let header: YCHomeBusinessHeader = tableview.dequeueReusableHeaderFooter()
            header.updateWithVer(currentVersion, and: currentState)
            header.delegate = self
            return header
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = Section(section: section)
        switch section {
        case .news:
            return YCHomeBusinessHeader.GetHeight(currentVersion, currentState)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(section: section)
        switch section {
        case .news:
            return newsData.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(indexPath: indexPath)
        switch section {
        case .news:
            return YCHomeNewsCell.GetHeight(model: newsData[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(indexPath: indexPath)
        switch section {
        case .news:
               let cell:YCHomeNewsCell = tableView.dequeueReusableCell()
               return cell
          }
     }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! YCHomeNewsCell
        cell.updateWithModel(model: newsData[indexPath.row])
    }
}


extension YCHomeController: SelectItemDelegate {

    func tapItem(type: YCHomeBusinessHeader.BusinessType) {
        switch type {
            case .main:
               let mainVC:CustomerServiceController = CustomerServiceController()
               mainVC.flag = 1
               let navi:UINavigationController = UINavigationController(rootViewController: mainVC)
               present(navi, animated: true, completion: nil)
            case .superMarket:
               let supermarket = SupermarketMainController()
               supermarket.version = currentVersion
               supermarket.state = currentState
               supermarket.divCode = divCode
               supermarket.divName = divName
               present(supermarket, animated: true, completion: nil)
            case .ordermanage:
               let myOrder = SupermarketMyOrderController()
               let navi:UINavigationController = UINavigationController(rootViewController: myOrder)
               present(navi, animated: true, completion: nil)
            case .customerservice:
               let customerVC = RSCustomerService()
               let navi = UINavigationController(rootViewController: customerVC)
               present(navi, animated: true, completion: nil)
            case .wallet:
               pushToAppWithSchem("rswallet")
            case .agency:
               let vc = RSAgencyViewController()
               let navi = UINavigationController(rootViewController: vc)
               present(navi, animated: true, completion: nil)
            case .chat:
               pushToAppWithSchem("rsmain")
            case .addressmanage:
               let supermarketMyaddress = SupermarketMyAddressViewController()
               let navi = UINavigationController(rootViewController: supermarketMyaddress)
               present(navi, animated: true, completion: nil)
        }
     }
}





