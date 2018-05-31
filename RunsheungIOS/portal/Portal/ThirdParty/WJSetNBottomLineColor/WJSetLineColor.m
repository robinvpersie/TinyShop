//
//  WJSetLineColor.m
//  WJIM_DOME
//
//  Created by 王五 on 2017/9/5.
//  Copyright © 2017年 王五. All rights reserved.
//

#import "WJSetLineColor.h"

@implementation WJSetLineColor
+ (instancetype)shareSetLineColor{
    static WJSetLineColor *setlinecolor= nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        setlinecolor = [[self alloc]init];
    });
    return setlinecolor;
}

- (void)setNaviLineColor:(UIViewController*)vc withColor:(UIColor*)color{
    UIImage *colorImage = [self imageWithColor:color size:CGSizeMake(vc.view.frame.size.width, 1.0)];
    [vc.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    [vc.navigationController.navigationBar setShadowImage:[self imageWithColor:color size:CGSizeMake(vc.view.frame.size.width, 0.8)]];

}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
