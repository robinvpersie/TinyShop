//
//  GoodsDetailController.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "SupermarketMineViewController.h"

@interface GoodsDetailController : SupermarketBaseViewController

@property(nonatomic, copy) NSString *item_code;//商品编号

@property(nonatomic, copy) NSString *divCode;

@property(nonatomic, assign) ControllerType controllerType;

@property(nonatomic, assign) BOOL isScan;

@end
