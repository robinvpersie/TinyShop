//
//  SupermarketRefundData.h
//  Portal
//
//  Created by ifox on 2017/1/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 退款详情数据模型
 */
@interface SupermarketRefundData : NSObject

@property(nonatomic, copy) NSString *refundBill;
@property(nonatomic, copy) NSNumber *refundPrice;
@property(nonatomic, strong) NSArray *refundFollow;//退款流程
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *submitDate;//提交时间
@property(nonatomic, copy) NSString *refundType;//申请类型(原因)

@end
