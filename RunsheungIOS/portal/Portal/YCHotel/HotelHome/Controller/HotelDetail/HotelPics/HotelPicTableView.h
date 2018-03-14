//
//  HotelPicTableView.h
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PicType) {
    PicTypeAll = 0,
    PicTypeOutLook,
    PicTypeHall,
    PicTypeRoom,
    PicTypeFacility,
};

@interface HotelPicTableView : UITableView

@property(nonatomic, assign) PicType picType;
@property(nonatomic, strong) NSArray *dataArr;

@end
