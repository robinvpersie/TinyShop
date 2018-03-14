//
//  CouponTableView.h
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CouponStatus) {
    CouponWaitUse = 0,
    CouponUsed,
    CouponOvertime,
    CouponCantUse,
    CouponAll,
};


@interface CouponTableView : UITableView

@property(nonatomic, assign) CouponStatus couponStatus;

@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) NSMutableArray *selectedArray;

@end
