//
//  HotelCommentModel.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentModel.h"
#import "UILabel+WidthAndHeight.h"

@implementation HotelCommentModel

- (BOOL)hasHotelReply {
    if (self.hotelReply.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (HotelCommentType)commentType {
    if (self.images.count > 0) {
        return HotelCommentTypeContentWithImage;
    } else {
        return HotelCommentTypeContentOnly;
    }
}

- (CGFloat)contentHeight {
    CGFloat contentHeight = [UILabel getHeightByWidth:APPScreenWidth - 15*2 title:self.content font:[UIFont systemFontOfSize:12]];
    _contentHeight = contentHeight;
    return _contentHeight;
}

- (CGFloat)replyHeight {
    CGFloat replyHeight = [UILabel getHeightByWidth:APPScreenWidth - 8*2 - 15*2 title:self.hotelReply font:[UIFont systemFontOfSize:12]];
    _replyHeight = replyHeight;
    return _replyHeight;
}

- (CGFloat)height {
    _height = 75;
    switch (self.commentType) {
        case HotelCommentTypeContentOnly:
            if (self.isExpanding) {
               _height = _height + self.contentHeight + self.replyHeight;
            } else {
                _height = _height + self.contentHeight;
            }
            
            break;
        case HotelCommentTypeContentWithImage:
            if (self.isExpanding) {
                _height = _height + self.contentHeight + self.replyHeight + 100;
            } else {
                _height = _height + self.contentHeight + 100;
            }
            
            break;
        default:
            break;
    }
    return _height;
}

@end
