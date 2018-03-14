//
//  UIImageView+ImageCache.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>

@interface UIImageView (ImageCache)

+ (void)setimageWithImageView:(UIImageView *)imageView
                    UrlString:(NSString *)urlString
                 imageVersion:(NSString *)version;

@end
