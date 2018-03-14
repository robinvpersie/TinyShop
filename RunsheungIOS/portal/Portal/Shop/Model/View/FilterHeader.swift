//
//  FilterHeader.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SnapKit

//////////////////
class FitlerHeaderView:UIView {
    
    private lazy var synthesize:SynthesizeView = SynthesizeView()
    private lazy var FilterClickDown:FilterClickDownTable = FilterClickDownTable()
    private lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var saleBtn:UIButton = {
        let sale = UIButton(type: .custom)
        sale.setTitle("销量".localized, for: .normal)
        sale.setTitleColor(UIColor.darkcolor, for: .normal)
        sale.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sale.addTarget(self, action: #selector(didSale), for: .touchUpInside)
        return sale
    }()
    
    private lazy var priceview:PriceView = PriceView()
    
    private lazy var underlineView:UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.groupTableViewBackground
       return view
    }()
    
    private var selectIndex:Int?
    
    weak var superView:UIView?
    var callBackAction:((_ sortType:Int?,_ orderType:Int?)->Void)?
    
    convenience init(_ superView:UIView?) {
        self.init(frame: CGRect.zero)
        self.superView = superView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(synthesize)
        self.addSubview(saleBtn)
        self.addSubview(priceview)
        self.addSubview(underlineView)
        makeConstraints()
        
        synthesize.helpAction = { [weak self] in
            guard let strongself = self else {
                return
            }
            strongself.priceview.downOrtop = nil
            strongself.saleBtn.setTitleColor(UIColor.darkText, for: .normal)
            if strongself.FilterClickDown.isshow {
               strongself.FilterClickDown.hide()
            }else {
               strongself.FilterClickDown.showInView(strongself.superView, topView: strongself)
            }
        }
        
        self.FilterClickDown.clickAction = { [weak self] index in
            guard let strongself = self else {
                return
            }
            strongself.saleBtn.setTitleColor(UIColor.darkcolor, for: .normal)
            strongself.priceview.titlelb.textColor = UIColor.darkcolor
             if index == 0 {
               strongself.synthesize.titlelb.text = "评论数量".localized
               strongself.synthesize.titlelb.textColor = UIColor.navigationbarColor
               strongself.callBackAction?(1,nil)
             }else if index == 1 {
               strongself.synthesize.titlelb.text = "上架时间".localized
               strongself.synthesize.titlelb.textColor = UIColor.navigationbarColor
               strongself.callBackAction?(2,nil)
             }else {
               strongself.synthesize.titlelb.text = "人气".localized
               strongself.synthesize.titlelb.textColor = UIColor.navigationbarColor
               strongself.callBackAction?(5,nil)
             }
         }
        
        priceview.priceAction = { [weak self] dt in
            guard let strongself = self else {
                return
            }
            strongself.synthesize.titlelb.textColor = UIColor.darkcolor
            strongself.saleBtn.setTitleColor(UIColor.darkcolor, for: .normal)
            strongself.synthesize.titlelb.text = "综合".localized
            strongself.FilterClickDown.hide()
            if let dt = dt {
                if dt == 0 {
                  strongself.priceview.downOrtop = 1
                  strongself.callBackAction?(4,1)
                }else {
                  strongself.priceview.downOrtop = 0
                  strongself.callBackAction?(4,0)
                }
            }else {
                strongself.priceview.downOrtop = 1
                strongself.callBackAction?(4,1)

            }
        }
    }
    
    private func makeConstraints(){
        
        synthesize.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(1.0/3.0)
        }
        
        saleBtn.snp.makeConstraints { (make) in
            make.width.equalTo(synthesize)
            make.center.equalTo(self)
        }
        
        priceview.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalTo(self)
            make.width.equalTo(synthesize)
        }
        
        underlineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        
    }
    
    @objc private func didSale(){
        self.selectIndex = 1
        self.saleBtn.setTitleColor(UIColor.navigationbarColor, for: .normal)
        self.synthesize.titlelb.textColor = UIColor.darkcolor
        self.priceview.downOrtop = nil
        self.synthesize.titlelb.text = "综合".localized
        self.FilterClickDown.hide()
        self.callBackAction?(3,nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class PriceView:UIView {
    
    fileprivate lazy var upTrangle:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_kdsw")
        return view
    }()
    
    fileprivate lazy var downTrangle:UIImageView = {
        let down = UIImageView()
        down.image = UIImage(named: "icon_kjds")
        return down
    }()
    
     lazy var titlelb:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkcolor
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "价格".localized
        return label
    }()
    
    var downOrtop:Int? = nil{
        didSet{
            guard let dt = downOrtop else {
              upTrangle.image = UIImage(named: "icon_kdsw")
              downTrangle.image = UIImage(named: "icon_kjds")
              return
            }
            if dt == 0 {
               upTrangle.image = UIImage(named: "icon_kds")
               downTrangle.image = UIImage(named: "icon_kjds")
            }else {
               upTrangle.image = UIImage(named: "icon_kdsw")
               downTrangle.image = UIImage(named: "iconx-ki")
            }
        }
    }
    
    fileprivate lazy var trangleContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate lazy var helpBtn:UIButton = {
        let help = UIButton(type: .custom)
        help.addTarget(self, action: #selector(didHelp), for: .touchUpInside)
        return help
    }()
    
    var priceAction:((_ dt:Int?)->Void)?
    
    @objc private func didHelp(){
        priceAction?(downOrtop)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(trangleContainer)
        trangleContainer.addSubview(titlelb)
        
        let width = "综合".localized.widthWithConstrainedWidth(height: 20, font: UIFont.systemFont(ofSize: 14))
        trangleContainer.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(width+12)
            make.height.equalTo(20)
        }
        
        let trangleBaseView = UIView()
        trangleContainer.addSubview(trangleBaseView)
        trangleBaseView.snp.makeConstraints { (make) in
            make.trailing.centerY.equalTo(trangleContainer)
            make.height.equalTo(12)
            make.width.equalTo(5)
        }
        
        trangleBaseView.addSubview(upTrangle)
        trangleBaseView.addSubview(downTrangle)
        
        upTrangle.snp.makeConstraints { (make) in
            make.trailing.top.equalTo(trangleBaseView)
            make.width.height.equalTo(5)
        }
        
        downTrangle.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(trangleBaseView)
            make.width.height.equalTo(5)
        }
        
        titlelb.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(trangleContainer)
        }
        
        addSubview(helpBtn)
        helpBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




