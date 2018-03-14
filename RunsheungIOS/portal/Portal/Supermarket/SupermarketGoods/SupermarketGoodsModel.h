//
//  SupermarketGoodsModel.h
//  Portal
//
//  Created by ifox on 2017/1/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketGoodsModel : NSObject

@property(nonatomic, copy)      NSString *title;
@property(nonatomic, strong)    NSArray *images;
@property(nonatomic, copy)      NSString *city;
@property (nonatomic,copy)      NSString *expressAmount;
@property(nonatomic, strong)    NSNumber *sold;
@property(nonatomic, copy)      NSString *unit;
@property(nonatomic, strong)    NSNumber *price;
@property(nonatomic, strong)    NSNumber *marketPrice;
@property(nonatomic, copy)      NSString *linkUrl;
@property(nonatomic, copy)      NSString *content;
@property(nonatomic, copy)      NSString *itemCode;
@property(nonatomic, strong)    NSArray *features;
@property(nonatomic, assign)    NSNumber *hasChangeBuy;
@property(nonatomic, copy)      NSString *changeBuyTitle;
@property(nonatomic, assign)    NSNumber *hasCollection;
@property(nonatomic, copy)      NSString *storage;
@property(nonatomic, copy)      NSString *business_code;
@property(nonatomic, copy)      NSString *supplier_code;
@property(nonatomic, strong)    NSNumber *stock;//存储数量

@end
