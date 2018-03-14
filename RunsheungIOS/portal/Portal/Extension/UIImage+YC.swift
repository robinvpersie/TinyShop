//
//  UIImageView+YC.swift
//  Portal
//
//  Created by PENG LIN on 2016/11/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit


extension YCBox where Base:UIImage {
    
    public var fixedSize:CGSize{
       let imageWidth = Base.size.width
       let imageHeight = Base.size.height
       let fixedImageWidth:CGFloat
       let fixedImageHeight:CGFloat
       if imageWidth > imageHeight{
           fixedImageHeight = min(imageHeight, 1024)
           fixedImageWidth = imageWidth * (fixedImageHeight / imageHeight)
       }else {
           fixedImageWidth = min(imageWidth, 1024)
           fixedImageHeight = imageHeight * (fixedImageWidth / imageWidth)
       }
        return CGSize(width: fixedImageWidth, height: fixedImageHeight)
    }
    
    
    public func largestCenteredSquareImage() -> UIImage? {
        let scale = Base.scale
        let originalWidth  = Base.size.width * scale
        let originalHeight = Base.size.height * scale
        let edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        guard let imageRef = Base.cgImage?.cropping(to: cropSquare) else {
           return nil
        }
        return UIImage(cgImage: imageRef, scale: scale, orientation: Base.imageOrientation)
    }
    
    
    public func resizeToTargetSize(targetSize: CGSize) -> UIImage? {
        let size = Base.size
        let widthRatio  = targetSize.width  / Base.size.width
        let heightRatio = targetSize.height / Base.size.height
        let scale = UIScreen.main.scale
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: scale * floor(size.width * heightRatio), height: scale * floor(size.height * heightRatio))
        } else {
            newSize = CGSize(width: scale * floor(size.width * widthRatio), height:scale * floor(size.height * widthRatio))
        }
        let rect = CGRect(x:0,y:0, width:floor(newSize.width), height:floor(newSize.height))
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        Base.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public func scaleToMinSideLength(sideLength: CGFloat) -> UIImage {
        
        let pixelSideLength = sideLength * UIScreen.main.scale
        let pixelWidth = Base.size.width * Base.scale
        let pixelHeight = Base.size.height * Base.scale
        let newSize: CGSize
        if pixelWidth > pixelHeight {
            guard pixelHeight > pixelSideLength else { return Base }
            let newHeight = pixelSideLength
            let newWidth = (pixelSideLength / pixelHeight) * pixelWidth
            newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
        } else {
            guard pixelWidth > pixelSideLength else { return  Base }
            let newWidth = pixelSideLength
            let newHeight = (pixelSideLength / pixelWidth) * pixelHeight
            newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
        }
        
        if Base.scale == UIScreen.main.scale {
            let newSize = CGSize(width: floor(newSize.width / Base.scale), height: floor(newSize.height / Base.scale))
            UIGraphicsBeginImageContextWithOptions(newSize, false, Base.scale)
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            Base.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = newImage { return image }
            return Base
        } else {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            let rect = CGRect(x:0,y: 0,width:newSize.width, height:newSize.height)
            Base.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = newImage { return image }
            return Base
        }

      }
    
    
    public func fixRotation() -> UIImage? {
        if Base.imageOrientation == .up { return Base }
        
        let width = Base.size.width
        let height = Base.size.height
        var transform = CGAffineTransform.identity
        switch Base.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        default:
            break
        }
        
        switch Base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            
        default:
            break
        }
        
        guard let selfCGImage = Base.cgImage else {
            return nil
        }
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: selfCGImage.bitsPerComponent, bytesPerRow: 0, space: selfCGImage.colorSpace!, bitmapInfo: selfCGImage.bitmapInfo.rawValue);
        context?.concatenate(transform)
        switch Base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(selfCGImage, in: CGRect(x:0,y:0, width:height, height:width))
        default:
            context?.draw(selfCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
         }
        guard let con = context, let cgImage = con.makeImage() else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    
    public func cropToAspectRatio(aspectRatio: CGFloat) -> UIImage? {
         let size = Base.size
         let originalAspectRatio = size.width / size.height
         var rect = CGRect.zero
         if originalAspectRatio > aspectRatio {
            let width = size.height * aspectRatio
            rect = CGRect(x: (size.width - width) * 0.5, y: 0, width: width, height: size.height)
         } else if originalAspectRatio < aspectRatio {
            let height = size.width / aspectRatio
            rect = CGRect(x: 0, y: (size.height - height) * 0.5, width: size.width, height: height)
         } else {
            return Base
         }
        guard let cgImage = Base.cgImage,let cg = cgImage.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cg)
    }
    
    
    public func scaleWith(scale:CGFloat) -> UIImage? {
        let imagesize = CGSize(width: Base.size.width * scale, height: Base.size.height * scale)
        UIGraphicsBeginImageContext(imagesize)
        Base.draw(in: CGRect(x: 0, y: 0, width: imagesize.width, height: imagesize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    
    public func compressionImageToDataTargetWH( targetWH:inout CGFloat,maxFilesize:NSInteger) -> Data?{
        
        if targetWH <= 0 {
           targetWH = 1024
        }
        var newSize = CGSize(width: Base.size.width, height: Base.size.height)
        let tempHeight = newSize.height/targetWH
        let tempWidth = newSize.width/targetWH
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: Base.size.width/tempWidth, height: Base.size.height/tempWidth)
        }else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: Base.size.width/tempHeight, height: Base.size.height/tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        Base.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var compression:CGFloat = 0.9
        let maxCompression:CGFloat = 0.1
        var imageData = UIImageJPEGRepresentation(newImage!, compression)
        while imageData!.count/1000 > maxFilesize && compression > maxCompression {
            compression -= 0.1
            imageData = UIImageJPEGRepresentation(newImage!, compression)
        }
        return imageData
        
    }
    
    public func imageWithGradientTintColor(tintColor: UIColor) -> UIImage? {
        
        return imageWithTintColor(tintColor: tintColor, blendMode: CGBlendMode.overlay)
    }
    
    
    public func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(Base.size, false, 0)
        tintColor.setFill()
        let bounds = CGRect(origin: CGPoint.zero, size: Base.size)
        UIRectFill(bounds)
        Base.draw(in: bounds, blendMode: blendMode, alpha: 1)
        if blendMode != CGBlendMode.destinationIn {
            Base.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1)
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    
    public func renderAtSize(size: CGSize) -> UIImage? {
        
        // 确保 size 为整数，防止 mask 里出现白线
        let size = CGSize(width: ceil(size.width), height: ceil(size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0) // key
        let context = UIGraphicsGetCurrentContext()
        Base.draw(in: CGRect(origin: CGPoint.zero, size: size))
        guard let con = context,let cgImage = con.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage)
        UIGraphicsEndImageContext()
        return image
    }
    
    
    public func decodedImage() -> UIImage {
        return decodedImage(scale: Base.scale)
    }
    
    public func decodedImage(scale: CGFloat) -> UIImage {
        let imageRef = Base.cgImage
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: imageRef!.width, height: imageRef!.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        if let context = context {
            let rect = CGRect(x: 0, y: 0, width: (imageRef?.width)!, height: (imageRef?.height)!)
            context.draw(imageRef!, in: rect)
            let decompressedImageRef = context.makeImage()!
            return UIImage(cgImage: decompressedImageRef, scale: scale, orientation: Base.imageOrientation)
        }
        
        return Base
    }
    
    
    

}


