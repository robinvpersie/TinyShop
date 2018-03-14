//
//  CouponTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@class CouponTableViewCell;

@protocol SelectCouponDelegate <NSObject>

@optional

- (void)selectCoupon:(CouponTableViewCell *)cell
          isSelected:(BOOL)isSelected;

@end

@interface CouponTableViewCell : UITableViewCell

@property(nonatomic, assign) NSInteger couponStatus;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, weak) id<SelectCouponDelegate> delegate;

@property(nonatomic, strong) CouponModel *coupon;

@end
