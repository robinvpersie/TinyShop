//
//  HotelProgressView.h
//  Portal
//
//  Created by ifox on 2017/4/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelOrderDetailModel.h"

@interface HotelProgressView : UIView

@property(nonatomic, copy) NSString *createOrderTime;

@property(nonatomic, assign) HotelOrderStatus hotelOrderStatus;

@end
