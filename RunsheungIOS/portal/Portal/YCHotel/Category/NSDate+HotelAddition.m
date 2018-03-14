//
//  NSDate+HotelAddition.m
//  Portal
//
//  Created by ifox on 2017/4/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "NSDate+HotelAddition.h"

@implementation NSDate (HotelAddition)

+ (NSDate *)getDateWithString:(NSString *)dateString {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSString *)getDateStringWithDate:(NSDate *)date {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)getDaysCountWithStartDate:(NSString *)startDateString
                                endDate:(NSString *)endDateString {
    NSDate *startDate = [self getDateWithStringDate:startDateString];
    NSDate *endDate = [self getDateWithStringDate:endDateString];
    
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    
    int days = ((int)time)/(3600*24);
    NSString *dateValue = [NSString stringWithFormat:@"%i",days];
    return dateValue;
}

+ (NSDate *)getDateWithStringDate:(NSString *)stringDate {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:stringDate];
    return date;
}


@end
