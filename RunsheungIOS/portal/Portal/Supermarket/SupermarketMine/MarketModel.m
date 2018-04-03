//
//  MarketModel.m
//  Portal
//
//  Created by 이정구 on 2018/3/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "MarketModel.h"

@implementation MarketModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.default_add = [dic objectForKey:@"default_add"];
        self.mobilepho = [dic objectForKey:@"mobilepho"];
        self.seq_num = [dic objectForKey:@"seq_num"];
        self.to_address = [dic objectForKey:@"to_address"];
        self.zip_name = [dic objectForKey:@"zip_name"];
        self.delivery_name = [dic objectForKey:@"delivery_name"];
    }
    return self;
}



@end
