//
//  NSDictionary+YCHotel.h
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HotelHomeListModel;
@class HotelAlbumImageModel;
@class HotelCityModel;
@class HotelDetailModel;
@class HotelOrderDetailModel;
@class HotelOrderListModel;
@class HotelOrderArrangeModel;
@class HotelRoomInfoModel;
@class HotelCommentModel;
@class HotelDetailInfoModel;
@class HotelRetainTimeModel;

@interface NSDictionary (YCHotel)

+ (HotelHomeListModel *)getHotelHomeListModelWithDic:(NSDictionary *)dic;

+ (HotelAlbumImageModel *)getHotelAlbumModelWithDic:(NSDictionary *)dic;

+ (HotelCityModel *)getHotelCityModelWithDic:(NSDictionary *)dic;

+ (HotelDetailModel *)getHotelDetaiModelWithDic:(NSDictionary *)dic;

+ (HotelOrderDetailModel *)getHotelOrderDetailModelWithDic:(NSDictionary *)dic;

+ (HotelOrderListModel *)getHotelOrderListModelWithDic:(NSDictionary *)dic;

+ (HotelOrderArrangeModel *)getHotelOrderArrangeModelWithDic:(NSDictionary *)dic;

+ (HotelRoomInfoModel *)getHotelRoomTypeInfoModelWithDic:(NSDictionary *)dic;

+ (HotelCommentModel *)getHotelCommentModelWithDic:(NSDictionary *)dic;

+ (HotelDetailInfoModel *)getHotelDetailIntroModelWithDic:(NSDictionary *)dic;

+ (HotelRetainTimeModel *)getHotelRetainTimeModelWithDic:(NSDictionary *)dic;
@end
