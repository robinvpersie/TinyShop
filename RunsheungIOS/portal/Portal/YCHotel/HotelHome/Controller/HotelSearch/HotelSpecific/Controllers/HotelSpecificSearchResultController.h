//
//  HotelSpecificSearchResultController.h
//  Portal
//
//  Created by 王五 on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHoltelBaseViewController.h"
@class HotelHomeListModel;

@interface HotelSpecificSearchResultController : YCHoltelBaseViewController
- (instancetype)initWithModel:(HotelHomeListModel*)model;
@property(nonatomic,strong)HotelHomeListModel* homelistmodel;
@end
