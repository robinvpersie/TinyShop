//
//  SupermarketConfrimOrderByNumbersController.h
//  Portal
//
//  Created by ifox on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"

/**
 批量结算
 */
@interface SupermarketConfrimOrderByNumbersController : SupermarketBaseViewController

@property(nonatomic, strong) NSArray *dataArray;//商品批量提交数组
@property(nonatomic, assign) float totalPrice;

@property(nonatomic, copy) NSString *divCode;//(无用)

@property(nonatomic, assign) ControllerType controllerType;

@property(nonatomic, strong) NSArray *shopArray;//店铺数组(无用)

@end
