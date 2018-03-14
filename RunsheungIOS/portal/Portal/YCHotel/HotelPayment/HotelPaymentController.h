//
//  HotelPaymentController.h
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHoltelBaseViewController.h"
#import "HotelRoomTypeModel.h"

@interface HotelPaymentController : YCHoltelBaseViewController

@property(nonatomic, copy) NSString *paymentMoney;//实际支付金额
@property(nonatomic, copy) NSString *orderNum;//订单号
@property(nonatomic, copy) NSString *orderMoney;//订单金额
@property(nonatomic, copy) NSString *point;//积分

@property(nonatomic, copy) NSString *serverTime;//服务器时间
@property(nonatomic, copy) NSString *overTime;//超时时间

@property(nonatomic, copy) NSString *startDate;//入住时间
@property(nonatomic, copy) NSString *endDate;//离店时间
@property(nonatomic, copy) NSString *liveDays;//入住天数

@property(nonatomic, copy) NSString *hotelName;

@property(nonatomic, strong) HotelRoomTypeModel *roomModel;

@property(nonatomic, assign) BOOL isCreate;//是否是创建订单时

@end
