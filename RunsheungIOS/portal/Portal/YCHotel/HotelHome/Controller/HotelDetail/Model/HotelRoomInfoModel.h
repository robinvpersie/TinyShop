//
//  HotelRoomInfoModel.h
//  Portal
//
//  Created by ifox on 2017/4/26.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelRoomInfoServiceModel.h"

@interface HotelRoomInfoModel : NSObject

@property(nonatomic, copy) NSString *roomTypeID;
@property(nonatomic, copy) NSString *roomTypeName;
@property(nonatomic, copy) NSString *availableNum;
@property(nonatomic, copy) NSString *floor;
@property(nonatomic, copy) NSString *area;
@property(nonatomic, copy) NSString *wifi;
@property(nonatomic, copy) NSString *bedType;

@property(nonatomic, copy) NSArray *imageUrls;
@property(nonatomic, copy) NSArray<HotelRoomInfoServiceModel *> *hotelRoomFacility;
@property(nonatomic, copy) NSArray<HotelRoomInfoServiceModel *> *hotelRoomShower;
@property(nonatomic, copy) NSArray<HotelRoomInfoServiceModel *> *hotelRoomFoods;
@property(nonatomic, copy) NSArray<HotelRoomInfoServiceModel *> *hotelMedia;


@end
