//
//  SupermarketOrderTableViewCell.h
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SupermarketOrderData;

@interface SupermarketOrderTableViewCell : UITableViewCell


@property(nonatomic, strong) SupermarketOrderData *data;
@property(nonatomic, assign) BOOL isPageView;
@property(nonatomic, assign) ControllerType controllerType;

@end
