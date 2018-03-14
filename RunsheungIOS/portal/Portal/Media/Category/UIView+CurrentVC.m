//
//  UIView+CurrentVC.m
//  Portal
//
//  Created by ifox on 2017/2/23.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "UIView+CurrentVC.h"

@implementation UIView (CurrentVC)

- (UIViewController *)currentVC {
    //通过响应者链，获取此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者对象是否是视图控制器对象
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        //不停的指向下一个响应者
        next = next.nextResponder;
        
    }while (next != nil);
    
    return nil;
}


@end
