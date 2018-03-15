//
//  UIImageView+ImageCache.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

//#import "UIImageView+ImageCache.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (ImageCache)

+ (void)setimageWithImageView:(UIImageView *)imageView
                    UrlString:(NSString *)urlString
                 imageVersion:(NSString *)version {
//    SDImageCache *imageChache = [[SDImageCache alloc] init];
    NSString *key = [NSString stringWithFormat:@"%@%@",urlString,version];
    UIImage *storeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (storeImage == nil) {
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:key];
//        }];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] placeholderImage:[UIImage imageNamed:@"supermarket_defaultIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:key];
            [[SDImageCache sharedImageCache] storeImage:image forKey:key completion:^{
                
            }];
        }];
    } else {
        imageView.image = storeImage;
    }
}

- (NSString *)keyForImage:(NSString *)urlString
                  version:(NSString *)version {
    return [NSString stringWithFormat:@"%@%@",urlString,version];
}

@end
