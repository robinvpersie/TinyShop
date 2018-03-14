//
//  SupermarketNewAddessController.h
//  Portal
//
//  Created by ifox on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "SupermarketAddressModel.h"

@interface SupermarketNewAddessController : SupermarketBaseViewController

@property(nonatomic, strong) SupermarketAddressModel *addressModel;

@property(nonatomic, assign) BOOL isMyAddress;

@end
