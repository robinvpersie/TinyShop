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
        self.defaultadd = [dic objectForKey:@"default_add"];
        self.mobilepho = [dic objectForKey:@"mobilepho"];
        self.seqnum = [dic objectForKey:@"seq_num"];
        self.toaddress = [dic objectForKey:@"to_address"];
        self.zipname = [dic objectForKey:@"zip_name"];
        self.deliveryname = [dic objectForKey:@"delivery_name"];
    }
    return self;
}



@end
