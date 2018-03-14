//
//  HotelReleaseCommentViewController.h
//  Portal
//
//  Created by ifox on 2017/4/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHoltelBaseViewController.h"
#import "HotelOrderDetailModel.h"

@interface HotelReleaseCommentViewController : YCHoltelBaseViewController

@property(nonatomic, copy) NSString *hotelID;
@property(nonatomic, copy) NSString *orderID;
@property(nonatomic, strong) HotelOrderDetailModel *orderDetail;

@end
