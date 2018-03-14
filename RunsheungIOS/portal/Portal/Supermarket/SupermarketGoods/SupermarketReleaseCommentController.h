//
//  SupermarketReleaseCommentController.h
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "SupermarketOrderData.h"

@interface SupermarketReleaseCommentController : SupermarketBaseViewController

@property(nonatomic, strong) SupermarketOrderData *orderData;
@property(nonatomic, assign) NSInteger index;//第几个商品....

@property(nonatomic, strong) SupermarketOrderGoodsData *goodsData;

@property(nonatomic, assign) ControllerType controllerType;

@property(nonatomic, assign) BOOL isOrderDetail;

@property(nonatomic, assign) BOOL isLastOne;//是否是多商品的最后一个商品

@end
