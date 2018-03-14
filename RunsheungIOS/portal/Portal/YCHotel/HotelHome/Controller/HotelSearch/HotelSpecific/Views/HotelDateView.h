//
//  HotelDateView.h
//  Portal
//
//  Created by 王五 on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCalendarViewController.h"

@interface HotelDateView : UIView<MSSCalendarViewControllerDelegate>

@property (nonatomic, assign) NSInteger startDate;
@property (nonatomic, assign) NSInteger endDate;
@property (nonatomic, strong) UILabel *startDateLab;
@property (nonatomic, strong) UILabel *endDateLab;
@property (nonatomic, strong) UIButton *totalButton;
@property (nonatomic, copy) NSString *startStr;
@property (nonatomic, copy) NSString *endStr;
@property (nonatomic, copy) NSString *totalStr;
@end
