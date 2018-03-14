//
//  HotelReseveResultInfoTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/4/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelOrderDetailModel.h"

@interface HotelReseveResultInfoTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *hotelName;
@property(nonatomic, strong) UILabel *hotelLocation;

@property(nonatomic, strong) HotelOrderDetailModel *oderDetail;
@end
