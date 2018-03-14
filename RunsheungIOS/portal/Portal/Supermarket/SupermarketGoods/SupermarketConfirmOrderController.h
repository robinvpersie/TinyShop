//
//  SupermarketConfirmOrderController.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/14.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "SupermarketGoodsModel.h"
#import "GoodsOptionModel.h"

@interface SupermarketConfirmOrderController : SupermarketBaseViewController

@property(nonatomic, strong) SupermarketGoodsModel *goodsModel;
@property(nonatomic, assign) NSInteger amout;//购买数量
@property(nonatomic, assign) float totalPrice;
@property(nonatomic, strong) NSArray<GoodsOptionModel *> *attachGoods;//附加商品数组

@property(nonatomic, assign) ControllerType controllerType;

@end
