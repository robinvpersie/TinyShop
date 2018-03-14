//
//  HotelDetailModel.h
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelRatedModel.h"
#import "HotelSeviceInfoModel.h"
#import "HotelRoomTypeModel.h"

@interface HotelDetailModel : NSObject

@property(nonatomic, copy) NSString *hotelID;
@property(nonatomic, copy) NSString *hotelName;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *hotelPhoto;
@property(nonatomic, copy) NSString *latitude;
@property(nonatomic, copy) NSString *longtitude;
@property(nonatomic, strong) HotelRatedModel *rated;//置顶评价
@property(nonatomic, strong) NSArray<HotelSeviceInfoModel *> *hotelServices;
@property(nonatomic, strong) NSArray<HotelRoomTypeModel *> *hotelRoomTypes;//所有房型

@end
