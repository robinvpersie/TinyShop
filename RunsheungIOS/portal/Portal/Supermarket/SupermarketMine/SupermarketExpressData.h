//
//  SupermarketExpressData.h
//  Portal
//
//  Created by ifox on 2017/1/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketExpressData : NSObject

@property(nonatomic, copy) NSString *bill;
@property(nonatomic, copy) NSNumber *count;
@property(nonatomic, strong) NSArray *expFollow;
@property(nonatomic, copy) NSString *item_url;
@property(nonatomic, copy) NSString *status;//当前状态(如:运输中)
@property(nonatomic, copy) NSString *mobile;

@end
