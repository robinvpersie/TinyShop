//
//  UILabel+CreateLabel.h
//  Portal
//
//  Created by ifox on 2017/2/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CreateLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                    textAlignment:(NSTextAlignment)textAlignment
                             text:(NSString *)text;

@end
