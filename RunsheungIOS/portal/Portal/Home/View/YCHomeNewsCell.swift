//
//  YCHomeNewsCell.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

let toCellleftMargin: CGFloat = Ruler.iPhoneHorizontal(5.0, 10.0, 10.0).value
let toCellTopMargin: CGFloat = Ruler.iPhoneVertical(5.0, 5.0, 8.0, 8.0).value
let toCellImgTopMargin: CGFloat = Ruler.iPhoneVertical(0.0, 0.0, 0.0, 0.0).value
let labelMargin: CGFloat = Ruler.iPhoneVertical(8.0, 8.0, 10.0, 12.0).value


class YCHomeNewsCell: UITableViewCell {
    
     lazy var NewsNamelabel:UILabel = {
       let label = UILabel()
       label.textColor = UIColor.black
       label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
       label.numberOfLines = 1
       return label
    }()
    
    lazy var NewsImageView:UIImageView = {
       let imageview = UIImageView()
       return imageview
    }()
    
    lazy var NewsContentlabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var timeslabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 1
        return label

    }()
    
    lazy var commentImageView:UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    lazy var readlabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    lazy var bottomline:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.white
        
        addSubview(NewsNamelabel)
        addSubview(NewsImageView)
        addSubview(NewsContentlabel)
        addSubview(timeslabel)
        addSubview(commentImageView)
        addSubview(readlabel)
        addSubview(bottomline)
        
        self.bottomline.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(toCellleftMargin)
            make.height.equalTo(5)
            make.right.equalTo(self).offset(-toCellleftMargin)
            make.bottom.equalTo(self).offset(0)
        }
    }
    
    
    func updateWithModel(model:PersonalMyShareModel){
        
        NewsNamelabel.text = model.title
        NewsContentlabel.text = model.content
        timeslabel.text = model.date
        readlabel.text = "\(model.replyCount)"
        commentImageView.image = UIImage.discuss
        
        let height = timeslabel.font.lineHeight
        let width = timeslabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height)).width
        let timelabelx = toCellleftMargin
        let timeslabely = self.frame.size.height - toCellTopMargin - height
        let timeslablewidth = width
        let timeslableheight = height
        timeslabel.frame = CGRect(x: timelabelx, y: timeslabely, width: timeslablewidth, height: timeslableheight)
        
        let btnlabelwidth = readlabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height:11)).width
        let imageWidth = UIImage.discuss.size.width
        commentImageView.frame = CGRect(x: timeslabel.frame.maxX + 20, y: timeslabely, width: imageWidth, height: 11)
        readlabel.frame = CGRect(x: (commentImageView.frame.maxX) + 2, y: timeslabel.frame.minY, width: btnlabelwidth, height: 11)
        
        let newsImagey = toCellTopMargin
        let newsImageHeight = self.frame.size.height - 2 * toCellTopMargin
        let newsImageWidth = model.imgUrl.isEmpty ? 0 : newsImageHeight * 1.4
        let newsImagex = self.frame.size.width - toCellleftMargin - newsImageWidth
        self.NewsImageView.frame = CGRect(x: newsImagex, y: newsImagey, width: newsImageWidth, height: newsImageHeight)
        
        let options: KingfisherOptionsInfo = [.transition(.fade(0.6))]
        NewsImageView.kf.setImage(with: URL(string: model.imgUrl), placeholder: UIImage.YCPlaceHolder, options: options)
        
        let newsNamex = toCellleftMargin
        let newsNameY = toCellTopMargin
        let newsNameWidth = model.imgUrl.isEmpty ?  self.frame.size.width - 2 * toCellleftMargin : self.frame.size.width - newsImageWidth - 2 * toCellleftMargin - Ruler.iPhoneHorizontal(8, 10, 10).value
        let newsNameHeight = NewsNamelabel.font.lineHeight
        NewsNamelabel.frame = CGRect(x: newsNamex, y: newsNameY, width: newsNameWidth, height: newsNameHeight)
        
        
        let newsContentx = newsNamex
        let newsContenty = newsImagey + labelMargin + newsNameHeight
        let newsContentWidth = newsNameWidth
        let newsContentHeight = NewsContentlabel.font.lineHeight * 2
        NewsContentlabel.frame = CGRect(x: newsContentx, y: newsContenty, width: newsContentWidth, height: newsContentHeight)

    }
    
    
    class func getHeightWithModel(model:PersonalMyShareModel) -> CGFloat {
        
          let newnameHeight = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold).lineHeight
          let contentheight = UIFont.systemFont(ofSize: 12).lineHeight * 2
          let height = UIFont.systemFont(ofSize: 11).lineHeight
          return newnameHeight + toCellTopMargin + labelMargin + 2 + 12 + contentheight + height

    }
    
    
    
    
    
    func updateWithModel(model:Newsdat){
        
        //jake : 170709 read -> "\(model.ReplyCount)"
        NewsNamelabel.text = model.title
        NewsContentlabel.text = model.content
        timeslabel.text = model.date
        readlabel.text = "\(model.ReplyCount)"
        commentImageView.image = UIImage.discuss


        let height = timeslabel.font.lineHeight
        
        let timelabelx = toCellleftMargin
        let timeslabely = self.frame.size.height - toCellTopMargin - height
        let timeslablewidth = timeslabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height)).width
        let timeslableheight = height
        timeslabel.frame = CGRect(x: timelabelx, y: timeslabely, width: timeslablewidth, height: timeslableheight)
        
        let btnlabelwidth = readlabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height:11)).width
        let imageWidth = UIImage.discuss.size.width
        commentImageView.frame = CGRect(x: timeslabel.frame.maxX + 20, y: timeslabely, width: imageWidth, height: 11)
        
        readlabel.frame = CGRect(x: (commentImageView.frame.maxX) + 2, y: timeslabel.frame.minY, width: btnlabelwidth, height: 11)
        
        let newsImagey = toCellTopMargin
        let newsImageHeight = self.frame.size.height - 2 * toCellTopMargin
        let newsImageWidth = model.imgUrl.isEmpty ? 0 : newsImageHeight * 1.4
        let newsImagex = self.frame.size.width - toCellleftMargin - newsImageWidth
        self.NewsImageView.frame = CGRect(x: newsImagex, y: newsImagey, width: newsImageWidth, height: newsImageHeight)
        
        let options:KingfisherOptionsInfo = [.transition(.fade(0.6))]
        NewsImageView.kf.setImage(with: URL(string:model.imgUrl), placeholder: UIImage.YCPlaceHolder, options: options)
        
        let newsNamex = toCellleftMargin
        let newsNameY = toCellTopMargin
        let newsNameWidth = model.imgUrl.isEmpty ?  self.frame.size.width - 2 * toCellleftMargin : self.frame.size.width - newsImageWidth - 2 * toCellleftMargin - Ruler.iPhoneHorizontal(8, 10, 10).value
        let newsNameHeight = NewsNamelabel.font.lineHeight
        NewsNamelabel.frame = CGRect(x: newsNamex, y: newsNameY, width: newsNameWidth, height: newsNameHeight)
        
        
        let newsContentx = newsNamex
        let newsContenty = newsImagey + labelMargin + newsNameHeight
        let newsContentWidth = newsNameWidth
        let newsContentHeight = NewsContentlabel.font.lineHeight * 2
        NewsContentlabel.frame = CGRect(x: newsContentx, y: newsContenty, width: newsContentWidth, height: newsContentHeight)
    }
    
    class func GetHeight(model:Newsdat) -> CGFloat {
        
        let newnameHeight = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold).lineHeight
        let contentheight = UIFont.systemFont(ofSize: 12).lineHeight * 2
        let height = UIFont.systemFont(ofSize: 11).lineHeight
        return newnameHeight + toCellTopMargin + labelMargin + 2 + 12 + contentheight + height

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
