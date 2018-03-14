//
//  SupermarketCommentData.m
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCommentData.h"
#import "UILabel+WidthAndHeight.h"

#define BaseHeight 95 //头像 星星 时间合计高度
#define LabelWidth APPScreenWidth - 15 - 10

@implementation SupermarketCommentData

- (CGFloat)height {
    _height = 105;
    switch (self.type) {
        case ContentOnly:
            _height += [UILabel getHeightByWidth:LabelWidth title:self.content font:[UIFont systemFontOfSize:14]];
            
            return _height;
            break;
            
        case ContentWithImages:
            _height += [UILabel getHeightByWidth:LabelWidth title:self.content font:[UIFont systemFontOfSize:14]];
            
            _height += 140;
            return _height;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CommentType)type {
    if (self.images.count > 0) {
        return ContentWithImages;
    }
    return ContentOnly;
}

@end
