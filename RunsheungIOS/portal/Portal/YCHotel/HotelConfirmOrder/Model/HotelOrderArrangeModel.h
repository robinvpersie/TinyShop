//
//  HotelOrderArrangeModel.h
//  Portal
//
//  Created by ifox on 2017/4/25.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelOrderDetailModel.h"

@interface HotelOrderArrangeModel : NSObject

@property(nonatomic, copy) NSString *reserveInfo;
@property(nonatomic, copy) NSString *retainTime;//预计到店
@property(nonatomic, copy) NSString *arriveTime;
@property(nonatomic, copy) NSString *hotelName;
@property(nonatomic, copy) NSString *leaveTime;
@property(nonatomic, assign) HotelOrderStatus orderstatus;
@property(nonatomic, copy) NSString *phoneNum;
@property(nonatomic, strong) NSNumber *roomCount;
@property(nonatomic, copy) NSString *roomTypeID;
@property(nonatomic, copy) NSString *roomTypeName;
@property(nonatomic, copy) NSString *userName;

@property(nonatomic, copy) NSString *guestName;//入住人
@property(nonatomic, copy) NSString *guestPhone;//入住人手机


@end
