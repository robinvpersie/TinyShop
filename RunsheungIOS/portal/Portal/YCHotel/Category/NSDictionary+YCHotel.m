//
//  NSDictionary+YCHotel.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "NSDictionary+YCHotel.h"
#import "HotelHomeListModel.h"
#import "HotelAlbumImageModel.h"
#import "HotelCityModel.h"
#import "HotelDetailModel.h"
#import "HotelRatedModel.h"
#import "HotelSeviceInfoModel.h"
#import "HotelRoomTypeModel.h"
#import "HotelOrderDetailModel.h"
#import "HotelOrderListModel.h"
#import "HotelOrderDetailRoomModel.h"
#import "HotelOrderArrangeModel.h"
#import "HotelRoomInfoModel.h"
#import "HotelRoomInfoServiceModel.h"
#import "HotelCommentModel.h"
#import "HotelDetailInfoModel.h"
#import "HotelRetainTimeModel.h"

@implementation NSDictionary (YCHotel)

+ (HotelHomeListModel *)getHotelHomeListModelWithDic:(NSDictionary *)dic {
    HotelHomeListModel *model = [[HotelHomeListModel alloc] init];
    if (dic) {
        model.district = dic[@"district"];
        model.hotleName = dic[@"hotelname"];
        model.hotelInfoID = dic[@"hotelinfoid"];
        model.noMemeberPrice = dic[@"nomemeberprice"];
        model.score = ((NSNumber *)dic[@"total_score"]).floatValue;
        model.rateCount = ((NSNumber *)dic[@"rated_count"]).integerValue;
        model.hotelLev = dic[@"hotellev"];
        model.photoUrl = dic[@"photeurl"];
    }
    return model;
}

+ (HotelAlbumImageModel *)getHotelAlbumModelWithDic:(NSDictionary *)dic {
    HotelAlbumImageModel *model = [[HotelAlbumImageModel alloc] init];
    if (dic) {
        model.imageID = dic[@"imageid"];
        model.albumType = ((NSNumber *)dic[@"imagetype"]).integerValue;
        model.imgurl = dic[@"imgurl"];
    }
    return model;
}

+ (HotelCityModel *)getHotelCityModelWithDic:(NSDictionary *)dic {
    HotelCityModel *model = [[HotelCityModel alloc] init];
    if (dic) {
        model.cityName = dic[@"cityName"];
        model.zipCode = dic[@"cityZipcode"];
    }
    return model;
}

+ (HotelDetailModel *)getHotelDetaiModelWithDic:(NSDictionary *)dic {
    HotelDetailModel *model = [[HotelDetailModel alloc] init];
    if (dic) {
        NSDictionary *hotelInfo = dic[@"HotelInfo"];
        model.address = hotelInfo[@"Address"];
        model.hotelID = hotelInfo[@"HotelInfoID"];
        model.hotelName = hotelInfo[@"HotelName"];
        model.hotelPhoto = hotelInfo[@"PhoteURL"];
        model.latitude = hotelInfo[@"Latitude"];
        model.longtitude = hotelInfo[@"Longitude"];
        
        HotelRatedModel *rated = [[HotelRatedModel alloc] init];
        NSDictionary *hotelRated = dic[@"Rated"];
        rated.ratedContext = hotelRated[@"ratedContext"];
        rated.ratedName = hotelRated[@"ratedName"];
        rated.totalScore = hotelRated[@"total_score"];
        rated.userName = hotelRated[@"userName"];        
        model.rated = rated;
        
        NSMutableArray *roomTypeModels = @[].mutableCopy;
        
        NSArray *roomTypeDatas = dic[@"RoomTypeData"];
        if (roomTypeDatas.count > 0) {
            for (NSDictionary *roomTypeData in roomTypeDatas) {
                HotelRoomTypeModel *roomType = [[HotelRoomTypeModel alloc] init];
                roomType.MemeberPrice = roomTypeData[@"MemeberPrice"];
                roomType.iconUrl = roomTypeData[@"RoomTypeImg"];
                roomType.NoMemeberPrice = roomTypeData[@"NoMemeberPrice"];
                roomType.remark = roomTypeData[@"Remark"];
                roomType.roomTypeID = roomTypeData[@"RoomTypeID"];
                roomType.roomTypeName = roomTypeData[@"RoomTypeName"];
                [roomTypeModels addObject:roomType];
            }
        }
        model.hotelRoomTypes = roomTypeModels.copy;
        
        NSMutableArray *serviceModels = @[].mutableCopy;
        NSArray *serviceInfoDatas = dic[@"ServiceInfo"];
        if (serviceInfoDatas.count > 0) {
            for (NSDictionary *serviceInfoData in serviceInfoDatas) {
                HotelSeviceInfoModel *seviceModel = [[HotelSeviceInfoModel alloc] init];
                seviceModel.SeqID = serviceInfoData[@"SeqID"];
                seviceModel.ServiceDetailName = serviceInfoData[@"ServiceDetailName"];
                seviceModel.imageUrl = serviceInfoData[@"ImageURL"];
                [serviceModels addObject:seviceModel];
            }
        }
        model.hotelServices = serviceModels.copy;
    }
    return model;
}

