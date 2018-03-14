//
//  UILabel+CreateLabel.m
//  Portal
//
//  Created by ifox on 2017/2/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "UILabel+CreateLabel.h"

@implementation UILabel (CreateLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                    textAlignment:(NSTextAlignment)textAlignment
                             text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.font = font;
    if (textAlignment != NSTextAlignmentLeft) {
        label.textAlignment = textAlignment;
    } else {
        textAlignment = NSTextAlignmentLeft;
    }    
    label.text = text;
    
    return label;
}

@end
