//
//  HotelRoomTypeModel.h
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelRoomTypeModel : NSObject

@property(nonatomic, copy) NSString *roomTypeID;//房型ID
@property(nonatomic, copy) NSString *roomTypeName;//房型名
@property(nonatomic, strong) NSNumber *NoMemeberPrice;//非会员价
@property(nonatomic, strong) NSNumber *MemeberPrice;//会员价(显示会员价)
@property(nonatomic, copy) NSString *remark;//备注
@property(nonatomic, copy) NSString *iconUrl;//房型图片地址

@end
