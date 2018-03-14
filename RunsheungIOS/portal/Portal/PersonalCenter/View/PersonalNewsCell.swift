//
//  PersonalNewsCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit

class PersonalNewsCell: UITableViewCell {
    
    
    
    lazy var timelabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.YClightGrayColor
        label.x = 15
        label.y = 10
        label.height = 15
        label.width = screenWidth - 15
        return label
    }()
    
    lazy var PersonalcontentView: PersonalCommentView = {
        let commentView = PersonalCommentView()
        commentView.x = 15
        commentView.width = screenWidth - 30
        return commentView
    }()
    
    var LongGesture:UILongPressGestureRecognizer{
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        return gesture
    }
    
    var longPress:(() -> ())?
    
    func longGesture(){
        if let longPress = longPress {
          longPress()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
         selectionStyle = .none
        
         addSubview(timelabel)
         addSubview(PersonalcontentView)
         addGestureRecognizer(LongGesture)
    }
    
    func updateWithModel(model: Replydat){
        
        timelabel.text = model.dtRegDate
        PersonalcontentView.updateWithModel(model: model)
        PersonalcontentView.y = timelabel.maxy + 15
        PersonalcontentView.height = PersonalCommentView.getHeightWithModel(model: model)
        
    }
    
    class func getHeightWithModel(model:Replydat) -> CGFloat{
    
       return 10 + 15 + 15 + PersonalCommentView.getHeightWithModel(model: model) + 15
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


class PersonalCommentView:UIView {
    
    
    lazy var contentTextView:UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkcolor
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return textView
    }()
    
    
    lazy var Originallable:UILabel = {
       let label = UILabel()
       label.textColor = UIColor.white
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 12)
       label.backgroundColor = UIColor.navigationbarColor
       label.text = "原文"
       return label
    }()
    
    lazy var titlelabel:UILabel = {
         let label = UILabel()
         label.textColor = UIColor.YClightGrayColor
         label.font = UIFont.systemFont(ofSize: 12)
         label.numberOfLines = 1
         return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentTextView)
        addSubview(Originallable)
        addSubview(titlelabel)
        
    }
    
    func updateWithModel(model:Replydat){
        contentTextView.text = model.Content
        titlelabel.text = model.Title
        contentTextView.x = 0
        contentTextView.y = 0
        contentTextView.width = screenWidth - 30
        let contentHeight = model.Content.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 15))
        contentTextView.height = contentHeight

        let originalWidth = "原文".widthWithConstrainedWidth(height: 15, font: UIFont.systemFont(ofSize: 12))
        Originallable.x = 0
        Originallable.y = contentTextView.maxy + 15
        Originallable.width = originalWidth + 4
        Originallable.height = 15
        
        titlelabel.x = Originallable.maxx + 8
        titlelabel.y = Originallable.y
        titlelabel.width = screenWidth - 15 - Originallable.width - 8 - 15
        titlelabel.height = 15
    }
    
    func updateWithModel(model:RecommanddatPersonalCenter){
         contentTextView.text = model.Content
         titlelabel.text = model.Title
         contentTextView.x = 0
         contentTextView.y = 0
         contentTextView.width = screenWidth - 30
        let contentHeight = model.Content.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 15))
        contentTextView.height = contentHeight
        
        let originalWidth = "原文".widthWithConstrainedWidth(height: 15, font: UIFont.systemFont(ofSize: 12))
        Originallable.x = 0
        Originallable.y = contentTextView.maxy + 15
        Originallable.width = originalWidth + 4
        Originallable.height = 15
        
        titlelabel.x = Originallable.maxx + 8
        titlelabel.y = Originallable.y
        titlelabel.width = screenWidth - 15 - Originallable.width - 8 - 15
        titlelabel.height = 15

    }
    
    class func getHeightWithModel(model:Replydat) -> CGFloat{
          let contentHeight = model.Content.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 15))
          return contentHeight + 15 + 15
    }
    
    class func getHeightWithModel(model:RecommanddatPersonalCenter) -> CGFloat {
          let contentHeight = model.Content.heightWithConstrainedWidth(width: screenWidth - 30, font: UIFont.systemFont(ofSize: 15))
          return contentHeight + 15 + 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
