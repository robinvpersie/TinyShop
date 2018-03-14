//
//  SupermarketCouponController.h
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"

/**
 订单确认选择优惠券
 */
@interface SupermarketCouponController : SupermarketBaseViewController

@property(nonatomic, strong) NSArray *canUseCoupons;//可用优惠券
@property(nonatomic, strong) NSArray *cantUseCoupons;//不可用的优惠券

@end
