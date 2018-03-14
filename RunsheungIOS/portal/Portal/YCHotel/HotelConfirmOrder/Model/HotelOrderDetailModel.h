//
//  HotelOrderDetailModel.h
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HotelOrderStatus) {
    HotelOrderStatusWaitPay = 0,//订单待支付
    HotelOrderStatusPayFinish,//订单已支付
    HotelOrderStatusOverTime,//订单超时
    HotelOrderStatusCancel,//订单取消
    HotelOrderStatusLiveIn,//已入住
    HotelOrderStatusLeave,//已离店
    HotelOrderStatusComment,//已评论
    HotelOrderStatusDelete,//删除
//    HotelOrderStatusArrangedRoom,//已排房
    HotelOrderStatusRoomOverTime,//已过保留时间 无法取消订单
    HotelOrderStatusWaitTake,//等待接单
    HotelOrderStatusTaking,//酒店已接单
    HotelOrderStatusRefuse,//酒店拒绝接单
};

@interface HotelOrderDetailModel : NSObject

@property(nonatomic, copy) NSString *latitude;
@property(nonatomic, copy) NSString *longtitude;

@property(nonatomic, copy) NSString *hotelPhoneNum;

@property(nonatomic, copy) NSString *orderID;
@property(nonatomic, copy) NSString *hotelName;
@property(nonatomic, copy) NSString *hotelID;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *roomTypeID;
@property(nonatomic, copy) NSString *roomTypeName;
@property(nonatomic, copy) NSString *userName;//预订人姓名
@property(nonatomic, copy) NSString *phoneNum;//预订人手机号
@property(nonatomic, copy) NSString *arriveTime;//入住时间
@property(nonatomic, copy) NSString *leaveTime;//离店时间
@property(nonatomic, strong) NSNumber *roomPrice;
@property(nonatomic, strong) NSNumber *point;//使用积分

@property(nonatomic, copy) NSString *order_point;//订单使用的积分,支付时调用
@property(nonatomic, copy) NSString *real_amount;//实际金额

@property(nonatomic, strong) NSNumber *roomCount;//实际支付金额
@property(nonatomic, strong) NSNumber *orderPrice;//订单金额
@property(nonatomic, copy) NSString *reserveTime;//预定时间
@property(nonatomic, copy) NSString *imageUrl;//图片地址
@property(nonatomic, assign) HotelOrderStatus orderStatus;
@property(nonatomic, copy) NSString *currentTime;
@property(nonatomic, copy) NSString *overTime;
@property(nonatomic, copy) NSString *checkInTime;//入住时间
@property(nonatomic, copy) NSArray *roomInfo;//开锁信息

@property(nonatomic, copy) NSString *guestName;//入住人
@property(nonatomic, copy) NSString *guestPhone;//入住人手机
@property(nonatomic, copy) NSString *retainTime;//入住时间


@end
