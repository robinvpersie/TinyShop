//
//  NSDate+HotelAddition.h
//  Portal
//
//  Created by ifox on 2017/4/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HotelAddition)

+ (NSDate *)getDateWithString:(NSString *)dateString;

+ (NSString *)getDaysCountWithStartDate:(NSString *)startDateString
                                endDate:(NSString *)endDateString;

+ (NSString *)getDateStringWithDate:(NSDate *)date;
@end
