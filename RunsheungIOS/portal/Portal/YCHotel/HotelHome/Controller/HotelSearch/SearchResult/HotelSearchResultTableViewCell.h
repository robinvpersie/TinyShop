//
//  HotelSearchResultTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/4/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelHomeListModel.h"

@interface HotelSearchResultTableViewCell : UITableViewCell

@property(nonatomic, assign) int rommType;
@property(nonatomic, strong) HotelHomeListModel *data;

@end
