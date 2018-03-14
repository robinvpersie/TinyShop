//
//  UIButton+CreateButton.h
//  Portal
//
//  Created by ifox on 2017/3/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CreateButton)

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                         titleColor:(UIColor *)titleColor
                          titleFont:(UIFont *)titleFont
                    backgroundColor:(UIColor *)backgroundColor;

@end
