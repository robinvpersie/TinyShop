//
//  OrderPointController.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import MBProgressHUD
import DZNEmptyDataSet

fileprivate enum pointType:Int{
    case all = 1
    case income = 2
    case pay = 3
    
    var stringValue:String {
        switch self {
        case .all:
            return "1"
        case .income:
            return "2"
        case .pay:
            return "3"
        }
    }
}


class OrderPointContainer: UIViewController {
    
    var headerView:UIView!
    var pointlb:UILabel!
    var descriptionlb:UILabel!
    var pageIndex:Int = 1
    
    var myPointModel:MyPointModel?{
        didSet{
            guard let model = myPointModel else { return }
            let mutableAttbute = NSMutableAttributedString()
            let attributestr = NSAttributedString(string: "\(model.pointBalance.tot_mysave)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25),NSForegroundColorAttributeName:UIColor.white])
            mutableAttbute.append(attributestr)
            let point = NSAttributedString(string: "积分".localized,attributes:[NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.white])
            mutableAttbute.append(point)
            pointlb.attributedText = mutableAttbute
        }
    }
    
    var tab:TYTabButtonPagerController!
    var navigationBar:UINavigationBar!
    var customItem: UINavigationItem!

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        headerView = UIView()
        headerView.backgroundColor = UIColor(hex: 0xff7d70)
        view.addSubview(headerView)
        
        descriptionlb = UILabel()
        headerView.addSubview(descriptionlb)
        descriptionlb.textColor = UIColor.white
        descriptionlb.font = UIFont.systemFont(ofSize: 12)
        descriptionlb.text = "小积分大用途".localized
        descriptionlb.translatesAutoresizingMaskIntoConstraints = false
        descriptionlb.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        descriptionlb.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        
        pointlb = UILabel()
        headerView.addSubview(pointlb)
        pointlb.textColor = UIColor.white
        pointlb.translatesAutoresizingMaskIntoConstraints = false
        pointlb.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        pointlb.bottomAnchor.constraint(equalTo: descriptionlb.topAnchor, constant: -15).isActive = true
        
        customItem = UINavigationItem(title: "我的积分".localized)
        customItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow, style: .plain, target: self, action: #selector(yc_back))
        customItem.leftBarButtonItem?.tintColor = UIColor.white
        
        navigationBar = UINavigationBar()
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.items = [customItem]
        navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 19),NSForegroundColorAttributeName:UIColor.white]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        tab = TYTabButtonPagerController()
        tab.automaticallyAdjustsScrollViewInsets = false 
        tab.showbadge = false
        tab.dataSource = self
        tab.adjustStatusBarHeight = true
        tab.barStyle = .progressView
        tab.cellSpacing = 0
        tab.progressWidth = 45
        tab.cellWidth = screenWidth/3
        tab.normalTextColor = UIColor.darkcolor
        tab.selectedTextColor = UIColor.navigationbarColor
        tab.progressColor = UIColor.navigationbarColor
        addChildViewController(tab)
        view.addSubview(tab.view)
        
        fetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            navigationBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let statusHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController!.navigationBar.height
        navigationBar.heightAnchor.constraint(equalToConstant: (statusHeight + navHeight)).isActive = true
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 150)
        tab.view.frame = CGRect(x: 0, y: 160, width: view.width, height: view.height - 160)

    }
    
    func fucking(memid:String,token:String){
        
        MyPointModel.GetWithOption(pointType.all.stringValue, pageIndex: pageIndex, memid: memid, token: token) { [weak self] (result) in
            guard let strongself = self else { return }
            strongself.hideLoading()
            switch result {
            case .success(let model):
                strongself.myPointModel = model
                strongself.tab.reloadData()
            case .failure:
                strongself.tab.reloadData()
            }
        }
    }
    
    private func fetchData(){
        
        MBProgressHUD.showCustomInView(view)
        CheckToken.chekcTokenAPI { (result) in
            switch result {
            case .success(let check):
            if check.status == "1" {
                self.fucking(memid: check.custom_code, token: check.newtoken)
            }else {
                self.hideLoading()
                self.goToLogin()
              }
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                self.hideLoading()
            }
        }
    }
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OrderPointContainer:TYPagerControllerDataSource {
    
    func numberOfControllersInPagerController() -> Int {
        return 3
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let titleArr = ["全部明细".localized,"收入明细".localized,"支出明细".localized]
        return titleArr[index]
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
        let index = index + 1
        guard let type = pointType(rawValue: index) else { return nil }
        let point = OrderPointController(type: type)
        return point
    }
    
}




