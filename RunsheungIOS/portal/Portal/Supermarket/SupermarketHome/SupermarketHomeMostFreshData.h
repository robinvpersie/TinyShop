//
//  SupermarketHomeMostFreshData.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/12.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 新品尝鲜
 */
@interface SupermarketHomeMostFreshData : NSObject

@property(nonatomic, copy) NSString *ad_id;
@property(nonatomic, copy) NSString *item_code;
@property(nonatomic, copy) NSString *item_name;
@property(nonatomic, copy) NSString *stock_unit;
@property(nonatomic, copy) NSString *image_url;
@property(nonatomic, copy) NSString *item_price;
@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *imageUrl;

@property(nonatomic, copy) NSString *item_des;
@property(nonatomic, strong) NSNumber *good_num;

@end
