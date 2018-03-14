//
//  WJSetLineColor.h
//  WJIM_DOME
//
//  Created by 王五 on 2017/9/5.
//  Copyright © 2017年 王五. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSetLineColor : NSObject

/**
 单列方法

 @return 生成单列
 */
+ (instancetype)shareSetLineColor;

/**
 设置导航栏底部线条颜色

 @param vc 被设置的导航栏
 
 @param color 被设置的导航栏下滑线的颜色
 */
- (void)setNaviLineColor:(UIViewController*)vc withColor:(UIColor*)color;
@end
