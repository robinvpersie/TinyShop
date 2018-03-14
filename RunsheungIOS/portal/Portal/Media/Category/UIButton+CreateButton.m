//
//  UIButton+CreateButton.m
//  Portal
//
//  Created by ifox on 2017/3/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "UIButton+CreateButton.h"

@implementation UIButton (CreateButton)

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                         titleColor:(UIColor *)titleColor
                          titleFont:(UIFont *)titleFont
                    backgroundColor:(UIColor *)backgroundColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    button.backgroundColor = backgroundColor;
    
    return button;
}

@end
