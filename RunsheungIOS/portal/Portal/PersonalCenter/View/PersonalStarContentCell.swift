//
//  PersonalStarContentCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class PersonalStarContentCell: UITableViewCell {
    
    
    
    lazy var PersonalcontentView: PersonalCommentView = {
        let commentView = PersonalCommentView()
        commentView.x = 15
        commentView.width = screenWidth - 30
        return commentView
    }()
    
    lazy var starlabel:UILabel = {
       let lable = UILabel()
      lable.text = "点赞了你这条评论"
      lable.textColor = UIColor.darkcolor
      lable.font = UIFont.systemFont(ofSize: 14)
      return lable
        
    }()
    
    lazy var underlineView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
       return view
    }()
    
    lazy var HeaderView:PersonalStarHeaderView = {
        let personal = PersonalStarHeaderView(frame: CGRect(x: 15, y: 10, width: screenWidth - 30, height: 36))
        return personal
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(HeaderView)
        
        addSubview(starlabel)
        starlabel.x = 15
        starlabel.y = HeaderView.maxy + 10
        starlabel.width = screenWidth - 30
        starlabel.height = 17
        
        addSubview(underlineView)
        underlineView.x = 15
        underlineView.y = starlabel.maxy + 10
        underlineView.width = screenWidth - 30
        underlineView.height = 1
        
        addSubview(PersonalcontentView)
        PersonalcontentView.x = 15
        PersonalcontentView.y = underlineView.maxy + 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithModel(model:RecommanddatPersonalCenter){
        PersonalcontentView.height = PersonalCommentView.getHeightWithModel(model: model)
        PersonalcontentView.updateWithModel(model: model)
        HeaderView.updateWithModel(model: model)
    }
    
    class func getHeightwithModel(model:RecommanddatPersonalCenter) -> CGFloat{
        let height = PersonalCommentView.getHeightWithModel(model: model)
        return 36 + 10 + 17 + 19 + 0.7 + 10 + 10 + height
    
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


