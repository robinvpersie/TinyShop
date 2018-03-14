//
//  SupermarketMineViewController.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"

typedef NS_ENUM(NSInteger, ControllerType) {
    ControllerTypeSupermarket = 0,
    ControllerTypeDepartmentStores,
};

@interface SupermarketMineViewController : SupermarketBaseViewController

@property(nonatomic, assign) ControllerType controllerType;
@property(nonatomic, copy) NSString * divCode;
- (void)checkLogStatus;

@end
