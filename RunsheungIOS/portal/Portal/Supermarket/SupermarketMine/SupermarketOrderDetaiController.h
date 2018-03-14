//
//  SupermarketOrderDetaiController.h
//  Portal
//
//  Created by ifox on 2017/1/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"

@interface SupermarketOrderDetaiController : SupermarketBaseViewController

@property(nonatomic, copy) NSString *orderID;
@property(nonatomic, assign) NSInteger orderStatus;
@property(nonatomic, strong) SupermarketOrderData *data;

@property(nonatomic, assign) ControllerType controllerType;

@end
