//
//  GoodsOptionModel.h
//  Portal
//
//  Created by ifox on 2017/3/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsOptionModel : NSObject

@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, copy)  NSString *good_code;
@property(nonatomic, copy)   NSString *item_code;
@property(nonatomic, copy)   NSString *item_name;
@property(nonatomic, strong) NSNumber *item_price;
@property(nonatomic, copy)   NSString *stock_unit;//存储单位
@property(nonatomic, copy)   NSString *optionType;//1单选,2附加

@end
