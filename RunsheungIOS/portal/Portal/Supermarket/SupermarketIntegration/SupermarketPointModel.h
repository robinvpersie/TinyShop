//
//  SupermarketPointModel.h
//  Portal
//
//  Created by ifox on 2017/3/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketPointModel : NSObject

@property(nonatomic, copy) NSString *card_no;
@property(nonatomic, copy) NSString *store_code;
@property(nonatomic, copy) NSString *store_name;
@property(nonatomic, copy) NSString *trade_date;
@property(nonatomic, copy) NSString *trade_money;
@property(nonatomic, copy) NSString *trade_type;

@end
