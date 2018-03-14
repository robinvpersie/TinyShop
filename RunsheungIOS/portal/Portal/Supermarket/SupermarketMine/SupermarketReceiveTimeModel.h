//
//  SupermarketReceiveTimeModel.h
//  Portal
//
//  Created by ifox on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketReceiveTimeModel : NSObject

@property(nonatomic, copy) NSString *date;//日期
@property(nonatomic, copy) NSString *weekDay;//周几
@property(nonatomic, copy) NSString *dayAfter;//几天后
@property(nonatomic, assign) BOOL selectedAm;//选择上午
@property(nonatomic, assign) BOOL selectedPm;//选择下午

@end
