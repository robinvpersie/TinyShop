//
//  HotelSpecificTableView.h
//  Portal
//
//  Created by 王五 on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotelRoomTypeModel;
@protocol HotelSpecificTableViewDelegate<NSObject>
- (void)talbeViewSumbitAction:(id)vc;
- (void)tableViewSelectCell:(HotelRoomTypeModel *)model;
@end

@interface HotelSpecificTableView : UITableView

@property (nonatomic,strong)NSArray *hotelroomData;
@property (nonatomic, copy) NSString *hotelID;
@property (nonatomic, copy) NSString *hotelName;

@property (nonatomic, assign) id<HotelSpecificTableViewDelegate> tabledelegate;
@end
