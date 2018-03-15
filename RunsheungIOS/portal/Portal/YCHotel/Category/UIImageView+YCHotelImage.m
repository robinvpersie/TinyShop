//
//  UIImageView+YCHotelImage.m
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "UIImageView+YCHotelImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (YCHotelImage)

+ (void)hotelSetImageWithImageView:(UIImageView *)imageView
                         UrlString:(NSString *)urlString
                      imageVersion:(NSString *)version {
    NSString *key = [NSString stringWithFormat:@"%@%@",urlString,version];
    UIImage *storeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (storeImage == nil) {
      
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] placeholderImage:[UIImage imageNamed:@"hotel_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             [[SDImageCache sharedImageCache] storeImage:image forKey:key completion:^{
                
            }];
        }];
    } else {
        imageView.image = storeImage;
    }
}

@end
