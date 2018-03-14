//
//  ShopCultureController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopCultureController: ShopTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "文化".localized
        isNeedTopRefresh = false 
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = ShopCultureCell(style: .default, reuseIdentifier: nil)
            return cell
        }else {
            let cell = ShopThankCell(style: .default, reuseIdentifier: nil)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let culture = ShopSbController()
         self.navigationController?.pushViewController(culture, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
           return ShopCultureCell.getHeight()
        }else {
           return ShopThankCell.getHeightWithStr("感谢大家对宇成朝阳广场演艺中心的关注与喜爱，我们将一如既往的为您提供最好的服务")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




class ShopCultureCell:UITableViewCell{
    
    private lazy var imgView:UIImageView = UIImageView(image: UIImage(named: "sbimage"))
        
    private lazy var toplb:UILabel = {
        let toplb = UILabel()
        toplb.textColor = UIColor.navigationbarColor
        toplb.font = UIFont.systemFont(ofSize: 15)
        toplb.textAlignment = .center
        toplb.text = "宇成朝阳广场 CULTURE CENTER"
        return toplb
    }()
    
    private lazy var bottomlb:UILabel = {
        let bottomlb = UILabel()
        bottomlb.textColor = UIColor.darkcolor
        bottomlb.font = UIFont.systemFont(ofSize: 14)
        bottomlb.textAlignment = .center
        bottomlb.text = "为您打造高品质生活！"
        return bottomlb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(imgView)
        self.addSubview(toplb)
        self.addSubview(bottomlb)
        self.makeConstraint()
    }
    
    private func makeConstraint(){
        
       imgView.snp.makeConstraints { (make) in
           make.leading.top.trailing.equalTo(self)
           make.height.equalTo(150)
       }
        
       toplb.snp.makeConstraints { (make) in
           make.leading.equalTo(self).offset(15)
           make.trailing.equalTo(self).offset(-15)
           make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        bottomlb.snp.makeConstraints { (make) in
           make.leading.trailing.equalTo(toplb)
           make.top.equalTo(toplb.snp.bottom).offset(10)
        }
    }
    
    class func getHeight() -> CGFloat {
        return 150 + 10 + 18 + 10 + 18 + 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




class ShopThankCell:UITableViewCell{
    
    private lazy var descritionlb:UILabel = {
        let description = UILabel()
        description.textColor = UIColor.darkcolor
        description.numberOfLines = 0
        description.textAlignment = .center
        description.text = "感谢大家对宇成朝阳广场演艺中心的关注与喜爱，我们将一如既往的为您提供最好的服务"
        description.font = UIFont.systemFont(ofSize: 15)
        return description
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(descritionlb)
        descritionlb.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(5)
            make.trailing.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
        }
    }
    
    func updateWithString(_ str:String){
        
        let mutableAttributeStr:NSMutableAttributedString = NSMutableAttributedString(string: str)
        let paragraph:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 30
        mutableAttributeStr.addAttributes([NSParagraphStyleAttributeName:paragraph], range: NSRange(location: 0, length: mutableAttributeStr.length))
        descritionlb.attributedText = mutableAttributeStr
    }
    
    class func getHeightWithStr(_ str:String) -> CGFloat {
        
        let constraintRect = CGSize(width: screenWidth - 30.0, height: CGFloat(MAXFLOAT))
        let bound = str.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin,.usesFontLeading,.truncatesLastVisibleLine], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil)
        return ceil(bound.height) + 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



