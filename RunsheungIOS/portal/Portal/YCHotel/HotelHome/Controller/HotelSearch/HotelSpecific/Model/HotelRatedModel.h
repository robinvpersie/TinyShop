//
//  HotelRatedModel.h
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelRatedModel : NSObject

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, strong) NSNumber *totalScore;
@property(nonatomic, copy) NSString *ratedName;//评论人姓名
@property(nonatomic, copy) NSString *ratedContext;//评论内容

@end
