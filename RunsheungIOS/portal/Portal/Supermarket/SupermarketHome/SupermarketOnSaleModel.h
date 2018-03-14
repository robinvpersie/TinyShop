//
//  SupermarketOnSaleModel.h
//  Portal
//
//  Created by ifox on 2017/1/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketOnSaleModel : NSObject

@property(nonatomic, copy) NSString *item_code;
@property(nonatomic, copy) NSString *item_name;
@property(nonatomic, copy) NSString *stock_unit;
@property(nonatomic, strong) NSNumber *price;
@property(nonatomic ,copy) NSString *iamge_url;
@property(nonatomic, copy) NSString *ver;

@end
