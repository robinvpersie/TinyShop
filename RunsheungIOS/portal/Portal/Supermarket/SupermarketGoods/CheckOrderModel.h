//
//  CheckOrderModel.h
//  Portal
//
//  Created by ifox on 2017/3/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponModel.h"
#import "CheckOrderGoodsRange.h"

@interface CheckOrderModel : NSObject

@property(nonatomic, assign) BOOL canUseCoupons;
@property(nonatomic, assign) BOOL canUsePoint;
@property(nonatomic, strong) NSArray<CouponModel *> *coupons;
@property(nonatomic, strong) NSArray<CouponModel *> *cantUseCoupons;
@property(nonatomic, strong) NSArray<CheckOrderGoodsRange *> *goodsRanges;
@property(nonatomic, strong) NSNumber *expressPrice;
@property(nonatomic, copy) NSString *guid;
@property(nonatomic, strong) NSNumber *canMaxUsePoint;
@property(nonatomic, strong) NSNumber *totalPoint;
@property(nonatomic, strong) NSNumber *price;//单价
@property(nonatomic, strong) NSNumber *totalPrice;

@property(nonatomic, copy) NSString *divCode;

@end
