//
//  CouponModel.h
//  Portal
//
//  Created by ifox on 2017/2/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>   

typedef NS_ENUM(NSInteger, CouponTye) {
    CouponOverSale = 1,  //满折
    CouponOverCut      //满减
};

@interface CouponModel : NSObject

@property(nonatomic, assign) BOOL cantSelected;//不能被选中

@property(nonatomic, assign) BOOL isSelected;//是否被选中

@property(nonatomic, strong) NSNumber *couponID;//选择的id

@property(nonatomic, assign) CouponTye couponType;
@property(nonatomic, copy) NSString *couponNumber;//优惠券编号
@property(nonatomic, strong) NSNumber *couponRange;//限定使用类型(0无限制全场通用)
@property(nonatomic, copy) NSString *couponRangeMsg;//限定文字说明

@property(nonatomic, copy) NSString *couponName;//优惠券名
@property(nonatomic, copy) NSString *createDate;//接受日期
@property(nonatomic, copy) NSString *startDate;//开始使用日期
@property(nonatomic, copy) NSString *endDate;//使用结束日期
@property(nonatomic, copy) NSString *receiveDate;//到期日期

@property(nonatomic, copy) NSString *overMsg;//满足条件金额说明  (满500使用)
@property(nonatomic, strong) NSNumber *overMoney;//满足条件金额(0.00无条件使用)
@property(nonatomic, strong) NSNumber *platform;//使用平台 默认0全使用平台

@property(nonatomic, strong) NSNumber *upLimitMoney;//折扣上线 最多优惠50元等 优惠券类型2的使用情况
@property(nonatomic, strong) NSNumber *decent;

@end
