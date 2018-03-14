//
//  OrderMyCouponController.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import DZNEmptyDataSet
import MBProgressHUD


enum Fromtype {
    case Profile
    case order
}

extension MyCouponContainer:TYPagerControllerDataSource {
    
    func numberOfControllersInPagerController() -> Int {
        
        switch ctType {
          case .order:
            return 1
          case .Profile:
            return 2
        }
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let titleArr = ["可用优惠券","不可用优惠券"]
        return titleArr[index]
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        let coupon = OrderMyCouponController()
        if index == 0 {
          coupon.canUse = .can
        }else {
          coupon.canUse = .cannot
        }
        coupon.fromType = self.ctType
        return coupon
    }
    
}

class MyCouponContainer: CanteenBaseViewController {
    
    
    
    fileprivate var ctType:Fromtype
    
    private lazy var useBt:UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.navigationbarColor
        btn.setTitle("使用", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(didUse), for: .touchUpInside)
        return btn
        
    }()
    
    private lazy var tab:TYTabButtonPagerController = {
        
        let tab = TYTabButtonPagerController()
        tab.showbadge = false
        tab.dataSource = self
        tab.adjustStatusBarHeight = true
        tab.barStyle = .progressView
        tab.cellSpacing = 0
        tab.progressWidth = 45
        tab.cellWidth = screenWidth/2
        tab.normalTextColor = UIColor.darkcolor
        tab.selectedTextColor = UIColor.navigationbarColor
        tab.progressColor = UIColor.navigationbarColor

        return tab
   }()
    
    @objc private func didUse(){
       
    }

    init(type:Fromtype) {
        self.ctType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        title = "优惠券"
        self.addChildViewController(tab)
        view.addSubview(tab.view)

        switch ctType {
        case .order:
            tab.view.frame = CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64 - 50)
            view.addSubview(useBt)
            useBt.snp.makeConstraints({ (make) in
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
                make.bottom.equalTo(view)
                make.height.equalTo(50)
            })

        case .Profile:
            tab.view.frame = CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



class OrderMyCouponController:CanteenBaseViewController,UITableViewDelegate,
UITableViewDataSource,DZNEmptyDataSetSource{
    
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.registerClassOf(CouponBasicCell.self)
        tableView.registerClassOf(CouponCanUseCell.self)
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(topRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        tableView.mj_footer.isHidden = true
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var nextPage:Int = 1
    private var isloading = true
    private var isFetching = false
    
    private var couponlist = [Listcoupon]()
    
    private enum loadState{
       case topRefresh
       case normal
       case loadmore
    }
    
   enum CouponCanUse:Int {
       case can = 1
       case cannot = 0
    }
    var canUse:CouponCanUse = .can
    var fromType:Fromtype = .Profile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        requestWith(.normal)
    }
    
    private func requestWith(_ loadmode:loadState,finish:(()->Void)? = nil){
        
        if isFetching {
            finish?()
            return
        }
        
        if case .loadmore = loadmode {
            if nextPage == 0 {
               tableView.mj_footer.endRefreshingWithNoMoreData()
               return
            }
        }
        
        if loadmode == .topRefresh || loadmode == .normal {
            nextPage = 1
        }
        
    
         MyCouponModel.GetWithType(isUsed: canUse.rawValue, currentPage: nextPage, failureHandler: { reason, errormessage in
             self.showMessage(errormessage)
             self.isloading = false
             self.isFetching = false
             let waytoUpdate:UITableView.WayToUpdate = .reloadData
             waytoUpdate.performWithTableView(tableview: self.tableView)
             finish?()
            
         }) { model in
            
             self.isloading = false
             self.isFetching = false
             var waytoupdate:UITableView.WayToUpdate = .reloadData
             guard let model = model else {
                waytoupdate.performWithTableView(tableview: self.tableView)
                finish?()
                return
             }
            self.nextPage = model.nextPage
            if case .loadmore = loadmode {
                
                let oldCount = self.couponlist.count
                self.couponlist.append(contentsOf: model.listCoupons)
                let newCount = self.couponlist.count
                let indexPaths = Array(oldCount..<newCount).map({ IndexPath(row: $0, section: 0) })
                waytoupdate = .insert(indexPaths)
                waytoupdate.performWithTableView(tableview: self.tableView)
            
            }
            
            if loadmode == .topRefresh || loadmode == .normal {
                self.couponlist = model.listCoupons
                waytoupdate.performWithTableView(tableview: self.tableView)
                self.tableView.mj_footer.endRefreshing()
                if !self.couponlist.isEmpty {
                self.tableView.mj_footer.isHidden = false
                }else {
                self.tableView.mj_footer.isHidden = true 
                }
            }
            finish?()
            
            
        }
    }
    
    @objc private func loadMore(){
       requestWith(.loadmore) { 
          self.tableView.mj_footer.endRefreshing()
        }
    }
    
    @objc private func topRefresh(){
       requestWith(.topRefresh) { 
          self.tableView.mj_header.endRefreshing()
        }
    }
    
    private func fetchAgain(){
        requestWith(.normal)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if isloading {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            return indicator
        } else {
            let nodata = YCNoDataAlertView()
            nodata.freshAction = { [weak self] in
                guard let strongself = self else { return }
                strongself.fetchAgain()
            }
            return nodata
        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return couponlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch canUse {
        case .can:
            switch fromType {
            case .order:
                let cell:CouponCanUseCell = tableView.dequeueReusableCell()
                return cell
            case .Profile:
                let cell:CouponBasicCell = tableView.dequeueReusableCell()
                return cell
            }
        case .cannot:
            let cell:CouponBasicCell = tableView.dequeueReusableCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch canUse {
        case .can:
            switch fromType {
            case .order:
                let cell = cell as! CouponCanUseCell
                cell.updateWithModel(couponlist[indexPath.row])
            case .Profile:
                let cell = cell as! CouponBasicCell
                cell.updateWithModel(couponlist[indexPath.row])
            }
        case .cannot:
            let cell = cell as! CouponBasicCell
            cell.updateWithModel(couponlist[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch canUse {
        case .can:
            return CouponCanUseCell.getHeight()
        case .cannot:
            return CouponBasicCell.getHeight()
        }
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


class CouponBasicCell:UITableViewCell {
    
    
    private var pricelb = UILabel()
    private var discountlb = UILabel()
    private var namelb = UILabel()
    private var timelb = UILabel()
    var containerView = UIView()
    var leadConstraint:Constraint? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        let backGroundImgView = UIImageView()
        backGroundImgView.image = UIImage(named: "redbg")
        containerView.addSubview(backGroundImgView)
        backGroundImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        
        pricelb.textColor = UIColor.white
        pricelb.font = UIFont.systemFont(ofSize: 13)
        
        discountlb.textColor = UIColor.white
        discountlb.font = UIFont.systemFont(ofSize: 11)
    
        let trailStack = UIStackView(arrangedSubviews: [pricelb,discountlb])
        trailStack.alignment = .trailing
        trailStack.distribution = .equalSpacing
        trailStack.spacing = 5
        trailStack.axis = .vertical
        containerView.addSubview(trailStack)
        trailStack.snp.makeConstraints { (make) in
            make.trailing.equalTo(containerView).offset(-10)
            make.centerY.equalTo(containerView)
        }
        
        
        namelb.textColor = UIColor.darkText
        namelb.font = UIFont.systemFont(ofSize: 12)
        
        timelb.textColor = UIColor.darkText
        timelb.font = UIFont.systemFont(ofSize: 11)
        
        let leadStack = UIStackView(arrangedSubviews: [namelb,timelb])
        leadStack.alignment = .leading
        leadStack.distribution = .equalSpacing
        leadStack.spacing = 5
        leadStack.axis = .vertical
        containerView.addSubview(leadStack)
        leadStack.snp.makeConstraints { (make) in
            leadConstraint = make.leading.equalTo(containerView).offset(15).constraint
            make.centerY.equalTo(containerView)
        }
    }
    
    func updateWithModel(_ model:Listcoupon){
        
        namelb.text = model.couponName
        let startTime = model.startDate
        let endTime = model.endDate
        timelb.text = "使用期限 \(startTime)-\(endTime)"
        pricelb.text = "￥" + "\(model.dcAmount)"
        discountlb.text = "满\(model.upperLimitAmount)使用"
    }
    
    class func getHeight() -> CGFloat {
        return 80
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class CouponCanUseCell:CouponBasicCell {
    
    
    private var selectBtn:UIButton!
    
    var selectAction: (()->Void)?
    
    var isSelect:Bool = false {
        didSet{
            if isSelect {
              selectBtn.setImage(UIImage(named: "icon_qq1"), for: .normal)
            }else {
              selectBtn.setImage(UIImage(named: "icon_qq1c"), for: .normal)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        selectBtn = UIButton(type: .custom)
        selectBtn.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        containerView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(10)
            make.centerY.equalTo(containerView)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        self.leadConstraint?.update(offset: 40)
    }
    
    override func updateWithModel(_ model: Listcoupon) {
        super.updateWithModel(model)
        if model.canUse {
            isSelect = true
           //selectBtn.setImage(UIImage(named: "icon_qq1"), for: .normal)
        }else {
            isSelect = false
           //selectBtn.setImage(UIImage(named: "icon_qq1c"), for: .normal)
        }
    }
    
    func didSelect() {
        isSelect = !isSelect
        self.selectAction?()
    }
    
    override class func getHeight() -> CGFloat {
        return super.getHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
