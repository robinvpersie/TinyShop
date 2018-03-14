

import UIKit

class ShopBrandFilterCell: UICollectionViewCell {
    
    private var imgView:UIImageView!
    
    private var titlelb:UILabel!
    
    private var pricelb:UILabel!
    
    private var commentlb:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        imgView = UIImageView()
        contentView.addSubview(imgView)
        
        titlelb = UILabel()
        titlelb.numberOfLines = 2
        titlelb.textColor = UIColor.darkcolor
        titlelb.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(titlelb)
        
        pricelb = UILabel()
        pricelb.textColor = UIColor.navigationbarColor
        pricelb.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(pricelb)
        
        commentlb = UILabel()
        commentlb.font = UIFont.systemFont(ofSize: 11)
        commentlb.textColor = UIColor.YClightGrayColor
        contentView.addSubview(commentlb)
        makeConstraints()
    }
    
    
    private func makeConstraints(){
        
        imgView.snp.makeConstraints { (make) in
           make.width.equalTo(contentView).multipliedBy(0.9)
           make.centerX.equalTo(contentView)
           make.top.equalTo(contentView).offset(10)
           make.height.equalTo(imgView.snp.width)
        }
        
        titlelb.snp.makeConstraints { (make) in
           make.leading.equalTo(contentView).offset(15)
           make.top.equalTo(imgView.snp.bottom).offset(10)
           make.trailing.equalTo(contentView).offset(-15)
           make.height.equalTo(30)
        }
        
        pricelb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(titlelb.snp.bottom).offset(10)
         }
        
        commentlb.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.bottom.equalTo(pricelb)
        }
    }
    
    
    func updateWithMall(_ model:MallGoods3){
        imgView.kf.setImage(with: model.imageUrl, options: [.transition(.fade(0.5))])
        titlelb.text = model.itemName
        pricelb.text = "￥\(model.itemP)"
        commentlb.text = "\(model.assessCnt)" + "评价".localized

    }
    
    func updateWithEvent(_ model:Eventgoods2){
        imgView.kf.setImage(with: model.imageUrl, options: [.transition(.fade(0.5))])
        titlelb.text = model.itemName
        pricelb.text = "￥\(model.itemP)"
        commentlb.text = "\(model.assessCnt)" + "评价".localized
    }
    
    func updateWithModel(_ model:BrandFilterItem){
        
        imgView.kf.setImage(with: model.imageUrl, options: [.transition(.fade(0.5))])
        titlelb.text = model.itemName
        pricelb.text = "￥\(model.itemPrice)"
        commentlb.text = "\(model.comments)" + "评价".localized
    }
    
    class func getSize() -> CGSize {
        let width = (screenWidth - 1)/2.0
        let height = 10 + (screenWidth-1)/2.0*0.9 + 10 + 30 + 10 + 18
        return CGSize(width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
