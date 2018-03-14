//
//  HotelOrderListModel.h
//  Portal
//
//  Created by ifox on 2017/4/19.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelOrderDetailModel.h"

//typedef NS_ENUM(NSInteger, HotelOrderStatus) {
//    HotelOrderStatusWaitPay = 0,//订单待支付
//    HotelOrderStatusPayFinish,//订单已支付
//    HotelOrderStatusOverTime,//订单超时
//    HotelOrderStatusCancel,//订单取消
//    HotelOrderStatusLiveIn,//已入住
//    HotelOrderStatusLeave,//已离店
//    HotelOrderStatusComment,//已评论
//    HotelOrderStatusDelete,//删除
//};


@interface HotelOrderListModel : NSObject

@property(nonatomic, copy) NSString *orderID;
@property(nonatomic, copy) NSString *hotelName;
@property(nonatomic, copy) NSString *roomTypeID;
@property(nonatomic, copy) NSString *roomTypeName;
@property(nonatomic, copy) NSString *arriveTime;
@property(nonatomic, copy) NSString *leaveTime;
@property(nonatomic, strong) NSNumber *roomPrice;
@property(nonatomic, strong) NSNumber *roomCount;
@property(nonatomic, assign) HotelOrderStatus orderStatus;
@property(nonatomic, copy) NSString *reserveTime;
@property(nonatomic, copy) NSString *currentTime;
@property(nonatomic, copy) NSString *overTime;

@end
