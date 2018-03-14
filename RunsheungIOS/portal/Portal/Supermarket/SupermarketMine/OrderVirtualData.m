//
//  OrderVirtualData.m
//  Portal
//
//  Created by ifox on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "OrderVirtualData.h"
#import "SupermarketOrderData.h"

@implementation OrderVirtualData

+ (NSArray *)getAllOrder {
    SupermarketOrderData *data_0 = [[SupermarketOrderData alloc] init];
    data_0.status = OrderWaitPay;
    data_0.time = @"2016-06-25";
//    data_0.status = OrderRefundCommit;
    data_0.goodsCount = 3;
    data_0.totalPrice = 225;
    data_0.goodList = @[@"1",@"2",@"3"];
    
    SupermarketOrderData *data_1 = [[SupermarketOrderData alloc] init];
//    data_1.status = OrderWaitSend;
    data_1.time = @"2016-06-23";
//    data_1.status = OrderRefundCommit;
    data_1.goodsCount = 2;
    data_1.totalPrice = 118;
    data_1.goodList = @[@"1",@"2"];
    
    SupermarketOrderData *data_2 = [[SupermarketOrderData alloc] init];
//    data_2.status = OrderRefundCommit;
    data_2.time = @"2016-06-25";
//    data_2.status = OrderRefundCommit;
    data_2.goodsCount = 1;
    data_2.totalPrice = 118;
    data_2.goodList = @[@"1"];
    
    SupermarketOrderData *data_3 = [[SupermarketOrderData alloc] init];
    data_3.status = OrderWaitComment;
    data_3.time = @"2016-06-21";
//    data_3.status = OrderRefundSuccess;
    data_3.goodsCount = 1;
    data_3.totalPrice = 118;
    data_3.goodList = @[@"1"];
    
    return @[data_0,data_1,data_2,data_0,data_3];
}

@end