public extension UIImage {
    
    static var dropDown:UIImage {
       return UIImage(named:"icon_dropdown")!
    }
    
    static var My:UIImage{
       return UIImage(named: "My")!
    }
    
    static var scan_net:UIImage{
       return UIImage(named: "scan_net")!
    }
    
    static var location:UIImage{
        return UIImage(named: "location")!
    }
    
    static var discuss:UIImage{
        return UIImage(named: "icon_comment_002")!
    }
    
    static var leftarrow:UIImage? {
        return UIImage(named: "icon_02_01")
    }
    
    static var password:UIImage{
        return UIImage(named: "icon_password")!
    }
    
    static var phone:UIImage{
        return UIImage(named: "iocn_phone")!
    }
    
    static var QRIcon:UIImage{
        return UIImage(named: "icon_qr")!
    }
    
    static var Dragon:UIImage{
     return UIImage(named: "Dragon")!
    }
    
    static var redlike:UIImage{
      return UIImage(named: "icon_redlike")!
    }
    
    static var nolike:UIImage{
      return UIImage(named: "icon_garylike")!
    }
    
    static var yc_searchbarTextfieldBackground: UIImage {
        return UIImage(named: "searchbar_textfield_background")!
    }
    
    static var ycDateImg:UIImage {
        return UIImage(named: "icon_date_001")!
    }
    
    static var YCPlaceHolder:UIImage? {
        return UIImage(named: "img_placeholder")
    }
    
    static var YCAvatarPlaceHolderImage:UIImage {
        return UIImage(named: "img_defaultphoto")!
    }
    
    static var ycpayImage:UIImage?{
        return UIImage(named: "icon_yuchengpay")
    }
    
    static var wechatPayImage:UIImage?{
        return UIImage(named: "icon_weichatpay")
    }
    
    static var aliPayImage:UIImage?{
        return UIImage(named: "icon_alipay")
    }
    
    static var bankPayImage:UIImage?{
        return UIImage(named: "icon_bank")
    }
    
    static var selectedImage:UIImage?{
        return UIImage(named: "icon_qq1")
    }
    
    static var unselectedImage:UIImage?{
        return UIImage(named: "icon_qq1c")
    }
    
    static var shareImage:UIImage?{
        return UIImage(named: "icon_fx")
    }
    
    static var collectImage:UIImage?{
        return UIImage(named:"icon_scc")
    }
    
    static var LaunchImage:UIImage?{
        var viewOrientation:String = "Portrait"
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
           viewOrientation = "Landscape"
        }
        var launchImageName:String = ""
        let imagesDict:[[String:Any]] = Bundle.main.infoDictionary?["UILaunchImages"] as! [[String : Any]]
        let viewSize = UIApplication.shared.windows.first!.bounds.size
        for dict in imagesDict {
            let imageSize = CGSizeFromString(dict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(imageSize, viewSize) && viewOrientation == (dict["UILaunchImageOrientation"] as! String) {
                  launchImageName = dict["UILaunchImageName"] as! String
            }
        }
        return UIImage(named: launchImageName)
    }

    
}










