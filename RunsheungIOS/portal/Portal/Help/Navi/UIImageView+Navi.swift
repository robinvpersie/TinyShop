
import UIKit
import Kingfisher

//private var avatarKeyAssociatedObject: Void?

public extension UIImageView {


    public func navi_setAvatar(_ avatar: Avatar,completion:((_ image:UIImage) -> Void)? = nil) {
       switch  avatar.style {
        case .original:
              break
        default:
            break
        }
        self.kf.setImage(with: avatar.url, placeholder: avatar.placeholderImage,progressBlock: { (recevie,total) in
            
        }, completionHandler: { ( image,_,_,_)in
                DispatchQueue.main.async {
                    if let image = image {
                    completion?(image)
                }
            }
        })

    }
    
}