+ (HotelOrderDetailModel *)getHotelOrderDetailModelWithDic:(NSDictionary *)dic {
    HotelOrderDetailModel *model = [[HotelOrderDetailModel alloc] init];
    if (dic) {
        model.latitude = dic[@"Latitude"];
        model.guestName = dic[@"GuestName"];
        model.guestPhone = dic[@"GuestPhone"];
        model.retainTime = dic[@"RetainTime"];
        model.longtitude = dic[@"Longitude"];
        model.hotelPhoneNum = dic[@"hotelPhone"];
        model.orderID = dic[@"orderId"];
        model.hotelName = dic[@"hotelName"];
        model.hotelID = dic[@"hotelInfoID"];
        model.address = dic[@"address"];
        model.roomTypeID = dic[@"roomTypeID"];
        model.roomTypeName = dic[@"roomTypeName"];
        model.userName = dic[@"userName"];
        model.phoneNum = dic[@"phonenum"];
        model.arriveTime = dic[@"arriveTime"];
        model.leaveTime = dic[@"leaveTime"];
        model.roomPrice = dic[@"roomPrice"];
        model.roomCount = dic[@"roomCount"];
        model.reserveTime = dic[@"reserveTime"];
        model.orderStatus = ((NSNumber *)dic[@"orderStatus"]).integerValue;
        model.currentTime = dic[@"currentTime"];
        model.overTime = dic[@"overTime"];
        model.checkInTime = dic[@"checkInTime"];
        model.imageUrl = dic[@"imgurl"];
        model.point = dic[@"point_amount"];
        model.orderPrice = dic[@"order_amount"];
        model.order_point = dic[@"order_point"];
        model.real_amount = dic[@"real_amount"];
//        model.roomInfo = dic[@"roomInfo"];
        NSMutableArray *roomInfoArr = @[].mutableCopy;
        NSArray *roomInfo = dic[@"roomInfo"];
        if (roomInfo.count > 0) {
            for (NSDictionary *roomInfoDta in roomInfo) {
                HotelOrderDetailRoomModel *roomModel = [[HotelOrderDetailRoomModel alloc] init];
                roomModel.registerID = roomInfoDta[@"RegisterID"];
                roomModel.roomNo = roomInfoDta[@"RoomNo"];
                [roomInfoArr addObject:roomModel];
            }
        }
        model.roomInfo = roomInfoArr.mutableCopy;
        
    }
    return model;
}

+ (HotelOrderListModel *)getHotelOrderListModelWithDic:(NSDictionary *)dic {
    HotelOrderListModel *model = [[HotelOrderListModel alloc] init];
    if (dic) {
        model.arriveTime = dic[@"arriveTime"];
        model.currentTime = dic[@"currentTime"];
        model.hotelName = dic[@"hotelName"];
        model.leaveTime = dic[@"leaveTime"];
        model.orderID = dic[@"orderId"];
        model.orderStatus = ((NSNumber *)dic[@"orderStatus"]).integerValue;
        model.overTime = dic[@"overTime"];
        model.reserveTime = dic[@"reserveTime"];
        model.roomCount = dic[@"roomCount"];
        model.roomPrice = dic[@"roomPrice"];
        model.roomTypeID = dic[@"roomTypeID"];
        model.roomTypeName = dic[@"roomTypeName"];
    }
    return model;
}

