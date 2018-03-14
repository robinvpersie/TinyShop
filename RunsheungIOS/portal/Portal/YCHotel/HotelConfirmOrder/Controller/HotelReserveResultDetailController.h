//
//  HotelReserveResultDetailController.h
//  Portal
//
//  Created by ifox on 2017/4/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHoltelBaseViewController.h"
#import "HotelOrderListModel.h"

@interface HotelReserveResultDetailController : YCHoltelBaseViewController

@property(nonatomic, copy) NSString *orderNum;
@property(nonatomic, strong) HotelOrderListModel *orderListModel;

@end
