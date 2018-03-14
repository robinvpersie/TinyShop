//
//  SupermarketExpInfoData.h
//  Portal
//
//  Created by ifox on 2017/1/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketExpInfoData : NSObject

@property(nonatomic, copy) NSString *expDate;
@property(nonatomic, copy) NSString *expLocation;
@property(nonatomic, strong) NSNumber *hasCurrent;//1为在当前状态

@end
