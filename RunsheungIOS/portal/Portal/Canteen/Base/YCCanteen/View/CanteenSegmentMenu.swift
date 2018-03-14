//
//  CanteenSegmentMenu.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

struct segmentMenuSelectModel {
    var allSelectIndex:Int = 0
    var nearleftSelectIndex:Int = 0
    var nearrightSelectIndex:Int?
    var sortSelectIndex:Int = 0
    var filterSelectIndex:Int = 0
    var timeIndex:Int?
    var numIndex:Int?
    var serviceIndex:Int?
    var isWatch:Bool = false
    var isholy:Bool = false
}

class CanteenSegmentMenu: UIView {
    
    private lazy var backContainerView:UIButton = {
        let backContainer = UIButton(type: .custom)
        backContainer.addTarget(self, action: #selector(hide), for: .touchUpInside)
        backContainer.backgroundColor = UIColor.black
        backContainer.alpha = 0.5
        return backContainer
    }()
    
    private lazy var underlineView:UIView = {
       let underline = UIView()
       underline.backgroundColor = UIColor.classBackGroundColor
       return underline
    }()
    
    private lazy var backStackView:UIStackView = {
       let stackView = UIStackView()
       stackView.axis = .horizontal
       stackView.alignment = .center
       stackView.distribution = .fillEqually
       stackView.spacing = 0
       return stackView
    }()
    
    lazy var segmentAllView:SegmentAllView = SegmentAllView(with: self, selectIndex: self.allSelectIndex)
    lazy var segmentNearView:SegmentNearView = SegmentNearView(with: self)
    lazy var segmentSortView:SegmentSortView = SegmentSortView(with: self)
    lazy var segmentFilterView:SegmentFilterView = SegmentFilterView(with:self)
    var buttonArray = [UIButton]()
    var DropViewArray = [UIView]()
    weak var superView:UIView?
    var allSelectIndex:Int = 0 {
        didSet{
          self.segmentAllView.selectIndex = self.allSelectIndex
        }
    }
    var nearleftSelectIndex:Int = 0
    var nearrightSelectIndex:Int?
    var sortSelectIndex:Int = 0
    var filterSelectIndex:Int = 0
    var timeIndex:Int?
    var numIndex:Int?
    var serviceIndex:Int?
    var currentIndex:Int?
    var isWatch:Bool = false
    var isholy:Bool = false
    var callBackBlock:((_ model:segmentMenuSelectModel) -> Void)?
    
    var AllTypeModelArray = [CanteenAllTypeModel]()
    {
        didSet{
          let btn = buttonArray[0]
          if !AllTypeModelArray.isEmpty{
            let model = AllTypeModelArray[allSelectIndex]
            btn.setTitle(model.SUBCodeName + "▲", for: .normal)
         }
        }
    }
    
    var placeModel = [CanteenPlaceModel](){
        didSet{
            let btn = buttonArray[1]
            if !placeModel.isEmpty {
              let model = placeModel[nearleftSelectIndex]
              btn.setTitle(model.PlaceName + "▲", for: .normal)
            }
        }
    }
    
    var sortModelArray = [CanteenSortModel](){
        didSet{
            let btn = buttonArray[2]
            if !sortModelArray.isEmpty {
              let model = sortModelArray[sortSelectIndex]
              btn.setTitle(model.SUBCodeName + "▲", for: .normal)
           }
        }
    }
    
    var filterModelArray = [CanteenFilterModel](){
        didSet{
            let btn = buttonArray[3]
            btn.setTitle("筛选"+"▲", for: .normal)
        }
    }
    
    convenience init(with superView:UIView){
       self.init(frame:CGRect.zero)
       self.superView = superView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        addSubview(underlineView)
        addSubview(backStackView)
        makeConstaint()
        DropViewArray = [segmentAllView,segmentNearView,segmentSortView,segmentFilterView]
        buttonArray = Array(0..<4).map({
           let btn = UIButton(type: .custom)
           btn.tag = $0
           btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
           btn.titleLabel?.textAlignment = .center
           btn.setTitleColor(UIColor.darkcolor, for: .normal)
           btn.addTarget(self, action: #selector(didTap(sender:)), for: .touchUpInside)
           backStackView.addArrangedSubview(btn)
           return btn
        })
    }
    
    /// 由于数据是有4个接口分开的，所以必须对应的赋值Model
    func reloadDatas(){
        
        allSelectIndex = 0
        nearleftSelectIndex = 0
        nearrightSelectIndex = nil
        sortSelectIndex = 0
        filterSelectIndex = 0
        timeIndex = nil
        numIndex = nil
        serviceIndex = nil
        isWatch = false
        isholy = false
        hide()
     }
    
    
    @objc private func didTap(sender:UIButton){
        
        if currentIndex == sender.tag {
           hide()
           currentIndex = nil
           return
        }
        hide()
        buttonArray = buttonArray.enumerated().map({ index,button in
            if index == 0 {
                let trangle = index == sender.tag ? "▼":"▲"
                if !AllTypeModelArray.isEmpty{
                     let subCodeName = AllTypeModelArray[allSelectIndex].SUBCodeName
                     button.setTitle(subCodeName+trangle, for: .normal)
                }
            }else if index == 1 {
                let trangle = index == sender.tag ? "▼":"▲"
                   if !AllTypeModelArray.isEmpty {
                     button.setTitle(placeModel[nearleftSelectIndex].PlaceName+trangle, for: .normal)
                    }
                }else if index == 2 {
                 let trangle = index == sender.tag ? "▼":"▲"
                 if !sortModelArray.isEmpty {
                  button.setTitle(sortModelArray[sortSelectIndex].SUBCodeName+trangle , for: .normal)
                 }
                }else {
                  let trangle = index == sender.tag ? "▼":"▲"
                  button.setTitle("筛选"+trangle, for: .normal)
                }
              button.setTitleColor(UIColor.darkcolor, for: .normal)
              return button
         })
        
         sender.setTitleColor(UIColor.navigationbarColor, for: .normal)
          if backContainerView.superview == nil {
            superView?.addSubview(backContainerView)
            backContainerView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalTo(self.superView!)
                make.top.equalTo(self.snp.bottom)
            }
         }

        switch sender.tag {
        case 0:
            segmentAllView.showInView(superView, with: AllTypeModelArray)
            segmentAllView.selectAction = { [weak self] index in
                guard let strongself = self else {
                    return
                }
                strongself.segmentFilterView.remakeAction()
                strongself.allSelectIndex = index
                strongself.hide()
                strongself.needcallBack()
            }
        case 1:
            segmentNearView.showInView(superView, with: placeModel)
            segmentNearView.selectAction = { [weak self] lead , trail in
                guard let strongself = self else {
                    return
                }
                strongself.nearleftSelectIndex = lead
                strongself.nearrightSelectIndex = trail
                strongself.hide()
                strongself.needcallBack()
            }
        case 2:
            segmentSortView.showInView(superView, with: sortModelArray)
            segmentSortView.selectAction = { [weak self] index in
                guard let strongself = self else {
                    return
                }
                strongself.sortSelectIndex = index
                strongself.hide()
                strongself.needcallBack()
            }
        default:
            segmentFilterView.showInView(superView, with: filterModelArray)
            segmentFilterView.callBack = { [weak self] time,num,service,iswatchSelect,isholySelect in
                guard let strongself = self else { return }
                strongself.timeIndex = time
                strongself.numIndex = num
                strongself.serviceIndex = service
                strongself.isWatch = iswatchSelect
                strongself.isholy = isholySelect
                strongself.hide()
                strongself.needcallBack()
            }
        }
        currentIndex = sender.tag
    }
    
    
    private func needcallBack(){
        
        let model = segmentMenuSelectModel(allSelectIndex: allSelectIndex ,
                                           nearleftSelectIndex: nearleftSelectIndex,
                                           nearrightSelectIndex: nearrightSelectIndex,
                                           sortSelectIndex: sortSelectIndex,
                                           filterSelectIndex: filterSelectIndex,
                                           timeIndex: timeIndex,
                                           numIndex: numIndex,
                                           serviceIndex: serviceIndex,
                                           isWatch: isWatch,
                                           isholy: isholy)
        callBackBlock?(model)
     }
    
    private func makeConstaint(){
        
        underlineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
        
        backStackView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self)
            make.bottom.equalTo(underlineView.snp.top)
        }
        
    }
    
    func hide(){
        guard let currentIndex = self.currentIndex else {
            return
        }
        self.backContainerView.removeFromSuperview()
        let dropView = DropViewArray[currentIndex]
        dropView.removeFromSuperview()
        for (index,button) in buttonArray.enumerated() {
            if index == 0 {
                if !AllTypeModelArray.isEmpty{
                    button.setTitle(AllTypeModelArray[allSelectIndex].SUBCodeName + "▲", for: .normal)
               }
            }else if index == 1 {
               if !placeModel.isEmpty {
                 button.setTitle(placeModel[nearleftSelectIndex].PlaceName + "▲", for: .normal)
               }
                
          }else if index == 2 {
                if !sortModelArray.isEmpty {
                  button.setTitle(sortModelArray[sortSelectIndex].SUBCodeName + "▲" , for: .normal)
                }
                
          }else {
               button.setTitle("筛选"+"▲", for: .normal)
           }
            button.setTitleColor(UIColor.darkcolor, for: .normal)
           }
        self.currentIndex = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}





