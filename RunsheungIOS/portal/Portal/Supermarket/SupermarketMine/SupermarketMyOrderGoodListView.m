//
//  SupermarketMyOrderGoodListView.m
//  Portal
//
//  Created by ifox on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMyOrderGoodListView.h"
#import "SupermarketMyOrderGoodView.h"
#import "SupermarketOrderGoodsData.h"

#define CellHeight  110

@interface SupermarketMyOrderGoodListView ()

@end

@implementation SupermarketMyOrderGoodListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setGoodsListArray:(NSArray *)goodsListArray {
    _goodsListArray = goodsListArray;
    
    for (int i = 0; i < goodsListArray.count; i++) {
        SupermarketMyOrderGoodView *goodView = [[SupermarketMyOrderGoodView alloc] initWithFrame:CGRectMake(0, CellHeight * i + 5*i, APPScreenWidth, CellHeight)];
        goodView.data = goodsListArray[i];
        [self addSubview:goodView];
    }
    
}

@end
