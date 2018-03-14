

import Foundation


public let miniAvatarStyle: AvatarStyle = .roundedRectangle(size: CGSize(width: 70, height: 70), cornerRadius: 35, borderWidth: 0)
public let nanoAvatarStyle: AvatarStyle = .roundedRectangle(size: CGSize(width: 80, height: 80), cornerRadius: 40, borderWidth: 0)
public let picoAvatarStyle: AvatarStyle = .roundedRectangle(size: CGSize(width: 30, height: 30), cornerRadius: 15, borderWidth: 0)


public enum AvatarStyle {

    case original
    case rectangle(size: CGSize)
    case roundedRectangle(size: CGSize, cornerRadius: CGFloat, borderWidth: CGFloat)
}

extension AvatarStyle {

    var hashString: String {

        switch self {

        case .original:
            return "Original-"

        case .rectangle(let size):
            return "Rectangle-\(size)-"

        case .roundedRectangle(let size, let cornerRadius, let borderWidth):
           return "RoundedRectangle-\(size)-\(cornerRadius)-\(borderWidth)-"
        }
    }
}

public protocol Avatar {
    
    var url: URL? { get }
    var style: AvatarStyle { get }
    var placeholderImage: UIImage? { get }
    var localOriginalImage: UIImage? { get }
    var localStyledImage: UIImage? { get }
    func save(originalImage: UIImage, styledImage: UIImage)
}

public extension Avatar {
    
    public var key: String {
        return style.hashString + (url?.absoluteString ?? "")
    }
}




