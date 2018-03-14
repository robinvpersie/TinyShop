//
//  SupermarketHomePeopleLikeData.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/12.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketHomePeopleLikeData : NSObject

@property(nonatomic, copy) NSString *ad_id;
@property(nonatomic, copy) NSString *item_code;
@property(nonatomic, copy) NSString *item_name;
@property(nonatomic, copy) NSString *stock_unit;
@property(nonatomic, copy) NSString *item_price;
@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, strong) NSNumber *item_quantity;

@end
