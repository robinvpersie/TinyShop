//
//  OrderDetailModel.h
//  Portal
//
//  Created by ifox on 2017/1/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property(nonatomic, copy) NSString *orderDate;
@property(nonatomic, copy) NSString *order_price;
@property(nonatomic, copy) NSString *realPrice;
@property(nonatomic, copy) NSString *expDate;
@property(nonatomic, copy) NSString *expLocation;
@property(nonatomic, copy) NSString *payment;//支付方式
@property(nonatomic, copy) NSString *user_name;//收货地址人
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *freight;//运费
@property(nonatomic, copy) NSString *distribution;//配送时间
@property(nonatomic, copy) NSArray *goodList;
@property(nonatomic, copy) NSString *order_code;//订单编号
@property(nonatomic, copy) NSString *point;//使用的积分
@property(nonatomic, copy) NSString *couponAmout;//订单优惠券优惠
@property(nonatomic, strong) NSNumber *candeleteOrder;

@end
