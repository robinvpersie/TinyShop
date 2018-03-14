//
//  SupermarketOrderGoodsData.h
//  Portal
//
//  Created by ifox on 2017/1/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RefundStatus) {
    RefundStatus0 = 0,
    RefundStatus1,
    RefundStatus2,
    RefundStatus3,
    RefundStatus4,
    RefundStatus5,
    RefundStatus6
};

@interface SupermarketOrderGoodsData : NSObject

@property(nonatomic, copy) NSString *item_code;
@property(nonatomic, strong) NSNumber *amount;
@property(nonatomic, strong) NSNumber *price;
//@property(nonatomic, strong) NSNumber *need_assess;//是否需要评价
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *stockUnit;
@property(nonatomic, copy) NSString *image_url;
@property(nonatomic, copy) NSString *ver;
@property(nonatomic, assign) RefundStatus refundStatus;

@property(nonatomic, strong) NSNumber *assess_stauts;
@property(nonatomic, copy) NSString *divCode;

@end
