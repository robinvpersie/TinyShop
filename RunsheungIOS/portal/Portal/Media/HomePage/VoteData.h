//
//  VoteData.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteData : NSObject

@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, strong) NSNumber *uniqueId;

@end
