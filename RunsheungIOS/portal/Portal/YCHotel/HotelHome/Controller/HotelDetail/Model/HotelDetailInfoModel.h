//
//  HotelDetailInfoModel.h
//  Portal
//
//  Created by ifox on 2017/5/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelRoomInfoServiceModel.h"

/**
 酒店详情介绍
 */
@interface HotelDetailInfoModel : NSObject

@property(nonatomic, copy) NSString *hotelInfoID;
@property(nonatomic, copy) NSString *hotelName;
@property(nonatomic, copy) NSString *telephone;
@property(nonatomic, copy) NSString *fac;//什么东西???
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *hotelDescription;//有关酒店的介绍
@property(nonatomic, copy) NSString *latitude;
@property(nonatomic, copy) NSString *longtitude;

@property(nonatomic, strong) NSArray<HotelRoomInfoServiceModel *> *serviceInfos;

@end
