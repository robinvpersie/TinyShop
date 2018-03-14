//
//  SupermarketMyOrderController.h
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"

@interface SupermarketMyOrderController : SupermarketBaseViewController

@property(nonatomic, assign) ControllerType controllerType;

@property(nonatomic, assign) NSInteger pageIndex;

@property(nonatomic, copy) void (^refresh)();

@end
