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
			model.divCode = dic[@"div_code"];
			model.divName = dic[@"div_name"];
			model.nameStr = dic[@"item_name"];
			model.image_url = dic[@"image_url"];
			model.item_code = dic[@"item_code"];
			model.price = dic[@"item_price"];
			model.number = ((NSNumber *)dic[@"item_quantity"]).integerValue;
			model.stock_unit = dic[@"stock_unit"];
			model.sale_custom_code = dic[@"sale_custom_code"];
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

