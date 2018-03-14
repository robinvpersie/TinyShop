//
//  RefundListData.h
//  Portal
//
//  Created by ifox on 2017/3/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RefundListStatus) {
    RefundListStatus0 = 0,
    RefundListStatus1,
    RefundListStatus2,
    RefundListStatus3,
    RefundListStatus4,
    RefundListStatus5,
    RefundListStatus6,
    RefundListStatus7,
};

/**
 退款列表数据模型
 */
@interface RefundListData : NSObject

@property(nonatomic, copy) NSString *applyTime;
@property(nonatomic, copy) NSString *imageURl;
@property(nonatomic, copy) NSString *item_name;
@property(nonatomic, copy) NSString *itemCode;
@property(nonatomic, copy) NSString *orderNum;
@property(nonatomic, copy) NSString *refundNo;
@property(nonatomic, assign) RefundListStatus status;

@end
