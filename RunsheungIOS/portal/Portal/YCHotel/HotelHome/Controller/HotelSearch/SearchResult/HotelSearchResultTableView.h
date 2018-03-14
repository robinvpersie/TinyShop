//
//  HotelSearchResultTableView.h
//  Portal
//
//  Created by ifox on 2017/4/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HotelRoomType) {
    HotelRoomTypeAllDay = 0,
    HotelRoomTypeHour,
};

@interface HotelSearchResultTableView : UITableView

@property(nonatomic, assign) HotelRoomType roomType;
@property(nonatomic, strong) NSArray *dataArray;

@end
