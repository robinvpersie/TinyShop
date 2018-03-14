//
//  UIImageView+YCHotelImage.h
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YCHotelImage)

+ (void)hotelSetImageWithImageView:(UIImageView *)imageView
                         UrlString:(NSString *)urlString
                      imageVersion:(NSString *)version;

@end
