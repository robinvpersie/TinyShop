//
//  ReservationControllerCells.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import SnapKit

class ReservationBasicCell:UITableViewCell,UITextFieldDelegate {
    
    var valueChangeAction:((String?) -> Void)?
    lazy var leftlable:UILabel = {
       let lable = UILabel()
       lable.textColor = UIColor.darkcolor
       lable.font = UIFont.systemFont(ofSize: 15)
       return lable
    }()
    lazy var textfield:UITextField = {
       let textfield = UITextField()
       textfield.textColor = UIColor.darkcolor
       textfield.font = UIFont.systemFont(ofSize: 15)
       textfield.textAlignment = .right
       textfield.delegate = self
       return textfield
    }()
    var fieldTrailConstraint:Constraint? = nil
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }
    
    func valueChange(){
       self.valueChangeAction?(textfield.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueChangeAction?(textfield.text)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(leftlable)
        contentView.addSubview(textfield)
        makeConstraint()
    }
    
    private func makeConstraint(){
        leftlable.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        textfield.snp.makeConstraints { (make) in
            fieldTrailConstraint = make.trailing.equalTo(contentView).offset(-15).constraint
            make.centerY.equalTo(contentView.snp.centerY)
        }
    
    }
    
    func updateWithTimeStr(_ timeStr:String?){
        guard let timeStr = timeStr else { return }
        textfield.text = timeStr
    }
    
    func updateWithContact(_ contact:String?){
        guard let contact = contact else { return }
        textfield.text = contact
    }
    
    func updateWithPhone(_ phone:String?){
        guard let phone = phone else { return }
        textfield.text = phone
    }
    
    func updateWithNum(_ num:Int?){
        guard let num = num else { return }
        textfield.text = "\(num)"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ReservationSelectCell:ReservationBasicCell{
    
    private lazy var selectBtn:UIButton = {
        let selectBtn = UIButton(type: .custom)
        selectBtn.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        return selectBtn
    }()
    
    lazy var BellReasonBtn:UIButton = {
        let bellBtn = UIButton(type: .custom)
        bellBtn.setTitleColor(UIColor.darkcolor, for: .normal)
        bellBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        bellBtn.addTarget(self, action: #selector(didBell), for: .touchUpInside)
        bellBtn.isHidden = true
        return bellBtn
    }()
    
    lazy var whatkimBtn:UIButton = {
        let whatBtn = UIButton(type: .custom)
        whatBtn.setTitleColor(UIColor.navigationbarColor, for: .normal)
        whatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        whatBtn.addTarget(self, action: #selector(didWhat), for: .touchUpInside)
        whatBtn.setTitle("什么是金钟?", for: .normal)
        whatBtn.isHidden = true 
        return whatBtn
    }()
    
    
    var selectAction:(() ->Void)?
    var BellAction:(()->Void)?
    var whatAction:(()->Void)?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textfield.isHidden = true
        contentView.addSubview(selectBtn)
        contentView.addSubview(whatkimBtn)
        contentView.addSubview(BellReasonBtn)
        makeConstraint()
    }
    
    private func makeConstraint(){
        
        selectBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(20)
        }
        
        whatkimBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(selectBtn.snp.leading).offset(-10)
            make.centerY.equalTo(contentView)
        }
        
        BellReasonBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(whatkimBtn.snp.leading).offset(-10)
            make.centerY.equalTo(contentView)
        }
    }
    
    @objc private func didWhat(){
        whatAction?()
    }
    
    @objc private func didSelect(){
        selectAction?()
    }
    
    @objc private func didBell(){
        BellAction?()
    }

    
    func updateSelected(_ isSelected:Bool){
        if isSelected {
           selectBtn.setImage(UIImage(named: "icon_qq1"), for: .normal)
        }else {
           selectBtn.setImage(UIImage(named: "icon_qq1c"), for: .normal)
        }
    }
    
    class func getHeight() -> CGFloat{
        return 45
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class ReservationRemarkCell:UITableViewCell,YYTextViewDelegate {
    
    lazy var textView:YYTextView = {
        let textView = YYTextView()
        textView.placeholderFont = UIFont.systemFont(ofSize: 15)
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.placeholderText = "备注".localized
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    var valueChangeAction: ((String) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.x = 15
        textView.y = 10
        textView.width = screenWidth - 30
        textView.height = 100
    }
    
    func updateWithRemark(_ remark:String?){
        textView.text = remark
    }
    
    
    
    func textViewDidEndEditing(_ textView: YYTextView) {
        valueChangeAction?(textView.text)
    }
    
    class func getHeight()->CGFloat {
        return 120
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
