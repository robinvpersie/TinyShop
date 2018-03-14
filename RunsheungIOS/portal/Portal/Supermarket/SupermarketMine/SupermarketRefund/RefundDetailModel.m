//
//  RefundDetailModel.m
//  Portal
//
//  Created by ifox on 2017/3/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RefundDetailModel.h"
#import "UILabel+WidthAndHeight.h"

@implementation RefundDetailModel

- (CGFloat)contentHeight {
    CGFloat height = [UILabel getHeightByWidth:APPScreenWidth - 15*2 - 10 title:self.content font:[UIFont systemFontOfSize:14]];
    _contentHeight = height;
    return _contentHeight;
}

@end
