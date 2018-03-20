//
//  CollectionItemModel.m
//  Portal
//
//  Created by 이정구 on 2018/3/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "CollectionItemModel.h"

@implementation CollectionItemModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.shopImage = dic[@"shop_thumnail_image"];
        self.customCode = dic[@"custom_code"];
        self.customName = dic[@"custom_name"];
        self.koraddr = dic[@"kor_addr"];
        self.distance = dic[@"distance"];
        self.score = dic[@"score"];
        self.cnt = dic[@"cnt"];
        self.salCustomCnt = dic[@"sale_custom_cnt"];
    }
    return self;
}

@end
