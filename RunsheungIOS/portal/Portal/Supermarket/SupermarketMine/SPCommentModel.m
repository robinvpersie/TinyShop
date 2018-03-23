//
//  SPCommentModel.m
//  Portal
//
//  Created by 이정구 on 2018/3/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "SPCommentModel.h"

@implementation SPCommentModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.imagePath = dic[@"img_path"];
        self.nickname = dic[@"nick_name"];
        self.customname = dic[@"custom_name"];
        self.score = dic[@"score"];
        self.identifier = dic[@"id"];
        self.customCode = dic[@"custom_code"];
        self.repContent = dic[@"rep_content"];
        self.saleContent = dic[@"sale_content"];
        self.regdate = dic[@"reg_date"];
        self.num = dic[@"num"];
        self.rnm = dic[@"rum"];
    }
    return self;
}

@end
