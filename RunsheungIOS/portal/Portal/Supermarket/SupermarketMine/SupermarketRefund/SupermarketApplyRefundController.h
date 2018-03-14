//
//  SupermarketApplyRefundController.h
//  Portal
//
//  Created by ifox on 2017/1/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "OrderDetailModel.h"
#import "SupermarketOrderGoodsData.h"

@interface SupermarketApplyRefundController : SupermarketBaseViewController

@property(nonatomic, strong) OrderDetailModel *orderDetail;
@property(nonatomic, strong) SupermarketOrderData *orderData;

@property(nonatomic, copy) NSString *orderNum;//订单编号

@property(nonatomic, strong) SupermarketOrderGoodsData *goods;

@end