+ (HotelOrderArrangeModel *)getHotelOrderArrangeModelWithDic:(NSDictionary *)dic {
    HotelOrderArrangeModel *model = [[HotelOrderArrangeModel alloc] init];
    if (dic) {
        model.reserveInfo = dic[@"ReserveInfo"];
        model.guestName = dic[@"GuestName"];
        model.guestPhone = dic[@"GuestPhone"];
        model.retainTime = dic[@"RetainTime"];
        model.arriveTime = dic[@"arriveTime"];
        model.hotelName = dic[@"hotelName"];
        model.leaveTime = dic[@"leaveTime"];
        model.orderstatus = ((NSNumber *)dic[@"orderStatus"]).integerValue;
        model.phoneNum = dic[@"phonenum"];
        model.roomCount = dic[@"roomCount"];
        model.roomTypeID = dic[@"roomTypeID"];
        model.roomTypeName = dic[@"roomTypeName"];
        model.userName = dic[@"userName"];
    }
    return model;
}

+ (HotelRoomInfoModel *)getHotelRoomTypeInfoModelWithDic:(NSDictionary *)dic {
    HotelRoomInfoModel *model = [[HotelRoomInfoModel alloc] init];
    if (dic) {
        NSArray *roomTypeInfoArr = dic[@"RoomTypeInfo"];
        
        NSDictionary *roomTypeInfo = roomTypeInfoArr.firstObject;
        model.roomTypeID = roomTypeInfo[@"roomtypeid"];
        model.roomTypeName = roomTypeInfo[@"roomtypename"];
        model.availableNum = roomTypeInfo[@"availableNum"];
        model.floor = roomTypeInfo[@"floor"];
        model.area = roomTypeInfo[@"area"];
        model.wifi = roomTypeInfo[@"wifi"];
        model.bedType = roomTypeInfo[@"bedType"];
        
        NSMutableArray *imageUrls = @[].mutableCopy;
        
        NSArray *roomTypeImg = dic[@"RoomTypeImg"];
        if (roomTypeImg.count > 0) {
            for (NSDictionary *roomImgDic in roomTypeImg) {
                NSString *imgUrl = roomImgDic[@"imgurl"];
                [imageUrls addObject:imgUrl];
            }
        }
        model.imageUrls = imageUrls.copy;
        
        {
            //食品
            NSMutableArray *foodsModel = @[].mutableCopy;
            NSArray *foodsData = dic[@"Fooddrinks"];
            if (foodsData.count > 0) {
                for (NSDictionary *foodData in foodsData) {
                    HotelRoomInfoServiceModel *foodModel = [[HotelRoomInfoServiceModel alloc] init];
                    foodModel.seqID = foodData[@"SeqID"];
                    foodModel.serviceDetailName = foodData[@"ServiceDetailName"];
                    foodModel.serviceName = foodData[@"ServiceName"];
                    [foodsModel addObject:foodModel];
                }
            }
            model.hotelRoomFoods = foodsModel.copy;
        }
        
        {
            //娱乐
            NSMutableArray *mediaModels = @[].mutableCopy;
            NSArray *mediaDatas = dic[@"Media"];
            if (mediaDatas.count > 0) {
                for (NSDictionary *mediaData in mediaDatas) {
                    HotelRoomInfoServiceModel *mediaModel = [[HotelRoomInfoServiceModel alloc] init];
                    mediaModel.seqID = mediaData[@"SeqID"];
                    mediaModel.serviceDetailName = mediaData[@"ServiceDetailName"];
                    mediaModel.serviceName = mediaData[@"ServiceName"];
                    [mediaModels addObject:mediaModel];
                }
            }
            model.hotelMedia = mediaModels.copy;
        }
        
        {
        //浴室
            NSMutableArray *showerModels = @[].mutableCopy;
            NSArray *showerDatas = dic[@"Shower"];
            if (showerDatas.count > 0) {
                for (NSDictionary *showerData in showerDatas) {
                    HotelRoomInfoServiceModel *showerModel = [[HotelRoomInfoServiceModel alloc] init];
                    showerModel.seqID = showerData[@"SeqID"];
                    showerModel.serviceDetailName = showerData[@"ServiceDetailName"];
                    showerModel.serviceName = showerData[@"ServiceName"];
                    [showerModels addObject:showerModel];
                }
            }
            model.hotelRoomShower = showerModels.copy;
        }
        
        {
        //房间设施
            NSMutableArray *facilityModels = @[].mutableCopy;
            NSArray *facilityDatas = dic[@"Roomfacilities"];
            if (facilityDatas.count > 0) {
                for (NSDictionary *facilityData in facilityDatas) {
                    HotelRoomInfoServiceModel *facilityModel = [[HotelRoomInfoServiceModel alloc] init];
                    facilityModel.seqID = facilityData[@"SeqID"];
                    facilityModel.serviceDetailName = facilityData[@"ServiceDetailName"];
                    facilityModel.serviceName = facilityData[@"ServiceName"];
                    [facilityModels addObject:facilityModel];
                }
            }
            model.hotelRoomFacility = facilityModels.copy;
        }
        
        
    }
    return model;
}

