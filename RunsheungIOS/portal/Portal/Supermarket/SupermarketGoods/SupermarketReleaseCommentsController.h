//
//  SupermarketReleaseCommentsController.h
//  Portal
//
//  Created by ifox on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupermarketBaseViewController.h"

@interface SupermarketReleaseCommentsController : SupermarketBaseViewController

@property(nonatomic, strong) SupermarketOrderData *data;
@property(nonatomic, strong) NSArray *waitCommentGoodsArr;//待评价的商品数组

@end
