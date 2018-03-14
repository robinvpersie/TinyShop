//
//  SupermarketKindModel.h
//  Portal
//
//  Created by ifox on 2017/1/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketKindModel : NSObject

@property(nonatomic, copy) NSString *category_code;
@property(nonatomic, copy) NSString *category_name;
@property(nonatomic, copy) NSString *category_name_en;
@property(nonatomic, copy) NSString *icon_url;
@property(nonatomic, strong) NSString *level;

@end
