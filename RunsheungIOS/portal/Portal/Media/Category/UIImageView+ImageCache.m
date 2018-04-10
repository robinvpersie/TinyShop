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
    
    NSString *key = [NSString stringWithFormat:@"%@%@",urlString,version];
    UIImage *storeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (storeImage == nil) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] placeholderImage:[UIImage imageNamed:@"no_search"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

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