+ (HotelCommentModel *)getHotelCommentModelWithDic:(NSDictionary *)dic {
    HotelCommentModel *model = [[HotelCommentModel alloc] init];
    if (dic) {
        model.content = dic[@"context"];
        model.userName = dic[@"nick_name"];
        model.hotelReply = dic[@"parent_rated"];
        model.commentID = dic[@"ratedid"];
        model.commentTime = dic[@"ratedtime"];
        NSNumber *score = dic[@"total_score"];
        model.score = score.floatValue;
        model.roomTypeName = dic[@"roomtypename"];
        
        NSMutableArray *images = @[].mutableCopy;
        
        NSArray *imageUrls = dic[@"imgurl"];
        if (imageUrls.count > 0) {
            for (NSDictionary *imageData in imageUrls) {
                NSString *url = imageData[@"ImageURL"];
                [images addObject:url];
            }
        }
        model.images = images.copy;
    }
    return model;
}

+ (HotelDetailInfoModel *)getHotelDetailIntroModelWithDic:(NSDictionary *)dic {
    HotelDetailInfoModel *model = [[HotelDetailInfoModel alloc] init];
    if (dic) {
        NSArray *hotelDetailArr = dic[@"HotelDetail"];
        NSDictionary *hotelDetail = hotelDetailArr.firstObject;
        model.address = hotelDetail[@"Address"];
        model.hotelDescription = hotelDetail[@"Descriptions"];
        model.fac = hotelDetail[@"Fac"];
        model.hotelInfoID = hotelDetail[@"HotelInfoID"];
        model.hotelName = hotelDetail[@"HotelName"];
        model.latitude = hotelDetail[@"Latitude"];
        model.longtitude = hotelDetail[@"Longitude"];
        model.telephone = hotelDetail[@"TelPhone"];
        
        NSArray *serviceInfoData = dic[@"ServiceInfo"];
        NSMutableArray *serviceModels = @[].mutableCopy;
        if (serviceInfoData.count > 0) {
            for (NSDictionary *serviceInfoDic in serviceInfoData) {
                HotelRoomInfoServiceModel *serviceModel = [[HotelRoomInfoServiceModel alloc] init];
                serviceModel.seqID = serviceInfoDic[@"SeqID"];
                serviceModel.serviceDetailName = serviceInfoDic[@"ServiceDetailName"];
                serviceModel.serviceName = serviceInfoDic[@"ServiceName"];
                serviceModel.useYN = serviceInfoDic[@"UseYN"];
                serviceModel.imageUrl = serviceInfoDic[@"ImageURL"];
                [serviceModels addObject:serviceModel];
            }
        }
        model.serviceInfos = serviceModels.copy;
    }
    return model;
}

+ (HotelRetainTimeModel *)getHotelRetainTimeModelWithDic:(NSDictionary *)dic {
    HotelRetainTimeModel *model = [[HotelRetainTimeModel alloc] init];
    if (dic) {
        model.dictKey = dic[@"DictKey"];
        model.dictType = dic[@"DictType"];
        model.dictValue = dic[@"DictValue"];
        model.remark = dic[@"Remark"];
        model.SystemDictionaryID = dic[@"SystemDictionaryID"];
    }
    return model;
}

@end
