//
//  HotelConfirmOrderViewController.h
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHoltelBaseViewController.h"
#import "HotelRoomTypeModel.h"

@interface HotelConfirmOrderViewController : YCHoltelBaseViewController

//@property(nonatomic, copy) NSString *roomTypeID;
//@property(nonatomic, strong) NSNumber *price;
@property(nonatomic, copy) NSString *hotelID;

@property(nonatomic, copy) NSString *hotelName;
//@property(nonatomic, copy) NSString *roomTypeName;

@property(nonatomic, strong) HotelRoomTypeModel *roomModel;

@property(nonatomic, retain) NSArray *dateArray;

@end
