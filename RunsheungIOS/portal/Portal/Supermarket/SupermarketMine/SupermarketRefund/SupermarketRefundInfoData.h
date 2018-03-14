//
//  SupermarketRefundInfoData.h
//  Portal
//
//  Created by ifox on 2017/1/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketRefundInfoData : NSObject

@property(nonatomic, strong) NSNumber *hasCurrent;
@property(nonatomic, strong) NSString *refundDate;
@property(nonatomic, copy) NSString *refundLocation;

@end
