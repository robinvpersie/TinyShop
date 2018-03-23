//
//  LZShopModel.m
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZShopModel.h"
#import "LZCartModel.h"

@implementation LZShopModel

- (void)configGoodsArrayWithArray:(NSArray*)array; {
    if (array.count > 0) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            LZCartModel *model = [[LZCartModel alloc]init];
            model.divCode = @"2";
//            model.divName = dic[@"div_name"];
            model.nameStr = dic[@"item_name"];
            model.image_url = dic[@"item_img_url"];
            model.item_code = dic[@"item_code"];
            model.price = dic[@"item_p"];
            model.number = ((NSNumber *)dic[@"sale_q"]).integerValue;
//            model.stock_unit = dic[@"stock_unit"];
            [dataArray addObject:model];
        }
        
        _goodsArray = [dataArray mutableCopy];
    }
}

- (NSMutableArray *)selectedGoodsArray {
    if (_selectedGoodsArray == nil) {
        _selectedGoodsArray = @[].mutableCopy;
    }
    return _selectedGoodsArray;
}

@end
