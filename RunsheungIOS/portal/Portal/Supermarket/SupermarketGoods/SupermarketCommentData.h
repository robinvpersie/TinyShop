//
//  SupermarketCommentData.h
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommentType) {
    ContentOnly = 0,
    ContentWithImages,
};

@interface SupermarketCommentData : NSObject

@property(nonatomic, strong)    NSNumber    *commentID;
@property(nonatomic, copy)      NSString    *sendTime;
@property(nonatomic, strong)    NSNumber    *hasLikes;//是否点赞 1为已点赞 0为未点赞
@property(nonatomic, copy)      NSString    *avatarUrlString;
@property(nonatomic, strong)    NSArray     *images;//晒图
@property(nonatomic, strong)    NSNumber    *level;
@property(nonatomic, assign)    NSInteger   likeAmount; //点赞数
@property(nonatomic, copy)      NSString    *userID;
@property(nonatomic, assign)    float       rating;//评分
@property(nonatomic, copy)      NSString    *content;
@property(nonatomic, assign)    CommentType type;
@property(nonatomic, assign)    CGFloat     height;

//一下三条属性用于我的评价
@property(nonatomic, copy)      NSString *item_code;
@property(nonatomic, copy)      NSString *item_name;
@property(nonatomic, copy)      NSString *image_url;

@end
