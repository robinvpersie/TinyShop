//
//  ProfileAvatarCell.swift
//  Portal
//
//  Created by linpeng on 2018/1/10.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileAvatarCell: UITableViewCell {
    
    var backGroundImgView: UIImageView!
    var namelb: UILabel!
    var penBtn: UIButton!
    var avatarImgView: UIImageView!
    var penAction: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backGroundImgView = UIImageView()
        backGroundImgView.isUserInteractionEnabled = true
        backGroundImgView.image = UIImage(named: "img_personalcenter_bg")
        contentView.addSubview(backGroundImgView)
        backGroundImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        avatarImgView = UIImageView()
        avatarImgView.layer.cornerRadius = 30
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.backgroundColor = UIColor.white.cgColor
        contentView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(contentView).offset(-15)
            make.width.height.equalTo(60)
        }
        
        namelb = UILabel()
        namelb.font = UIFont.systemFont(ofSize: 16)
        namelb.textColor = UIColor.white
        contentView.addSubview(namelb)
        namelb.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(avatarImgView)
        }
        
        penBtn = UIButton(type: .custom)
        penBtn.addTarget(self, action: #selector(didPen), for: .touchUpInside)
        penBtn.setImage(UIImage(named: "editbtn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        contentView.addSubview(penBtn)
        penBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(namelb.snp.trailing).offset(5)
            make.centerY.height.equalTo(namelb)
        }
    }

    func configureWithModel(_ model: ProfileModel?){
        namelb.text = model?.nick_name
        avatarImgView.kf.setImage(with: model?.head_url)
    }
   
    
    @objc func didPen(){
        penAction?()
    }
    
    class func getHeight() -> CGFloat {
        return Ruler.iPhoneVertical(180, 180, 200, 190).value
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
