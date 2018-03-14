//
//  CommentTextCell.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit


class CommentTextCell: UITableViewCell,YYTextViewDelegate {

    var textView:YYTextView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        textView = YYTextView(frame: CGRect(x: 15, y: 10, width: screenWidth - 30, height: 150))
        textView.placeholderText = "菜品口味如何，服务周到吗，环境如何？（写够15字，才是好同志）"
        textView.placeholderTextColor = UIColor.YClightGrayColor
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = UIColor.darkcolor
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.returnKeyType = .default
        textView.delegate = self
        contentView.addSubview(textView)

    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func getHeight() -> CGFloat {
        return 20 + 150
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


class CommentTasteCell:UITableViewCell {
    
    
     var tasteStarView:CosmosView!
     var environmentStarView:CosmosView!
     var servicStarView:CosmosView!
    
     var titleStackView:UIStackView!
     var starStackView:UIStackView!
     var desStackView:UIStackView!
     var callBackAction:((Double)->Void)?
    
    var tastePoint:Double = 0{
        didSet {
            tasteStarView.rating = tastePoint
        }
    }
    
    var environmentPoint:Double = 0 {
        didSet{
            environmentStarView.rating = environmentPoint
        }
    }
    
    var serviceStarPoint:Double = 0 {
        didSet{
            servicStarView.rating = serviceStarPoint
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let tastLable = UILabel()
        tastLable.font = UIFont.systemFont(ofSize: 15)
        tastLable.textColor = UIColor.darkcolor
        tastLable.text = "口味"
        
        let environment = UILabel()
        environment.font = UIFont.systemFont(ofSize: 15)
        environment.textColor = UIColor.darkcolor
        environment.text = "环境"
        
        let service = UILabel()
        service.font = UIFont.systemFont(ofSize: 15)
        service.textColor = UIColor.darkcolor
        service.text = "服务"
        
        titleStackView = UIStackView()
        titleStackView.axis = .vertical
        titleStackView.alignment = .leading
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 10
        contentView.addSubview(titleStackView)
        
        
        titleStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        titleStackView.addArrangedSubview(tastLable)
        titleStackView.addArrangedSubview(environment)
        titleStackView.addArrangedSubview(service)
        
        
        tasteStarView = CosmosView()
        tasteStarView.settings.filledImage = UIImage(named:"IOCN_SS")!
        tasteStarView.settings.emptyImage = UIImage(named: "IOCN_XX")!
        tasteStarView.settings.updateOnTouch = true
        tasteStarView.settings.fillMode = .precise
        tasteStarView.settings.minTouchRating = 0
        tasteStarView.settings.starSize = 20
        contentView.addSubview(tasteStarView)
        tasteStarView.snp.makeConstraints { (make) in
            make.top.equalTo(titleStackView)
            make.leading.equalTo(titleStackView.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        
        environmentStarView = CosmosView()
        environmentStarView.settings.filledImage = UIImage(named: "IOCN_SS")!
        environmentStarView.settings.emptyImage = UIImage(named: "IOCN_XX")!
        environmentStarView.settings.starSize = 20
        environmentStarView.settings.fillMode = .precise
        environmentStarView.settings.minTouchRating = 0
        contentView.addSubview(environmentStarView)
        environmentStarView.snp.makeConstraints { (make) in
            make.leading.equalTo(tasteStarView)
            make.trailing.equalTo(tasteStarView)
            make.top.equalTo(tasteStarView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
                
        servicStarView = CosmosView()
        servicStarView.settings.filledImage = UIImage(named: "IOCN_SS")!
        servicStarView.settings.emptyImage = UIImage(named: "IOCN_XX")!
        servicStarView.settings.starSize = 20
        servicStarView.settings.fillMode = .precise
        servicStarView.settings.minTouchRating = 0
        contentView.addSubview(servicStarView)
        servicStarView.snp.makeConstraints { (make) in
            make.leading.equalTo(tasteStarView)
            make.trailing.equalTo(tasteStarView)
            make.top.equalTo(environmentStarView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        tasteStarView.didFinishTouchingCosmos = { [weak self] rating in
            guard let strongself = self else {
               return
            }
            let averagePoint = (rating + strongself.environmentStarView.rating + strongself.servicStarView.rating)/Double(3)
            strongself.callBackAction?(averagePoint)
        }

        environmentStarView.didFinishTouchingCosmos = { [weak self] score in
            guard let strongself = self else {
                return
            }
            let averagePoint = (score + strongself.tasteStarView.rating + strongself.servicStarView.rating)/Double(3)
            strongself.callBackAction?(averagePoint)
        }
        
        servicStarView.didFinishTouchingCosmos = { [weak self] score in
            guard let strongself = self else {
                return
            }
            let averagePoint = (score + strongself.tasteStarView.rating + strongself.environmentStarView.rating)/Double(3)
            strongself.callBackAction?(averagePoint)
        }
    }
    
    class func getHeight() -> CGFloat{
        return 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




