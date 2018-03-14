//
//  SupermarketMineData.h
//  Portal
//
//  Created by ifox on 2017/1/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketMineData : NSObject

@property(nonatomic, copy) NSString *header_url;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, strong) NSNumber *coupons_count;//优惠券
@property(nonatomic, strong) NSString *point;//积分
@property(nonatomic, strong) NSNumber *collection_count;//收藏量
@property(nonatomic, strong) NSNumber *waitPayCount;
@property(nonatomic, strong) NSNumber *waitSendCount;
@property(nonatomic, strong) NSNumber *waitPickCount;
@property(nonatomic, strong) NSNumber *waitReceiveCount;
@property(nonatomic, strong) NSNumber *waitCommentCount;

@end
