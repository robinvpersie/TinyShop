//
//  HotelAlbumImageModel.h
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HotelAlbumType) {
    HotelAlbumTypeAll = 0,
    HotelAlbumTypeOutLook,
    HotelAlbumTypeHall,
    HotelAlbumTypeRoom,
    HotelAlbumTypeFacility,
};

@interface HotelAlbumImageModel : NSObject

@property(nonatomic, assign) HotelAlbumType albumType;
@property(nonatomic, copy) NSString *imageID;
@property(nonatomic, copy) NSString *imgurl;

@end
