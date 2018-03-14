//
//  HotelRoomInfoServiceModel.h
//  Portal
//
//  Created by ifox on 2017/4/26.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelRoomInfoServiceModel : NSObject

@property(nonatomic, copy) NSString *serviceName;
@property(nonatomic, copy) NSString *seqID;
@property(nonatomic, copy) NSString *serviceDetailName;
@property(nonatomic, copy) NSString *imageUrl;

@property(nonatomic, strong) NSNumber *useYN;//我也不知道是什么

@end
