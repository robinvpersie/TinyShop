//
//  PersonalMyStarCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/24.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class PersonalMyStarCell: UITableViewCell {
    
    lazy var HeaderView:PersonalStarHeaderView = {
        let personal = PersonalStarHeaderView(frame: CGRect(x: 15, y: 10, width: screenWidth - 30, height: 36))
        personal.didclickStarImage = { isstar in
          self.clickstar?(isstar)
        }
        return personal
     }()
    
    var clickstar:((_ isstar:Bool) -> ())?
    
    lazy var PersonalcontentView: PersonalCommentView = {
        let commentView = PersonalCommentView()
        commentView.x = 15
        commentView.width = screenWidth - 30
        return commentView
    }()

     override init(style: UITableViewCellStyle, reuseIdentifier: String?){
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(HeaderView)
        addSubview(PersonalcontentView)
     }
    
    
    func updateWithModel(model:RecommanddatPersonalCenter){
        PersonalcontentView.y = CGFloat(15 + 36 + 15)
        PersonalcontentView.height = PersonalCommentView.getHeightWithModel(model: model)
        PersonalcontentView.updateWithModel(model: model)
        HeaderView.updateWithModel(model: model)
    }
    
    class func getHeightwithModel(model:RecommanddatPersonalCenter) -> CGFloat{
        let height = PersonalCommentView.getHeightWithModel(model: model)
        return  15 + 36 + 15 + height + 15
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