fileprivate class OrderPointController:CanteenBaseTableViewController{
    
    var type:pointType
    var myPointModel:MyPointModel?
    var pointList = [PointList]()
    var pageIndex:Int = 1
    enum Section:Int{
       case normal
       case loadMore
        static let count:Int = 2
        init(indexPath:IndexPath){
            self.init(rawValue: indexPath.row)!
        }
        init(section:Int){
            self.init(rawValue: section)!
        }
    }
    
    init(type:pointType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.mj_footer.removeFromSuperview()
        tableView.registerClassOf(OrderPointCell.self)
        tableView.registerNibOf(YCLoadMoreCell.self)
        tableView.delegate = self
        requestWithModel(.Static)
    }
    
    private func requestWithModel(_ updateModel:UpdateMode,finish:(()->Void)? = nil){
        
        if isFetching { finish?(); return }
        
        if case .LoadMore = updateModel {
            pageIndex += 1
        }else if case .TopRefresh = updateModel {
            pageIndex = 1
        }
        isFetching = true
        let memid = YCAccountModel.getAccount()?.memid ?? ""
        let token = YCAccountModel.getAccount()?.token ?? ""
        MyPointModel.GetWithOption(type.stringValue, pageIndex: pageIndex, memid: memid, token: token) { [weak self] (result) in
            guard let strongself = self else { return }
            strongself.isloading = false
            strongself.isFetching = false
            var waytoUpdate:UITableView.WayToUpdate!
            switch result {
            case .success(let model):
                if .LoadMore == updateModel {
                    if !model.pointList.isEmpty {
                       let originalCount = strongself.pointList.count
                       strongself.pointList.append(contentsOf: model.pointList)
                       let nowCount = strongself.pointList.count
                       let insertArray = Array(originalCount..<nowCount).map({
                            IndexPath(item: $0, section: Section.normal.rawValue)
                        })
                       waytoUpdate = .insert(insertArray)
                       waytoUpdate.performWithTableView(tableview: strongself.tableView)
                    }else {
                       strongself.pageIndex -= 1
                    }
                }else {
                    strongself.pointList = model.pointList
                    waytoUpdate = .reloadData
                    waytoUpdate.performWithTableView(tableview: strongself.tableView)
                }
            case .failure:
                waytoUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: strongself.tableView)
            }
            finish?()
        }
    }
    
    override func topRefresh() {
        requestWithModel(.TopRefresh) { [weak self] in
          self?.tableView.mj_header.endRefreshing()
        }
    }
    
    
    override func fetchAgain() {
        requestWithModel(.Static) {}
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(section: section)
        switch section {
        case .normal:
            return pointList.count
        case .loadMore:
            return pointList.isEmpty ? 0:1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(indexPath: indexPath)
        switch section {
        case .normal:
            let cell:OrderPointCell = tableView.dequeueReusableCell()
            return cell
        case .loadMore:
            let cell:YCLoadMoreCell = tableView.dequeueReusableCell()
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(indexPath: indexPath)
        switch section {
        case .normal:
            return OrderPointCell.getHeight()
        case .loadMore:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = Section(indexPath: indexPath)
        switch section {
        case .normal:
            let cell = cell as! OrderPointCell
            cell.updateWithModel(pointList[indexPath.row])
        case .loadMore:
            let cell = cell as! YCLoadMoreCell
            if !cell.activityIndicator.isAnimating {
                cell.activityIndicator.startAnimating()
                cell.info = ""
            }
            requestWithModel(.LoadMore, finish: { 
                cell.activityIndicator.stopAnimating()
            })
        }
    }
    
   func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if isloading {
            return nil
        }else {
            let title = "没有积分"
            return NSAttributedString(string: title)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


class OrderPointCell:UITableViewCell {
    
    fileprivate var titlenamelb:UILabel!
    fileprivate var timelb:UILabel!
    fileprivate var detaillb:UILabel!
    fileprivate var leftStack:UIStackView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titlenamelb = UILabel()
        titlenamelb.textColor = UIColor.darkcolor
        titlenamelb.font = UIFont.systemFont(ofSize: 14)
        
        timelb = UILabel()
        timelb.textColor = UIColor.darkcolor
        timelb.font = UIFont.systemFont(ofSize: 11)
        
        leftStack = UIStackView(arrangedSubviews: [titlenamelb,timelb])
        leftStack.distribution = .fillProportionally
        leftStack.axis = .vertical
        leftStack.spacing = 5
        contentView.addSubview(leftStack)
        
        leftStack.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        detaillb = UILabel()
        detaillb.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(detaillb)
        
        detaillb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
    }
    
    func updateWithModel(_ model:PointList){
        
        titlenamelb.text = model.trade_type
        timelb.text = model.trade_date
        if model.trade_money.characters.first == "-" {
          detaillb.textColor = UIColor.navigationbarColor
        }else {
          detaillb.textColor = UIColor(red: 2.0/255.0, green: 169.0/255.0, blue: 239/255.0, alpha: 1)
        }
        detaillb.text = model.trade_money
    
    }
    
    class func getHeight() -> CGFloat {
        return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    

