//
//  BroadcastData.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BroadcastData : NSObject

@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *start_time;
@property(nonatomic, copy) NSString *end_time;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSNumber *uniqueId;

@end
