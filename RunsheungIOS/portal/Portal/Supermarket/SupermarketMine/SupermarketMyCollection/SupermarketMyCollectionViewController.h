//
//  SupermarketMyCollectionViewController.h
//  Portal
//
//  Created by ifox on 2017/5/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"

@interface SupermarketMyCollectionViewController : SupermarketBaseViewController

@property(nonatomic, assign) ControllerType controllerType;
@property(nonatomic, copy) NSString * divCode;
@property(nonatomic, copy) void(^refresh)();

@end
