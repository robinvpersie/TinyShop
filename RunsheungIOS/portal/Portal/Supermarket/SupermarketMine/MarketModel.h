//
//  MarketModel.h
//  Portal
//
//  Created by 이정구 on 2018/3/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketModel : NSObject

@property (nonatomic, copy) NSString *default_add;
@property (nonatomic, copy) NSString *delivery_name;
@property (nonatomic, copy) NSString *mobilepho;
@property (nonatomic, copy) NSString *seq_num;
@property (nonatomic, copy) NSString *to_address;
@property (nonatomic, copy) NSString *zip_name;
@property(nonatomic, copy) NSNumber *hasDelivery;//检测地址是否可以派送


-(instancetype)initWithDic:(NSDictionary *)dic;

@end
