//
//  MarketModel.h
//  Portal
//
//  Created by 이정구 on 2018/3/22.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketModel : NSObject

@property (nonatomic, copy) NSString *defaultadd;
@property (nonatomic, copy) NSString *deliveryname;
@property (nonatomic, copy) NSString *mobilepho;
@property (nonatomic, copy) NSString *seqnum;
@property (nonatomic, copy) NSString *toaddress;
@property (nonatomic, copy) NSString *zipname;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