public class leadTrailCell:UITableViewCell {
    
    fileprivate lazy var leadlable:UILabel = {
        let lead = UILabel()
        lead.textColor = UIColor.darkcolor
        lead.font = UIFont.systemFont(ofSize: 14)
        return lead
    }()
    
    fileprivate lazy var traillable:UILabel = {
        let trail = UILabel()
        trail.textColor = UIColor.YClightGrayColor
        trail.font = UIFont.systemFont(ofSize: 14)
        return trail
    }()
    
    var model:(lead:String,trail:String)?{
        didSet{
            if let model = model {
              self.leadlable.text = model.lead
              self.traillable.text = model.trail
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(leadlable)
        contentView.addSubview(traillable)
        makeConstraint()
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? UIColor.classBackGroundColor : UIColor.white
     }
    
    private func makeConstraint(){
        
       leadlable.snp.makeConstraints { (make) in
         make.leading.equalTo(contentView).offset(15)
         make.centerY.equalTo(contentView)
       }
        
       traillable.snp.makeConstraints { (make) in
         make.trailing.equalTo(contentView).offset(-15)
         make.centerY.equalTo(contentView)
       }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

/////////////////
class SegmentAllView:UITableView,UITableViewDelegate,UITableViewDataSource{
    
    var DataSource = [(String,String)](){
        didSet {
           reloadData()
        }
    }
    var selectAction:((_ index:Int)->Void)?
    weak var topView:UIView?
    var selectIndex:Int?
    var AllTypeModelArray = [CanteenAllTypeModel](){
        didSet{
            DataSource = AllTypeModelArray.map({
               return ($0.SUBCodeName,"\($0.CUSTOMCount)")
            })
        }
    }
    
    convenience init(with topView:UIView,selectIndex:Int? ){
       self.init(frame: CGRect.zero, style: .plain)
       self.topView = topView
       self.selectIndex = selectIndex
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.classBackGroundColor
        registerClassOf(leadTrailCell.self)
        rowHeight = 45
        delegate = self
        dataSource = self
        tableFooterView = UIView()
    }
    
    
    func showInView(_ superView:UIView?,with modelArray:[CanteenAllTypeModel]){
       guard let superView = superView else {
         return
        }
       if modelArray.isEmpty {
          return
        }
       superView.addSubview(self)
       AllTypeModelArray = modelArray
       self.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(superView)
            make.top.equalTo(self.topView!.snp.bottom)
            make.height.equalTo(45*6)
       }
        if let selectIndex = self.selectIndex {
           selectRow(at: IndexPath(row: selectIndex, section: 0), animated: false, scrollPosition: .none)
        }
    }
    
    func hideAndDo(complete:(()->Void)?){
         self.removeFromSuperview()
         complete?()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:leadTrailCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! leadTrailCell
        cell.model = DataSource[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        hideAndDo { 
            self.selectAction?(indexPath.row)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


///////////////
class SegmentNearTrailCell:UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.textLabel?.textColor = selected ? UIColor.navigationbarColor:UIColor.darkcolor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class SegmentNearView:UIView,UITableViewDelegate,UITableViewDataSource {
    var leadtableView:UITableView!
    var trailtableView:UITableView!
    var placeModel = [CanteenPlaceModel](){
        didSet{
          leadtableView.reloadData()
          trailtableView.reloadData()
        }
    }
    weak var topView:UIView?
    var leadSelectIndex = 0
    var trailSelectIndex:Int?
    var temporyleadSelectIndex = 0
    var selectAction:((_ lead:Int,_ trail:Int?)->Void)?
    convenience init(with topView:UIView){
        self.init(frame: CGRect.zero)
        self.topView = topView
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leadtableView = UITableView(frame: CGRect.zero, style: .plain)
        leadtableView.delegate = self
        leadtableView.dataSource = self
        leadtableView.registerClassOf(SegmentSortCell.self)
        leadtableView.tableFooterView = UIView()
        addSubview(leadtableView)
        
        trailtableView = UITableView(frame: CGRect.zero, style: .plain)
        trailtableView.delegate = self
        trailtableView.dataSource = self
        trailtableView.registerClassOf(SegmentNearTrailCell.self)
        trailtableView.tableFooterView = UIView()
        addSubview(trailtableView)
        makeConstraint()
    }
    
    private func makeConstraint(){
        leadtableView.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.3)
        }
        
        trailtableView.snp.makeConstraints { (make) in
            make.leading.equalTo(leadtableView.snp.trailing)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
    
    
    func showInView(_ superView:UIView?,with modelArray:[CanteenPlaceModel]){
        guard let superView = superView else { return }
        if modelArray.isEmpty {  return  }
        superView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.leading.equalTo(superView)
            make.trailing.equalTo(superView)
            make.top.equalTo(self.topView!.snp.bottom)
            make.height.equalTo(45*6)
        }
        temporyleadSelectIndex = leadSelectIndex
        placeModel = modelArray
        leadtableView.selectRow(at: IndexPath(row: leadSelectIndex, section: 0), animated: false, scrollPosition: .none)
        if let trail = self.trailSelectIndex {
          trailtableView.selectRow(at: IndexPath(row: trail, section: 0), animated: false, scrollPosition: .none)
        }
        
    }
    
    func hideAndDo(complete:(()->Void)?){
        self.removeFromSuperview()
        complete?()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leadtableView {
           return placeModel.count
        }else {
          if !placeModel.isEmpty {
             return placeModel[temporyleadSelectIndex].FloorList.count
          } else { return 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leadtableView {
            temporyleadSelectIndex = indexPath.row
            trailtableView.reloadData()
        } else {
           trailSelectIndex = indexPath.row
           leadSelectIndex = temporyleadSelectIndex
           hideAndDo {
              self.selectAction?(self.leadSelectIndex,self.trailSelectIndex)
           }
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leadtableView {
            let cell:SegmentSortCell = tableView.dequeueReusableCell()
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }else {
            let cell:SegmentNearTrailCell = tableView.dequeueReusableCell()
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == leadtableView {
           cell.textLabel?.text = placeModel[indexPath.row].PlaceName
        }else {
           cell.textLabel?.text = placeModel[temporyleadSelectIndex].FloorList[indexPath.row].SUBCodeName
            if indexPath.row == trailSelectIndex && temporyleadSelectIndex == leadSelectIndex {
                cell.textLabel?.textColor = UIColor.navigationbarColor
            }else {
                cell.textLabel?.textColor = UIColor.darkcolor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





////////////


class SegmentSortCell:UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? UIColor.classBackGroundColor:UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class SegmentSortView:UITableView,UITableViewDataSource,UITableViewDelegate{
    
    var selectAction:((_ index:Int)->Void)?
    var selectIndex = 0
    var sortModelArray = [CanteenSortModel](){
        didSet{
          reloadData()
        }
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        registerClassOf(SegmentSortCell.self)
        rowHeight = 45
        tableFooterView = UIView()
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
    }
    weak var topView:UIView?
    convenience init(with topView:UIView){
        self.init(frame: CGRect.zero,style:.plain)
        self.topView = topView
    }
    func hideAndDo(complete:(()->Void)?){
        removeFromSuperview()
        complete?()
    }
    
    func showInView(_ superView:UIView?,with modelArray:[CanteenSortModel]){
        guard let superView = superView else { return }
        if modelArray.isEmpty {  return  }
        superView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.leading.equalTo(superView)
            make.trailing.equalTo(superView)
            make.top.equalTo(self.topView!.snp.bottom)
            make.height.equalTo(45*6)
        }
        sortModelArray = modelArray
        selectRow(at: IndexPath(row: selectIndex, section: 0), animated: false, scrollPosition: .none)
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SegmentSortCell = tableView.dequeueReusableCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.darkcolor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = sortModelArray[indexPath.row].SUBCodeName
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        hideAndDo { 
           self.selectAction?(indexPath.row)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



////
class SegmentFilterView:UIView,UITableViewDelegate,UITableViewDataSource {
    
    var watchSelected = false{
        didSet{
          tableView.reloadRows(at: [IndexPath(row: 0, section: sectionType.header.rawValue)], with: .none)
        }
    }
    var holySelected = false{
        didSet{
          tableView.reloadRows(at: [IndexPath(row: 1, section: sectionType.header.rawValue)], with: .none)
        }
    }
    var timeselectIndex:Int?
    var numselectIndex:Int?
    var serviceSelectIndex:Int?
    var titleArray = ["用餐时段".localized,"用餐人数".localized,"餐厅服务".localized]
    var callBack:((_ timeIndex:Int?,_ numIndex:Int?,_ serviceIndex:Int?,_ watchselectd:Bool,_ holySelected:Bool) -> Void)?
    
    enum sectionType:Int{
       case header
       case choose
    }
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(ReservationSelectCell.self)
        tableView.registerClassOf(SegmentFilterChooseCell.self)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var remake:UIButton = {
       let btn = UIButton(type: .custom)
       btn.backgroundColor = UIColor.white
       btn.setTitle("重置".localized, for: .normal)
       btn.setTitleColor(UIColor.darkcolor, for: .normal)
       btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
       btn.addTarget(self, action: #selector(remakeAction), for: .touchUpInside)
       return btn
    }()
    
    lazy var finish:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        btn.setTitle("完成".localized, for: .normal)
        btn.setTitleColor(UIColor.darkcolor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        return btn
    }()

    
    
    var filterArray = [CanteenFilterModel](){
        didSet{
          tableView.reloadData()
        }
    }
    weak var topView:UIView?
    
    convenience init(with topView:UIView){
        self.init(frame: CGRect.zero)
        self.topView = topView
    }
    
    func remakeAction(){
       timeselectIndex = nil
       numselectIndex = nil
       serviceSelectIndex = nil
       watchSelected = false
       holySelected = false
       tableView.reloadData()
    }
    
    func finishAction(){
       callBack?(timeselectIndex,numselectIndex,serviceSelectIndex,watchSelected,holySelected)
    }
    
    
    func hideAndDo(complete:(()->Void)?){
        removeFromSuperview()
        complete?()
    }
    
    func showInView(_ superView:UIView?,with modelArray:[CanteenFilterModel]){
        
        guard let superView = superView else { return }
        superView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.leading.equalTo(superView)
            make.trailing.equalTo(superView)
            make.top.equalTo(self.topView!.snp.bottom)
            make.height.equalTo(Ruler.iPhoneVertical(300, 320, 400, 420).value)
        }
        filterArray = modelArray
    }

    var backView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.classBackGroundColor
        addSubview(tableView)
        tableView.backgroundColor = UIColor.clear
        backView.backgroundColor = UIColor.clear
        addSubview(backView)
        backView.addSubview(remake)
        backView.addSubview(finish)
        makeConstraint()
    }
    
    private func makeConstraint(){
       tableView.snp.makeConstraints { (make) in
          make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 40, 0))
       }
       backView.snp.makeConstraints { (make) in
          make.leading.equalTo(self)
          make.trailing.equalTo(self)
          make.bottom.equalTo(self)
          make.height.equalTo(40)
       }
       
       remake.snp.makeConstraints { (make) in
          make.leading.equalTo(backView).offset(15)
          make.centerY.equalTo(backView)
          make.width.equalTo(50)
          make.height.equalTo(25)
       }
        
       finish.snp.makeConstraints { (make) in
          make.width.equalTo(remake.snp.width)
          make.height.equalTo(remake.snp.height)
          make.centerY.equalTo(remake.snp.centerY)
          make.trailing.equalTo(backView.snp.trailing).offset(-15)
       }
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sectionType(rawValue: section) else { fatalError() }
        switch section {
        case .header:
            return 2
        case .choose:
            return filterArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            let cell:ReservationSelectCell = tableView.dequeueReusableCell()
            cell.selectAction = { [weak self] in
                guard let strongself = self else {
                    return
                }
                if indexPath.row == 0 {
                   strongself.watchSelected = !strongself.watchSelected
                }else {
                   strongself.holySelected = !strongself.holySelected
                }
            }
            return cell
        case .choose:
            let cell:SegmentFilterChooseCell = tableView.dequeueReusableCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            return ReservationSelectCell.getHeight()
        case .choose:
            return SegmentFilterChooseCell.getHeightWithModelArray(filterArray[indexPath.row].subCodeLis)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            let cell = cell as! ReservationSelectCell
            if indexPath.row == 0 {
             cell.leftlable.text = "只看免预约".localized
             cell.updateSelected(watchSelected)
            }else if indexPath.row == 1 {
             cell.leftlable.text = "节假日可用".localized
             cell.updateSelected(holySelected)
            }
        case .choose:
            let cell = cell as! SegmentFilterChooseCell
            cell.titlelable.text = titleArray[indexPath.row]
            cell.filterModel = filterArray[indexPath.row].subCodeLis
            if indexPath.row == 0 {
               cell.selectIndex = timeselectIndex
               cell.callback = { [weak self] index in
                guard let strongself = self else {
                    return
                }
                strongself.timeselectIndex = index
                }
            }else if indexPath.row == 1 {
               cell.selectIndex = numselectIndex
               cell.callback = { [weak self] index in
                guard let strongself = self else {
                    return
                }
                strongself.numselectIndex = index
               }
            }else {
               cell.selectIndex = serviceSelectIndex
               cell.callback = { [weak self] index in
                guard let strongself = self else {
                    return
                }
                strongself.serviceSelectIndex = index
               }
            }
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = sectionType(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .header:
            if indexPath.row == 0 {
              watchSelected = !watchSelected
            }else {
              holySelected = !holySelected
            }
        case .choose:
            break
        }
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}


class SegmentFilterChooseCell:UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var collectionView:UICollectionView!
    var titlelable:UILabel!
    var collectionHeight:Constraint? = nil
    var selectIndex:Int?
        var filterModel = [CanteenFilterSubModel](){
        didSet{
            let rest = filterModel.count % 4
            var line:Int = 0
            if rest == 0 {
                line = filterModel.count/4
            }else {
                line = filterModel.count/4 + 1
            }
            let collectionHeight:Int = line*30+(line-1)*10
            let height = collectionHeight + 48
            self.collectionHeight?.update(offset: height)
            collectionView.reloadData()
        }
    }
    var callback:((_ selectIndex:Int) -> Void)?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titlelable = UILabel()
        titlelable.textColor = UIColor.darkcolor
        titlelable.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titlelable)
        titlelable.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.height.equalTo(18)
        }
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: (screenWidth-60)/4, height: 30)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClassOf(segmentfilterCell.self)
        collectionView.backgroundColor = UIColor.clear
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.top.equalTo(titlelable.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            self.collectionHeight = make.height.equalTo(0).constraint
        }
    }
    
    class func getHeightWithModelArray(_ modelArray:[CanteenFilterSubModel]) -> CGFloat {
        let rest = modelArray.count % 4
        var line:Int = 0
        if rest == 0 {
          line = modelArray.count/4
        }else {
          line = modelArray.count/4 + 1
        }
        let collectionHeight:Int = line*30+(line-1)*10
        let height = collectionHeight + 48
        return CGFloat(height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:segmentfilterCell = collectionView.dequeueReusableCell(indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! segmentfilterCell
        
        cell.name.text = filterModel[indexPath.row].SUB_CODE_NAME
        if indexPath.row == selectIndex {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.backgroundColor = UIColor.navigationbarColor.cgColor
            cell.name.textColor = UIColor.white
        }else {
            cell.layer.borderColor = UIColor.classBackGroundColor.cgColor
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.name.textColor = UIColor.darkcolor
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          selectIndex = indexPath.row
          callback?(selectIndex!)
          collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class segmentfilterCell:UICollectionViewCell {
    
    var name:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 0.5
        name = UILabel()
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 12)
        name.textColor = UIColor.darkcolor
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







