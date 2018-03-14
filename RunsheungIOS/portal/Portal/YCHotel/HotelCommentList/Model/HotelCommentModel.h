//
//  HotelCommentModel.h
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HotelCommentType) {
    HotelCommentTypeContentOnly = 0,
    HotelCommentTypeContentWithImage
};

@interface HotelCommentModel : NSObject

@property(nonatomic, copy) NSString *commentID;

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, assign) float score;
@property(nonatomic, copy) NSString *commentTime;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *roomTypeName;

@property(nonatomic, copy) NSString *hotelReply;//酒店回复内容
@property(nonatomic, assign) BOOL hasHotelReply;//是否有酒店回复
@property(nonatomic, assign) BOOL isExpanding;//酒店回复是否展开

@property(nonatomic, strong) NSArray *images;//图片
@property(nonatomic, assign) HotelCommentType commentType;

@property(nonatomic, assign) CGFloat contentHeight;
@property(nonatomic, assign) CGFloat replyHeight;

@property(nonatomic, assign) CGFloat height;

@end