/// 综合View
class SynthesizeView:UIView{
    
    fileprivate var trangleView:UIImageView!
    var titlelb:UILabel!
    fileprivate var helpView:UIButton!
    var helpAction:(()->Void)?
    
    @objc private func didHelp(){
        helpAction?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layoutGuide = UILayoutGuide()
        addLayoutGuide(layoutGuide)
        
        titlelb = UILabel()
        titlelb.textColor = UIColor.darkcolor
        titlelb.font = UIFont.systemFont(ofSize: 14)
        titlelb.text = "综合".localized
        titlelb.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titlelb)
        
        trangleView = UIImageView()
        trangleView.image = UIImage(named: "icon_kjds")
        trangleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trangleView)
        
        helpView = UIButton(type: .custom)
        helpView.addTarget(self, action: #selector(didHelp), for: .touchUpInside)
        addSubview(helpView)
        
        let titlelead = NSLayoutConstraint(item: titlelb, attribute: .leading, relatedBy: .equal, toItem: layoutGuide, attribute: .leading, multiplier: 1.0, constant: 0)
        let titleCenterY = NSLayoutConstraint(item: titlelb, attribute: .centerY, relatedBy: .equal, toItem: layoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([titlelead,titleCenterY])
        
        let trangleleading = NSLayoutConstraint(item: trangleView, attribute: .leading, relatedBy: .equal, toItem: titlelb, attribute: .trailing, multiplier: 1.0, constant: 3)
        let trangleHeight = NSLayoutConstraint(item: trangleView, attribute: .height, relatedBy: .equal, toItem: trangleView, attribute: .height, multiplier: 1.0, constant: 5)
        let trangleWidth = NSLayoutConstraint(item: trangleView, attribute: .width, relatedBy: .equal, toItem: trangleView, attribute: .width, multiplier: 1.0, constant: 0)
        let trangleTrail = NSLayoutConstraint(item: trangleView, attribute: .trailing, relatedBy: .equal, toItem: layoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0)
        let trangleCenterY = NSLayoutConstraint(item: trangleView, attribute: .centerY, relatedBy: .equal, toItem: layoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([trangleleading,trangleHeight,trangleWidth,trangleTrail,trangleCenterY])
        
        let layoutHeight = NSLayoutConstraint(item: layoutGuide, attribute: .height, relatedBy: .equal, toItem: layoutGuide, attribute: .height, multiplier: 1.0, constant: 5)
        let layoutCenterY = NSLayoutConstraint(item: layoutGuide, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        let layoutCenterX = NSLayoutConstraint(item: layoutGuide, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([layoutHeight,layoutCenterY,layoutCenterX])
        
        helpView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class FilterClickDownTable:UIView,UITableViewDataSource,UITableViewDelegate{
    
    var clickAction:((_ index:Int)->Void)?
    var bottomConstraint:Constraint? = nil
    var isshow:Bool = false
    
    private lazy var tableview:UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.backgroundColor = UIColor.clear
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.registerClassOf(FilterDownCell.self)
        return table
    }()
    
    private lazy var container:UIButton = {
        let view = UIButton(type: .custom)
        view.addTarget(self, action: #selector(didContainer), for: .touchUpInside)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    func didContainer(){
        self.hide()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.addSubview(tableview)
        self.tableview.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(132)
            self.bottomConstraint = make.bottom.equalTo(self.snp.top).constraint
        }

    }
    
    
    func showInView(_ view:UIView?,topView:UIView){
        guard let superView = view else { return }
        if let _ = self.superview {
           self.removeFromSuperview()
        }
        superView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(superView)
            make.top.equalTo(topView.snp.bottom)
        }
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint?.update(offset: 44 * 3)
        }
        self.isshow = true
    }
    
    func hide() {
        self.removeFromSuperview()
        self.isshow = false
    }
    
    func hideAndAction(_ action:(()->Void)? ){
        
        UIView.animate(withDuration: 0.2, animations: {
        }) { (finish) in
            if finish {
             self.removeFromSuperview()
             self.isshow = false
             action?()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideAndAction { 
          self.clickAction?(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FilterDownCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? FilterDownCell
        if indexPath.row == 0 {
           cell?.textLabel?.text = "评论数量".localized
        }else if indexPath.row == 1{
           cell?.textLabel?.text = "上架时间".localized
        }else {
           cell?.textLabel?.text = "人气".localized
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class FilterDownCell:UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
           self.textLabel?.textColor = UIColor.navigationbarColor
        }else {
           self.textLabel?.textColor = UIColor.darkcolor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

