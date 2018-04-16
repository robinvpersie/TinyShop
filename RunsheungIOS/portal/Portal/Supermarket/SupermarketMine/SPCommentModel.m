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
        self.commentTime = dic[@"comment_time"];
        self.nickname = dic[@"nick_name"];
        self.itemcode = dic[@"item_code"];
        self.score = [(NSNumber *)dic[@"score"] longValue];
        self.imageUrl = dic[@"image_url"];
        self.level = [(NSNumber *)dic[@"level"] longValue];
        self.haslikes = dic[@"hasLikes"];
        self.text = dic[@"text"];
        self.commentid = dic[@"comment_id"];
        self.likescount = [(NSNumber *)dic[@"rum"] longValue];
        self.headUrl = dic[@"head_url"];
   }
    return self;
}

@end
